//
//  FakeVocabularyController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 21.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire

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
    
    func updateVocabulary(completion: (Void) -> Void) {
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
