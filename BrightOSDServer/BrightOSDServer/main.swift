//
//  main.swift
//  BrightOSDServer
//
//  Created by Jonathan James Cosgrove on 09/04/2017.
//  Copyright © 2017 Jonathan James Cosgrove. All rights reserved.
//

import Cocoa
import Foundation

NSApplication.shared()

NSApp.setActivationPolicy(NSApplicationActivationPolicy.accessory)

let brightOSDServerController = BrightOSDServerController()
NSApp.delegate = brightOSDServerController

NSApp.run()
