//
//  SlovarNetworkController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 26.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire
import Operations

protocol VocabularyController: class {
    var cache: SlovarCache { get }
    func prepareVocabulary(completion: (Void) -> Void)
}

final class VocabularyNetworkController: VocabularyController {
    
    let apiKey: String
    let cache: SlovarCache
    private let operationQueue = OperationQueue()
    private let logObserver = LogObserver()
    
    let cacheFile: NSURL = {
        let docsFolder = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let cacheFile = docsFolder.URLByAppendingPathComponent("entries.json")
        return cacheFile
    }()
    
    private let loadOperation: LoadVocabularyFromFileOperation
    init(apiKey: String) {
        self.apiKey = apiKey
        self.cache = SlovarCache()
        self.loadOperation = LoadVocabularyFromFileOperation(file: cacheFile, vocabularyCache: cache)
        loadOperation.observe { (operation) in
            operation.didFinish { _ in
                print("Loaded!")
            }
            operation.didFailed {
                debugPrint($0)
            }
        }
        
        cache.delegate = self
        operationQueue.delegate = self
        operationQueue.addOperation(loadOperation)
        
    }
    
    /// Asks controller to prepare vocabulary for viewing. Completion may be called multiple times (for example, after load from persistent storage or from the web).
    func prepareVocabulary(completion: (Void) -> Void) {
        if loadOperation.finished {
            completion()
        }
        fetchVocabulary(completion)
    }
    
    private func fetchVocabulary(completion: (Void) -> Void) {
        let getOperation = GetVocabularyOperation(cache: cache)
        getOperation.observe { (operation) in
            operation.didFinish { _ in completion() }
            operation.didFailed { (errors) in
                print(errors)
            }
        }
        getOperation.qualityOfService = .UserInitiated
        getOperation.addDependency(loadOperation)
        operationQueue.addOperation(getOperation)
    }
    
}

extension VocabularyNetworkController: SlovarCacheDelegate {
    func cacheDidUpdate(cache: SlovarCache) {
        let serialize = SaveVocabularyToFileOperation(to: cacheFile, from: cache)
        operationQueue.addOperation(serialize)
    }
}

extension VocabularyNetworkController: OperationQueueDelegate {
    func operationQueue(operationQueue: OperationQueue, willAddOperation operation: NSOperation) {
        if let operation = operation as? Operation {
            operation.addObserver(logObserver)
        }
    }
    func operationQueue(operationQueue: OperationQueue, operationDidFinish operation: NSOperation, withErrors errors: [ErrorType]) { }
}
