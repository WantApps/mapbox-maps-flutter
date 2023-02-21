//
//  MediaProvider.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 17.02.2023.
//

import Foundation

class MediaProvider {

    public static func image(named: String) -> UIImage? {
        let podBundle = Bundle(for: MediaProvider.self)
        guard let url = podBundle.url(forResource: "mapbox_maps_flutter", withExtension: "bundle") else {
            return nil
        }
        return UIImage(named: named, in: Bundle(url: url), compatibleWith: nil)
    }
}
