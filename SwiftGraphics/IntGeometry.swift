//
//  IntGeometry.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

public struct GenericPoint <T> {
    public let x:T
    public let y:T

    public init(x:T, y:T) {
        self.x = x
        self.y = y
    }
}

public struct GenericSize <T> {
    public let width:T
    public let height:T

    public init(width:T, height:T) {
        self.width = width
        self.height = height
    }
}

public typealias IntPoint = GenericPoint<Int>
public typealias IntSize = GenericSize<Int>

