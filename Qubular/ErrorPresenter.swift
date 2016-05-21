//
//  ErrorPresenter.swift
//  Qubular
//
//  Created by Oleg Dreyman on 21.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

protocol ErrorPresenter: class {
    func present(errorMessage message: String)
}
