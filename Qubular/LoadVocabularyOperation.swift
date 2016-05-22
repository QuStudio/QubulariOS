//
//  LoadVocabularyFromFileOperation.swift
//  Qubular
//
//  Created by Oleg Dreyman on 01.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Operations
import Vocabulaire

final class LoadVocabularyFromFileOperation: Operation {
    
    let cache: SlovarCache
    let file: NSURL
    let versionController: VersionController?
    
    init(file: NSURL, vocabularyCache: SlovarCache, versionController: VersionController? = nil) {
        self.file = file
        self.cache = vocabularyCache
        self.versionController = versionController
        super.init()
        self.name = "Parse Vocabulary"
    }
    
    enum Error: ErrorType {
        case InvalidJSONStructure
        case NoVersionInJSON
        case JSONSerializationError(systemError: ErrorType?)
    }
    
    override func execute() {
        guard let stream = NSInputStream(URL: file) else {
            finish()
            return
        }
        
        stream.open()
        defer { stream.close() }
        
        do {
            if let json = try NSJSONSerialization.JSONObjectWithStream(stream, options: [.AllowFragments]) as? [String: AnyObject],
                jentries = json["entries"] as? [[String: AnyObject]] {
                let entries: [Entry] = jentries.flatMap({ try? Entry(from: $0) })
                self.cache.vocabulary = entries
                if let versionController = versionController {
                    if let newVersion = (json["version"] as? Structure).flatMap({ try? VocabularyVersion(from: $0) }) {
                        versionController.version = newVersion
                    } else {
                        finishWithError(Error.NoVersionInJSON)
                        return
                    }
                }
                finish()
            } else {
                finishWithError(Error.InvalidJSONStructure)
            }
        } catch let jsonError {
            print(jsonError)
            finishWithError(Error.JSONSerializationError(systemError: jsonError))
        }
    }
    
}
