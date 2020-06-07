//
//  Project39Tests.swift
//  Project39Tests
//
//  Created by Mike on 2020-06-04.
//  Copyright © 2020 Mike. All rights reserved.
//

import XCTest
@testable import Project39

class Project39Tests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAllWordsLoaded() {
        let playData = PlayData()
        XCTAssertEqual(playData.allWords.count, 18440, "allWords was not 18440")
    }
    
    func testWordCountsAreCorrect() {
        let playData = PlayData()
        XCTAssertEqual(playData.wordCounts.count(for: "home"), 174, "Home does not appear 174 times")
        XCTAssertEqual(playData.wordCounts.count(for: "fun"), 4, "Fun does not appear 4 times")
        XCTAssertEqual(playData.wordCounts.count(for: "mortal"), 41, "Mortal does not appear 41 times")
    }
    
    func testWordsLoadQuickly() {
        measure {
            _ = PlayData()
        }
    }
    
    func testUserFilterWorks() {
        let playData = PlayData()
        
        playData.applyUserFilter("100")
        XCTAssertEqual(playData.filteredWords.count, 495, "100 does not appear 495 times")
        
        playData.applyUserFilter("1000")
        XCTAssertEqual(playData.filteredWords.count, 55, "1000 does not appear 55 times")
        
        playData.applyUserFilter("10000")
        XCTAssertEqual(playData.filteredWords.count, 1, "10000 does not appear 1 time")
        
        playData.applyUserFilter("test")
        XCTAssertEqual(playData.filteredWords.count, 56, "test does not appear 56 times")
        
        playData.applyUserFilter("swift")
        XCTAssertEqual(playData.filteredWords.count, 7, "swift does not appear 7 times")
        
        playData.applyUserFilter("objective-c")
        XCTAssertEqual(playData.filteredWords.count, 0, "objective-c does not appear 0 times")
    }
}
