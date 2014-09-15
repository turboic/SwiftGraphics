//
//  Ellipse.swift
//  Newton
//
//  Created by Jonathan Wight on 9/14/14.
//  Copyright (c) 2014 toxicsoftware. All rights reserved.
//

import Foundation

class Ellipse {
    var center:CGPoint
    let a:CGFloat // semi major axis
    let b:CGFloat // semi minor axis
    let e:CGFloat // eccentricity
    let F:CGFloat

    init(center:CGPoint, semiMajorAxis a:CGFloat, eccentricity e:CGFloat) {
        self.center = center
        self.a = a
        self.b = a * sqrt(1.0 - e * e)
        self.e = e
        self.F = a * e
    }

    var F1: CGPoint { get { return CGPoint(x:self.center.x - self.F, y:self.center.y) } }
    var F2: CGPoint { get { return CGPoint(x:self.center.x + self.F, y:self.center.y) } }

    var rect:CGRect {
        get {
            let size = CGSize(width:self.a * 2, height:self.b * 2)
            let origin = CGPoint(x:self.center.x - size.width * 0.5, y:self.center.y - size.height * 0.5)
            return CGRect(origin:origin, size:size)
        }
    }

    var path:CGPath { get { return CGPathCreateWithEllipseInRect(self.rect, nil) } }
}