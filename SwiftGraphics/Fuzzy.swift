//
//  Fuzzy.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

// MARK: Fuzzy equality

public protocol FuzzyEquatable {
    func ==%(lhs: Self, rhs: Self) -> Bool
}

infix operator ==% { associativity none precedence 130 }

extension CGFloat : FuzzyEquatable {
}

public func ==% (lhs:CGFloat, rhs:CGFloat) -> Bool {
    let epsilon = CGFloat(FLT_EPSILON) // TODO: FLT vs DBL
    return equal(lhs, rhs, accuracy:epsilon)
}

infix operator !=% { associativity none precedence 130 }

public func !=% <T:FuzzyEquatable> (lhs:T, rhs:T) -> Bool {
    return !(lhs ==% rhs)
}

public func equal(lhs:CGFloat, rhs:CGFloat, # accuracy:CGFloat) -> Bool {
    return abs(rhs - lhs) <= accuracy
}
