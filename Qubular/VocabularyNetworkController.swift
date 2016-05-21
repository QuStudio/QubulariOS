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
    let versionController: VersionController
    private let operationQueue = OperationQueue()
    
    let cacheFile: NSURL = {
        let docsFolder = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        let cacheFile = docsFolder.URLByAppendingPathComponent("entries.json")
        return cacheFile
    }()
    
    private let loadOperation: LoadVocabularyFromFileOperation
    init(apiKey: String, versionController: VersionController) {
        self.apiKey = apiKey
        self.versionController = versionController
        self.cache = SlovarCache()
        self.loadOperation = LoadVocabularyFromFileOperation(file: cacheFile, vocabularyCache: cache)
        loadOperation.observe { (operation) in
            operation.didFinish {
                print($0)
            }
            operation.didFailed {
                debugPrint($0)
            }
        }
        
        cache.delegate = self
        operationQueue.addOperation(loadOperation)
        
    }
    
    /// Asks controller to prepare vocabulary for viewing. May be called multiple times (for example, after load from persistent storage or from the web).
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

final class FakeVocabularyController: VocabularyController {
    
    let apiKey: String
    let cache: SlovarCache
    
    init(apiKey: String, cache: SlovarCache) {
        self.apiKey = apiKey
        self.cache = cache
    }
    
    func prepareVocabulary(completion: (Void) -> Void) {
        testFetchSlovar(completion)
    }
    func testFetchSlovar(completion: (Void) -> Void) {
        let queue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)
        dispatch_async(queue) {
            let foreign = ForeignLexeme(lemma: Morpheme("Менеджер"),
                                        forms: [Morpheme("Менеджмент"), Morpheme("Менеджуля")],
                                        origin: Morpheme("manager"),
                                        meaning: "A head of something",
                                        permissibility: .GenerallyAllowed)
            let native1 = NativeLexeme(lemma: Morpheme("Управляющий"),
                                       meaning: "",
                                       usage: .General)
            let native2 = NativeLexeme(lemma: Morpheme("Главный"),
                                       meaning: "",
                                       usage: .Promising)
            let native3 = NativeLexeme(lemma: Morpheme("Заведующий"),
                                       meaning: "",
                                       usage: .Rare)
            let natives: Set = [native1, native2, native3]
            let voc = [Entry(id: 2, foreign: foreign, natives: natives)]
            self.cache.vocabulary = voc
            completion()
        }
    }
}
