//
//  AdvancedSlovarCache.swift
//  Qubular
//
//  Created by Oleg Dreyman on 14.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire
import Operations

final class SaveVocabularyToFileOperation: Operation {
    
    let fileLocation: NSURL
    let cache: SlovarCache
    
    init(to fileLocation: NSURL, from cache: SlovarCache) {
        self.fileLocation = fileLocation
        self.cache = cache
    }
    
    override func execute() {
        guard let stream = NSOutputStream(URL: fileLocation, append: false) else {
            finish()
            return
        }
        
        stream.open()
        defer { stream.close() }
        
        let json = ["entries": cache.vocabulary.map({ $0.representation })]
        var error: NSError?
        NSJSONSerialization.writeJSONObject(json, toStream: stream, options: [], error: &error)
        if let error = error {
            finishWithError(error)
            return
        } else {
            finish()
            return
        }
    }
    
}
