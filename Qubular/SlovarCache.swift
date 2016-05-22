//
//  VocabulaireCache.swift
//  Qubular
//
//  Created by Oleg Dreyman on 27.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire
import CoreData

final class SlovarCache {
    
    private var firstTime = true
    var vocabulary: Vocabulary = [] {
        didSet {
            if !firstTime {
                delegate?.cacheDidUpdate(self)
            } else {
                firstTime = false
            }
        }
    }
    
    weak var delegate: SlovarCacheDelegate?
    
    init(delegate: SlovarCacheDelegate? = nil) {
        self.delegate = delegate
    }
        
}

protocol SlovarCacheDelegate: class {
    func cacheDidUpdate(cache: SlovarCache)
}

private class Book {
    
    var vocabulary: Vocabulary
    
    init(vocabulary: Vocabulary) {
        self.vocabulary = vocabulary
    }
    
}
