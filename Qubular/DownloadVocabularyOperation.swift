//
//  DownloadVocabularyOperation.swift
//  Qubular
//
//  Created by Oleg Dreyman on 01.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Operations

final class DownloadVocabularyOperation: Operation {
    
    let cacheFile: NSURL
    lazy var urlSession: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        return session
    }()
    
    init(cacheFile: NSURL) {
        self.cacheFile = cacheFile
        super.init()
        self.name = "Download Vocabulary"
    }
    
    override func execute() {
        let url = NSURL(string: "http://qubular.org/api/entries")!
        let task = urlSession.downloadTaskWithURL(url)
        task.resume()
    }
    
    enum Error: ErrorType {
        case Cancelled
        case CantMoveItem(systemError: ErrorType?)
        case NetworkClientError(systemError: ErrorType?)
    }
    
}

extension DownloadVocabularyOperation: NSURLSessionDownloadDelegate {
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        guard !cancelled else {
            finishWithError(Error.Cancelled)
            return
        }
        // Possible error handling
        if let status = (downloadTask.response as? NSHTTPURLResponse)?.statusCode where status != 200 {
            print(status)
            finishWithError(ServerError.Not200(statusCode: status))
            return
        }
        
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtURL(cacheFile)
        } catch { }
        do {
            try fileManager.moveItemAtURL(location, toURL: cacheFile)
            finish()
        } catch let error {
            finishWithError(Error.CantMoveItem(systemError: error))
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        guard !cancelled else {
            finishWithError(Error.Cancelled)
            return
        }
        if let error = error {
            finishWithError(Error.NetworkClientError(systemError: error))
        }
    }
    
}

extension DownloadVocabularyOperation {
    
    func downloadFinished(location: NSURL, response: NSURLResponse?) {
        
    }
    
    func downloadFailed(with error: NSError) {
        finishWithError(error)
    }
    
}
