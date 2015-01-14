//
//  EditorView.swift
//  SwiftGraphicsDemo
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

struct Handle {
    var position : CGPoint
}

protocol Editor {
    var handles:[Handle] { get }
    var guides:[Handle] { get }
    func setHandlePosition(handle:Int, position:CGPoint);
    func draw(context:CGContextRef);
}

class BezierEditor : Editor {
    var curve:BezierCurve
    var handles:[Handle] = []
    var guides:[Handle] = []

    init(_ curve:BezierCurve) {
        self.curve = curve
        self.handles = self.curve.points.map {
            (p:CGPoint) -> Handle in
            return Handle(position:p)
        }
        self._update()
    }
    
    func setHandlePosition(handle:Int, position:CGPoint) {
        self.handles[handle].position = position
        self._update()
    }
    
    func _update() {
        // Make a new curve from the points of the handles...
        let points = self.handles.map() {
            (h:Handle) -> CGPoint in
            return h.position
        }
        self.curve = BezierCurve(points:points)

        // Make a cubic and turn its points into guides...
        let cubicCurve = self.curve.increasedOrder()
        self.guides = cubicCurve.controls.map {
            (p:CGPoint) -> Handle in
            return Handle(position:p)
        }
    }
    
    func draw(context:CGContextRef) {
        context.withColor(CGColor.redColor()) {
            for p in self.handles {
                context.strokeCross(CGRect(center:p.position, size:CGSize(w:6, h:6)))
            }
        }
        context.withColor(CGColor.blueColor()) {
            for p in self.guides {
                context.strokeSaltire(CGRect(center:p.position, size:CGSize(w:3, h:3)))
            }
        }
        
        context.stroke(self.curve)
        context.withColor(CGColor.lightGrayColor()) {
            context.strokeRect(self.curve.bounds)
            let points = self.curve.points
            context.strokeLine(points[0], points[1])
            context.strokeLine(points[2], self.curve.end)
        }
    }
}

class EditorView: NSView {

    var curves : [Editor] = [
        BezierEditor(BezierCurve(start:CGPoint(x:100,y:200), control1:CGPoint(x:150,y:250),
            control2:CGPoint(x:200,y:250), end:CGPoint(x:200,y:200))),
        BezierEditor(BezierCurve(start:CGPoint(x:100,y:100), control1:CGPoint(x:150,y:150),
            end:CGPoint(x:200,y:100)))]
    
    var activeCurve : Editor?
    var activeHandle : Int?

//    override init(frame frameRect: NSRect) {
//        super.init(frameRect:frame)
//    }

    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        NSColor.whiteColor().set()
        NSRectFill(dirtyRect)
        NSColor.blackColor().set()

        let context = NSGraphicsContext.currentContext()!.CGContext
        for curve in self.curves {
            curve.draw(context)
        }
    }
    
    override func mouseDown(theEvent: NSEvent) {
        let location = self.convertPoint(theEvent.locationInWindow, fromView:nil)
        if let (curve, index) = handleHit(location) {
            activeCurve = curve
            activeHandle = index
            self.needsDisplay = true
        }
    }

    override func mouseDragged(theEvent: NSEvent) {
        if let activeHandle = activeHandle {
            let location = self.convertPoint(theEvent.locationInWindow, fromView:nil)
            activeCurve!.setHandlePosition(activeHandle, position:location)
            self.needsDisplay = true
        }
    }

    override func mouseUp(theEvent: NSEvent) {
        self.activeCurve = nil
        self.activeHandle = nil
        self.needsDisplay = true
    }

    func handleHit(point:CGPoint) -> (Editor, Int)? {
        for curve in self.curves {
            for (index, handle) in enumerate(curve.handles) {
                let R = CGFloat(10.0)
                let handleRect = CGRect(x:handle.position.x - R, y:handle.position.y - R, width:R * 2, height:R * 2)
                if handleRect.contains(point) {
                    return (curve, index)
                }
            }
        }
        return nil
    }

}
