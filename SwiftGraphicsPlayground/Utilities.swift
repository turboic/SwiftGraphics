//
//  Utilities.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

extension Array {
    init(count:Int, block:(Void) -> T) {
        self.init()
        for N in 0..<count {
            self.append(block())
        }
    }
}

public func arrayOfRandomPoints(count:Int, range:CGRect) -> Array <CGPoint> {
    return Array <CGPoint> (count:10) {
        return Random().randomCGPoint(range)
    }
}