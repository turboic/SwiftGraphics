// Playground - noun: a place where people can play

import Cocoa

import SwiftGraphics
import SwiftGraphicsPlayground
import XCPlayground

func SGPRender(identifier:String, block:((ctx:CGContext, bounds:CGRect) -> Void)) {
    let demoView = SwiftGraphicsPlayground.DemoView(frame:CGRect(size:CGSize(w:480, h:320)))
    demoView.drawBlock = block
    XCPShowView(identifier, demoView)
}

extension Array {
    init(count:Int, block:(Void) -> T) {
        self.init()
        for N in 0..<count {
            self.append(block())
        }
    }
}

internal extension Array {
    mutating func push(o:T) {
        self.append(o)
    }
    mutating func pop() -> T? {
        if let first = self.first {
            self.removeAtIndex(0)
            return first
        }
        return nil
    }
}

func grahamOrdered(var points:[CGPoint]) -> [CGPoint] {
    // Find the point (and its index) with the lowest y
    typealias IndexedPoint = (index:Int,point:CGPoint)
    let lowest:IndexedPoint = reduce(enumerate(points), IndexedPoint(0, points[0])) {
        (u:IndexedPoint, c:IndexedPoint) -> IndexedPoint in
        return c.point.y < u.point.y ? c : (c.point.y == u.point.y ? (c.point.x <= u.point.x ? c : u) : u)
    }

    points.removeAtIndex(lowest.index)
    points.sort {
        return Turn(lowest.point, $0, $1) <= .None
    }
    points.insert(lowest.point, atIndex:0)
    return points
}

func grahamScan(var points:[CGPoint], preordered:Bool = false) -> [CGPoint] {
    if points.count <= 3 {
        return points
    }

    if preordered == false {
        points = grahamOrdered(points)
    }

    var hull:[Int] = [0, 1]
    
    
    for index in 2..<points.count {
        let p = points[hull[hull.count - 2]]
        let q = points[hull[hull.count - 1]]
        let r = points[index]
        let t = Turn(p, q, r)
        println(hull.count - 2, hull.count - 1, index, t.rawValue)
        if t != .Left {
//            hull.removeLast()            
        }
        hull.push(index + 2)
    }

    println(hull)
    
    let hull_points:[CGPoint] = hull.map {
        return points[$0]
    }
    
    println(hull_points)

    return hull_points
}

let r = Random()
r.seed = 100

var points = Array <CGPoint> (count:10) {
    return r.randomCGPoint(CGRect(w:480, h:320))
}
points = grahamOrdered(points)

let hull = grahamScan(points)


SGPRender("Test") {
    (ctx:CGContext, bounds:CGRect) in
    for (index, point) in enumerate(points) {
        if contains(hull, point) {
            NSColor.greenColor().set()
        }
        else {
            NSColor.redColor().set()
        }
        ctx.strokeCross(CGRect(center:point, radius:5))
        ctx.drawLabel("\(index)", point:point + CGPoint(x:2, y:0), size:10)
    }
    
}

