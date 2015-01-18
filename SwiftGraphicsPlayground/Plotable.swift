//
//  Plotable.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics
import SwiftGraphics

public protocol Geometry {
    var frame:CGRect { get }    
}

extension CGPoint : Geometry {
    public var frame:CGRect { get { return CGRect(center:self, diameter:0) } }
}

public protocol Plotable : Geometry {
    func plotInContext(ctx:CGContext)
}

extension CGPoint : Plotable {
    public func plotInContext(ctx:CGContext) {
        ctx.plotPoints([self])
    }
}

extension Circle : Plotable {
    public func plotInContext(ctx:CGContext) {
        ctx.strokeEllipseInRect(frame)
    }
}

extension Triangle : Plotable {
    public func plotInContext(ctx:CGContext) {
        let (a,b,c) = points
        ctx.strokeLine([a, b, c], close:true)
    }
    public var frame : CGRect {
        get {
            let (a,b,c) = self.points
            let points = [a,b,c]
            let rects:[CGRect] = points.map {
                return $0.frame
            }
            println(rects)
            return CGRect.unionOfRects(rects)
        }
    }
}

public extension CGContext {

    public func plot(a:Plotable) {
        a.plotInContext(self)
    }


    public func plot(a:Array <Plotable>) {
        for e in a {
            e.plotInContext(self)
//            strokeRect(e.frame)
        }
    }

    public func plot(d:[String:Plotable]) {
        for (key, value) in d {
            value.plotInContext(self)
            println(key)
            drawLabel(key, point:value.frame.mid, size: 16)
//            strokeRect(value.frame)
        }
    }
}


