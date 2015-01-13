//
//  Drawable.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

public protocol Drawable {
    func drawInContext(context:CGContext)
}

public extension CGContext {
    func draw(drawable:Drawable, style:Style? = nil) {
        if let style = style {
            with(style) {
                drawable.drawInContext(self)
            }
        }
        else {
            drawable.drawInContext(self)
        }
    }

    func draw(drawables:Array <Drawable>, style:Style? = nil) {
        let block:Void -> Void = {
            for drawable in drawables {
                self.draw(drawable)
            }
        }
        if let style = style {
            with(style, block)
        }
        else {
            block()
        }

    }

    func draw <T> (things:Array <T>, style:Style? = nil, filter:T -> Drawable) {
        let drawables = things.map(filter)
        draw(drawables, style:style)
    }

}

extension BezierCurve: Drawable {
    public func drawInContext(context:CGContext) {
        context.stroke(self)
    }
}

public struct Saltire {
    public let frame:CGRect

    public init(frame:CGRect) {
        self.frame = frame
    }
}

extension Saltire: Drawable {
    public func drawInContext(context:CGContext) {
        context.strokeSaltire(frame)
    }
}

//extension Array {
//    func converted <U> () -> [U] {
//        return self.map() {
//            (value:T) -> U in
//            return value as U
//        }
//    }
//}

