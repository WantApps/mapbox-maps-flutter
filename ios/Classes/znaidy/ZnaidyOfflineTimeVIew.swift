//
//  ZnaidyOfflineTimeVIew.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 12.04.2023.
//

import Foundation

class ZnaidyOfflineTimeView : UIView {
    
    private var backgroundView: UIView!
    private var offlineLabel: UILabel!
    private var timeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false

        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = 6.67
        backgroundView.layer.masksToBounds = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        offlineLabel = UILabel()
        offlineLabel.text = "OFFLINE FOR"
        offlineLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        offlineLabel.font = MediaProvider.getFont(ofSize: 7, weight: .bold)
        offlineLabel.textAlignment = .center
        offlineLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(offlineLabel)
        
        timeLabel = UILabel()
        timeLabel.text = "23hrs"
        timeLabel.textColor = UIColor.black
        timeLabel.font = MediaProvider.getFont(ofSize: 12.5, weight: .bold)
        timeLabel.textAlignment = .center
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)

        NSLayoutConstraint.activate([
            backgroundView.widthAnchor.constraint(equalTo: widthAnchor),
            backgroundView.heightAnchor.constraint(equalTo: heightAnchor),
            
            offlineLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3.0),
            offlineLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 3.0),
            offlineLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -3.0),
            
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3.0),
            timeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 3.0),
            timeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -3.0)
        ])
    }
    
    func setOfflineTime(interval: TimeInterval) {
        var time = 0.0
        var unit = "min"
        if (interval < 3600) {
            time = (interval / 60).rounded()
            unit = "min"
        } else if (interval < 86400) {
            time = (interval / 3600).rounded()
            unit = "hrs"
        } else {
            time = (interval / 86400).rounded()
            unit = "days"
        }
        timeLabel.text = "\(String(format: "%.0f", time))\(unit)"
    }
    
}
