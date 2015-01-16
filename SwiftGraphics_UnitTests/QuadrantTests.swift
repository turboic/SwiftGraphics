//
//  QuadrantTests.swift
//  SwiftGraphics
//
//  Created by Dzianis Lebedzeu on 1/17/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa
import XCTest
import SwiftGraphics


class QuadrantTests: XCTestCase {

    let p1 = CGPointMake(-1, -1)
    let p2 = CGPointMake(-1, 1)
    let p3 = CGPointMake(1, -1)
    let p4 = CGPointMake(1, 1)
    
    func testCGRectFromQuadrant() {
        let rect = CGRectMake(0, 0, 20, 20)
        
        XCTAssertEqual(rect.quadrant(.MinXMinY), CGRectMake(0, 0, 10, 10))
        XCTAssertEqual(rect.quadrant(.MaxXMinY), CGRectMake(10, 0, 10, 10))
        XCTAssertEqual(rect.quadrant(.MinXMaxY), CGRectMake(0, 10, 10, 10))
        XCTAssertEqual(rect.quadrant(.MaxXMaxY), CGRectMake(10, 10, 10, 10))
    }
    
    func testQuadrantFromPoint() {
        XCTAssertEqual(Quadrant.MinXMinY, Quadrant.fromPoint(p1))
        XCTAssertEqual(Quadrant.MinXMaxY, Quadrant.fromPoint(p2))
        XCTAssertEqual(Quadrant.MaxXMinY, Quadrant.fromPoint(p3))
        XCTAssertEqual(Quadrant.MaxXMaxY, Quadrant.fromPoint(p4))
    }
    
    func testQuadrantFromPointWithOrigin() {
        XCTAssertEqual(Quadrant.MaxXMinY, Quadrant.fromPoint(p1, origin: p2))
        XCTAssertEqual(Quadrant.MinXMaxY, Quadrant.fromPoint(p2, origin: p3))
        XCTAssertEqual(Quadrant.MaxXMinY, Quadrant.fromPoint(p3, origin: p4))
        XCTAssertEqual(Quadrant.MaxXMaxY, Quadrant.fromPoint(p4, origin: p1))
    }
    
    func testQuadrantFromPointWithRect() {
        // TODO: add tests
    }
    
    func testQuadrantToPoint() {
        XCTAssertEqual(p1, Quadrant.MinXMinY.toPoint())
        XCTAssertEqual(p2, Quadrant.MinXMaxY.toPoint())
        XCTAssertEqual(p3, Quadrant.MaxXMinY.toPoint())
        XCTAssertEqual(p4, Quadrant.MaxXMaxY.toPoint())
    }

}
