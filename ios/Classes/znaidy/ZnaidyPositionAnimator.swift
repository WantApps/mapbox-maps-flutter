//
//  ValueAnimator.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 24.02.2023.
//
//  taken from : https://stackoverflow.com/questions/61594608/ios-equivalent-of-androids-valueanimator

import Foundation
import CoreLocation

fileprivate var defaultFunction: (TimeInterval, TimeInterval) -> (Double) = { time, duration in
    return time / duration
}

protocol ZnaidyPositionAnimationDelegate {
    func onAnimationUpdate(id: String, position: CLLocationCoordinate2D)
    func onAnimationEnd(id: String)
}

class ZnaidyPositionAnimator {
    
    let id: String
    let from: CLLocationCoordinate2D
    let to: CLLocationCoordinate2D
    var duration: TimeInterval = 0
    var animationCurveFunction: (TimeInterval, TimeInterval) -> (Double)
    var delegate: ZnaidyPositionAnimationDelegate
    
    var startTime: Date!
    var displayLink: CADisplayLink?
    var currentPosition: CLLocationCoordinate2D
    
    init (id: String, from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, duration: TimeInterval, animationCurveFunction: @escaping (TimeInterval, TimeInterval) -> (Double) = defaultFunction, delegate: ZnaidyPositionAnimationDelegate) {
        self.id = id
        self.from = from
        self.to = to
        self.duration = duration + 1
        self.animationCurveFunction = animationCurveFunction
        self.delegate = delegate
        self.currentPosition = from
    }
    
    func isRunning() -> Bool {
        return displayLink != nil
    }
    
    func start() {
        displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink?.add(to: .current, forMode: .default)
    }
    
    @objc
    private func update() {
        
        if startTime == nil {
            startTime = Date()
            currentPosition = updatePosition(0)
            delegate.onAnimationUpdate(id: id, position: currentPosition)
            return
        }
        
        var timeElapsed = Date().timeIntervalSince(startTime)
        var stop = false
        
        if timeElapsed > duration {
            timeElapsed = duration
            stop = true
        }
        
        currentPosition = updatePosition(timeElapsed)
        delegate.onAnimationUpdate(id: id, position: currentPosition)

        if stop {
            cancel()
            delegate.onAnimationEnd(id: id)
        }
    }
    
    func stop() -> CLLocationCoordinate2D {
        cancel()
        return currentPosition
    }
    
    private func cancel() {
        self.displayLink?.remove(from: .current, forMode: .default)
        self.displayLink = nil
    }
    
    private func updatePosition(_ timeElapsed: TimeInterval) -> CLLocationCoordinate2D {
        let latitude = from.latitude + (to.latitude - from.latitude) * animationCurveFunction(timeElapsed, duration)
        let longitude = from.longitude + (to.longitude - from.longitude) * animationCurveFunction(timeElapsed, duration)
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
