//
//  BrightOSDBrightnessImageView.swift
//  BrightOSDServer
//
//  Created by Jonathan James Cosgrove on 09/04/2017.
//  Copyright © 2017 Jonathan James Cosgrove. All rights reserved.
//

import Cocoa

class BrightOSDBrightnessImageView: NSImageView {

    override func draw(_ baseRectangle: NSRect) {

        // set the draw color
        if(Config.currentOSDMode == Config.OSDModes.light) {
            NSColor.init(white: 0.2, alpha: 1.0).set()
        } else {
            NSColor.init(white: 0.98, alpha: 1.0).set()
        }

        // circle helpers
        let radius = CGFloat(27.5)
        let origin = NSPoint(x: 100, y: 115)

        // circle segment helpers
        let numberOfSegments = 8
        let segmentRadiusOffset = CGFloat(20)
        let segmentLength = CGFloat(10)

        // general styling
        let thickLine = CGFloat(10)
        let thinLine = CGFloat(5)

        // draw the main circle
        let mainCircle = NSBezierPath()

        mainCircle.lineWidth = thickLine

        mainCircle.appendArc(
            withCenter: NSPoint(
                x: origin.x,
                y: origin.y
            ),
            radius: radius,
            startAngle: 0,
            endAngle: -360,
            clockwise: true
        )

        mainCircle.stroke()

        // draw the segments, around the outside of the circle
        for segmentIndex in 0..<numberOfSegments {
            
            // radius for segment:
            let angleInDegrees = CGFloat(360/numberOfSegments * segmentIndex)
            
            // draw segment as a line, starting at:
            let startPoint = calculateSegmentPoint(
                radius: radius + segmentRadiusOffset,
                angleInDegrees: angleInDegrees,
                origin: origin
            )
            
            // and ending at:
            let endPoint = calculateSegmentPoint(
                radius: radius + segmentRadiusOffset + segmentLength,
                angleInDegrees: angleInDegrees,
                origin: origin
            )
            
            // draw the line for this segment
            let segment = NSBezierPath()
            segment.lineWidth = thickLine
            segment.move(to: startPoint)
            segment.line(to: endPoint)
            segment.stroke()
            
            // now 'hack' rounded edges on each segment, start:
            let startCircle = NSBezierPath(
                roundedRect: NSRect(
                    x: startPoint.x - (thinLine/2),
                    y: startPoint.y - (thinLine/2),
                    width: thinLine,
                    height: thinLine
                ),
                xRadius: thinLine/2,
                yRadius: thinLine/2
            )
            
            // and end:
            let endCircle = NSBezierPath(
                roundedRect: NSRect(
                    x: endPoint.x - (thinLine/2),
                    y: endPoint.y - (thinLine/2),
                    width: thinLine,
                    height: thinLine
                ),
                xRadius: thinLine/2,
                yRadius: thinLine/2
            )
            
            // draw the circles/ends for this segment
            startCircle.lineWidth = thinLine
            startCircle.stroke();
            
            endCircle.lineWidth = thinLine
            endCircle.stroke();
        }
    }
    
    func calculateSegmentPoint(radius: CGFloat, angleInDegrees: CGFloat, origin: NSPoint) -> NSPoint {
        let x = CGFloat(radius * cos(angleInDegrees * 3.14159 / CGFloat(180))) + origin.x;
        let y = CGFloat(radius * sin(angleInDegrees * 3.14159 / CGFloat(180))) + origin.y;
        return NSPoint(x: x, y: y);
    }
}
