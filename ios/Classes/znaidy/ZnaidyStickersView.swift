//
//  ZnaidyStickersView.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 25.03.2023.
//

import Foundation

class ZnaidyStickersView : UIView {
    
    private var backgroundView: UIImageView!
    private var stickersText: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundView = UIImageView(image: MediaProvider.image(named: "stickers_background"))
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        translatesAutoresizingMaskIntoConstraints = false
        stickersText = UILabel()
        stickersText.textColor = UIColor.white
        stickersText.textAlignment = .center
        stickersText.lineBreakMode = .byClipping
        stickersText.font = MediaProvider.getFont(ofSize: 13)
        stickersText.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stickersText)
        NSLayoutConstraint.activate([
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor),
            
            stickersText.centerXAnchor.constraint(equalTo: centerXAnchor),
            stickersText.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setStickersCount(_ count: Int) {
        if (count > 9) {
            stickersText.text = "9+"
        } else {
            stickersText.text = "\(count)"
        }
    }
}
