//
//  LogObserver.swift
//  Qubular
//
//  Created by Oleg Dreyman on 21.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Operations

final class LogObserver: OperationObserver {
    
    func operationDidStart(operation: Operation) {
        debugPrint("\(operation) did start")
    }
    
    func operation(operation: Operation, didProduceOperation newOperation: NSOperation) {
        debugPrint("\(operation) did produce \(newOperation)")
    }
    
    func operationDidFinish(operation: Operation, errors: [ErrorType]) {
        if errors.isEmpty {
            debugPrint("\(operation) did finish succesfully")
        } else {
            debugPrint("\(operation) did failed with \(errors)")
        }
    }
    
}
