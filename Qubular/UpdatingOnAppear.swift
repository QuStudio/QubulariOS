//
//  UpdatingOnAppear.swift
//  Qubular
//
//  Created by Oleg Dreyman on 26.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

protocol UpdatingOnAppear: class {
    var dataUpdateAvailable: Bool { get set }
    func updateData()
}

extension UpdatingOnAppear {
    
    func dataDidUpdate() {
        dataUpdateAvailable = true
    }
    
    func updateData() { }
    
    func updateIfNewDataAvailable() {
        if dataUpdateAvailable {
            updateData()
        }
    }
    
}
