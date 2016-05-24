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

class WhisperController: MessagePresenter {
    
    private let navigationController: UINavigationController
    init(whisperTo navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    static let errorColor = UIColor(red: 128/255, green: 0, blue: 0, alpha: 1.0)
    static let warningColor = UIColor(red: 245/255, green: 215/255, blue: 110/255, alpha: 1.0)
    static let niceColor = UIColor(red: 63/255, green: 195/255, blue: 128/255, alpha: 1.0)
    func present(message message: UserMessage) {
        let colorChooser: () -> UIColor = {
            switch message.type {
            case .Error:
                return WhisperController.errorColor
            case .Notice:
                return WhisperController.warningColor
            case .Nice:
                return WhisperController.niceColor
            }
        }
        let color = colorChooser()
        onMainQueue { 
            let wmessage = Message(title: message.string, backgroundColor: color)
            Whisper(wmessage, to: self.navigationController, action: .Show)
        }
    }
    
}
