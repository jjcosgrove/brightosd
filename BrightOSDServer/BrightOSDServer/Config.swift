//
//  Config.swift
//  BrightOSDServer
//
//  Created by Jonathan James Cosgrove on 09/04/2017.
//  Copyright © 2017 Jonathan James Cosgrove. All rights reserved.
//

import Cocoa

struct Config {
    static var currentOSDMode = OSDModes.dark

    struct OSDModes {
        static let dark = 0
        static let light = 1
    }

    struct OSDLevelIndicator {
        static let minValue = Double(0)
        static let maxValue = Double(16)
        static var currentValue = Int32(8)
    }
}
