//
//  Private.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

// MARK: Comparing

func compare <T:Comparable> (lhs:T, rhs:T) -> Int {
    return lhs == rhs ? 0 : (lhs > rhs ? 1 : -1)
}

