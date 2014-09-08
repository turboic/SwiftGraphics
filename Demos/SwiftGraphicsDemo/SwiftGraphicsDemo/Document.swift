//
//  Document.swift
//  Sketch
//
//  Created by Jonathan Wight on 8/30/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa

class Document: NSDocument {
                            
    override init() {
        super.init()
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func makeWindowControllers() {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        let windowController = storyboard.instantiateInitialController() as NSWindowController
        self.addWindowController(windowController)                                    
    }

    override func dataOfType(typeName: String?, error outError: NSErrorPointer) -> NSData? {


        outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        return nil
    }

    override func readFromData(data: NSData?, ofType typeName: String?, error outError: NSErrorPointer) -> Bool {
        outError.memory = NSError.errorWithDomain(NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        return false
    }


}

