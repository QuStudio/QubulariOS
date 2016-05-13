//
//  Version.swift
//  Qubular
//
//  Created by Oleg Dreyman on 12.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire

class VersionController {
    
    static private let defaultsKey = "com.qubular.vocabularyVersion"
    
    var version: VocabularyVersion
    var latestAvailableVersion: VocabularyVersion?
    let defaults: NSUserDefaults?
    
    init(defaults: NSUserDefaults? = .standardUserDefaults()) {
        self.defaults = defaults
        if let versionDict = defaults?.objectForKey(VersionController.defaultsKey) as? [String: AnyObject],
            version = try? VocabularyVersion(from: versionDict) {
            self.version = version
        } else {
            self.version = .develop
            defaults?.setObject(version.representation, forKey: VersionController.defaultsKey)
        }
    }
    
    init(version: VocabularyVersion, defaults: NSUserDefaults? = .standardUserDefaults()) {
        self.defaults = defaults
        self.version = version
        defaults?.setObject(version.representation, forKey: VersionController.defaultsKey)
    }
    
}
