//
//  Config.swift
//  BrightOSDClient
//
//  Created by Jonathan James Cosgrove on 04/04/2017.
//  Copyright © 2017 Jonathan James Cosgrove. All rights reserved.
//

import Cocoa

struct Config {
    static var defaultModeValue = String("dark")
    static var defaultBrightnessValue = Int(8)
    
    struct OSDLevelIndicator {
        static let minValue = Int(0)
        static let maxValue = Int(16)
    }
}
