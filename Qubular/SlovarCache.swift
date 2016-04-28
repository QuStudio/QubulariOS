//
//  VocabulaireCache.swift
//  Qubular
//
//  Created by Oleg Dreyman on 27.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire

class SlovarCache {
    
    private static let slovarKey = "slovar"
    private let cache = NSCache()
    
    init() {
        let book = Book(vocabulary: [])
        cache.setObject(book, forKey: SlovarCache.slovarKey)
    }
    
    var vocabulary: Vocabulary? {
        get {
            if let book = cache.objectForKey(SlovarCache.slovarKey) as? Book {
                return book.vocabulary
            }
            return nil
        }
        set {
            guard let vocabulary = newValue else { return }
            let book = Book(vocabulary: vocabulary)
            cache.setObject(book, forKey: SlovarCache.slovarKey)
        }
    }
    
}

private class Book {
    
    var vocabulary: Vocabulary
    
    init(vocabulary: Vocabulary) {
        self.vocabulary = vocabulary
    }
    
}
