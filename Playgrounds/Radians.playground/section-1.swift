// Playground - noun: a place where people can play

import Foundation

struct Angle {
    typealias AngleType = CGFloat

    var radians:AngleType

    init() {
        radians = 0
    }

    init(_ value: AngleType) {
        radians = value
    }

}

extension Angle : Comparable {
}

func <(lhs: Angle, rhs: Angle) -> Bool {
    return lhs.radians < rhs.radians
}

func ==(lhs: Angle, rhs: Angle) -> Bool {
    return lhs.radians == rhs.radians
}

extension Angle : Hashable {
    var hashValue: Int { get { return radians.hashValue } }
}

//extension Angle : AbsoluteValuable {
//    static func abs(x: Angle) -> Angle {
//        return Angle(abs(x.radians))
//    }
//}

extension Angle : Strideable {

    typealias Stride = AngleType

    func distanceTo(other: Angle) -> Stride {
        return radians.distanceTo(other.radians)
    }
    func advancedBy(n: Stride) -> Angle {
        return Angle(radians.advancedBy(n))
    }
}

//extension Angle : FloatingPointType {
//
//    /// The positive infinity.
//    static var infinity: Angle { get { return Angle(AngleType.infinity) } }
//
//    /// A quiet NaN.
//    static var NaN: Angle { get { return Angle(AngleType.NaN) } }
//
//    /// A quiet NaN.
//    static var quietNaN: Angle { get { return Angle(AngleType.quietNaN) } }
//
//    /// `true` iff `self` is negative
//    var isSignMinus: Bool { get { return radians.isSignMinus } }
//
//    /// `true` iff `self` is normal (not zero, subnormal, infinity, or
//    /// NaN).
//    var isNormal: Bool { get { return radians.isNormal } }
//
//    /// `true` iff `self` is zero, subnormal, or normal (not infinity
//    /// or NaN).
//    var isFinite: Bool { get { return radians.isFinite } }
//
//    /// `true` iff `self` is +0.0 or -0.0.
//    var isZero: Bool { get { return radians.isZero } }
//
//    /// `true` iff `self` is subnormal.
//    var isSubnormal: Bool { get { return radians.isSubnormal } }
//
//    /// `true` iff `self` is infinity.
//    var isInfinite: Bool { get { return radians.isInfinite } }
//
//    /// `true` iff `self` is NaN.
//    var isNaN: Bool { get { return radians.isNaN } }
//
//    /// `true` iff `self` is a signaling NaN.
//    var isSignaling: Bool { get { return radians.isSignaling } }
//}


extension Angle {
    init(radians: Float) {
        self.radians = AngleType(radians)
    }

    init(radians: Double) {
        self.radians = AngleType(radians)
    }

}


