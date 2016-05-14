//
//  DownloadVocabularyOperation.swift
//  Qubular
//
//  Created by Oleg Dreyman on 01.05.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import Foundation
import Operations

class DownloadVocabularyOperation: Operation {
    
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
    
}

extension DownloadVocabularyOperation: NSURLSessionDownloadDelegate {
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        // Possible error handling
        if let status = (downloadTask.response as? NSHTTPURLResponse)?.statusCode where status != 200 {
            print(status)
            finishWithError(ServerError.Not200(statusCode: status) as NSError)
            return
        }
        
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtURL(cacheFile)
        } catch { }
        do {
            try fileManager.moveItemAtURL(location, toURL: cacheFile)
            finish()
        } catch let error as NSError {
            finishWithError(error)
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if let error = error {
            finishWithError(error)
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
