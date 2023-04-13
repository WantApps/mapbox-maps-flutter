//
//  Localization.swift
//  Pods
//
//  Created by Yurii Potapov on 13.04.2023.
//

import Foundation
import L10n_swift

class Localizaton {
    static let shared = Localizaton()
    
    private let l10n: L10n
    
    init() {
        let podBundle = Bundle(for: Localizaton.self)
        l10n = L10n(bundle: podBundle)
    }
    
    public static func localize(key: String) -> String {
        return key.l10n(instance: Localizaton.shared.l10n)
//        let podBundle = Bundle(for: Localizaton.self)
//        return NSLocalizedString(key, bundle: podBundle, comment: "")
    }
    
    public static func localizePlural(key: String, count: Int) -> String {
        return key.l10nPlural(instance: Localizaton.shared.l10n, count)
//        let podBundle = Bundle(for: Localizaton.self)
//        let format = NSLocalizedString(key, bundle: podBundle, comment: "")
//        var result = String.localizedStringWithFormat(format, count)
//        return result
    }
}
