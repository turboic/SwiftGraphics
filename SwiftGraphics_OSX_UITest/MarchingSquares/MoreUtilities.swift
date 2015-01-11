//
//  Utilities.swift
//  Metaballs
//
//  Created by Jonathan Wight on 9/14/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

extension CGRect {

    init(minX:CGFloat, minY:CGFloat, maxX:CGFloat, maxY:CGFloat) {
        origin = CGPoint(x:minX, y:minY)
        size = CGSize(width:maxX - minX, height:maxY - minY)
    }

    func partiallyIntersects(other:CGRect) -> Bool {
        if CGRectIntersectsRect(self, other) == true {
            let union = CGRectUnion(self, other)
            if CGRectEqualToRect(self, union) == false {
                return true
            }
        }
        return false
    }
}

func random() -> CGFloat {
    return CGFloat(arc4random_uniform(UInt32.max)) / CGFloat(UInt32.max)
}

func random(range:ClosedInterval<CGFloat>) -> CGFloat {
    return random() * (range.end - range.start) + range.start
}

func random(range:CGRect) -> CGPoint {
    return CGPoint(
        x:range.origin.x + random() * range.size.width,
        y:range.origin.y + random() * range.size.height
    )
}
