// Playground - noun: a place where people can play

import Cocoa
import CoreGraphics
import SwiftGraphics

let size = CGSize(w:240, h:240)
let context = CGContextRef.bitmapContext(size)
context.setFillColor(CGColor.lightGrayColor())
CGContextFillRect(context, CGRect(size:size))

CGContextTranslateCTM(context, 20, 20)

let curve = BezierCurve(
    start: CGPoint(x:0,y:50),
    control1: CGPoint(x:50,y:200),
    control2: CGPoint(x:150,y:200),
    end: CGPoint(x:200,y:0))

context.setLineWidth(4)

context.setStrokeColor(CGColor.blackColor())
context.stroke(curve)

context.setLineDash([10,10])

context.setStrokeColor(CGColor.blueColor().withAlpha(0.5))
context.strokeLine(curve.points)

context.setStrokeColor(CGColor.greenColor().withAlpha(0.5))
context.strokeRect(curve.simpleBounds())

context.setStrokeColor(CGColor.redColor().withAlpha(0.5))
context.strokeRect(curve.bounds())

context.nsimage

