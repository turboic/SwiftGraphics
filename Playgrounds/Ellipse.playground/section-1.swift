// Playground - noun: a place where people can play

import Cocoa
import CoreGraphics
import SwiftGraphics

extension CGContext {

    var size:CGSize {
        get {
            return CGSize(w:CGFloat(CGBitmapContextGetWidth(self)), h:CGFloat(CGBitmapContextGetHeight(self)))
        }
    }

    func strokePath(path:CGPath) {
        CGContextAddPath(self, path)
        CGContextStrokePath(context)
    }
}

struct Marker {
    let point:CGPoint

    func draw(context:CGContext) {
        context.strokeSaltire(CGRect(center:point, diameter:10))
    }

    static func markers(points:[CGPoint]) -> [Marker] {
        return points.map() {
            return Marker(point:$0)
        }
    }

}

extension CGContext {
    func draw(markers:[Marker]) {
        for marker in markers {
            marker.draw(self)
        }
    }
}

struct BezierCurveChain {
    let curves:[BezierCurve]

    init(curves:[BezierCurve]) {
        self.curves = curves
    }
}

extension CGContext {
    func stroke(chain:BezierCurveChain) {
        for curve in chain.curves {
            stroke(curve)
        }
    }
}

extension Ellipse {

    var points:[CGPoint] {
        return [
            center + CGPoint(x:-a, y:-b),
            center + CGPoint(x:-a, y:+b),
            center + CGPoint(x:+a, y:-b),
            center + CGPoint(x:+a, y:+b),
        ]
    }

    var asBezierChain:(BezierCurveChain) {
        get {
            let curves = self.asBezierCurves
            let curvesArray = [curves.0, curves.1, curves.2, curves.3]
            return BezierCurveChain(curves:curves)
        }
    }


    var asBezierCurves:(BezierCurve, BezierCurve, BezierCurve, BezierCurve) {
        get {

            let t = CGAffineTransform(rotation: DegreesToRadians(45))

            let da = a * 4.0 * (sqrt(2.0) - 1.0) / 3.0
            let db = b * 4.0 * (sqrt(2.0) - 1.0) / 3.0

            let curve0 = BezierCurve(
                start:    center + CGPoint(x:0, y:b) * t,
                control1: center + (CGPoint(x:0, y:b) + CGPoint(x:da, y:0)) * t,
                control2: center + (CGPoint(x:a, y:0) + CGPoint(x:0, y:db)) * t,
                end:      center + CGPoint(x:a, y:0) * t
            )
            let curve1 = BezierCurve(
                start:    center + CGPoint(x:a, y:0) * t,
                control1: center + (CGPoint(x:a, y:0) + CGPoint(x:0, y:-db)) * t,
                control2: center + (CGPoint(x:0, y:-b) + CGPoint(x:da, y:0)) * t,
                end:      center + CGPoint(x:0, y:-b) * t
            )
            let curve2 = BezierCurve(
                start:    center + CGPoint(x:0, y:-b) * t,
                control1: center + (CGPoint(x:0, y:-b) + CGPoint(x:-da, y:0)) * t,
                control2: center + (CGPoint(x:-a, y:0) + CGPoint(x:0, y:-db)) * t,
                end:      center + CGPoint(x:-a, y:0) * t
            )
            let curve3 = BezierCurve(
                start:    center + CGPoint(x:-a, y:0) * t,
                control1: center + (CGPoint(x:-a, y:0) + CGPoint(x:0, y:db)) * t,
                control2: center + (CGPoint(x:0, y:b) + CGPoint(x:-da, y:0)) * t,
                end:      center + CGPoint(x:0, y:b) * t
            )

        return (curve0, curve1, curve2, curve3)
        }
    }
}


let size = CGSize(w:200, h:200)
let context = CGContextRef.bitmapContext(size, color:CGColor.lightGrayColor())

CGContextTranslateCTM(context, 100, 100)

var ellipse = Ellipse(center:CGPointZero, semiMajorAxis:50.0, eccentricity:0.9)
context.strokePath(ellipse.path)

let markers = Marker.markers(ellipse.points)
context.draw(markers)

//    init(center:CGPoint, semiMajorAxis a:CGFloat, eccentricity e:CGFloat) {



let curves = ellipse.asBezierCurves
let bezierCurves = [curves.0, curves.1, curves.2, curves.3]
for (index, curve) in enumerate(bezierCurves) {
    if index % 2 == 0 {
        context.setStrokeColor(CGColor.redColor())
    }
    else {
        context.setStrokeColor(CGColor.greenColor())
    }
    context.stroke(curve)
}

context.nsimage

