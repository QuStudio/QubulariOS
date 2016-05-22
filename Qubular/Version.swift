//
//  Version.swift
//  Qubular
//
//  Created by Oleg Dreyman on 12.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire

protocol VersionController: class {
    var version: VocabularyVersion? { get set }
}

final class UserDefaultsVersionController: VersionController {
    
    static private let key = "com.qubular.vocabularyVersion"
    private let defaults: NSUserDefaults
    
    init(defaults: NSUserDefaults = .standardUserDefaults()) {
        self.defaults = defaults
    }
    
    var version: VocabularyVersion? {
        get {
            if let versionRepresentation = defaults.objectForKey(UserDefaultsVersionController.key) as? Structure,
                version = try? VocabularyVersion(from: versionRepresentation) {
                return version
            }
            return nil
        }
        set {
            defaults.setObject(newValue?.representation, forKey: UserDefaultsVersionController.key)
        }
    }
    
}

struct Versions {
    
    let stored: VocabularyVersion
    let latest: VocabularyVersion
    
}
