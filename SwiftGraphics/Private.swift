//
//  Private.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

struct SlidingWindow <T> : GeneratorType {
    typealias Element = (T, T?)

    var g : Array<T>.Generator
    var e : T?

    init(_ a:Array <T>) {
        g = a.generate()
        e = g.next()
    }

    mutating func next() -> Element? {
        if e == nil {
            return nil
        }

    let next = g.next()
    let result = (e!, next)
    e = next

    return result
    }
}


// MARK: Comparing

func compare <T:Comparable> (lhs:T, rhs:T) -> Int {
    return lhs == rhs ? 0 : (lhs > rhs ? 1 : -1)
}

