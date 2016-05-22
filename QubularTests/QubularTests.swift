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
import Vocabulaire

class QubularTests: XCTestCase {
    
    let queue = OperationQueue()
    
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
    
    final class FakeVersionController: VersionController {
        let fakeVersion: VocabularyVersion
        init(fakeVersion: VocabularyVersion = .develop) {
            self.fakeVersion = fakeVersion
        }
        var version: VocabularyVersion? {
            get {
                return fakeVersion
            }
            set {
                print("Go fuck yourself with \(newValue)")
            }
        }
    }
    
    func testCheckVersion() {
        let expectation = expectationWithDescription("Operation")
        let checkVersion = CheckVersionOperation()
        checkVersion.observe { (operation) in
            operation.didFinish { _ in
                print(checkVersion.latestVersion)
                expectation.fulfill()
            }
            operation.didFailed { errors in
                print(errors)
                XCTFail()
            }
        }
        queue.addOperation(checkVersion)
        waitForExpectationsWithTimeout(10.0, handler: nil)
    }
    
    func testVersionUpdate() {
        let expectation = expectationWithDescription("Operation")
        let cache = SlovarCache()
        let versionController = FakeVersionController(fakeVersion: VocabularyVersion(major: 0, minor: 0, patch: 1))
        let onlyIfLatestAvailable = NewerVersionAvailableCondition(versionController: versionController, developSupport: true)
        let get = GetVocabularyOperation(cache: cache, versionController: versionController)
        get.observe { (operation) in
            operation.didFinish { _ in
                expectation.fulfill()
            }
        }
        get.addCondition(onlyIfLatestAvailable)
        queue.addOperation(get)
        waitForExpectationsWithTimeout(10.0, handler: nil)
        
    }
    
    func testVersionCondition() {
        let expectation = expectationWithDescription("Operation")
        let dependent = BlockOperation {
            print("BLOCKBLOCKBLOCK")
        }
        dependent.observe { (operation) in
            operation.didFinish { _ in
                XCTFail()
            }
            operation.didFailed { errors in
                print(errors)
                expectation.fulfill()
            }
        }
        let controller = FakeVersionController(fakeVersion: VocabularyVersion(major: 0, minor: 0, patch: 5))
        let onlyIfLatestAvailable = NewerVersionAvailableCondition(versionController: controller, developSupport: false)
        dependent.addCondition(onlyIfLatestAvailable)
        queue.addOperation(dependent)
        waitForExpectationsWithTimeout(10.0, handler: nil)
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
    
//    func testGet() {
//        let queue = OperationQueue()
//        let cache = SlovarCache()
//        let expectation = expectationWithDescription("getting things done")
//        let get = GetVocabularyOperation(cache: cache) {
//            let vocabulary = cache.vocabulary!
//            print("Yay")
//            print(vocabulary)
//            expectation.fulfill()
//        }
//        queue.addOperation(get)
//        waitForExpectationsWithTimeout(20.0, handler: nil)
//    }
    
}
