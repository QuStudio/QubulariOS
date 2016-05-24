//
//  NativesBriefPresenter.swift
//  Qubular
//
//  Created by Oleg Dreyman on 21.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import UIKit
import Vocabulaire

protocol NativesBriefPresenting {
    
    weak var nativesLabel: UILabel! { get set }
    
}

final class NativesBriefPresenter {
    
    func present(entry: Entry, on presenting: NativesBriefPresenting) {
        presenting.nativesLabel.text = entry.nativesByUsage.map({ $0.lemma.view }).joinWithSeparator(", ")
    }
    
}

protocol NativePresenting {
    
    weak var lemmaLabel: UILabel! { get }
    weak var usageIndicator: IndicatorView! { get }
    
}

final class NativePresenter {
    
    let natives: [NativeLexeme]
    
    init(natives: [NativeLexeme]) {
        self.natives = natives
    }
    
    func present(nativeAt index: Int, on presenting: NativePresenting) {
        let native = natives[index]
        present(native, ofNumber: index + 1, on: presenting)
    }
    
    private func present(nativeLexeme: NativeLexeme, ofNumber number: Int, on presenting: NativePresenting) {
        let string = "\(number). \(nativeLexeme.lemma.view)"
        presenting.lemmaLabel.text = string
        presenting.usageIndicator.color = nativeLexeme.usage.indicatorColor
    }
    
}

private extension NativeLexeme.Usage {
    
    var indicatorColor: UIColor {
        switch self {
        case .General:
            return UIColor(red: 63/255, green: 195/255, blue: 128/255, alpha: 1.0)
        case .Promising:
            return UIColor(red: 245/255, green: 215/255, blue: 110/255, alpha: 1.0)
        case .Rare:
            return UIColor(red: 211/255, green: 84/255, blue: 0, alpha: 1.0)
        case .Fancy:
            return UIColor(red: 190/255, green: 144/255, blue: 212/255, alpha: 1.0)
        }
    }
    
}

