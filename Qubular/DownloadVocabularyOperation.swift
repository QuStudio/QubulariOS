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
    
    init(cacheFile: NSURL) {
        self.cacheFile = cacheFile
        super.init()
        self.name = "Download Vocabulary"
    }
    
    override func execute() {
        let url = NSURL(string: "http://qubular.org/api/entries")!
        let task = NSURLSession.sharedSession().downloadTaskWithURL(url) { (savedFileURL, response, error) in
            if let savedFileURL = savedFileURL {
                self.downloadFinished(savedFileURL, response: response)
            } else if let error = error {
                self.downloadFailed(with: error)
            }
        }
        task.resume()
    }
    
}

extension DownloadVocabularyOperation {
    
    func downloadFinished(savedFileURL: NSURL, response: NSURLResponse?) {
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtURL(cacheFile)
        } catch { }
        do {
            try fileManager.moveItemAtURL(savedFileURL, toURL: cacheFile)
            finish()
        } catch let error as NSError {
            finishWithError(error)
        }
    }
    
    func downloadFailed(with error: NSError) {
        finishWithError(error)
    }
    
}
