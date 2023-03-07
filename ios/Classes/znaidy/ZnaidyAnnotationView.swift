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
    
    private var markerBackground: UIImageView!
    private var userAvatar: UIImageView!
    private var stickerCounter: UILabel!
    private var companyCounter: UILabel!
    private var speedView: ZnaidySpeedView!
    private var glowView: GlowView!
    private var inAppView: UILabel!
    
    private var markerBackgrounsWidthConstraint: NSLayoutConstraint!
    private var markerBackgroundHeightConstraint: NSLayoutConstraint!
    private var avatarWidthConstraint: NSLayoutConstraint!
    private var avatarHeightConstraint: NSLayoutConstraint!
    private var avatarBottomOffsetConstraint: NSLayoutConstraint!
    private var glowWidthConstraint: NSLayoutConstraint!
    private var glowHeightConstraint: NSLayoutConstraint!
    
    private(set) var annotationData: ZnaidyAnnotationData?
    
    func bind(_ annotationData: ZnaidyAnnotationData) {
        NSLog("\(TAG): bind: \(annotationData.toString())")
        switch (annotationData.markerType) {
            case ._self:
                bindSelf(annotationData)
            case .friend:
                bindFriend(annotationData)
            case .company:
                bindCompany(annotationData)
        }
        
        let zoomFactor = annotationData.markerType == ._self ? max(annotationData.zoomFactor, 0.5) : max(annotationData.zoomFactor, 0.2)
        
        if (annotationData.focused) {
            setFocusedSize(zoomFactor: zoomFactor)
        } else if (annotationData.onlineStatus == .offline) {
            setOfflineSize(zoomFactor: zoomFactor)
        } else {
            setRegularSize(zoomFactor: zoomFactor)
        }
        self.annotationData = annotationData
        
        if (annotationData.onlineStatus != ZnaidyOnlineStatus.offline && annotationData.zoomFactor >= 1.0) {
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
    
    func animateReceiveSticker() {
        
    }
    
    func animateHide(completion: @escaping () -> Void) {
        setRegularSize(zoomFactor: 0.2) { bool in
            completion()
        }
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
            markerBackground.image = MediaProvider.image(named: "znaidy_marker_self")
            companyCounter.isHidden = true
            stickerCounter.isHidden = true
            speedView.isHidden = true
        }
        if (typeChanged || self.annotationData?.onlineStatus != annotationData.onlineStatus) {
            setOnlineStatus(onlineStatus: annotationData.onlineStatus)
        }
        if (typeChanged || self.annotationData?.userAvatar() != annotationData.userAvatar()) {
            setAvatar(avatarUrl: annotationData.userAvatar())
        }
    }
    
    private func bindFriend(_ annotationData: ZnaidyAnnotationData) {
        let typeChanged = self.annotationData?.markerType != annotationData.markerType
        if (typeChanged) {
            markerBackground.image = MediaProvider.image(named: "znaidy_marker_friend")
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
    }
    
    private func bindCompany(_ annotationData: ZnaidyAnnotationData) {
        let typeChanged = self.annotationData?.markerType != annotationData.markerType
        if (typeChanged) {
            markerBackground.image = MediaProvider.image(named: "znaidy_marker_company")
            stickerCounter.isHidden = true
            speedView.isHidden = true
            glowView.isHidden = true
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
                glowView.setColor(color: ZnaidyConstants.znaidyGray)
                glowView.isHidden = false
                glowView.startAnimation()
            case .inApp:
                glowView.setColor(color: ZnaidyConstants.znaidyBlue)
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
            stickerCounter.text = count > 9 ? "9+" : String(count)
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
}

//animation
extension ZnaidyAnnotationView {
    
    private func markerIdleAnimation() {
        let keyframes: [NSNumber] = [0.0, NSNumber(value: 1.0/7.0), NSNumber(value: 2.0/7.0), NSNumber(value: 3.0/7.0), NSNumber(value: 4.0/7.0), NSNumber(value: 5.0/7.0), NSNumber(value: 6.0/7.0), NSNumber(value: 7.0/7.0)]
        let values = [1.0, 1.02, 1.06, 1.0, 0.94, 0.98, 1.0]
        let reversedValues = [1.0, 0.98, 0.94, 1.0, 1.06, 1.02, 1.0]
        let duration = 1.5
        
        let markerAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        markerAnimation.values = values
        markerAnimation.keyTimes = keyframes
        markerAnimation.duration = duration
        markerAnimation.repeatCount = Float.infinity
        markerBackground.layer.add(markerAnimation, forKey: "idle")
        
        let avatarHeightAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        avatarHeightAnimation.values = values
        markerAnimation.keyTimes = keyframes

        let avatarWidthAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        avatarWidthAnimation.values = reversedValues
        markerAnimation.keyTimes = keyframes

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [avatarWidthAnimation, avatarHeightAnimation]
        animationGroup.duration = duration
        animationGroup.repeatCount = Float.infinity
        userAvatar.layer.add(animationGroup, forKey: "idle")
    }
    
    private func startIdleAnimation() {
        if (markerBackground.isAnimating && userAvatar.isAnimating) {
            return
        }
        markerIdleAnimation()
    }
    
    private func stopIdleAnimation() {
        markerBackground.layer.removeAnimation(forKey: "idle")
        userAvatar.layer.removeAnimation(forKey: "idle")
    }
    
    private func setFocusedSize(zoomFactor: Double) {
        NSLog("\(TAG): setFocusedSize: markerWidth=\(markerBackground.frame.width), focusedSize=\(ZnaidyConstants.markerWidthFocused)")
        self.layoutIfNeeded()
        
        self.markerBackgrounsWidthConstraint.constant = ZnaidyConstants.markerWidthFocused * zoomFactor
        self.markerBackgroundHeightConstraint.constant = ZnaidyConstants.markerHeightFocused * zoomFactor
        self.avatarWidthConstraint.constant = ZnaidyConstants.avatarSizeFocused * zoomFactor
        self.avatarHeightConstraint.constant = ZnaidyConstants.avatarSizeFocused * zoomFactor
        self.avatarBottomOffsetConstraint.constant = ZnaidyConstants.avatarOffset * zoomFactor
        self.userAvatar.layer.cornerRadius = ZnaidyConstants.avatarSizeFocused / 2 * zoomFactor
        self.glowWidthConstraint.constant = ZnaidyConstants.annotationWidth * zoomFactor
        self.glowHeightConstraint.constant = ZnaidyConstants.annotationWidth * zoomFactor
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    private func setRegularSize(zoomFactor: Double, completion: ((Bool) -> Void)? = nil) {
        NSLog("\(TAG): setRegularSize: markerWidth=\(markerBackground.frame.width), focusedSize=\(ZnaidyConstants.markerWidth), zoomFactor=\(zoomFactor)")
        self.layoutIfNeeded()
        
        self.markerBackgrounsWidthConstraint.constant = ZnaidyConstants.markerWidth * zoomFactor
        self.markerBackgroundHeightConstraint.constant = ZnaidyConstants.markerHeight * zoomFactor
        self.avatarWidthConstraint.constant = ZnaidyConstants.avatarSize * zoomFactor
        self.avatarHeightConstraint.constant = ZnaidyConstants.avatarSize * zoomFactor
        self.avatarBottomOffsetConstraint.constant = ZnaidyConstants.avatarOffset * zoomFactor
        self.userAvatar.layer.cornerRadius = ZnaidyConstants.avatarSize / 2 * max(zoomFactor, 0.5)
        self.glowWidthConstraint.constant = ZnaidyConstants.annotationWidth * zoomFactor
        self.glowHeightConstraint.constant = ZnaidyConstants.annotationWidth * zoomFactor

        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
        }, completion: completion)
    }
    
    private func setOfflineSize(zoomFactor: Double) {
        NSLog("\(TAG): setOfflineSize: markerWidth=\(markerBackground.frame.width), focusedSize=\(ZnaidyConstants.markerWidthOffline)")
        self.layoutIfNeeded()
        
        self.markerBackgrounsWidthConstraint.constant = ZnaidyConstants.markerWidthOffline * zoomFactor
        self.markerBackgroundHeightConstraint.constant = ZnaidyConstants.markerHeightOffline * zoomFactor
        self.avatarWidthConstraint.constant = ZnaidyConstants.avatarSizeOffline * zoomFactor
        self.avatarHeightConstraint.constant = ZnaidyConstants.avatarSizeOffline * zoomFactor
        self.avatarBottomOffsetConstraint.constant = ZnaidyConstants.avatarOffset * zoomFactor
        self.userAvatar.layer.cornerRadius = ZnaidyConstants.avatarSizeOffline / 2 * zoomFactor
        self.glowWidthConstraint.constant = ZnaidyConstants.annotationWidth * zoomFactor
        self.glowHeightConstraint.constant = ZnaidyConstants.annotationWidth * zoomFactor

        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}

//layouting
extension ZnaidyAnnotationView {
    
    private func commonInit() {
        markerBackground = buildMarkerBackground()
        userAvatar = buildUserAvatar()
        stickerCounter = buildStickersCounter()
        companyCounter = buildCompanySizeCounter()
        speedView = ZnaidySpeedView()
        glowView = GlowView()
        inAppView = buildInAppView()
        addSubview(glowView)
        addSubview(markerBackground)
        addSubview(userAvatar)
        addSubview(stickerCounter)
        addSubview(companyCounter)
        addSubview(speedView)
        addSubview(inAppView)
        companyCounter.isHidden = true
        speedView.isHidden = true
        stickerCounter.isHidden = true
        inAppView.isHidden = true
        
        markerBackgrounsWidthConstraint = markerBackground.widthAnchor.constraint(equalToConstant: ZnaidyConstants.markerWidth)
        markerBackgroundHeightConstraint = markerBackground.heightAnchor.constraint(equalToConstant: ZnaidyConstants.markerHeight)
        avatarWidthConstraint = userAvatar.widthAnchor.constraint(equalToConstant: ZnaidyConstants.avatarSize)
        avatarHeightConstraint = userAvatar.heightAnchor.constraint(equalToConstant: ZnaidyConstants.avatarSize)
        avatarBottomOffsetConstraint = userAvatar.centerYAnchor.constraint(equalTo: markerBackground.centerYAnchor, constant: ZnaidyConstants.avatarOffset)
        glowWidthConstraint = glowView.widthAnchor.constraint(equalToConstant: ZnaidyConstants.annotationWidth)
        glowHeightConstraint = glowView.heightAnchor.constraint(equalToConstant: ZnaidyConstants.annotationWidth)

        NSLayoutConstraint.activate([
            markerBackgrounsWidthConstraint,
            markerBackgroundHeightConstraint,
            markerBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ZnaidyConstants.markerOffsetY),
            markerBackground.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            glowWidthConstraint,
            glowHeightConstraint,
            glowView.centerXAnchor.constraint(equalTo: markerBackground.centerXAnchor),
            glowView.centerYAnchor.constraint(equalTo: markerBackground.centerYAnchor),

            avatarWidthConstraint,
            avatarHeightConstraint,
            userAvatar.centerXAnchor.constraint(equalTo: markerBackground.centerXAnchor),
            avatarBottomOffsetConstraint,
            
            stickerCounter.widthAnchor.constraint(equalToConstant: ZnaidyConstants.stickerCountSize),
            stickerCounter.heightAnchor.constraint(equalToConstant: ZnaidyConstants.stickerCountSize),
            stickerCounter.bottomAnchor.constraint(equalTo: markerBackground.topAnchor, constant: 30.0),
            stickerCounter.leftAnchor.constraint(equalTo: markerBackground.rightAnchor, constant: -27.0),
            
            companyCounter.widthAnchor.constraint(equalToConstant: ZnaidyConstants.companyCountSize),
            companyCounter.heightAnchor.constraint(equalToConstant: ZnaidyConstants.companyCountSize),
            companyCounter.bottomAnchor.constraint(equalTo: markerBackground.bottomAnchor, constant: -20.0),
            companyCounter.leftAnchor.constraint(equalTo: markerBackground.leftAnchor),
            
            speedView.widthAnchor.constraint(equalToConstant: ZnaidyConstants.currentSpeedWidth),
            speedView.heightAnchor.constraint(equalToConstant: ZnaidyConstants.currentSpeedHeight),
            speedView.bottomAnchor.constraint(equalTo: markerBackground.bottomAnchor, constant: -20.0),
            speedView.leftAnchor.constraint(equalTo: markerBackground.leftAnchor),
            
            inAppView.widthAnchor.constraint(equalToConstant: ZnaidyConstants.inAppWidth),
            inAppView.heightAnchor.constraint(equalToConstant: ZnaidyConstants.inAppHeight),
            inAppView.centerXAnchor.constraint(equalTo: markerBackground.centerXAnchor),
            inAppView.bottomAnchor.constraint(equalTo: markerBackground.topAnchor, constant: -10.0),
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
        imageView.layer.cornerRadius = ZnaidyConstants.avatarSize / 2
        imageView.layer.masksToBounds = true
        return imageView
    }
    
    private func buildStickersCounter() -> UILabel {
        let label = UILabel()
        label.text = "9+"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.backgroundColor = ZnaidyConstants.znaidyBlue
        label.layer.cornerRadius = ZnaidyConstants.stickerCountSize / 2
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func buildCompanySizeCounter() -> UILabel {
        let label = UILabel()
        label.text = "2"
        label .textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 11)
        label.backgroundColor = ZnaidyConstants.znaidyBlack
        label.layer.cornerRadius = ZnaidyConstants.companyCountSize / 2
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func buildInAppView() -> UILabel {
        let label = UILabel()
        label.text = "in app"
        label .textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13)
        label.backgroundColor = ZnaidyConstants.znaidyBlue
        label.layer.cornerRadius = 4.0
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
