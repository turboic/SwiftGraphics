//
//  Turn.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

public enum Turn : Int {
    case Left = 1
    case None = 0
    case Right = -1

    public init(_ p:CGPoint, _ q:CGPoint, _ r:CGPoint) {
        let c = (q.x - p.x)*(r.y - p.y) - (r.x - p.x)*(q.y - p.y)
        self = c == 0 ? .None : (c > 0 ? .Left : .Right)
    }
}

extension Turn : Comparable {
}

public func < (lhs:Turn, rhs:Turn) -> Bool {
    return lhs.rawValue < rhs.rawValue
}
