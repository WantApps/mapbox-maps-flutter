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
    
    public static func registerFonts() {
        NSLog("MapBoxFlutter: registerFonts...")
        let podBundle = Bundle(for: MediaProvider.self)
        let resultRegular = UIFont.registerFont(bundle: podBundle, fontName: "jet_brains_mono_regular", fontExtension: "ttf")
        let resultBold = UIFont.registerFont(bundle: podBundle, fontName: "jet_brains_mono_bold", fontExtension: "ttf")
        let resultExtraBold = UIFont.registerFont(bundle: podBundle, fontName: "jet_brains_mono_extrabold", fontExtension: "ttf")
        NSLog("MapBoxFlutter: registerFonts: regular = \(resultRegular), bold = \(resultBold), extraBold = \(resultExtraBold)")
//        for family in UIFont.familyNames.sorted() {
//          let names = UIFont.fontNames(forFamilyName: family)
//          NSLog("MapBoxFlutter: Family: \(family) Font names: \(names)")
//        }
    }
    
    public static func getFont(ofSize fontSize: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        switch weight {
            case .bold:
                return UIFont(name: "JetBrainsMono-Bold", size: fontSize)!
            case .heavy:
                return UIFont(name: "JetBrainsMono-ExtraBold", size: fontSize)!
            default:
                return UIFont(name: "JetBrainsMono-Regular", size: fontSize)!
        }
    }
}
