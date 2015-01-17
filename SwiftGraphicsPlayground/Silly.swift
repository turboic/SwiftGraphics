//
//  Silly.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

public func tiled(context:CGContext, tileSize:CGSize, dimension:IntSize, origin:CGPoint = CGPoint(x:0.5, y:0.5), block:CGContext -> Void) {

    for y in 0..<dimension.height {
        for x in 0..<dimension.width {

            let frame = CGRect(
                origin:CGPoint(x:CGFloat(x) * tileSize.width, y:CGFloat(y) * tileSize.height),
                size:tileSize
                )

            CGContextSaveGState(context)
            CGContextClipToRect(context, frame)

            let translate = CGPoint(
                x:frame.origin.x + origin.x * tileSize.width,
                y:frame.origin.y + origin.y * tileSize.height
            )

            CGContextTranslateCTM(context, translate.x, translate.y)

            block(context)

            CGContextRestoreGState(context)
        }
    }
}
