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

