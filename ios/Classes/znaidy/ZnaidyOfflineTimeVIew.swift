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
    
    private var updatesTimer: Timer?
    
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
        offlineLabel.text = Localizaton.localize(key: "offline_for")
        offlineLabel.textColor = UIColor.black.withAlphaComponent(0.5)
        offlineLabel.font = MediaProvider.getFont(ofSize: 7, weight: .bold)
        offlineLabel.textAlignment = .center
        offlineLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(offlineLabel)
        
        timeLabel = UILabel()
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
    
    func setOfflineTime(offlineTimestamp: Int) {
        startUpdates(offlineTimestamp)
    }
    
    private func startUpdates(_ offlineTimestamp: Int) {
        stopUpdates()
        onUpdate(offlineTimestamp: offlineTimestamp)
        updatesTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
            self.onUpdate(offlineTimestamp: offlineTimestamp)
        }
    }
    
    func stopUpdates() {
        updatesTimer?.invalidate()
    }
    
    private func onUpdate(offlineTimestamp: Int) {
        let lastOnlineDate = Date(timeIntervalSince1970: Double(offlineTimestamp) / 1000.0)
        let diffs = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: lastOnlineDate, to: Date())
        let offlineTime = Int(Date().timeIntervalSince1970 - Double(offlineTimestamp / 1000))
        
        if (diffs.year! >= 1) {
            offlineLabel.text = Localizaton.localize(key: "offline_for")
            if (diffs.month! % 12 == 0) {
                let attributedString = NSMutableAttributedString()
                attributedString.append(NSAttributedString(string: "\(diffs.year!)"))
                attributedString.append(NSAttributedString(string: " ", attributes: [ NSAttributedString.Key.font: MediaProvider.getFont(ofSize: 6, weight: .bold) ]))
                attributedString.append(NSAttributedString(string: "\(Localizaton.localize(key: "time_unit_year"))"))
                timeLabel.attributedText = attributedString
            } else {
                let attributedString = NSMutableAttributedString()
                attributedString.append(NSAttributedString(string: "\(diffs.year!)\(Localizaton.localize(key: "time_unit_year"))"))
                attributedString.append(NSAttributedString(string: " ", attributes: [ NSAttributedString.Key.font: MediaProvider.getFont(ofSize: 6, weight: .bold) ]))
                attributedString.append(NSAttributedString(string: "\(diffs.month!)\(Localizaton.localize(key: "time_unit_month"))"))
                timeLabel.attributedText = attributedString
            }
        } else if (diffs.day! >= 7) {
            let format = DateFormatter()
            format.dateFormat = "d MMM"
            offlineLabel.text = Localizaton.localize(key: "offline_since")
            let formattedDate = format.string(from: lastOnlineDate).uppercased().replacingOccurrences(of: ".", with: "")
            let parts = formattedDate.split(separator: " ")
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: "\(parts[0])"))
            attributedString.append(NSAttributedString(string: " ", attributes: [ NSAttributedString.Key.font: MediaProvider.getFont(ofSize: 6, weight: .bold) ]))
            let monthName = String(parts[1])
            attributedString.append(NSAttributedString(string: "\(monthName.prefix(3))"))
            timeLabel.attributedText = attributedString
        } else {
            var time = 0
            var unit = "min"
            if (diffs.day! >= 1) {
                time = diffs.day!
                unit = Localizaton.localizePlural(key: "time_unit_day", count: time)
            } else if (diffs.hour! < 1) {
                time = diffs.minute!
                unit = Localizaton.localize(key: "time_unit_minute")
            } else if (diffs.hour! < 24) {
                time = diffs.hour!
                unit = Localizaton.localizePlural(key: "time_unit_hour", count: time)
            }
            offlineLabel.text = Localizaton.localize(key: "offline_for")
            let attributedString = NSMutableAttributedString()
            attributedString.append(NSAttributedString(string: "\(time)"))
            attributedString.append(NSAttributedString(string: " ", attributes: [ NSAttributedString.Key.font: MediaProvider.getFont(ofSize: 6, weight: .bold) ]))
            attributedString.append(NSAttributedString(string: "\(unit)"))
            timeLabel.attributedText = attributedString
        }
    }
    
}
