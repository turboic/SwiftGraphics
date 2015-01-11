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

