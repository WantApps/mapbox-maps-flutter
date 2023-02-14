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
    
    private weak var delegate: ControllerDelegate?

    init(withDelegate delegate: ControllerDelegate) {
        self.delegate = delegate
    }
    
    func createManagerId(_ managerId: String, annotationOptions: FLTZnaidyAnnotationOptions, completion: @escaping (String?, FlutterError?) -> Void) {
        addViewAnnotation(at: convertDictionaryToCLLocationCoordinate2D(dict: annotationOptions.geometry)!)
        completion("0", nil)
    }
    
    func updateManagerId(_ managerId: String, annotationId: String, annotationOptions: FLTZnaidyAnnotationOptions, completion: @escaping (FlutterError?) -> Void) {
        completion(nil)
    }
    
    func deleteManagetId(_ managetId: String, annotationId: String, completion: @escaping (FlutterError?) -> Void) {
        completion(nil)
    }
    
    
    private func addViewAnnotation(at coordinate: CLLocationCoordinate2D) {
        let options = ViewAnnotationOptions(
            geometry: Point(coordinate),
            width: 100,
            height: 40,
            allowOverlap: false,
            anchor: .center
        )
        let sampleView = createSampleView(withText: "Hello world!")
//        sampleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (self.onAnnotationTap (_:))))
        try? delegate?.getViewAnnotationsManager().add(sampleView, options: options)
    }
    
    private func createSampleView(withText text: String) -> UIView {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle(text, for: UIControl.State.normal)
        button.addTarget(self, action: #selector (self.onAnnotationTap (_:)), for: UIControl.Event.touchDown)
        return button
        
//        let label = UILabel()
//        label.text = text
//        label.font = .systemFont(ofSize: 14)
//        label.numberOfLines = 0
//        label.textColor = .black
//        label.backgroundColor = .white
//        label.textAlignment = .center
//        return label
    }
    
    @objc func onAnnotationTap(_ sender:UITapGestureRecognizer){
        NSLog("\(TAG): onAnnotationTap")
    }
}
