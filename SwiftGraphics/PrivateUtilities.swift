//
//  PrivateUtilities.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/27/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation
import CoreGraphics

// Utility code that is used by SwiftGraphics but isn't intended to be used outside of this project

/**
 :example:
    let (a,b) = ordered(("B", "A"))
 */
public func ordered <T:Comparable> (tuple:(T, T)) -> (T, T) {
    let (lhs, rhs) = tuple
    if lhs <= rhs {
        return (lhs, rhs)
    }
    else {
        return (rhs, lhs)
    }
}

