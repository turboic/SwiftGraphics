//
//  TransformTests.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 11/12/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa
import XCTest
import SwiftGraphics

typealias Transform = CGAffineTransform

class TransformTests: XCTestCase {

    func testExample() {
        var t = Transform.identity
        XCTAssertEqual(t, CGAffineTransformIdentity)

        t.scale(100, 100)
        XCTAssertEqual(t, Transform.scale(sx:100, sy:100))
        XCTAssertEqual(t, Transform(sx:100, sy:100))

        var p = CGPoint(x:1, y:2)
        p *= t
        XCTAssertEqual(p, CGPoint(x:100, y:200))
    }

    func test_rotationAroundPoint1() {
        var p = CGPoint(x:10, y:0)
        var t = Transform.rotationAroundPoint(CGPoint(x:0, y:0), angle:DegreesToRadians(-90))
        p *= t

        // Fudge p.x to make XCTAssertEqual work.
        if p.x ==% 0.0 {
            p.x = 0.0
        }

        XCTAssertEqual(p, CGPoint(x:0.0, y:-10))
    }

    func test_rotationAroundPoint2() {
        var p = CGPoint(x:110, y:100)
        var t = Transform.rotationAroundPoint(CGPoint(x:100, y:100), angle:DegreesToRadians(-90))
        p *= t
        XCTAssertEqual(p, CGPoint(x:100, y:90))
    }

}
