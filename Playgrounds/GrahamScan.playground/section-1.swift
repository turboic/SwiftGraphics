// Playground - noun: a place where people can play

import Cocoa

import SwiftGraphics
import SwiftGraphicsPlayground
import XCPlayground

func SGPRender(identifier:String, block:((ctx:CGContext, bounds:CGRect) -> Void)) {
    let demoView = SwiftGraphicsPlayground.DemoView(frame:CGRect(size:CGSize(w:480, h:320)))
    demoView.drawBlock = block
    XCPShowView(identifier, demoView)
}

var points = arrayOfRandomPoints(50, CGRect(w:480, h:320))

SGPRender("Test") {
    (ctx:CGContext, bounds:CGRect) in

    points = grahamOrdered(points)

    // Next line asplodes!
    let hull = grahamScan(points)

    for (index, point) in enumerate(points) {
        if contains(hull, point) {
            NSColor.greenColor().set()
        }
        else {
            NSColor.redColor().set()
        }
        ctx.strokeCross(CGRect(center:point, radius:5))
        ctx.drawLabel("\(index)", point:point + CGPoint(x:2, y:0), size:10)
    }

}

