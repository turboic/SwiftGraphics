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
    init(h:CGFloat = 0.0, s:CGFloat = 0.0, v:CGFloat = 0.0) {
        (self.h, self.s, self.v) = (h,s,v)
    }
    init(tuple:(h:CGFloat, s:CGFloat, v:CGFloat)) {
        (self.h, self.s, self.v) = tuple
    }
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

// TODO: One option? Or just add alpha to colors
//struct HSVA {
//    var hsv:HSV
//    var a:CGFloat
//}
//
//struct RGBA {
//    var rgb:RGB
//    var a:CGFloat
//}

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

func convert(rgb:RGB) -> HSV {
    let max_ = max(rgb.r, rgb.g, rgb.b)
    let min_ = min(rgb.r, rgb.g, rgb.b)
    let delta = max_ - min_

    var h:CGFloat = 0.0
    let s = max_ != 0.0 ? delta / max_ : 0.0
    let v = max_

    if s == 0.0 {
        h = 0.0
    }
    else {
        if rgb.r == max_ {
            h = (rgb.g - rgb.b) / delta
        }
        else if rgb.g == max_ {
            h = 2 + (rgb.b - rgb.r) / delta
        }
        else if rgb.b == max_ {
            h = 4 + (rgb.r - rgb.g) / delta
        }

        h *= 60
        if h < 0 {
            h += 360
        }
    }

    h /= 360

    return HSV(h:h, s:s, v:v)
}
