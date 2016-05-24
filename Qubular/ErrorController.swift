//
//  ErrorController.swift
//  Qubular
//
//  Created by Oleg Dreyman on 21.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation

final class ErrorController {
    
    var presenter: MessagePresenter?
    
    static let failMessage = "Нет возможности обновить словарь"
    static let unknownErrorMessage = "Неизвестная ошибка"
    static let alreadyUpdatedMessage = "Словарь уже обновлён до последней версии"
    func errorDidHappen(error: ErrorType) {
        debugPrint(error)
        switch error {
        case DownloadVocabularyOperation.Error.NetworkClientError:
            self.presenter?.present(message: UserMessage(ErrorController.failMessage))
        case ServerError.Not200:
            self.presenter?.present(message: UserMessage(ErrorController.failMessage))
        case NewerVersionAvailableCondition.Error.LatestVersionIsAlreadyStored:
            self.presenter?.present(message: UserMessage(ErrorController.alreadyUpdatedMessage, type: .Nice))
        default:
            self.presenter?.present(message: UserMessage(ErrorController.unknownErrorMessage))
        }
    }
    
}
