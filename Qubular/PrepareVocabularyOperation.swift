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

class PrepareVocabularyOperation: Operation {
    
    init(cache: SlovarCache, completion: (Void) -> Void) {
        
    }
    
}

class LatestVersionCondition: OperationCondition {
    
    static var name = "Latest Version Condition"
    static var isMutuallyExclusive = false
    
    let versionController: VersionController
    
    init(versionController: VersionController) {
        self.versionController = versionController
    }
    
    func dependencyForOperation(operation: Operation) -> NSOperation? {
        return CheckVersionOperation(versionController: versionController)
    }
    
    func evaluateForOperation(operation: Operation, completion: OperationConditionResult -> Void) {
        guard let newestVersion = versionController.latestAvailableVersion else {
            completion(.Failed(error: Error.NoNewestVersion))
            return
        }
        if newestVersion > versionController.version {
            completion(.Failed(error: Error.LatestVersionIsNotInstalled))
            return
        }
        completion(.Satisfied)
    }
    
    enum Error: ErrorType {
        case NoNewestVersion
        case LatestVersionIsNotInstalled
    }
    
}

private class CheckVersionOperation: Operation {
    
    let versionController: VersionController
    
    init(versionController: VersionController) {
        self.versionController = versionController
        super.init()
        self.name = "Check Version"
    }
    
    private override func execute() {
        let url = NSURL(string: "http://qubular.org/api/version")!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (versionData, response, error) in
            if let data = versionData {
                self.dataTaskDidFinish(data, response: response)
            } else if let error = error {
                self.dataTaskDidFailed(with: error)
            }
        }
        task.resume()
    }
    
    func dataTaskDidFinish(versionData: NSData, response: NSURLResponse?) {
        if let response = response as? NSHTTPURLResponse where response.statusCode != 200 {
            self.finishWithError(ServerError.Not200(statusCode: response.statusCode))
            return
        }
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(versionData, options: []) as? [String: AnyObject], version = try? VocabularyVersion(from: json) {
                self.versionController.latestAvailableVersion = version
                self.finish()
            } else {
                self.finishWithError(CheckVersionError.CannotInitializeVersionFromJSON)
            }
        } catch {
            self.finishWithError(CheckVersionError.JSONParsingFailed(jsonError: error))
        }
    }
    
    func dataTaskDidFailed(with error: NSError) {
        finishWithError(error)
    }
    
}

enum CheckVersionError: ErrorType {
    case JSONParsingFailed(jsonError: ErrorType)
    case CannotInitializeVersionFromJSON
}
