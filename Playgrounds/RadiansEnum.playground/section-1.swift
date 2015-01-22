// Playground - noun: a place where people can play

import Foundation

public func DegreesToRadians(v:Double) -> Double {
    return v * M_PI / 180
}

public func RadiansToDegrees(v:Double) -> Double {
    return v * 180 / M_PI
}

enum Angle {
    typealias ScalarType = Double

    case radians(ScalarType)
    case degrees(ScalarType)

    var asRadians:ScalarType {
        get {
            switch self {
                case .radians(let radians):
                    return radians
                case .degrees(let degrees):
                    return DegreesToRadians(degrees)
            }
        }
    }

    var asDegrees:ScalarType {
        get {
            switch self {
                case .radians(let radians):
                    return RadiansToDegrees(radians)
                case .degrees(let degrees):
                    return degrees
            }
        }
    }
}


sizeof(Angle)

Angle.degrees(90).asRadians
