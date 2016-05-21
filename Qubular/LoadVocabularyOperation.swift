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
    
    init(file: NSURL, vocabularyCache: SlovarCache) {
        self.file = file
        self.cache = vocabularyCache
        super.init()
        self.name = "Parse Vocabulary"
    }
    
    override func execute() {
        print(file)
        guard let stream = NSInputStream(URL: file) else {
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
                finishWithError(OperationError.ExecutionFailed)
            }
        } catch let jsonError {
            print(jsonError)
            finishWithError(jsonError)
        }
    }
    
}
