//
//  SketchView.swift
//  Sketch
//
//  Created by Jonathan Wight on 8/30/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

class SketchView: NSView {

    var rootNode : Group

    required init(coder: NSCoder) {
//        rootNode.children = [
//            Circle(name:"1", center:CGPoint(x:100, y:100), radius:10),
//            Circle(name:"2", center:CGPoint(x:110, y:110), radius:10),
//        ]

        rootNode = loadTest() as Group

        super.init(coder: coder)

    }
        
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let context = NSGraphicsContext.currentContext().CGContext
        self.renderNode(context, rect:dirtyRect, node:self.rootNode) {
            (context:CGContext, node:Node) -> Void in
            NSColor.redColor().set()            
        }
    }
    
    func renderNode(context:CGContext, rect:CGRect, node:Node, applySyleForNode:(context:CGContext, node:Node) -> Void) {
        applySyleForNode(context: context, node: node)

        if let geometryNode = node as? GeometryNode {
            if rect.intersects(geometryNode.frame) == false {
                return
            }
        }
        
        switch node {
            case let node as Circle:
                context.strokeEllipseInRect(node.frame)
            case let node as Line:
                context.strokeLine(node.start, node.end)
            case let node as Rectangle:
                context.strokeRect(node.frame)
            case let node as Group:
                break
            default:
                println("No renderer for \(node)")
        }
        
        if let group = node as? Group {
            for node in group.children {
                self.renderNode(context, rect:rect, node:node, applySyleForNode:applySyleForNode)
            }
        }
    }
    
    override func mouseDown(theEvent: NSEvent!) {
        let location = self.convertPoint(theEvent.locationInWindow, fromView:nil)

        let rect = CGRect(center:location, radius:20)
        
        let context = CGContext.bitmapContext(rect.size)
        
        CGContextConcatCTM(context, CGAffineTransform(tx:-rect.origin.x, ty:-rect.origin.y))
        
        CGContextSetAllowsAntialiasing(context, false)
        
        var colors = Dictionary <UInt32, Node> ()
        
        self.renderNode(context, rect:rect, node:rootNode) {
            (context:CGContext, node:Node) -> Void in

            let colorInt:UInt32 = Random.random(0...0xFFFFFF) << 8 | 0xFF
            let color = NSColor(rgba:colorInt)
            colors[colorInt] = node
//            println("DEFINING: \(colorInt.asHex()) \(color)")
            CGContextSetStrokeColorWithColor(context, color.CGColor)
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextSetLineWidth(context, 4)
        }
        
        let bitmap = Bitmap(
            size:UIntSize(width:UInt(rect.size.width), height:UInt(rect.size.height)),
            bitsPerComponent:8,
            bitsPerPixel:32,
            bytesPerRow:UInt(rect.size.width) * 4,
            ptr:CGBitmapContextGetData(context))
        
        let colorInt = bitmap[UIntPoint(x:UInt(location.x - rect.origin.x), y:UInt(location.y - rect.origin.y))]
        let color = NSColor(rgba: colorInt)
//        println("SEARCH: \(colorInt.asHex()) \(color)")

        let node = colors[colorInt]
        println(node)

        
        let image = context.nsimage

        image.TIFFRepresentation.writeToFile("/Users/schwa/Desktop/test.tiff", atomically:false)
    }
}

