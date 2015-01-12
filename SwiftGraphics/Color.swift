//
//  Color.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

struct HSV {
    var h:CGFloat = 0.0
    var s:CGFloat = 0.0
    var v:CGFloat = 0.0
}

struct RGB {
    var r:CGFloat = 0.0
    var g:CGFloat = 0.0
    var b:CGFloat = 0.0
    init(r:CGFloat = 0.0, g:CGFloat = 0.0, b:CGFloat = 0.0) {
        (self.r, self.g, self.b) = (r,g,b)
    }
    init(tuple:(r:CGFloat, g:CGFloat, b:CGFloat)) {
        (self.r, self.g, self.b) = tuple
    }
}

func convert(hsv:HSV) -> RGB {
    var (h, s, v) = (hsv.h, hsv.s, hsv.v)
    if (s == 0) {
        return RGB(tuple:(v,v,v))
    }
    else {
        h *= 360.0;
        if (h == 360.0) {
            h = 0.0
        }
        else {
            h /= 60
        }
        let i = floor(h)
        let f = h - i
        let p = v * (1.0 - s)
        let q = v * (1.0 - (s * f))
        let t = v * (1.0 - (s * (1.0 - f)))

        switch Int(i) {
            case 0:
                return RGB(tuple:(v,t,p))
            case 1:
                return RGB(tuple:(q,v,p))
            case 2:
                return RGB(tuple:(p,v,t))
            case 3:
                return RGB(tuple:(p,q,v))
            case 4:
                return RGB(tuple:(t,p,v))
            case 5:
                return RGB(tuple:(v,p,q))
            default:
                assert(false)
                break
        }
    }
}

//void RGBtoHSV(float r, float g, float b, float *h, float *s, float *v)
//{
//    float max = MAX(r, MAX(g, b));
//    float min = MIN(r, MIN(g, b));
//    float delta = max - min;
//    
//    *v = max;
//    *s = (max != 0.0f) ? (delta / max) : 0.0f;
//    
//    if (*s == 0.0f) {
//        *h = 0.0f;
//    } else {
//        if (r == max) {
//            *h = (g - b) / delta;
//        } else if (g == max) {
//            *h = 2.0f + (b - r) / delta;
//        } else if (b == max) {
//            *h = 4.0f + (r - g) / delta;
//        }
//        
//        *h *= 60.0f;
//        
//        if (*h < 0.0f) {
//            *h += 360.0f;
//        }
//    }
//    
//    *h /= 360.0f;
//}
