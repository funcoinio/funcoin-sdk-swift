//
//  FUNCOINTests.swift
//  FUNCOINTests
//
//  Created by Yate Fulham on 2018/08/10.
//  Copyright © 2018 Cryptape. All rights reserved.
//

import XCTest
@testable import FUNCOIN

class FUNCOINTests: XCTestCase {
    func testDefaultInstance() {
        XCTAssertEqual(funcoin.provider.url, FUNCOIN.default.provider.url)
    }
}
