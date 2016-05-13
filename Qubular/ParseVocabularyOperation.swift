//
//  ParseVocabularyOperation.swift
//  Qubular
//
//  Created by Oleg Dreyman on 01.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Operations
import Vocabulaire

class ParseVocabularyOperation: Operation {
    
    let cache: SlovarCache
    let cacheFile: NSURL
    
    init(cacheFile: NSURL, vocabularyCache: SlovarCache) {
        self.cacheFile = cacheFile
        self.cache = vocabularyCache
        super.init()
        self.name = "Parse Vocabulary"
    }
    
    override func execute() {
        print(cacheFile)
        guard let stream = NSInputStream(URL: cacheFile) else {
            finish()
            return
        }
        
        stream.open()
        defer { stream.close() }
        
        do {
            if let json = try NSJSONSerialization.JSONObjectWithStream(stream, options: [.AllowFragments]) as? [String: AnyObject],
                jentries = json["entries"] as? [[String: AnyObject]] {
                let entries: [Entry] = jentries.flatMap {
                    do {
                        return try Entry(from: $0)
                    } catch let error {
                        print(error, $0)
                        return nil
                    }
                }
                self.cache.vocabulary = entries
                print("finishing")
                finish()
            } else {
                print("failed")
                finishWithError(NSError(code: .ExecutionFailed))
            }
        } catch let jsonError as NSError {
            print(jsonError)
            finishWithError(jsonError)
        }
    }
    
}
