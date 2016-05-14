//
//  OperationErrorHandler.swift
//  Qubular
//
//  Created by Oleg Dreyman on 14.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Operations

protocol OperationErrorHandler {
    
    func operation(operation: Operation, didFailedWithErrors erros: [NSError])
    
}
