//
//  VocabularyControllerUser.swift
//  Qubular
//
//  Created by Oleg Dreyman on 14.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

protocol VocabularyControllerUser: class {
    weak var vocabularyController: VocabularyController! { get set }
}
