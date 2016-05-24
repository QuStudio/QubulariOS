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

final class GetVocabularyOperation: GroupOperation {
    
    let downloadOperation: DownloadVocabularyOperation
    let parseOperation: LoadVocabularyFromFileOperation
    
    init(cache: SlovarCache, versionController: VersionController? = nil) {
        let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let cacheFile = cachesFolder.URLByAppendingPathComponent("entries.json")
        downloadOperation = DownloadVocabularyOperation(cacheFile: cacheFile)
        let networkObserver = NetworkObserver()
        downloadOperation.addObserver(networkObserver)
        parseOperation = LoadVocabularyFromFileOperation(file: cacheFile, vocabularyCache: cache, versionController: versionController)
        parseOperation.addDependency(downloadOperation)
        
        super.init(operations: [downloadOperation, parseOperation])
        downloadOperation.observe { (operation) in
            operation.didFail { errors in
                self.finish(errors)
                self.parseOperation.cancel()
            }
        }
        self.name = "Get Vocabulary"
    }
    
}
