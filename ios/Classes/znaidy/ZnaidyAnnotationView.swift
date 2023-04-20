//
//  ZnaidyAnnotationView.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 16.02.2023.
//

import Foundation
import UIKit
import SDWebImage

class ZnaidyAnnotationView: UIView {
    
    private let TAG = "ZnaidyAnnotationView"
    
    private var animationContainer: UIView!
    private var markerBackground: UIImageView!
    private var userAvatar: UIImageView!
    private var avatarMask: CALayer!
    private var stickerCounter: ZnaidyStickersView!
    private var companyCounter: UILabel!
    private var speedView: ZnaidySpeedView!
    private var glowView: GlowView!
    private var inAppView: UILabel!
    private var batteryView: ZnaidyBatteryView!
    private var offlineTimeView: ZnaidyOfflineTimeView!
    
    private var markerBackgrounsWidthConstraint: NSLayoutConstraint!
    private var markerBackgroundHeightConstraint: NSLayoutConstraint!
    private var avatarWidthConstraint: NSLayoutConstraint!
    private var avatarHeightConstraint: NSLayoutConstraint!
    private var avatarBottomOffsetConstraint: NSLayoutConstraint!
    private var glowWidthConstraint: NSLayoutConstraint!
    private var glowHeightConstraint: NSLayoutConstraint!
    private var speedWidthConstraint: NSLayoutConstraint!
    private var speedHeightConstraint: NSLayoutConstraint!
    private var speedOffsetYConstraint: NSLayoutConstraint!
    private var speedOffsetXConstraint: NSLayoutConstraint!
    private var batteryWidthConstraint: NSLayoutConstraint!
    private var batteryHeightConstraint: NSLayoutConstraint!

    private(set) var annotationData: ZnaidyAnnotationData?
    private(set) var annotationZoomFactor: Double = 1.0
    
    func bind(_ annotationData: ZnaidyAnnotationData, zoomFactor: Double) {
        NSLog("\(TAG): bind: \(annotationData.toString())")
        switch (annotationData.markerType) {
            case ._self:
                bindSelf(annotationData)
            case .friend:
                bindFriend(annotationData)
            case .company:
                bindCompany(annotationData)
        }
        
        annotationZoomFactor = annotationData.applyZoomFactor(zoomFactor: zoomFactor)

        setLayout(zoomFactor: annotationZoomFactor, annotationData: annotationData)
        self.annotationData = annotationData
        
        if (annotationData.onlineStatus != ZnaidyOnlineStatus.offline && annotationZoomFactor >= 1.0) {
            startIdleAnimation()
            if (annotationData.markerType != ZnaidyMarkerType.company) {
                glowView.isHidden = false
                glowView.startAnimation()
            }
        } else {
            stopIdleAnimation()
            glowView.stopAnimation()
            glowView.isHidden = true
        }
    }
    
    func bindZoomFactor(_ zoomFactor: Double, completion: @escaping () -> Void) {
        guard let annotationData = self.annotationData else {
            return
        }
        annotationZoomFactor = annotationData.applyZoomFactor(zoomFactor: zoomFactor)
        if (annotationZoomFactor >= 0.5) { completion () }
        setLayout(zoomFactor: annotationZoomFactor, annotationData: annotationData) { bool in
            if (annotationData.onlineStatus != ZnaidyOnlineStatus.offline && self.annotationZoomFactor >= 1.0) {
                self.startIdleAnimation()
                if (annotationData.markerType != ZnaidyMarkerType.company) {
                    self.glowView.isHidden = false
                    self.glowView.startAnimation()
                }
            } else {
                self.stopIdleAnimation()
                self.glowView.stopAnimation()
                self.glowView.isHidden = true
            }
            if (self.annotationZoomFactor < 0.5) { completion() }
        }
    }
    
    func animateReceiveSticker() {
        stickerAnimation()
    }
    
    func animateHide(completion: @escaping () -> Void) {
        setLayout(zoomFactor: 0.2, annotationData: annotationData!) { bool in
            completion()
        }
    }
    
    func onRemove() {
        offlineTimeView.stopUpdates()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

//bind annotation data
extension ZnaidyAnnotationView {
    
    private func bindSelf(_ annotationData: ZnaidyAnnotationData) {
        let typeChanged = self.annotationData?.markerType != annotationData.markerType
        if (typeChanged) {
            markerBackground.image = MediaProvider.image(named: annotationData.markerStyle.getImageName())
            companyCounter.isHidden = true
            stickerCounter.isHidden = true
        }
        if (typeChanged || self.annotationData?.onlineStatus != annotationData.onlineStatus) {
            setOnlineStatus(onlineStatus: annotationData.onlineStatus)
        }
        if (typeChanged || self.annotationData?.userAvatar() != annotationData.userAvatar()) {
            setAvatar(avatarUrl: annotationData.userAvatar())
        }
        if (typeChanged || self.annotationData?.currentSpeed != annotationData.currentSpeed) {
            setCurrentSpeed(annotationData.currentSpeed)
        }
        if (typeChanged || self.annotationData?.batteryLevel != annotationData.batteryLevel || self.annotationData?.batteryCharging != annotationData.batteryCharging) {
            setBattery(level: annotationData.batteryLevel, charging: annotationData.batteryCharging)
        }
    }
    
    private func bindFriend(_ annotationData: ZnaidyAnnotationData) {
        let typeChanged = self.annotationData?.markerType != annotationData.markerType
        if (typeChanged) {
            markerBackground.image = MediaProvider.image(named: annotationData.markerStyle.getImageName())
            companyCounter.isHidden = true
        }
        if (typeChanged || self.annotationData?.onlineStatus != annotationData.onlineStatus) {
            setOnlineStatus(onlineStatus: annotationData.onlineStatus)
        }
        if (typeChanged || self.annotationData?.stickerCount != annotationData.stickerCount) {
            setStickersCount(annotationData.stickerCount)
        }
        if (typeChanged || self.annotationData?.currentSpeed != annotationData.currentSpeed) {
            setCurrentSpeed(annotationData.currentSpeed)
        }
        if (typeChanged || self.annotationData?.userAvatar() != annotationData.userAvatar()) {
            setAvatar(avatarUrl: annotationData.userAvatar())
        }
        if (typeChanged || self.annotationData?.batteryLevel != annotationData.batteryLevel || self.annotationData?.batteryCharging != annotationData.batteryCharging) {
            setBattery(level: annotationData.batteryLevel, charging: annotationData.batteryCharging)
        }
    }
    
    private func bindCompany(_ annotationData: ZnaidyAnnotationData) {
        let typeChanged = self.annotationData?.markerType != annotationData.markerType
        if (typeChanged) {
            markerBackground.image = MediaProvider.image(named: annotationData.markerStyle.getImageName())
            stickerCounter.isHidden = true
            speedView.isHidden = true
            glowView.isHidden = true
            batteryView.isHidden = true
            glowView.stopAnimation()
        }
        if (typeChanged || self.annotationData?.companySize != annotationData.companySize) {
            companyCounter.text = String(annotationData.companySize)
            companyCounter.isHidden = false
        }
        if (typeChanged || self.annotationData?.avatarUrls != annotationData.avatarUrls) {
            setCompanyAvatars(avatars: annotationData.avatarUrls)
        }
    }
    
    private func setOnlineStatus(onlineStatus: ZnaidyOnlineStatus) {
        switch (onlineStatus) {
            case .online:
                glowView.setColor(color: ZnaidyConstants.onlineGlowColor)
                glowView.isHidden = false
                glowView.startAnimation()
            case .inApp:
                glowView.setColor(color: ZnaidyConstants.inAppGlowOutColor)
                glowView.isHidden = false
                glowView.startAnimation()
            case .offline:
                glowView.stopAnimation()
                glowView.isHidden = true
                break
        }
    }
        
    private func setAvatar(avatarUrl: String?) {
        if let avatarUrl = avatarUrl {
            userAvatar.sd_setImage(
                with: URL(string: avatarUrl),
                placeholderImage: MediaProvider.image(named: "avatar_placeholder"),
                progress: nil
            )
        } else {
            userAvatar.image = MediaProvider.image(named: "avatar_placeholder")
        }
    }
    
    private func setCompanyAvatars(avatars: [String]) {
        if (avatars.isEmpty) {
            userAvatar.image = MediaProvider.image(named: "avatar_placeholder")
        } else {
            setAvatar(avatarUrl: avatars.first)
        }
    }
    
    private func setStickersCount(_ count: Int) {
        if (count == 0) {
            stickerCounter.isHidden = true
        } else {
            stickerCounter.isHidden = false
            stickerCounter.setStickersCount(count)
        }
    }
    
    private func setCurrentSpeed(_ speed: Int) {
        if (speed == 0) {
            speedView.isHidden = true
        } else {
            speedView.isHidden = false
            speedView.setSpeed(speed: speed)
        }
    }
    
    private func setBattery(level: Int, charging: Bool) {
        batteryView.setBatteryLevel(level: level, charging: charging)
    }
}

//animation
extension ZnaidyAnnotationView {
    
    private func markerIdleAnimation() {
        let keyframes: [NSNumber] = [0.0, NSNumber(value: 1.0/7.0), NSNumber(value: 2.0/7.0), NSNumber(value: 3.0/7.0), NSNumber(value: 4.0/7.0), NSNumber(value: 5.0/7.0), NSNumber(value: 6.0/7.0), NSNumber(value: 7.0/7.0)]
        let values = [1.0, 1.02, 1.06, 1.0, 0.94, 0.98, 1.0]
        let duration = 1.5
        
        let markerAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        markerAnimation.values = values
        markerAnimation.keyTimes = keyframes
        markerAnimation.duration = duration
        markerAnimation.repeatCount = Float.infinity
        animationContainer.layer.add(markerAnimation, forKey: "idle")
    }
    
    private func startIdleAnimation() {
        if (animationContainer.layer.animationKeys()?.contains("idle") != nil) {
            return
        }
        markerIdleAnimation()
    }
    
    private func stopIdleAnimation() {
        animationContainer.layer.removeAnimation(forKey: "idle")
    }
    
    private func stickerAnimation() {
        let keyframes: [NSNumber] = [0.0, NSNumber(value: 1.0/8.0), NSNumber(value: 2.0/8.0), NSNumber(value: 3.0/8.0), NSNumber(value: 4.0/8.0), NSNumber(value: 5.0/8.0), NSNumber(value: 6.0/8.0), NSNumber(value: 7.0/8.0), NSNumber(value: 8.0/8.0)]
        let values = [1.0, 0.97, 0.96, 0.9, 1.1, 0.99, 1.01, 1.0]
        let duration = 0.2

        let markerWidthAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        markerWidthAnimation.values = values
        markerWidthAnimation.keyTimes = keyframes

        let markerHeightAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        markerHeightAnimation.values = values
        markerHeightAnimation.keyTimes = keyframes

        let markerAnimationGroup = CAAnimationGroup()
        markerAnimationGroup.animations = [markerWidthAnimation, markerHeightAnimation]
        markerAnimationGroup.duration = duration
        animationContainer.layer.add(markerAnimationGroup, forKey: "sticker")
    }
    
    private func setLayout(zoomFactor: Double, annotationData: ZnaidyAnnotationData, completion: ((Bool) -> Void)? = nil) {
        NSLog("\(TAG): setLayout: [\(annotationData.id)], zoomFactor=\(zoomFactor)")
        
        self.markerBackgrounsWidthConstraint.constant = ZnaidyConstants.markerWidth * zoomFactor
        self.markerBackgroundHeightConstraint.constant = ZnaidyConstants.markerHeight * zoomFactor
        
        self.avatarWidthConstraint.constant = ZnaidyConstants.avatarSize * zoomFactor
        self.avatarHeightConstraint.constant = ZnaidyConstants.avatarSize * zoomFactor
        self.avatarBottomOffsetConstraint.constant = ZnaidyConstants.avatarOffset * zoomFactor
        self.avatarMask.frame = CGRect(origin: self.userAvatar.bounds.origin, size: CGSize(width: ZnaidyConstants.avatarSize * zoomFactor, height: ZnaidyConstants.avatarSize * zoomFactor))
        
        self.glowWidthConstraint.constant = ZnaidyConstants.annotationWidth * zoomFactor
        self.glowHeightConstraint.constant = ZnaidyConstants.annotationWidth * zoomFactor
        
        if (zoomFactor <= 0.5 || annotationData.currentSpeed < 1 || annotationData.onlineStatus == .offline) {
            self.speedView.isHidden = true
        } else {
            speedView.isHidden = false
            speedWidthConstraint.constant = ZnaidyConstants.currentSpeedSize * zoomFactor
            speedHeightConstraint.constant = ZnaidyConstants.currentSpeedSize * zoomFactor
            speedOffsetYConstraint.constant = ZnaidyConstants.currentSpeedVerticalOffset * zoomFactor
            speedOffsetXConstraint.constant = zoomFactor >= 1.0 ? ZnaidyConstants.currentSpeedHorizontalOffset : ZnaidyConstants.currentSpeedHorizontalOffsetSmall
            speedView.setZoomFactor(zoomFactor: zoomFactor)
        }
        
        if (zoomFactor > 1.0 && annotationData.onlineStatus == .inApp) {
            inAppView.isHidden = false
        } else {
            inAppView.isHidden = true
        }
        
        if (zoomFactor > 1.0 || (zoomFactor >= 1.0 && annotationData.onlineStatus == .offline)) {
            batteryWidthConstraint.constant = ZnaidyConstants.batterySize * zoomFactor
            batteryHeightConstraint.constant = ZnaidyConstants.batterySize * zoomFactor
            batteryView.setZoomFactor(zoomFactor: zoomFactor)
            batteryView.isHidden = false
        } else {
            batteryView.isHidden = true
        }
        
        if (zoomFactor <= 0.5 || annotationData.stickerCount == 0 || annotationData.focused) {
            self.stickerCounter.isHidden = true
        } else {
            self.stickerCounter.isHidden = false
        }
        
        if (zoomFactor >= 1.0 && annotationData.onlineStatus == .offline) {
            self.offlineTimeView.setOfflineTime(offlineTimestamp: annotationData.lastOnline)
            self.offlineTimeView.isHidden = false
        } else {
            self.offlineTimeView.isHidden = true
            self.offlineTimeView.stopUpdates()
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }, completion: { result in
            if let completion = completion {
                completion(result)
            }
        })
    }
}

//layouting
extension ZnaidyAnnotationView {
    
    private func commonInit() {
//        backgroundColor = UIColor.red.withAlphaComponent(0.2)
        animationContainer = UIView()
        animationContainer.translatesAutoresizingMaskIntoConstraints = false
        markerBackground = buildMarkerBackground()
        userAvatar = buildUserAvatar()
        stickerCounter = ZnaidyStickersView()
        companyCounter = buildCompanySizeCounter()
        speedView = ZnaidySpeedView()
        glowView = GlowView()
        inAppView = buildInAppView()
        batteryView = ZnaidyBatteryView()
        offlineTimeView = ZnaidyOfflineTimeView()
        
        addSubview(glowView)
        addSubview(inAppView)
        addSubview(animationContainer)
        addSubview(offlineTimeView)
        animationContainer.addSubview(markerBackground)
        animationContainer.addSubview(userAvatar)
        animationContainer.addSubview(stickerCounter)
        animationContainer.addSubview(companyCounter)
        animationContainer.addSubview(speedView)
        animationContainer.addSubview(batteryView)
        companyCounter.isHidden = true
        speedView.isHidden = true
        stickerCounter.isHidden = true
        inAppView.isHidden = true
        batteryView.isHidden = true
        offlineTimeView.isHidden = true
        
        markerBackgrounsWidthConstraint = markerBackground.widthAnchor.constraint(equalToConstant: ZnaidyConstants.markerWidth)
        markerBackgroundHeightConstraint = markerBackground.heightAnchor.constraint(equalToConstant: ZnaidyConstants.markerHeight)
        
        avatarWidthConstraint = userAvatar.widthAnchor.constraint(equalToConstant: ZnaidyConstants.avatarSize)
        avatarHeightConstraint = userAvatar.heightAnchor.constraint(equalToConstant: ZnaidyConstants.avatarSize)
        avatarBottomOffsetConstraint = userAvatar.centerYAnchor.constraint(equalTo: markerBackground.centerYAnchor, constant: ZnaidyConstants.avatarOffset)
        
        glowWidthConstraint = glowView.widthAnchor.constraint(equalToConstant: ZnaidyConstants.annotationWidth)
        glowHeightConstraint = glowView.heightAnchor.constraint(equalToConstant: ZnaidyConstants.annotationWidth)
        
        speedWidthConstraint = speedView.widthAnchor.constraint(equalToConstant: ZnaidyConstants.currentSpeedSize)
        speedHeightConstraint = speedView.heightAnchor.constraint(equalToConstant: ZnaidyConstants.currentSpeedSize)
        speedOffsetYConstraint = speedView.bottomAnchor.constraint(equalTo: markerBackground.bottomAnchor, constant: ZnaidyConstants.currentSpeedVerticalOffset)
        speedOffsetXConstraint = speedView.leftAnchor.constraint(equalTo: markerBackground.leftAnchor, constant: ZnaidyConstants.currentSpeedHorizontalOffset)

        batteryWidthConstraint = batteryView.widthAnchor.constraint(equalToConstant: ZnaidyConstants.batterySize)
        batteryHeightConstraint = batteryView.heightAnchor.constraint(equalToConstant: ZnaidyConstants.batterySize)
        
        NSLayoutConstraint.activate([
            animationContainer.widthAnchor.constraint(equalTo: widthAnchor),
            animationContainer.heightAnchor.constraint(equalTo: heightAnchor),
            animationContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            markerBackgrounsWidthConstraint,
            markerBackgroundHeightConstraint,
            markerBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ZnaidyConstants.markerOffsetY),
            markerBackground.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            glowWidthConstraint,
            glowHeightConstraint,
            glowView.centerXAnchor.constraint(equalTo: centerXAnchor),
            glowView.bottomAnchor.constraint(equalTo: bottomAnchor),

            avatarWidthConstraint,
            avatarHeightConstraint,
            userAvatar.centerXAnchor.constraint(equalTo: markerBackground.centerXAnchor),
            avatarBottomOffsetConstraint,
            
            stickerCounter.widthAnchor.constraint(equalToConstant: ZnaidyConstants.stickerCountSize),
            stickerCounter.heightAnchor.constraint(equalToConstant: ZnaidyConstants.stickerCountSize),
            stickerCounter.topAnchor.constraint(equalTo: markerBackground.topAnchor),
            stickerCounter.rightAnchor.constraint(equalTo: markerBackground.rightAnchor, constant: ZnaidyConstants.stickersHorizontalOffset),
            
            companyCounter.widthAnchor.constraint(equalToConstant: ZnaidyConstants.companyCountSize),
            companyCounter.heightAnchor.constraint(equalToConstant: ZnaidyConstants.companyCountSize),
            companyCounter.bottomAnchor.constraint(equalTo: markerBackground.bottomAnchor, constant: -20.0),
            companyCounter.leftAnchor.constraint(equalTo: markerBackground.leftAnchor),
            
            speedWidthConstraint,
            speedHeightConstraint,
            speedOffsetYConstraint,
            speedOffsetXConstraint,
            
            inAppView.widthAnchor.constraint(equalToConstant: ZnaidyConstants.inAppWidth),
            inAppView.heightAnchor.constraint(equalToConstant: ZnaidyConstants.inAppHeight),
            inAppView.centerXAnchor.constraint(equalTo: centerXAnchor),
            inAppView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ZnaidyConstants.inAppVerticalOffset),
            
            batteryWidthConstraint,
            batteryHeightConstraint,
            batteryView.rightAnchor.constraint(equalTo: markerBackground.rightAnchor, constant: ZnaidyConstants.batteryHoryzontalOffset),
            batteryView.bottomAnchor.constraint(equalTo: markerBackground.bottomAnchor),
            
            offlineTimeView.widthAnchor.constraint(equalToConstant: ZnaidyConstants.offlineTimeWidth),
            offlineTimeView.heightAnchor.constraint(equalToConstant: ZnaidyConstants.offlineTimeHeight),
            offlineTimeView.centerXAnchor.constraint(equalTo: centerXAnchor),
            offlineTimeView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ZnaidyConstants.offlineTimeVerticalOffset)
        ])
        
        markerIdleAnimation()
        glowView.startAnimation()
    }
    
    private func buildMarkerBackground() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func buildUserAvatar() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let maskImage = MediaProvider.image(named: "avatar_mask")!
        avatarMask = CALayer()
        avatarMask.contents = maskImage.cgImage
        avatarMask.contentsCenter = CGRect(
                x: ((maskImage.size.width/2) - 1)/maskImage.size.width,
                y: ((maskImage.size.height/2) - 1)/maskImage.size.height,
                width: 1 / maskImage.size.width,
                height: 1 / maskImage.size.height)
        avatarMask.frame = imageView.bounds
        imageView.layer.mask = avatarMask
        return imageView
    }
    
    private func buildCompanySizeCounter() -> UILabel {
        let label = UILabel()
        label.text = "2"
        label .textColor = .white
        label.textAlignment = .center
        label.font = MediaProvider.getFont(ofSize: 11)
        label.backgroundColor = ZnaidyConstants.znaidyBlack
        label.layer.cornerRadius = ZnaidyConstants.companyCountSize / 2
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func buildInAppView() -> UILabel {
        let label = UILabel()
        label.text = Localizaton.localize(key: "in_app")
        label .textColor = .white
        label.textAlignment = .center
        label.font = MediaProvider.getFont(ofSize: ZnaidyConstants.inAppFont, weight: .heavy)
        label.backgroundColor = ZnaidyConstants.inAppColor
        label.layer.cornerRadius = 6.7
        label.layer.masksToBounds = true
        label.transform = CGAffineTransformMakeRotation((-9.39) * .pi/180)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
