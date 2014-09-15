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

let points = [
    random(CGRect(w:480, h:320)),
    random(CGRect(w:480, h:320)),
    random(CGRect(w:480, h:320)),
    random(CGRect(w:480, h:320)),
    random(CGRect(w:480, h:320)),
    random(CGRect(w:480, h:320)),
]

SGPRender("Test") {
    (ctx:CGContext, bounds:CGRect) in
    for (index, point) in enumerate(points) {
        ctx.strokeCross(CGRect(center:point, radius:5))
        ctx.drawLabel("\(index)", point:point + CGPoint(x:2, y:0), size:10)
    }
}

