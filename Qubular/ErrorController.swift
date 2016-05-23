//
//  ErrorController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 21.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

final class ErrorController {
    
    var presenter: ErrorPresenter?
    
    static let failMessage = "Нет возможности обновить словарь"
    static let unknownErrorMessage = "Неизвестная ошибка"
    func errorDidHappen(error: ErrorType) {
        debugPrint(error)
        switch error {
        case DownloadVocabularyOperation.Error.NetworkClientError:
            self.presenter?.present(errorMessage: ErrorController.failMessage)
        case ServerError.Not200:
            self.presenter?.present(errorMessage: ErrorController.failMessage)
        default:
            self.presenter?.present(errorMessage: ErrorController.unknownErrorMessage)
        }
    }
    
}
