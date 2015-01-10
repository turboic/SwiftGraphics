//
//  QuadTreeView.swift
//  Sketch
//
//  Created by Jonathan Wight on 9/7/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

class QuadTreeView: NSView {

    var quadTree: SwiftGraphics.QuadTree <CGPoint>!
    
    required init?(coder: NSCoder) {
        super.init(coder:coder)
        
        quadTree = QuadTree <CGPoint> (frame:self.bounds)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let context = NSGraphicsContext.currentContext()!.CGContext

        self.quadTree.render(context)

        for point in self.quadTree.objectsInRect(dirtyRect.insetted(dx:-5, dy:-5)) {
            context.strokeCross(CGRect(center:point, diameter:10))
        }
    }

    override func mouseDown(theEvent: NSEvent) {
        let location = self.convertPoint(theEvent.locationInWindow, fromView:nil)
        self.quadTree.addObject(location, point:location)
        self.needsDisplay = true
    }

    override func mouseDragged(theEvent: NSEvent) {
        let location = self.convertPoint(theEvent.locationInWindow, fromView:nil)
        self.quadTree.addObject(location, point:location)
        self.needsDisplay = true
    }
    
}

extension QuadTree {
    func render(context:CGContext) {
        self.rootNode.render(context)
    }
}

extension QuadTreeNode {
    func render(context:CGContext) {
        context.strokeRect(self.frame)
        
        if let subnodes = self.subnodes {
            for node in subnodes {
                node.render(context)
            }
        }
    }
}
