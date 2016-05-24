//
//  ErrorPresenter.swift
//  Qubular
//
//  Created by Oleg Dreyman on 21.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

//protocol ErrorPresenter: class {
//    func present(errorMessage message: String)
//}

struct UserMessage {
    enum Kind {
        case Error
        case Notice
        case Nice
    }
    let string: String
    let type: Kind
    init(_ string: String, type: Kind = .Error) {
        self.string = string
        self.type = type
    }
}

protocol MessagePresenter: class {
    func present(message message: UserMessage)
}
