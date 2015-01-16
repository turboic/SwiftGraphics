// Playground - noun: a place where people can play

import CoreGraphics
import SwiftGraphics
import SwiftGraphicsPlayground

struct BezierCurveChain {

    // TODO: This isn't really an accurate representaiton of what we want.
    // TODO: Control points should be shared between neighbouring curves.
    let curves:[BezierCurve]

    init(curves:[BezierCurve]) {

        var previousCurve:BezierCurve?
        self.curves = curves.map() {
            (curve:BezierCurve) -> BezierCurve in

            var newCurve = curve
            if let previousEndPoint = previousCurve?.end {
                if let start = curve.start {
//                    assert(previousEndPoint == start)
                    newCurve = BezierCurve(controls:curve.controls, end:curve.end)
                }
            }

            previousCurve = curve

            return newCurve
        }
    }
}

extension BezierCurveChain: Printable {
    var description: String {
        get {
            return ", ".join(curves.map() { $0.description })
        }
    }
}

extension CGContext {
    func stroke(chain:BezierCurveChain) {
        // Stroke all curves as a single path
        let start = chain.curves[0].start
        CGContextMoveToPoint(self, start!.x, start!.y)
        for curve in chain.curves {
            self.addToPath(curve)
        }
        CGContextStrokePath(self)
    }
}


extension Ellipse {

    var markup:[Markup] {

        var markup:[Markup] = []

        // Center and foci already include rotation...
        markup.append(Marker(point: center, tag: "center"))
        markup.append(Marker(point: foci.0, tag: "foci"))
        markup.append(Marker(point: foci.1, tag: "foci"))

        let t = CGAffineTransform(rotation: rotation)
        markup.append(Marker(point: center + CGPoint(x:-a, y:-b) * t, tag: "corner"))
        markup.append(Marker(point: center + CGPoint(x:-a, y:+b) * t, tag: "corner"))
        markup.append(Marker(point: center + CGPoint(x:+a, y:-b) * t, tag: "corner"))
        markup.append(Marker(point: center + CGPoint(x:+a, y:+b) * t, tag: "corner"))

        markup.append(Marker(point: CGPoint(x:-a) * t, tag: "-a"))
        markup.append(Marker(point: CGPoint(x:+a) * t, tag: "+a"))
        markup.append(Marker(point: CGPoint(y:-b) * t, tag: "-b"))
        markup.append(Marker(point: CGPoint(y:+b) * t, tag: "+b"))

        let A = LineSegment(start:CGPoint(x:-a) * t, end:CGPoint(x:+a) * t)
        markup.append(Guide(type: .lineSegment(A), tag: "A"))

        let B = LineSegment(start:CGPoint(y:-b) * t, end:CGPoint(y:+b) * t)
        markup.append(Guide(type: .lineSegment(B), tag: "B"))

        return markup
    }

}


extension Ellipse {

    var asBezierChain:(BezierCurveChain) {
        get {
            let curves = self.asBezierCurves
            let curvesArray = [curves.0, curves.1, curves.2, curves.3]
            return BezierCurveChain(curves:curvesArray)
        }
    }

    var asBezierCurves:(BezierCurve, BezierCurve, BezierCurve, BezierCurve) {
        get {

            let t = CGAffineTransform(rotation: rotation)

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


let size = CGSize(w:400, h:400)
let context = CGContextRef.bitmapContext(size, color:CGColor.lightGrayColor())

CGContextTranslateCTM(context, 200, 200)

var ellipse = Ellipse(center:CGPointZero, semiMajorAxis:150.0, eccentricity:0.9, rotation:DegreesToRadians(30))
//context.strokePath(ellipse.path)

let markup = ellipse.markup
context.draw(markup)

let curves = ellipse.asBezierChain
context.stroke(curves)


context.nsimage

