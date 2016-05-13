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
    
    init(apiKey: String, versionController: VersionController, cache: SlovarCache = SlovarCache()) {
        self.apiKey = apiKey
        self.cache = cache
        self.versionController = versionController
    }
    
    func prepareVocabulary(completion: (Void) -> Void) {
        fetchVocabulary(completion)
    }
    
    func fetchVocabulary(completion: (Void) -> Void) {
        let getOperation = GetVocabularyOperation(cache: cache, completion: completion)
        operationQueue.addOperation(getOperation)
    }
    
}

final class FakeVocabularyController: VocabularyController {
    
    let apiKey: String
    let cache: SlovarCache
    
    init(apiKey: String, cache: SlovarCache = SlovarCache()) {
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
                                        permissibility: .NotAllowed)
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
