// Playground - noun: a place where people can play

import Cocoa
import SwiftGraphics
import SwiftGraphicsPlayground
import XCPlayground

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

func pt(x:CGFloat, y:CGFloat) -> CGPoint {
    return CGPoint(x:x, y:y)
}

let t1 = Triangle(pt(0,0), pt(100,0), pt(0,100))
//println(dump(t1))

let size = CGSize(w:200, h:200)
let context = CGContextRef.bitmapContext(size)
context.setFillColor(CGColor.lightGrayColor())
CGContextFillRect(context, CGRect(size:size))

CGContextTranslateCTM(context, 50, 50)

context.draw(t1)
var (p0, p1, p2) = t1.points
context.plotPoints([p0,p1,p2])

context.setStrokeColor(CGColor.redColor())

//func drawAngle(vertex:CGPoint, p1:CGPoint, p2:CGPoint) {
//    let delta:CGFloat = -DegreesToRadians(90)
//
//    var a = angle(vertex, p1, p2) + delta
//    context.strokeLine(vertex, vertex + 
//    CGPoint(magnitude:20, direction: a))
//    context.strokeLine(vertex, vertex + CGPoint(magnitude:20, direction: a))
//}
//
////drawAngle(p0, p1, p2)
////drawAngle(p1, p2, p0)
//drawAngle(p2, p0, p1)



context.nsimage
