//
//  Searchable.swift
//  Qubular
//
//  Created by Oleg Dreyman on 22.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Vocabulaire

enum SearchState {
    case NotSuited
    case Suited(rate: Int)
}

extension SearchState: Comparable { }

func == (lhs: SearchState, rhs: SearchState) -> Bool {
    switch (lhs, rhs) {
    case (.NotSuited, .NotSuited):
        return true
    case (.Suited(let left), .Suited(let right)):
        return left == right
    default:
        return false
    }
}

func < (lhs: SearchState, rhs: SearchState) -> Bool {
    switch (lhs, rhs) {
    case (.Suited(let left), .Suited(let right)):
        return left < right
    case (.NotSuited, .Suited):
        return true
    case (.Suited, .NotSuited):
        return false
    default:
        return false
    }
}

protocol Searchable {
    
    func suitRate(forString string: String) -> SearchState
    
}

extension Searchable {
    
    func isSuited(forString string: String) -> Bool {
        switch suitRate(forString: string) {
        case .NotSuited:
            return false
        case .Suited(let rate) where rate > 0:
            return true
        default:
            return false
        }
    }
    
}

infix operator §§ { associativity left precedence 100 }
private func §§ (left: String, right: String) -> Bool {
    return left.lowercaseString.containsString(right.lowercaseString)
}

extension Entry: Searchable {
    
    func suitRate(forString string: String) -> SearchState {
        var finalRate = 0
        if foreign.lemma.view §§ string {
            finalRate += 100
        }
        for form in foreign.forms.map({ $0.view }) where form §§ string {
            finalRate += 50
            break
        }
        if foreign.meaning §§ string {
            finalRate += 20
        }
        if foreign.origin.view §§ string {
            finalRate += 50
        }
        for native in natives.map({ $0.lemma.view }) where native §§ string {
            finalRate += 30
            break
        }
        return finalRate > 0 ? .Suited(rate: finalRate) : .NotSuited
    }
    
}
