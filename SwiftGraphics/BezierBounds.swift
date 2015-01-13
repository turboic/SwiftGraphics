//
//  BezierBounds.swift
//  SwiftGraphics
//
//  Created by Zhang Yungui <https://github.com/rhcad> on 15/1/13.
//    Modified from http://pomax.nihongoresources.com/pages/bezier
//
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

public extension BezierCurve {
    
    func simpleBounds() -> CGRect {
        return CGRect.unionOfPoints(points)
    }
    
    //! Compute the bounding box based on the straightened curve, for best fit
    func bounds() -> CGRect {
        if self.controls.count == 1 {
            return increasedOrder().bounds()
        }
        
        assert(self.controls.count == 2)
        let pt1 = start!
        let pt2 = controls[0]
        let pt3 = controls[1]
        let pt4 = end
    
        var bbox = CGRect(P1:pt1, P2:pt4)   // compute linear bounds first
        var flag = 0
        
        // Recompute bounds projected on the x-axis, if the control points lie outside the bounding box x-bounds
        if pt2.x < bbox.minX || pt2.x > bbox.maxX || pt3.x < bbox.minX || pt3.x > bbox.maxX {
            let (t1, t2) = computeCubicFirstDerivativeRoots(pt1.x, b:pt2.x, c:pt3.x, d:pt4.x)
            if t1>=0 && t1<=1 {
                let x = computeCubicBaseValue(t1, a:pt1.x, b:pt2.x, c:pt3.x, d:pt4.x)
                bbox.union(CGPoint(x:x, y:bbox.minY))
                flag |= 1
            }
            if t2>=0 && t2<=1 {
                let x = computeCubicBaseValue(t2, a:pt1.x, b:pt2.x, c:pt3.x, d:pt4.x)
                bbox.union(CGPoint(x:x, y:bbox.minY))
                flag |= 2
            }
        }
        
        // Recompute on the y-axis, if the control points lie outside the bounding box y-bounds
        if pt2.y < bbox.minY || pt2.y > bbox.maxY || pt3.y < bbox.minY || pt3.y > bbox.maxY {
            let (t1, t2) = computeCubicFirstDerivativeRoots(pt1.y, b:pt2.y, c:pt3.y, d:pt4.y)
            if t1>=0 && t1<=1 {
                let y = computeCubicBaseValue(t1, a:pt1.y, b:pt2.y, c:pt3.y, d:pt4.y)
                bbox.union(CGPoint(x:bbox.minX, y:y))
                flag |= 4
            }
            if t2>=0 && t2<=1 {
                let y = computeCubicBaseValue(t2, a:pt1.y, b:pt2.y, c:pt3.y, d:pt4.y)
                bbox.union(CGPoint(x:bbox.minX, y:y))
                flag |= 8
            }
        }
        
        return bbox
    }
    
    
    
    // compute the value for the cubic bezier function at time=t
    private func computeCubicBaseValue(t:CGFloat, a:CGFloat, b:CGFloat, c:CGFloat, d:CGFloat) -> CGFloat {
        let v  = 1-t
        let v2 = v*v
        let t2 = t*t
        return v2*v*a + 3*v2*t*b + 3*v*t2*c + t2*t*d
    }
    
    // compute the value for the first derivative of the cubic bezier function at time=t
    private func computeCubicFirstDerivativeRoots(a:CGFloat, b:CGFloat, c:CGFloat, d:CGFloat) -> (CGFloat,CGFloat) {
        let u = b - a, vt = c - b, w = d - c
        let v = abs(u+w - 2*vt)<0.001 ? vt + 0.01 : vt
        
        let denominator = 2*(u - 2*v + w)
        let numerator   = 2*(u - v)
        let uv2         = 2*v-2*u
        let quadroot    = uv2*uv2 - 2*u*denominator
        let root        = sqrt(quadroot)
        
        // there are two possible values for 't' that yield inflection points,
        // and each of these inflection points might be outside the linear bounds
        return ((numerator + root) / denominator, (numerator - root) / denominator)
    }
    
}
