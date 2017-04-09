//
//  BrightOSDLevelIndicator.swift
//  BrightOSDServer
//
//  Created by Jonathan James Cosgrove on 09/04/2017.
//  Copyright © 2017 Jonathan James Cosgrove. All rights reserved.
//

import Cocoa

class BrightOSDLevelIndicator: NSLevelIndicator {
    
    override func draw(_ baseRectangle: NSRect) {
        
        // draw colors for each mode
        let backgroundColorLight = NSColor.init(white: 0.2, alpha: 1.0)
        let backgroundColorDark = NSColor.init(white: 0.0, alpha: 0.3)
        let segmentColor = NSColor.init(white: 0.98, alpha: 1.0)

        // segment helpers
        let maxSegments = self.maxValue
        let numOfSegments = self.intValue
        let segmentWidth = (self.frame.width - 1) / CGFloat(maxSegments)
        let segmentHeight = self.frame.height
        
        // for storing final background color
        var backgroundColor: NSColor?
        
        // set the background color based on current mode
        if(Config.currentOSDMode == Config.OSDModes.light) {
            backgroundColor = backgroundColorLight
        } else {
            backgroundColor = backgroundColorDark
        }
        
        // fill in the backgound
        backgroundColor?.set()
        var background = baseRectangle;
        background.size.height = 8
        NSRectFill(background);
        
        // draw each segment
        for segmentIndex in 0..<numOfSegments {

            let width = CGFloat(9)
            let height = CGFloat(segmentHeight - 2)

            let xPosition = CGFloat(CGFloat(segmentIndex) * segmentWidth + 1)
            let yPosition = CGFloat(1)

            let segment = NSRect(
                x: xPosition,
                y: yPosition,
                width: width,
                height: height
            )

            segmentColor.set()
            NSRectFill(segment)
        }
    }
}
