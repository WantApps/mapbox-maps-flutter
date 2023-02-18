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
    
    private var markerBackgrounsWidthConstraint: NSLayoutConstraint!
    private var markerBackgroundHeightConstraint: NSLayoutConstraint!
    private var avatarWidthConstraint: NSLayoutConstraint!
    private var avatarHeightConstraint: NSLayoutConstraint!
    
    private(set) var annotationData: ZnaidyAnnotationData?
    
    func bind(_ annotationData: ZnaidyAnnotationData) {
        NSLog("\(TAG): bind: \(annotationData)")
        if let avatar = annotationData.avatarUrls.first {
            setAvatar(avatarUrl: avatar)
        }
        
        if (annotationData.focused) {
            setFocusedSize()
        } else if (annotationData.onlineStatus == .offline) {
            setOfflineSize()
        } else {
            setRegularSize()
        }
        self.annotationData = annotationData
    }
    
    func animateReceiveSticker() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        markerBackground = buildMarkerBackground()
        userAvatar = buildUserAvatar()
        stickerCounter = buildStickersCounter()
        companyCounter = buildCompanySizeCounter()
        speedView = ZnaidySpeedView()
        glowView = GlowView()
        addSubview(glowView)
        addSubview(markerBackground)
        addSubview(userAvatar)
        addSubview(stickerCounter)
        addSubview(companyCounter)
        addSubview(speedView)
        companyCounter.isHidden = true
        speedView.isHidden = true
        stickerCounter.isHidden = true
        
        markerBackgrounsWidthConstraint = markerBackground.widthAnchor.constraint(equalToConstant: ZnaidyConstants.markerWidth)
        markerBackgroundHeightConstraint = markerBackground.heightAnchor.constraint(equalToConstant: ZnaidyConstants.markerHeight)
        avatarWidthConstraint = userAvatar.widthAnchor.constraint(equalToConstant: ZnaidyConstants.avatarSize)
        avatarHeightConstraint = userAvatar.heightAnchor.constraint(equalToConstant: ZnaidyConstants.avatarSize)

        NSLayoutConstraint.activate([
            markerBackgrounsWidthConstraint,
            markerBackgroundHeightConstraint,
            markerBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -ZnaidyConstants.markerOffsetY),
            markerBackground.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            glowView.widthAnchor.constraint(equalToConstant: ZnaidyConstants.annotationWidth),
            glowView.heightAnchor.constraint(equalToConstant: ZnaidyConstants.annotationWidth),
            glowView.centerXAnchor.constraint(equalTo: markerBackground.centerXAnchor),
            glowView.centerYAnchor.constraint(equalTo: markerBackground.centerYAnchor),

            avatarWidthConstraint,
            avatarHeightConstraint,
            userAvatar.centerXAnchor.constraint(equalTo: markerBackground.centerXAnchor),
            userAvatar.centerYAnchor.constraint(equalTo: markerBackground.centerYAnchor, constant: ZnaidyConstants.avatarOffset),
            
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
        ])
    }
    
    private func buildMarkerBackground() -> UIImageView {
        let image = MediaProvider.image(named: "znaidy_marker_friend")!
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func buildUserAvatar() -> UIImageView {
        let image = MediaProvider.image(named: "profile_daniel")!
        let imageView = UIImageView(image: image)
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
    
    private func markerIdleAnimation() {
        let markerAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        markerAnimation.values = [1.0, 1.01, 1.03, 1.0, 0.97, 0.99]
        markerAnimation.keyTimes = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
        markerAnimation.duration = 2.0
        markerAnimation.repeatCount = Float.infinity
        markerBackground.layer.add(markerAnimation, forKey: "idle")
        
        let avatarHeightAnimation = CAKeyframeAnimation(keyPath: "transform.scale.x")
        avatarHeightAnimation.values = [1.0, 1.01, 1.03, 1.0, 0.97, 0.99]
        markerAnimation.keyTimes = [0.0, 0.4, 0.8, 1.2, 1.6, 2.0]

        let avatarWidthAnimation = CAKeyframeAnimation(keyPath: "transform.scale.y")
        avatarWidthAnimation.values = [1.0, 0.99, 0.97, 1.0, 1.03, 1.01]
        markerAnimation.keyTimes = [0.0, 0.4, 0.8, 1.2, 1.6, 2.0]

        var animationGroup = CAAnimationGroup()
        animationGroup.animations = [avatarWidthAnimation, avatarHeightAnimation]
        animationGroup.duration = 2.0
        animationGroup.repeatCount = Float.infinity
        userAvatar.layer.add(animationGroup, forKey: "idle")
    }
    
    private func stopIdleAnimation() {
        markerBackground.layer.removeAnimation(forKey: "idle")
        userAvatar.layer.removeAnimation(forKey: "idle")
    }
        
    private func setAvatar(avatarUrl: String) {
        let resizeTransformer = SDImageResizingTransformer(size: CGSize(width: ZnaidyConstants.avatarSize, height: ZnaidyConstants.avatarSize), scaleMode: SDImageScaleMode.aspectFill)
        userAvatar.sd_setImage(
            with: URL(string: avatarUrl),
            placeholderImage: MediaProvider.image(named: "profile_daniel"),
            context: [:
//                .imageTransformer: resizeTransformer,
            ],
            progress: nil
        )
    }
    
    private func setFocusedSize() {
        NSLog("\(TAG): setFocusedSize: markerWidth=\(markerBackground.frame.width), focusedSize=\(ZnaidyConstants.markerWidthFocused)")
        
        self.layoutIfNeeded()
        
        self.markerBackgrounsWidthConstraint.constant = ZnaidyConstants.markerWidthFocused
        self.markerBackgroundHeightConstraint.constant = ZnaidyConstants.markerHeightFocused
        self.avatarWidthConstraint.constant = ZnaidyConstants.avatarSizeFocused
        self.avatarHeightConstraint.constant = ZnaidyConstants.avatarSizeFocused

        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    private func setRegularSize() {
        NSLog("\(TAG): setRegularSize: markerWidth=\(markerBackground.frame.width), focusedSize=\(ZnaidyConstants.markerWidth)")
        self.layoutIfNeeded()
        self.markerBackgrounsWidthConstraint.constant = ZnaidyConstants.markerWidth
        self.markerBackgroundHeightConstraint.constant = ZnaidyConstants.markerHeight
        self.avatarWidthConstraint.constant = ZnaidyConstants.avatarSize
        self.avatarHeightConstraint.constant = ZnaidyConstants.avatarSize
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    private func setOfflineSize() {
        NSLog("\(TAG): setOfflineSize: markerWidth=\(markerBackground.frame.width), focusedSize=\(ZnaidyConstants.markerWidthOffline)")
        self.layoutIfNeeded()
        self.markerBackgrounsWidthConstraint.constant = ZnaidyConstants.markerWidthOffline
        self.markerBackgroundHeightConstraint.constant = ZnaidyConstants.markerHeightOffline
        self.avatarWidthConstraint.constant = ZnaidyConstants.avatarSizeOffline
        self.avatarHeightConstraint.constant = ZnaidyConstants.avatarSizeOffline
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
}
