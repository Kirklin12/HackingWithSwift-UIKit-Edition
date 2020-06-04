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
        XCTAssertEqual(playData.allWords.count, 0, "allWords must be 0")
    }
}
