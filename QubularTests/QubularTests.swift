//
//  QubularTests.swift
//  QubularTests
//
//  Created by Oleg Dreyman on 26.04.16.
//  Copyright © 2016 Oleg Dreyman. All rights reserved.
//

import XCTest
@testable import Qubular
import Operations

class QubularTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    //    func testDownload() {
//        let queue = OperationQueue()
//        let cachesFolder = try! NSFileManager.defaultManager().URLForDirectory(.CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
//        let cacheFile = cachesFolder.URLByAppendingPathComponent("entries.json")
//        let download = DownloadVocabularyOperation(cacheFile: cacheFile)
//        queue.addOperation(download)
////        dispatch_main()
//        print("Yay!")
//    }
    
    func testGet() {
        let queue = OperationQueue()
        let cache = SlovarCache()
        let expectation = expectationWithDescription("getting things done")
        let get = GetVocabularyOperation(cache: cache) {
            let vocabulary = cache.vocabulary!
            print("Yay")
            print(vocabulary)
            expectation.fulfill()
        }
        queue.addOperation(get)
        waitForExpectationsWithTimeout(20.0, handler: nil)
    }
    
}
