//
//  ConvexHull.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

public func convexHull(var points:[CGPoint]) -> [CGPoint] {
    return monotoneChain(points)
}

// https://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain
public func monotoneChain(var points:[CGPoint], presorted:Bool = false) -> [CGPoint] {

    func cross(o:CGPoint, a:CGPoint, b:CGPoint) -> CGFloat {
       return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x)
    }

    if points.count <= 3 {
        return points
    }

    if presorted == false {
        points.sort {
            if $0.y < $1.y {
                return true
            }
            else if $0.y == $1.y {
                return $0.x < $1.x
            }
            return false
        }
    }

    var lower:[CGPoint] = []

    for (var i = 0; i < points.count; i++) {
        while (lower.count >= 2 && cross(lower[lower.count - 2], lower[lower.count - 1], points[i]) <= 0) {
            lower.removeLast()
        }
        lower.append(points[i])
    }
       
    var upper:[CGPoint] = []
    for (var i = points.count - 1; i >= 0; i--) {
        while (upper.count >= 2 && cross(upper[upper.count - 2], upper[upper.count - 1], points[i]) <= 0) {
            upper.removeLast()
            }
        upper.append(points[i]);
    }   

    lower.removeLast()
    upper.removeLast()

    let hull = lower + upper

    return hull
}
