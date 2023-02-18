//
//  MediaProvider.swift
//  mapbox_maps_flutter
//
//  Created by Yurii Potapov on 17.02.2023.
//

import Foundation

class MediaProvider {
    // convenient for specific image
    public static func picture() -> UIImage {
        return UIImage(named: "picture", in: Bundle(for: self), with: nil) ?? UIImage()
    }
    
    // for any image located in bundle where this class has built
    public static func image(named: String) -> UIImage? {
        return UIImage(named: named, in: Bundle(for: self), with: nil)
    }
}
