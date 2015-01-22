//
//  Triangle+Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/17/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

import CoreGraphics
import SwiftGraphics
import SwiftGraphicsPlayground

public extension Triangle {

    var markup:[Markup] {

        var markup:[Markup] = []

        markup.append(Marker(point: points.0, tag: "vertex"))
        markup.append(Marker(point: points.1, tag: "vertex"))
        markup.append(Marker(point: points.2, tag: "vertex"))
        markup.append(Marker(point: circumcenter, tag: "circumcenter"))
        markup.append(Guide(type: .circle(circumcircle), tag: "circumcircle"))

        markup.append(AngleMarker(points:(points.0, points.1, points.2)))
//        markup.append(AngleMarker(points:(points.1, points.2, points.0)))
//        markup.append(AngleMarker(points:(points.2, points.0, points.1)))

        return markup
    }
}


//func dump(t:Triangle) -> String {
//    var s = ""
//    s += "Points: \(t.points)\n"
//    s += "Lengths: \(t.lengths)\n"
//    s += "Angles: \(RadiansToDegrees(t.angles.0), RadiansToDegrees(t.angles.1), RadiansToDegrees(t.angles.2))\n"
//    s += "isIsosceles: \(t.isIsosceles)\n"
//    s += "isEquilateral: \(t.isEquilateral)\n"
//    s += "isScalene: \(t.isScalene)\n"
//    s += "isRightAngled: \(t.isRightAngled)\n"
//    s += "isOblique: \(t.isOblique)\n"
//    s += "isAcute: \(t.isAcute)\n"
//    s += "isObtuse: \(t.isObtuse)\n"
//    s += "isDegenerate: \(t.isDegenerate)\n"
//    s += "signedArea: \(t.signedArea)\n"
//    return s    
//}
