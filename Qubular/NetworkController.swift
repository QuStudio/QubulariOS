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
    func updateVocabulary(completion: (Void) -> Void)
}

final class VocabularyNetworkController: VocabularyController {
    
    let apiKey: String
    let cache: SlovarCache
    let versionController: VersionController
    var errorController: ErrorController?
    private let operationQueue = OperationQueue()
    private let logObserver = LogObserver()
    
    let entriesFileURL: NSURL = {
        let docsFolder = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let cacheFile = docsFolder.URLByAppendingPathComponent("entries.json")
        return cacheFile
    }()
    
    private let initialLoadOperation: LoadVocabularyFromFileOperation
    init(apiKey: String, versionController: VersionController) {
        self.apiKey = apiKey
        self.versionController = versionController
        self.cache = SlovarCache()
        self.initialLoadOperation = LoadVocabularyFromFileOperation(file: entriesFileURL, vocabularyCache: cache)
        initialLoadOperation.observe { (operation) in
            operation.didSuccess {
                print("Loaded!")
            }
            operation.didFail {
                debugPrint($0)
            }
        }
        
        cache.delegate = self
        operationQueue.delegate = self
        operationQueue.addOperation(initialLoadOperation)
    }
    
    /// Asks controller to prepare vocabulary for viewing. Completion may be called multiple times (for example, after load from persistent storage or from the web).
    func prepareVocabulary(completion: (Void) -> Void) {
        if initialLoadOperation.finished {
            completion()
        }
        fetchVocabulary(completion)
    }
    
    func updateVocabulary(completion: (Void) -> Void) {
        fetchVocabulary(completion)
    }
    
    private func fetchVocabulary(completion: (Void) -> Void) {
        let getOperation = GetVocabularyOperation(cache: cache, versionController: versionController)
        let onlyIfNotLatest = NewerVersionAvailableCondition(versionController: versionController, developSupport: true)
        getOperation.addCondition(onlyIfNotLatest)
        getOperation.observe { operation in
            operation.didSuccess {
                completion()
            }
            operation.didFail { (errors) in
                print(self.errorController)
                for error in errors {
                    self.errorController?.errorDidHappen(error)
                }
                completion()
            }
        }
        getOperation.qualityOfService = .UserInitiated
        operationQueue.addOperation(getOperation)
    }
    
}

extension VocabularyNetworkController: SlovarCacheDelegate {
    func cacheDidUpdate(cache: SlovarCache) {
        let serialize = SaveVocabularyToFileOperation(to: entriesFileURL, from: cache)
        operationQueue.addOperation(serialize)
    }
}

extension VocabularyNetworkController: OperationQueueDelegate {
    func operationQueue(operationQueue: OperationQueue, willAddOperation operation: NSOperation) {
        if operation !== initialLoadOperation {
            operation.addDependency(initialLoadOperation)
        }
        if let operation = operation as? Operation {
            operation.addObserver(logObserver)
        }
    }
    func operationQueue(operationQueue: OperationQueue, operationDidFinish operation: NSOperation, withErrors errors: [ErrorType]) { }
}
