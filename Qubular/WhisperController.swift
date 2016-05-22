//
//  WhisperController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 21.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import UIKit
import Whisper

class WhisperController: ErrorPresenter {
    
    private let navigationController: UINavigationController
    init(whisperTo navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    static let errorCollor = UIColor(red: 128/255, green: 0, blue: 0, alpha: 1.0)
    func present(errorMessage message: String) {
        onMainQueue { 
            let wmessage = Message(title: message, backgroundColor: WhisperController.errorCollor)
            Whisper(wmessage, to: self.navigationController, action: .Show)
        }
    }
    
}
