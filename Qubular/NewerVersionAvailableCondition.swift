//
//  PrepareVocabularyOperation.swift
//  Qubular
//
//  Created by Oleg Dreyman on 12.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Operations
import Vocabulaire

class NewerVersionAvailableCondition: OperationCondition {
    
    static var name = "Latest Version Condition"
    static var isMutuallyExclusive = false
    
    let versionController: VersionController
    let developSupport: Bool
    
    init(versionController: VersionController, developSupport: Bool = true) {
        self.developSupport = developSupport
        self.versionController = versionController
    }
    
    private var versions: Versions?
    func dependencyForOperation(operation: Operation) -> NSOperation? {
        let checkVersion = CheckVersionOperation()
        checkVersion.observe { (operation) in
            operation.didSuccess {
                if let newest = checkVersion.latestVersion, current = self.versionController.version {
                    self.versions = Versions(stored: current, latest: newest)
                }
            }
        }
        return checkVersion
    }
    
    func evaluateForOperation(operation: Operation, completion: OperationConditionResult -> Void) {
        guard let versions = versions else {
            completion(.Failed(error: Error.CannotCheckForLatestVersion))
            return
        }
        if developSupport && versions.latest == .develop {
            completion(.Satisfied)
        } else if versions.latest > versions.stored {
            completion(.Satisfied)
        } else {
            completion(.Failed(error: Error.LatestVersionIsAlreadyStored))
        }
    }
    
    enum Error: ErrorType {
        case CannotCheckForLatestVersion
        case LatestVersionIsAlreadyStored
    }
    
}

class CheckVersionOperation: Operation {
    
    var latestVersion: VocabularyVersion?
    private lazy var urlSession: NSURLSession = NSURLSession.sharedSession()
    
    override init() {
        super.init()
        let networkObserver = NetworkObserver()
        addObserver(networkObserver)
        self.name = "Check Version"
    }
    
    override func execute() {
        let url = NSURL(string: "http://qubular.org/api/version")!
        let task = urlSession.dataTaskWithURL(url) { (data, response, error) in
            if let error = error {
                self.finishWithError(CheckVersionError.NetworkClientError(systemError: error as ErrorType))
                return
            }
            if let status = (response as? NSHTTPURLResponse)?.statusCode where status != 200 {
                self.finishWithError(ServerError.Not200(statusCode: status))
                return
            }
            guard let data = data else {
                self.finishWithError(CheckVersionError.NoData)
                return
            }
            do {
                let version = try VocabularyVersion(from: data)
                self.latestVersion = version
                self.finish()
                return
            } catch {
                self.finishWithError(error)
                return
            }
        }
        task.resume()
    }
    
}

enum CheckVersionError: ErrorType {
    case NoData
    case JSONParsingFailed(jsonError: ErrorType)
    case CannotInitializeVersionFromJSON
    case NetworkClientError(systemError: ErrorType?)
}
