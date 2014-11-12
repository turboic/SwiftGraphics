//
//  Transforms.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

public extension CGAffineTransform {

    static var identity:CGAffineTransform = CGAffineTransformIdentity
    
    init() {
        self = CGAffineTransform.identity
    }

    init(transform: CGAffineTransform) {
        self = transform
    }

    init(a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat, tx: CGFloat, ty: CGFloat) {
        self = CGAffineTransformMake(a, b, c, d, tx, ty)
    }
    
    init(tx: CGFloat, ty: CGFloat) {
        self = CGAffineTransformMakeTranslation(tx, ty)
    }

    init(sx: CGFloat, sy: CGFloat) {
        self = CGAffineTransformMakeScale(sx, sy)
    }

    init(angle: CGFloat) {
        self = CGAffineTransformMakeRotation(angle)
    }

    var isIdentity: Bool { get { return CGAffineTransformIsIdentity(self) } }
}

public extension CGAffineTransform {

    static func translation(# tx: CGFloat, ty: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(tx, ty)
    }

    static func scale(# sx: CGFloat, sy: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeScale(sx, sy)
    }

    static func rotation(angle: CGFloat) -> CGAffineTransform {
        return CGAffineTransformMakeRotation(angle)
    }
}

public extension CGAffineTransform {

    func translated(# tx:CGFloat, ty:CGFloat) -> CGAffineTransform {
        return CGAffineTransformTranslate(self, tx, ty)
    }

    func scaled(# sx:CGFloat, sy:CGFloat) -> CGAffineTransform  {
        return CGAffineTransformScale(self, sx, sy)
    }

    func rotated(angle:CGFloat) -> CGAffineTransform  {
        return CGAffineTransformRotate(self, angle)
    }

    func concated(other:CGAffineTransform) -> CGAffineTransform {
        return CGAffineTransformConcat(self, other)
    }

    func inverted() -> CGAffineTransform {
        return CGAffineTransformInvert(self)
    }
//    var inverted: CGAffineTransform { get { return CGAffineTransformInvert(self) } }

}

public extension CGAffineTransform {

    mutating func translate(tx:CGFloat, _ ty:CGFloat) -> CGAffineTransform {
        self = translated(tx:tx, ty:ty)
        return self
    }

    mutating func scale(sx:CGFloat, _ sy:CGFloat) -> CGAffineTransform  {
        self = scaled(sx:sx, sy:sy)
        return self
    }

    mutating func rotate(angle:CGFloat) -> CGAffineTransform  {
        self = rotated(angle)
        return self
    }

    mutating func concat(other:CGAffineTransform) -> CGAffineTransform {
        self = concated(other)
        return self
    }

    mutating func invert() -> CGAffineTransform {
        self = self.inverted()
        return self
    }
}

// MARK: Equatable

extension CGAffineTransform : Equatable {
}

public func == (lhs:CGAffineTransform, rhs:CGAffineTransform) -> Bool {
    return CGAffineTransformEqualToTransform(lhs, rhs)
}

// MARK: Concatination via the + and += operators

public func + (lhs:CGAffineTransform, rhs:CGAffineTransform) -> CGAffineTransform {
    return lhs.concated(rhs)
}

public func += (inout lhs:CGAffineTransform, rhs:CGAffineTransform) {
    lhs.concat(rhs)
}

// MARK: Applying transforms to CG types

public func * (lhs:CGPoint, rhs:CGAffineTransform) -> CGPoint {
    return CGPointApplyAffineTransform(lhs, rhs)
}

public func *= (inout lhs:CGPoint, rhs:CGAffineTransform) {
    lhs = CGPointApplyAffineTransform(lhs, rhs)
}

public func * (lhs:CGSize, rhs:CGAffineTransform) -> CGSize {
    return CGSizeApplyAffineTransform(lhs, rhs)
}

public func *= (inout lhs:CGSize, rhs:CGAffineTransform) {
    lhs = CGSizeApplyAffineTransform(lhs, rhs)
}

public func * (lhs:CGRect, rhs:CGAffineTransform) -> CGRect {
    return CGRectApplyAffineTransform(lhs, rhs)
}

public func *= (inout lhs:CGRect, rhs:CGAffineTransform) {
    lhs = CGRectApplyAffineTransform(lhs, rhs)
}

// MARK: Converting transforms to/from arrays

public extension CGAffineTransform {
    init(v:[CGFloat]) {
        assert(v.count == 6)
        self = CGAffineTransformMake(v[0], v[1], v[2], v[3], v[4], v[5])
    }
    
    var values:[CGFloat] {
        get {
            return [a,b,c,d,tx,ty]
        }
        set(v) {
            assert(v.count == 6)
            (a, b, c, d, tx, ty) = (v[0], v[1], v[2], v[3], v[4], v[6])
        }
    }
}

// MARK: Translation using CGPoint

public extension CGAffineTransform {

    static func translation(t: CGPoint) -> CGAffineTransform {
        return CGAffineTransformMakeTranslation(t.x, t.y)
    }

    func translated(# t:CGPoint) -> CGAffineTransform {
        return CGAffineTransformTranslate(self, t.x, t.y)
    }

    mutating func translate(t:CGPoint) -> CGAffineTransform {
        self = translated(tx:t.x, ty:t.y)
        return self
    }
}

// MARK: Convenience constructors.

public extension CGAffineTransform {

    init(transforms:[CGAffineTransform]) {
        var current = CGAffineTransform.identity
        for transform in transforms {
            current.concat(transform)
        }
        self = current
    }

    static func rotationAroundPoint(point:CGPoint, angle:CGFloat) -> CGAffineTransform {
        var transform = CGAffineTransform.translation(point)
        transform.rotate(angle)
        transform.translate(-point)
        return transform
    }
}

