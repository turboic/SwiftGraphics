//
//  SwiftGraphicsPlayground_OSX_UnitTests.swift
//  SwiftGraphicsPlayground_OSX_UnitTests
//
//  Created by Jonathan Wight on 1/11/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa
import XCTest
import SwiftGraphicsPlayground

class SwiftGraphicsPlayground_UnitTests: XCTestCase {

    func testPerformanceExample() {
        let rng = Random(provider:SRandomProvider(seed:0))
        let count:UInt64 = 1000000
        typealias Type = UInt32
        let uniformMax:Type = 1000

        self.measureBlock() {
            var total:UInt64 = 0
            for n in 0..<count {
                let r:Type = rng.random(uniformMax)
                total += UInt64(r)
            }
        }
    }

    func testRandom() {
        let rng = Random(provider:SRandomProvider(seed:0))
        let count:UInt64 = 100000
        typealias Type = UInt32
        let max_delta:Type = 1
        let uniformMax:Type = 1000

        var total:UInt64 = 0
        for n in 0..<count {
            let r:Type = rng.random(uniformMax)
            total += UInt64(r)
        }

        let average = Type(total / count)
        XCTAssertGreaterThanOrEqual(average, uniformMax / 2 - max_delta)
        XCTAssertLessThanOrEqual(average, uniformMax / 2 + max_delta)
    }
}
