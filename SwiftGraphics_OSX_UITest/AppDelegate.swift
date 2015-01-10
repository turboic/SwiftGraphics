//
//  AppDelegate.swift
//  SwiftGraphics_OSX_UITest
//
//  Created by Jonathan Wight on 1/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa
import SwiftGraphics
import SwiftGraphicsPlayground


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {

        var points = arrayOfRandomPoints(50, CGRect(w:480, h:320))

        points = grahamOrdered(points)

        // Next line asplodes!
        let hull = grahamScan(points)

        println(hull)


    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

