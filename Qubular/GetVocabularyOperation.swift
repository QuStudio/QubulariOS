//
//  GetVocabularyOperation.swift
//  Qubular
//
//  Created by Oleg Dreyman on 01.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Operations
import Vocabulaire

class GetVocabularyOperation: GroupOperation {
    
    let downloadOperation: DownloadVocabularyOperation
    let parseOperation: ParseVocabularyOperation
    
    init(cache: SlovarCache, completion: Void -> Void) {
        let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let cacheFile = cachesFolder.URLByAppendingPathComponent("entries.json")
        downloadOperation = DownloadVocabularyOperation(cacheFile: cacheFile)
        let networkObserver = NetworkObserver()
        downloadOperation.addObserver(networkObserver)
        parseOperation = ParseVocabularyOperation(cacheFile: cacheFile, vocabularyCache: cache)
        parseOperation.addDependency(downloadOperation)
        
        let finishing = NSBlockOperation(block: completion)
        finishing.addDependency(parseOperation)
        
        super.init(operations: [downloadOperation, parseOperation, finishing])
        self.name = "Get Vocabulary"
    }
    
}
