//
//  ClampedTests.swift
//  CoreColorTests
//
//  Created by yukonblue on 2024-03-09.
//

import XCTest
@testable import CoreColor

final class ClampedTests: XCTestCase {

    struct Shell {
        let value: Float

        init(@Clamped(range: 0.0...1.0) value: Float) {
            self.value = value
        }
    }

    func test_Clamped_onFloatingPoint() {
        var shell = Shell(value: 1.0)
        XCTAssertEqual(shell.value, 1.0)

        shell = .init(value: 1.2)
        XCTAssertEqual(shell.value, 1.0)

        shell = .init(value: -1.2)
        XCTAssertEqual(shell.value, 0.0)
    }
}
