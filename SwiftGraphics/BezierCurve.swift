//
//  BezierCurve.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

public struct BezierCurve {

    public enum Order {
        case Quadratic
        case Cubic
        case OrderN(Int)
    }

    public var start : CGPoint?
    public var controls : [CGPoint]
    public var end : CGPoint

    public init(controls:[CGPoint], end:CGPoint) {
        self.controls = controls
        self.end = end
    }

    public init(start:CGPoint, controls:[CGPoint], end:CGPoint) {
        self.start = start
        self.controls = controls
        self.end = end
    }

    public var order : Order {
        get {
            switch self.controls.count + 2 {
                case 3:
                    return .Quadratic
                case 4:
                    return .Cubic
                default:
                    return .OrderN(self.controls.count + 2)
            }       
        }
    }
    public var points : [CGPoint] {
        get {
            if let start = self.start {
                return [start] + self.controls + [self.end]
            }
            else {
                return self.controls + [self.end]
            }
        }
    }
}

// MARK: Good old Printable.

extension BezierCurve : Printable {
    public var description: String { get {
        let controlsString = ", ".join(controls.map() {
            (c:CGPoint) -> String in
            return "(\(c.x), \(c.y))"
        })
        return "BezierCurve(start:\(start?.description), controls:\(controlsString), end:\(end.description))"
    } }
}

// MARK: Convenience initializers

public extension BezierCurve {
    public init(control1:CGPoint, end:CGPoint) {
        self.controls = [control1]
        self.end = end
    }

    public init(control1:CGPoint, control2:CGPoint, end:CGPoint) {
        self.controls = [control1, control2]
        self.end = end
    }

    public init(start:CGPoint, control1:CGPoint, end:CGPoint) {
        self.start = start
        self.controls = [control1]
        self.end = end
    }

    public init(start:CGPoint, control1:CGPoint, control2:CGPoint, end:CGPoint) {
        self.start = start
        self.controls = [control1, control2]
        self.end = end
    }

    public init(points:[CGPoint]) {
        self.start = points[0]
        self.controls = Array(points[1..<points.count - 1])
        self.end = points[points.count - 1]
    }

    public init(start:CGPoint, end:CGPoint) {
        self.start = start
        self.controls = [(start + end) / 2]
        self.end = end
    }
}

// MARK: Increasing the order.

public extension BezierCurve {
    func increasedOrder() -> BezierCurve {
        switch self.controls.count {
        case 1:
            let CP1 = points[0] + ((2.0 / 3.0) * (points[1] - points[0]))
            let CP2 = points[2] + ((2.0 / 3.0) * (points[1] - points[2]))
            return BezierCurve(start:start!, controls:[CP1, CP2], end:end)
        case 2:
            return self
        default:
            return BezierCurve(start:start!, end:end).increasedOrder()
        }
    }
}

// MARK: Converting from tuples

public extension BezierCurve {
    init(_ v:[(CGFloat, CGFloat)]) {
        self.start = CGPoint(v[0])
        self.controls = v.count==2 ? [CGPoint(v[1]), CGPoint(v[2])] : v.count==1 ? [CGPoint(v[1])] : []
        self.end = CGPoint(v[v.count - 1])
    }
}

// MARK: Stroking the path to a context

public extension CGContextRef {
    func stroke(curve:BezierCurve) {
        switch curve.order {
            case .Quadratic:
                if let start = curve.start {
                    CGContextMoveToPoint(self, start.x, start.y)
                    }
                CGContextAddQuadCurveToPoint(self, curve.controls[0].x, curve.controls[0].y, curve.end.x, curve.end.y)              
                CGContextStrokePath(self)
            case .Cubic:
                if let start = curve.start {
                    CGContextMoveToPoint(self, start.x, start.y)
                    }
                CGContextAddCurveToPoint(self, curve.controls[0].x, curve.controls[0].y, curve.controls[1].x, curve.controls[1].y, curve.end.x, curve.end.y)              
                CGContextStrokePath(self)
            case .OrderN(let order):
                assert(false)
        }
    }
}
