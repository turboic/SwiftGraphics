//
//  IntGeometry.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

// MARK: Generic Types

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

public struct GenericRect <T, U> {
    public let origin:T
    public let size:U

    public init(origin:T, size:U) {
        self.origin = origin
        self.size = size
    }
}

// MARK: Int based geometry

public typealias IntPoint = GenericPoint<Int>
public typealias IntSize = GenericSize<Int>

// MARK: Protocols with associated types

// Due to a bug with Swift (http://openradar.appspot.com/myradars/edit?id=5241213351362560) we cannot make CG types conform to these protocols.
// Ideally instead of using CGPoint and friends we could just use PointType and our code would work with all types.

public protocol PointType {
    typealias ScalarType
    
    var x:ScalarType { get }
    var y:ScalarType { get }
    }

public protocol SizeType {
    typealias ScalarType
    
    var width:ScalarType { get }
    var height:ScalarType { get }
    }

public protocol RectType {
    typealias OriginType
    typealias SizeType

    var origin:OriginType { get }
    var size:SizeType { get }
    }

// MARK: Conforming generic type with protocols

extension GenericPoint: PointType {
    typealias ScalarType = T
}


extension GenericSize: SizeType {
    typealias ScalarType = T
}
