// Playground - noun: a place where people can play

import Cocoa
import CoreGraphics
import SwiftGraphics

let size = CGSize(w:240, h:240)
let context = CGContextRef.bitmapContext(size)
context.setFillColor(CGColor.lightGrayColor())
CGContextFillRect(context, CGRect(size:size))

CGContextTranslateCTM(context, 20, 20)

let curves = [
    BezierCurve(
        start: CGPoint(x:10,y:0),
        control1: CGPoint(x:-10,y:180),
        control2: CGPoint(x:150,y:200),
        end: CGPoint(x:200,y:0)),
    BezierCurve(
        start: CGPoint(x:40,y:10),
        control1: CGPoint(x:140,y:100),
        end: CGPoint(x:100,y:10))]

for curve in curves {
    context.setLineDash([1])
    context.setLineWidth(3)
    
    context.setStrokeColor(CGColor.blackColor())
    context.stroke(curve)
    
    context.setLineWidth(2)
    context.setLineDash([5,2])
    
    context.setStrokeColor(CGColor.blueColor().withAlpha(0.5))
    context.strokeLine(curve.points)
    
    context.setStrokeColor(CGColor.greenColor().withAlpha(0.5))
    context.strokeRect(curve.simpleBounds)
    
    context.setStrokeColor(CGColor.redColor().withAlpha(0.5))
    context.strokeRect(curve.bounds)
}

context.nsimage

