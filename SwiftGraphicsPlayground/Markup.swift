//
//  Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics
import SwiftGraphics
import SwiftGraphicsPlayground

public protocol Markup {
    var tag:String? { get }
    var style:Style? { get }
    func draw(context:CGContext)
}

public struct Guide: Markup {

    public enum Type {
//        case line(Line)
        case lineSegment(LineSegment)
        case polygon(SwiftGraphics.Polygon) // TODO: Should not have to namespace this.
        case rectangle(Rectangle)
        case circle(Circle)
    }

    public let type:Type
    public let tag:String?
    public let style:Style?

    public init(type:Type, tag:String? = nil, style:Style? = nil) {
        self.type = type
        self.tag = tag
        self.style = style
    }

    public func draw(context:CGContext) {

        if let style = style {
            CGContextSaveGState(context)
            context.apply(style)
        }

        switch type {
//            case .line:
//                break
            case .lineSegment(let lineSegment):
                context.stroke(lineSegment)
            case .polygon(let polygon):
                context.stroke(polygon)
            case .rectangle(let rectangle):
                context.strokeRect(rectangle)
            case .circle(let circle):
                context.draw(circle)
            default:
                break
        }

        if let style = style {
            CGContextRestoreGState(context)
        }

    }
}

public struct Marker: Markup {
    public let point:CGPoint
    public let tag:String?
    public var style:Style?

    public init(point:CGPoint, tag:String? = nil, style:Style? = nil) {
        self.point = point
        self.tag = tag
        self.style = style
    }

    public func draw(context:CGContext) {
        if let style = style {
            CGContextSaveGState(context)
            context.apply(style)
        }

        context.strokeSaltire(CGRect(center:point, diameter:10))

        if let style = style {
            CGContextRestoreGState(context)
        }
    }

    public static func markers(points:[CGPoint]) -> [Marker] {
        return points.map() {
            return Marker(point:$0)
        }
    }
}


public struct AngleMarker : Markup {

    public let tag:String?
    public let style:Style?

    public let points:(CGPoint, CGPoint, CGPoint)

    public init(points:(CGPoint, CGPoint, CGPoint), tag:String? = nil, style:Style? = nil) {
        self.tag = tag
        self.style = style
        self.points = points
    }

    public func draw(context:CGContext) {
//        context.setFillColor(CGColor.redColor())
        context.setStrokeColor(CGColor.redColor())

        var (p0, p1, p2) = points
        p0 = p1 + CGPoint(magnitude:20, direction: p0.angleTo(p1))



        context.strokeLine(p0, p1)

        context.setStrokeColor(CGColor.blueColor())
        context.strokeLine(p1, p2)

//        context.fillCircle(center: points.1, radius: 5)
//
//
//        CGContextMoveToPoint(context, <#x: CGFloat#>, <#y: CGFloat#>)
//        CGContextAddArc(context, <#x: CGFloat#>, <#y: CGFloat#>, <#radius: CGFloat#>, <#startAngle: CGFloat#>, <#endAngle: CGFloat#>, <#clockwise: Int32#>)
    }

}




public extension CGContext {
    func draw(markup:[Markup], styles:[String:Style]? = nil) {
        for item in markup {

            let style = styles?[item.tag!]

            if let style = style {
                CGContextSaveGState(self)
                apply(style)
            }

            item.draw(self)

            if let style = style {
                CGContextRestoreGState(self)
            }
        }
    }
}
