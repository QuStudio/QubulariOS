//
//  SlovarNetworkController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 26.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire

final class SlovarNetworkController {
    
    let apiKey: String
    let cache: SlovarCache
    
    weak var fetchingDelegate: SlovarFetchingDelegate?
    
    private static let slovarCacheKey = "slovar"
    
    static let slovarFetchingCompletedNotification = "slovarFetchingCompletedNotification"
    let notificationCenter = NSNotificationCenter.defaultCenter()

    init(apiKey: String, cache: SlovarCache = SlovarCache()) {
        self.apiKey = apiKey
        self.cache = cache
    }
    
//    func registerMe(registrant: SlovarFetchingNotificationReceiver) {
//        notificationCenter.addObserver(registrant, selector: #selector(SlovarFetchingNotificationReceiver.slovarFetchingCompleted(_:)), name: SlovarNetworkController.slovarFetchingCompletedNotification, object: self)
//    }
    
    func fetchSlovar() {
        testFetchSlovar()
    }
    
    func testFetchSlovar() {
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
            self.notificationCenter.postNotification(NSNotification(name: SlovarNetworkController.slovarFetchingCompletedNotification, object: self, userInfo: ["cacheKey": SlovarNetworkController.slovarCacheKey]))
            self.fetchingDelegate?.slovarFetchingCompleted()
        }
    }
    
}

@objc protocol SlovarUpdateObserver: class {

    func slovarDidUpdate(notification: NSNotification)

}

protocol SlovarFetchingDelegate: class {

    func slovarFetchingCompleted()

}
