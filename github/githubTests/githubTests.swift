//
//  githubTests.swift
//  githubTests
//
//  Created by 김선우 on 2022/03/22.
//

import XCTest
@testable import github

class githubTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        XCTAssertEqual(Util.getConsonant(text: "ABC"), "A")
        XCTAssertEqual(Util.getConsonant(text: "aBC"), "A")
        XCTAssertEqual(Util.getConsonant(text: "vaeBfC"), "V")
        XCTAssertEqual(Util.getConsonant(text: "가나다"), "ㄱ")
        XCTAssertEqual(Util.getConsonant(text: "까나따"), "ㄲ")
        XCTAssertEqual(Util.getConsonant(text: "ㄱㅏ나다"), "ㄱ")
        XCTAssertEqual(Util.getConsonant(text: " ㄱㅏ나다"), "ㄱ")
        XCTAssertEqual(Util.getConsonant(text: " 배터리"), "ㅂ")
        XCTAssertEqual(Util.getConsonant(text: " 바보"), "ㅂ")
        XCTAssertEqual(Util.getConsonant(text: " 힣힣가"), "ㅎ")
        XCTAssertEqual(Util.getConsonant(text: " ....하"), ".")
        XCTAssertEqual(Util.getConsonant(text: " 123"), "1")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
