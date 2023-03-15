//
//  ZnaidyAnnotationController.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 14.02.2023.
//

import Foundation
import Turf
import MapboxMaps

class ZnaidyAnnotationController: NSObject, FLT_ZnaidyAnnotationMessager {
    private let TAG = "ZnaidyAnnotationController"
    private static let errorCode = "0"
    private weak var delegate: ControllerDelegate?
    
    weak var flutterClickListener: FLTOnZnaidyAnnotationClickListener?
    
    var pointManagerId: String!
    
    private var locationUpdateRate: TimeInterval = 2.0
    private var viewAnnotations: [String: ZnaidyAnnotationView] = [:]
    private var annotationAnimators: [String:ZnaidyPositionAnimator] = [:]
    
    private var trackingCameraOptions: CameraOptions?
    
    init(withDelegate delegate: ControllerDelegate) {
        self.delegate = delegate
    }
    
    func createManagerId(_ managerId: String, annotationOptions: FLTZnaidyAnnotationOptions, completion: @escaping (String?, FlutterError?) -> Void) {
        do {
            guard let pointManager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager else {
                completion(nil, FlutterError(code: ZnaidyAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
                return
            }
            var pointAnnotation = PointAnnotation(coordinate: ZnaidyAnnotationDataMapper.coordinatesFromOptions(options: annotationOptions))
            pointAnnotation.iconImage = "dot-11"
            pointAnnotation.iconAnchor = IconAnchor.bottom
            pointAnnotation.iconOpacity = 0.00
            pointAnnotation.iconSize = 5
            pointManager.annotations.append(pointAnnotation)
            
            let annotationData = ZnaidyAnnotationDataMapper.createAnnotation(id: pointAnnotation.id, options: annotationOptions)
            let annotationView = ZnaidyAnnotationView()
            annotationView.bind(annotationData)
            
            //todo add viewAnnotation
            let options = ViewAnnotationOptions(
                geometry: Point(annotationData.geometry),
                width: ZnaidyConstants.annotationWidth,
                height: ZnaidyConstants.annotationHeight,
                associatedFeatureId: pointAnnotation.id,
                allowOverlap: true,
                anchor: .bottom,
                offsetY: ZnaidyConstants.markerOffsetY * -1,
                selected: annotationData.markerType == ._self
            )
            try delegate?.getViewAnnotationsManager().add(annotationView, options: options)

            viewAnnotations[annotationData.id] = annotationView
            completion(pointAnnotation.id, nil)
        } catch {
            completion(nil, FlutterError(code: ZnaidyAnnotationController.errorCode, message: error.localizedDescription, details: error))
        }
    }
    
    func updateManagerId(_ managerId: String, annotationId: String, annotationOptions: FLTZnaidyAnnotationOptions, completion: @escaping (FlutterError?) -> Void) {
        do {
            guard let annotationView = viewAnnotations[annotationId] else {
                throw AnnotationControllerError.noAnnotationFound
            }
            let newAnnotationData = ZnaidyAnnotationDataMapper.updateAnnotation(data: annotationView.annotationData!, options: annotationOptions)
            if (newAnnotationData.zoomFactor <= 0.5) {
                var viewAnnotationOptions = ViewAnnotationOptions()
                if (newAnnotationData.geometry != annotationView.annotationData?.geometry) {
                    guard let pointManager = try delegate?.getManager(managerId: pointManagerId) as? PointAnnotationManager else {
                        return
                    }
                    guard let index = pointManager.annotations.firstIndex(where: { pointAnnotation in
                        pointAnnotation.id == annotationId
                    }) else {
                        throw AnnotationControllerError.noAnnotationFound
                    }
                    var pointAnnotation = pointManager.annotations[index]
                    var newPointAnnotation = pointAnnotation.updateCoordinate(coordinate: newAnnotationData.geometry)
                    pointManager.annotations[index] = newPointAnnotation
                    viewAnnotationOptions.geometry = Point(newAnnotationData.geometry).geometry
                }
                
                let isHidden = newAnnotationData.zoomFactor == 0 && newAnnotationData.markerType != ._self
                if (isHidden) {
                    annotationView.animateHide {
                        do {
                            var viewAnnotationOptions = ViewAnnotationOptions()
                            viewAnnotationOptions.visible = false
                            try self.delegate?.getViewAnnotationsManager().update(annotationView, options: viewAnnotationOptions)
                        } catch {
                            
                        }
                    }
                } else {
                    viewAnnotationOptions.visible = true
                }
                try delegate?.getViewAnnotationsManager().update(annotationView, options: viewAnnotationOptions)
            } else {
                if (newAnnotationData.geometry != annotationView.annotationData?.geometry) {
                    var startPosition = annotationView.annotationData!.geometry
                    if let lastAnimator = annotationAnimators[annotationId] {
                        startPosition = lastAnimator.stop()
                        annotationAnimators.removeValue(forKey: annotationId)
                    }
                    let animator = ZnaidyPositionAnimator(id: annotationId, from: startPosition, to: newAnnotationData.geometry, duration: locationUpdateRate, delegate: self)
                    animator.start()
                    annotationAnimators[annotationId] = animator
                }
            }
            annotationView.bind(newAnnotationData)
            completion(nil)
        } catch {
            completion(FlutterError(code: ZnaidyAnnotationController.errorCode, message: error.localizedDescription, details: error))
        }
    }
    
    func deleteManagerId(_ managerId: String, annotationId: String, animated: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            guard let annotationView = viewAnnotations[annotationId] else {
                throw AnnotationControllerError.noAnnotationFound
            }
            guard let pointManager = try delegate?.getManager(managerId: managerId) as? PointAnnotationManager else {
                completion(FlutterError(code: ZnaidyAnnotationController.errorCode, message: "No manager found with id: \(managerId)", details: nil))
                return
            }
            let index = pointManager.annotations.firstIndex(where: { pointAnnotation in
                pointAnnotation.id == annotationId
            })
            if index == nil {
                throw AnnotationControllerError.noAnnotationFound
            }
            pointManager.annotations.remove(at: index!)
            
            try delegate?.getViewAnnotationsManager().remove(annotationView)
            viewAnnotations.removeValue(forKey: annotationId)
            completion(nil)
        } catch {
            completion(FlutterError(code: ZnaidyAnnotationController.errorCode, message: error.localizedDescription, details: error))
        }
    }
    
    func selectManagerId(_ managerId: String, annotationId: String, bottomPadding: NSNumber, animationDuration: NSNumber, zoom: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        do {
            guard let annotationView = viewAnnotations[annotationId], let annotationData = annotationView.annotationData else {
                throw AnnotationControllerError.noAnnotationFound
            }
            let newAnnotationData = ZnaidyAnnotationDataMapper.udpateAnnotationFocused(data: annotationData, focused: true)
            annotationView.bind(newAnnotationData)
            let padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: CGFloat(bottomPadding.doubleValue), right: 0.0)
            self.trackingCameraOptions = CameraOptions(center: newAnnotationData.geometry, padding: padding, zoom: zoom.doubleValue, bearing: 0.0, pitch: 0.0)
            delegate?.getMapView().camera.fly(to: self.trackingCameraOptions!, duration: Double(animationDuration.intValue) / 1000)
            completion(nil)
        } catch {
            completion(FlutterError(code: ZnaidyAnnotationController.errorCode, message: error.localizedDescription, details: error))
        }
    }

    func resetSelectionManagerId(_ managerId: String, annotationId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            guard let annotationView = viewAnnotations[annotationId], let annotationData = annotationView.annotationData else {
                throw AnnotationControllerError.noAnnotationFound
            }
            let newAnnotationData = ZnaidyAnnotationDataMapper.udpateAnnotationFocused(data: annotationData, focused: false)
            annotationView.bind(newAnnotationData)
            completion(nil)
        } catch {
            completion(FlutterError(code: ZnaidyAnnotationController.errorCode, message: error.localizedDescription, details: error))
        }
    }

    func sendStickerManagerId(_ managerId: String, annotationId: String, completion: @escaping (FlutterError?) -> Void) {
        do {
            guard let annotationView = viewAnnotations[annotationId] else {
                throw AnnotationControllerError.noAnnotationFound
            }
            annotationView.animateReceiveSticker()
            completion(nil)
        } catch {
            completion(FlutterError(code: ZnaidyAnnotationController.errorCode, message: error.localizedDescription, details: error))
        }
    }
    
    func setUpdateRateManagerId(_ managerId: String, rate: NSNumber, completion: @escaping (FlutterError?) -> Void) {
        locationUpdateRate = TimeInterval(rate.intValue / 1000)
        completion(nil)
    }
}

extension ZnaidyAnnotationController: ZnaidyPositionAnimationDelegate {
    func onAnimationUpdate(id: String, position: CLLocationCoordinate2D) {
        do {
            guard let annotationView = viewAnnotations[id] else {
                throw AnnotationControllerError.noAnnotationFound
            }
            guard let pointManager = try delegate?.getManager(managerId: pointManagerId) as? PointAnnotationManager else {
                return
            }
            guard let index = pointManager.annotations.firstIndex(where: { pointAnnotation in
                pointAnnotation.id == id
            }) else {
                throw AnnotationControllerError.noAnnotationFound
            }
            var pointAnnotation = pointManager.annotations[index]
            var newPointAnnotation = pointAnnotation.updateCoordinate(coordinate: position)
            pointManager.annotations[index] = newPointAnnotation
            
            try delegate?.getViewAnnotationsManager().update(annotationView, options: ViewAnnotationOptions(geometry: Point(position)))
            
            if (annotationView.annotationData?.focused != true) { return }
            
            self.trackingCameraOptions?.center = position
            delegate?.getMapView().camera.fly(to: self.trackingCameraOptions!, duration: 0)

        } catch {
            NSLog("\(TAG): onAnimationUpdate: \(error)")
            if let animator = annotationAnimators[id] {
                animator.stop()
                annotationAnimators.removeValue(forKey: id)
            }
        }
    }
    
    func onAnimationEnd(id: String) {
        annotationAnimators.removeValue(forKey: id)
    }
}

extension ZnaidyAnnotationController: AnnotationInteractionDelegate {
    func annotationManager(_ manager: MapboxMaps.AnnotationManager, didDetectTappedAnnotations annotations: [MapboxMaps.Annotation]) {
        guard let annotation = annotations.first as? PointAnnotation else {
            return
        }
        NSLog("\(TAG): onPointAnnotationClick: \(annotation.id)")
        guard let znaidyAnnotation = viewAnnotations[annotation.id], let annotationData = znaidyAnnotation.annotationData else {
            return
        }
        NSLog("\(TAG): onPointAnnotationClick: \(annotation.id), \(annotationData.toString())")
        if (annotationData.zoomFactor < 0.5 && annotationData.markerType != ._self) { return }
        flutterClickListener?.onZnaidyAnnotationClickAnnotationId(annotation.id, annotationOptions: ZnaidyAnnotationDataMapper.mapToOptions(data: annotationData), completion: { error in
            NSLog("\(self.TAG): onAnnotationClick platform done")
        })
    }
}

extension PointAnnotation {
    func updateCoordinate(coordinate: CLLocationCoordinate2D) -> PointAnnotation {
        var newAnnotation = PointAnnotation(id: id, coordinate: coordinate)
        newAnnotation.iconImage = iconImage
        newAnnotation.iconSize = iconSize
        newAnnotation.iconOpacity = iconOpacity
        newAnnotation.iconOffset = iconOffset
        newAnnotation.iconAnchor = iconAnchor
        return newAnnotation
    }
}
