//
//  UnitTests.swift
//  UnitTests
//
//  Created by Ayman Ali on 20/02/2024.
//

import XCTest
@testable import PARC

final class UnitTests: XCTestCase {
    
    func testSuccessfulConvertDate() {
        let input = "2023-10-02"
        let function = convertDate(dateString: input)
        XCTAssertEqual(function, "02/10/2023")
    }
//    func testFailureConvertDate() {
//        
//    }
}
