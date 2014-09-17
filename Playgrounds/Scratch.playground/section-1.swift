// Playground - noun: a place where people can play

import Cocoa

func cross(o:CGPoint, a:CGPoint, b:CGPoint) -> CGFloat {
   return (a.x - o.x) * (b.y - o.y) - (a.y - o.y) * (b.x - o.x)
}


cross(CGPoint(x:0, y:0), CGPoint(x:100, y:0), CGPoint(x:100, y:100))