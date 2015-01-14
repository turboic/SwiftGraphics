//
//  CGPoint+Rular.swift
//  SwiftGraphics
//
//  Created by Zhang Yungui <https://github.com/rhcad> on 15/1/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics


// MARK: Ruler constructions

public extension CGPoint {
    
    func rulerPoint(dir:CGPoint, dy:CGFloat) -> CGPoint {
        let len = distanceTo(dir)
        if len ==% 0 {
            return CGPoint(x:x, y:y + dy)
        }
        let d = dy / len
        return CGPoint(x:x - (dir.y - y) * d, y:y + (dir.x - x) * d)
    }
    
    func rulerPoint(dir:CGPoint, dx:CGFloat) -> CGPoint {
        let len = distanceTo(dir)
        if len ==% 0 {
            return CGPoint(x:x + dx, y:y)
        }
        let d = dx / len
        return CGPoint(x:x + (dir.x - x) * d, y:y + (dir.y - y) * d)
    }
    
    func rulerPoint(dir:CGPoint, dx:CGFloat, dy:CGFloat) -> CGPoint {
        let len = distanceTo(dir)
        if len ==% 0 {
            return CGPoint(x:x + dx, y:y + dy)
        }
        let dcos = (dir.x - x) / len
        let dsin = (dir.y - y) / len
        return CGPoint(x:x + dx * dcos - dy * dsin, y:y + dx * dsin + dy * dcos)
    }
}

// MARK: Vector projection

public extension CGPoint {
    
    public static var vectorTolerance:CGFloat = 1e-4
    
    func isPerpendicularTo(vec:CGPoint) -> Bool {
        let sinfz = abs(crossProduct(vec))
        if sinfz == 0 {
            return false
        }
        let cosfz = abs(dotProduct(vec))
        return cosfz <= sinfz * CGPoint.vectorTolerance
    }
    
    func distanceToVector(xAxis:CGPoint) -> CGFloat {
        let len = xAxis.magnitude
        return len == 0 ? magnitude : xAxis.crossProduct(self) / len
    }
    
    //! Returns the proportion of the projection vector onto xAxis, projection==xAxis * proportion
    func projectScaleToVector(xAxis:CGPoint) -> CGFloat {
        let d2 = xAxis.square
        return d2 == 0 ? 0.0 : dotProduct(xAxis) / d2
    }
    
    //! Returns the projection vector and perpendicular vector, self==proj+perp
    func projectResolveVector(xAxis:CGPoint) -> (CGPoint, CGPoint) {
        let s = projectScaleToVector(xAxis)
        let proj = xAxis * s, perp = self - proj
        return (proj, perp)
    }
    
    //! Vector decomposition: self==u*uAxis + v*vAxis
    func resolveVector(uAxis:CGPoint, vAxis:CGPoint) -> CGPoint {
        let denom = uAxis.crossProduct(vAxis)
        if denom == 0 {
            return CGPoint.zeroPoint
        }
        let c = uAxis.crossProduct(self)
        return CGPoint(x:crossProduct(vAxis) / denom, y:c / denom)  // (u,v)
    }
}
