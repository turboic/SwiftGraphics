//
//  Geometry.swift
//  QuadTree
//
//  Created by Jonathan Wight on 8/6/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

import CoreGraphics

/**
 Return true if a, b, and c all lie on the same line.
 */
func collinear(a:CGPoint, b:CGPoint, c:CGPoint) -> Bool {
    return (b.x - a.x) * (c.y - a.y) ==% (c.x - a.x) * (b.y - a.y)
}

// MARK: -

typealias Rectangle = CGRect

// MARK: -

public struct Line {
    let m:CGFloat
    let b:CGFloat

    // TODO: Vertical lines!?
    func segment(x0:CGFloat, x1:CGFloat) -> LineSegment {
        let start = CGPoint(x:x0, y:m * x0 + b)
        let end = CGPoint(x:x1, y:m * x1 + b)
        return LineSegment(start: start, end: end)
    }
}

// MARK: -

public struct LineSegment {
    public let start:CGPoint
    public let end:CGPoint

    public init(start:CGPoint, end:CGPoint) {
        self.start = start
        self.end = end
    }

    public var slope:CGFloat? {
        get {
            if end.x == start.x {
                return nil
            }
            return (end.y - start.y) / (end.x - start.x)
        }
    }

    public var angle:CGFloat {
        get {
            return atan2(end - start)
        }
    }

    public func isParallel(other:LineSegment) -> Bool {
        return self.slope == other.slope
    }

    public func intersection(other:LineSegment, clamped:Bool = true) -> CGPoint? {
        let x_1 = start.x
        let y_1 = start.y
        let x_2 = end.x
        let y_2 = end.y

        let x_3 = other.start.x
        let y_3 = other.start.y
        let x_4 = other.end.x
        let y_4 = other.end.y

        let denom = (x_1 - x_2) * (y_3 - y_4) - (y_1 - y_2) * (x_3 - x_4)
        if denom == 0.0 {
            return nil
        }

        let p1 = (x_1 * y_2 - y_1 * x_2)
        let p2 = (x_3 * y_4 - y_3 * x_4)
        let x = (p1 * (x_3 - x_4) - (x_1 - x_2) * p2) / denom
        let y = (p1 * (y_3 - y_4) - (y_1 - y_2) * p2) / denom

        let pt = CGPoint(x:x, y:y)

        if clamped {
            if self.containsPoint(pt) == false || other.containsPoint(pt) == false {
                return nil
            }
        }

        return pt
    }

    public func containsPoint(point:CGPoint) -> Bool {
        let a = self.start
        let b = self.end
        let c = point

        func within(p:CGFloat, q:CGFloat, r:CGFloat) -> Bool {
            // TODO: What about negatives?
            return q >= p && q <= r || q <= p && q >= r
        }
        return (collinear(a, b, c) && a.x != b.x) ? within(a.x, c.x, b.x) : within(a.y, c.y, b.y)
    }
}

// MARK: Circle

public struct Circle {
    public let center:CGPoint
    public let radius:CGFloat
    public var diameter:CGFloat { get { return radius * 2 } }
    
    public init(center:CGPoint, radius:CGFloat) {
        self.center = center
        self.radius = radius
    }
    
    public init(center:CGPoint, diameter:CGFloat) {
        self.center = center
        self.radius = diameter * 0.5
    }
    
    public var frame : CGRect {
        get {
            return CGRect(center: self.center, diameter: self.diameter)
        }
    }
}

// MARK: Circle

public struct Triangle {
    public let points: (CGPoint, CGPoint, CGPoint)

    public init(_ p0:CGPoint, _ p1:CGPoint, _ p2:CGPoint) {
        self.points = (p0, p1, p2)
    }
}

public extension Triangle {    
    public var lengths: (CGFloat, CGFloat, CGFloat) {
        get {
            return (
                (points.0 - points.1).magnitude,
                (points.1 - points.2).magnitude,
                (points.2 - points.0).magnitude
            )
        }
    }

    public var angles: (CGFloat, CGFloat, CGFloat) {
        get {
            let a1 = angle(points.0, points.1, points.2)
            let a2 = angle(points.1, points.2, points.0)
            let a3 = DegreesToRadians(180) - a1 - a2
            return (a1,a2,a3)
        }
    }
    
    public var isEquilateral: Bool {
        get {
            return equalities(self.lengths, { $0 ==% $1 }) == 3
        }
    }
    
    public var isIsosceles: Bool {
        get {
            return equalities(self.lengths, { $0 ==% $1 }) == 2
        }
    }
    
    public var isScalene: Bool {
        get {
            return equalities(self.lengths, { $0 ==% $1 }) == 1
        }
    }
    
    public var isRightAngled: Bool {
        get {
            let a = self.angles
            let rightAngle = CGFloat(0.5 * M_PI)
            return a.0 ==% rightAngle || a.1 ==% rightAngle || a.2 ==% rightAngle
        }
    }
    
    public var isOblique: Bool {
        get {
            return isRightAngled == false
        }
    }
    
    public var isAcute: Bool {
        get {
            let a = self.angles
            let rightAngle = CGFloat(0.5 * M_PI)
            return a.0 < rightAngle && a.1 < rightAngle && a.2 < rightAngle
        }
    }

    public var isObtuse: Bool {
        get {
            let a = self.angles
            let rightAngle = CGFloat(0.5 * M_PI)
            return a.0 > rightAngle || a.1 > rightAngle || a.2 > rightAngle
        }
    }

    public var isDegenerate: Bool {
        get {
            let a = self.angles
            let r180 = CGFloat(M_PI)
            return a.0 ==% r180 || a.1 ==% r180 || a.2 ==% r180
        }
    }

    public var signedArea: CGFloat {
        get {
            let (a, b, c) = points
            let signedArea = 0.5 * (a.x * (b.y - c.y) +
                b.x * (c.y - b.y) +
                c.x * (b.y - b.y))
            return signedArea
        }
    }
    
    public var area: CGFloat { get { return abs(signedArea) } }

    // https://en.wikipedia.org/wiki/Circumscribed_circle  
    public var circumcenter : CGPoint {
        get {
            let (a, b, c) = points
            let D = 2 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))
            
            let a2 = a.x ** 2 + a.y ** 2
            let b2 = b.x ** 2 + b.y ** 2
            let c2 = c.x ** 2 + c.y ** 2
            
            let X = (a2 * (b.y - c.y) + b2 * (c.y - a.y) + c2 * (a.y - b.y)) / D
            let Y = (a2 * (c.x - b.x) + b2 * (a.x - c.x) + c2 * (b.x - a.x)) / D

            return CGPoint(x:X, y:Y)
        }
    }
    
    public var circumcircle : Circle {
        get {
            let (a,b,c) = lengths
            let diameter = (a * b * c) / (2 * area)
            return Circle(center:circumcenter, diameter:diameter)
        }
    }

    public var inradius : CGFloat {
        get {
            let (a, b, c) = lengths
            return 2 * area / (a + b + c)
        }
    }
}

// TODO: Not quite working perfectly yet...
public extension Triangle {

    public var incenter : CGPoint {
        get {
            return toCartesian(alpha:1, beta:1, gamma:1)
        }
    }

    // converts trilinear coordinates to Cartesian coordinates relative
    // to the incenter; thus, the incenter has coordinates (0.0, 0.0)
    // TODO: THis seems broken!
    public func toLocalCartesian(# alpha:CGFloat, beta:CGFloat, gamma:CGFloat) -> CGPoint {
        let area = self.area
        let (a,b,c) = lengths
        let r = 2 * area / (a + b + c)
        let k = 2 * area / (a * alpha + b * beta + c * gamma)
//        let C:CGFloat = DegreesToRadians(90)//angles.2
        let C = angles.2
        let x = (k * beta - r + (k * alpha - r) * cos(C)) / sin(C)
        let y = k * alpha - r
        return CGPoint(x:x, y:y)
    }    

    // TODO: THis seems broken!
    public func toCartesian(# alpha:CGFloat, beta:CGFloat, gamma:CGFloat) -> CGPoint {
        let a = toLocalCartesian(alpha:alpha, beta:beta, gamma:gamma)
        let delta = toLocalCartesian(alpha:0,beta:0, gamma:1)

        return points.0 + a - delta
    }    
}

func equalities <T> (e:(T, T, T), test:((T, T) -> Bool)) -> Int {
    var c = 1
    if test(e.0, e.1) {
        c++
    }
    if test(e.1, e.2) {
        c++
    }
    if test(e.2, e.0) {
        c++
    }
    return min(c, 3)
}

public func angle(p0:CGPoint, p1:CGPoint, p2:CGPoint) -> CGFloat {
    let x10 = p1.x - p0.x
    let y10 = p1.y - p0.y
    let x20 = p2.x - p0.x
    let y20 = p2.y - p0.y
    return atan2(abs(x10 * y20 - y10 * x20), x10 * x20 + y10 * y20);
    }
