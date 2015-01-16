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
    func draw(context:CGContext)
}

public struct Guide: Markup {

    public enum Type {
        case line(Line)
        case lineSegment(LineSegment)
    }

    public let type:Type
    public let tag:String?

    public init(type:Type, tag:String?) {
        self.type = type
        self.tag = tag
    }

    public func draw(context:CGContext) {
        switch type {
            case .line:
                break
            case .lineSegment(let lineSegment):
                context.stroke(lineSegment)
        }
    }
}

public struct Marker: Markup {
    public let point:CGPoint
    public let tag:String?

    public init(point:CGPoint, tag:String? = nil) {
        self.point = point
        self.tag = tag
    }

    public func draw(context:CGContext) {
        context.strokeSaltire(CGRect(center:point, diameter:10))
    }

    public static func markers(points:[CGPoint]) -> [Marker] {
        return points.map() {
            return Marker(point:$0)
        }
    }

}

public extension CGContext {
    func draw(markup:[Markup]) {
        for item in markup {
            item.draw(self)
        }
    }
}
