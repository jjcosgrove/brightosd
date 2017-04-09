//
//  BrightOSDServerController.swift
//  BrightOSDServer
//
//  Created by Jonathan James Cosgrove on 09/04/2017.
//  Copyright © 2017 Jonathan James Cosgrove. All rights reserved.
//

import Cocoa
import Foundation

class BrightOSDServerController: NSObject, NSApplicationDelegate {

    var config: Config?
    var brightOSDWindow: NSWindow?
    var brightOSDVisualEffectView: NSVisualEffectView?
    var brightOSDLevelIndicator: BrightOSDLevelIndicator?
    var brightOSDFadeOutTimer: Timer?

    func applicationDidFinishLaunching(_ aNotification: Notification) {

        // create the OSD
        createBrightOSDWindow()
        createBrightOSDVisualEffectView()
        createBrightOSDBrightnessImageView()
        createBrightOSDLevelIndicator()

        // wait for notification from client
        registerBrightOSDListener()
    }

    func createBrightOSDWindow() {

        let width = CGFloat(200)
        let height = CGFloat(200)

        let xPosition = CGFloat(((NSScreen.main()?.frame.size.width)! - CGFloat(width)) / 2)
        let yPosition = CGFloat(140)

        brightOSDWindow = NSWindow(
            contentRect: NSRect(
                x: xPosition,
                y: yPosition,
                width: width,
                height: height
            ) ,
            styleMask: NSWindowStyleMask.borderless,
            backing: NSBackingStoreType.buffered,
            defer: true
        )

        brightOSDWindow?.level = Int(CGWindowLevelForKey(.screenSaverWindow)) + 1
        brightOSDWindow?.styleMask = NSWindowStyleMask.borderless
        brightOSDWindow?.isMovableByWindowBackground = false
        brightOSDWindow?.isExcludedFromWindowsMenu = true
        brightOSDWindow?.hasShadow = false
        brightOSDWindow?.isOpaque = false
        brightOSDWindow?.alphaValue = 0.0

        brightOSDWindow?.makeKeyAndOrderFront(nil)
    }
    
    func createBrightOSDVisualEffectView() {

        let width = CGFloat(200)
        let height = CGFloat(200)

        let xPosition = CGFloat(0)
        let yPosition = CGFloat(0)

        let cornerRadius = CGFloat(20)

        brightOSDVisualEffectView = NSVisualEffectView(
            frame: NSRect(
                x: xPosition,
                y: yPosition,
                width: width,
                height: height
            )
        )

        brightOSDVisualEffectView?.blendingMode = NSVisualEffectBlendingMode.behindWindow
        brightOSDVisualEffectView?.state = NSVisualEffectState.active

        setOSDWindowAndVisualEffectViewMode()

        brightOSDVisualEffectView?.maskImage = createBrightOSDImageMask(
            cornerRadius: cornerRadius
        )

        brightOSDWindow?.contentView = brightOSDVisualEffectView
    }
    
    func setOSDWindowAndVisualEffectViewMode() {

        let alphaValueDark = CGFloat(1.0)
        let backgroundColorDark = NSColor.clear

        let alphaValueLight = CGFloat(0.8)
        let backgroundColorLight = NSColor.init(red: 0.935, green: 0.935, blue: 0.935, alpha: 1.0)

        if(Config.currentOSDMode == Config.OSDModes.light) {

            brightOSDVisualEffectView?.appearance = NSAppearance.init(named: NSAppearanceNameVibrantLight)
            brightOSDVisualEffectView?.material = NSVisualEffectMaterial.light
            brightOSDVisualEffectView?.alphaValue = alphaValueLight
            brightOSDWindow?.backgroundColor = backgroundColorLight
        } else {

            brightOSDVisualEffectView?.appearance = NSAppearance.init(named: NSAppearanceNameVibrantDark)
            brightOSDVisualEffectView?.material = NSVisualEffectMaterial.dark
            brightOSDVisualEffectView?.alphaValue = alphaValueDark
            brightOSDWindow?.backgroundColor = backgroundColorDark
        }
    }

    func createBrightOSDImageMask(cornerRadius: CGFloat) -> NSImage {

        let edgeLength = 2.0 * cornerRadius + 1.0

        let maskImage = NSImage(
            size: NSSize(
                width: edgeLength,
                height: edgeLength
            ),
            flipped: false
        ) { rect in
            let bezierPath = NSBezierPath(
                roundedRect: rect,
                xRadius: cornerRadius,
                yRadius: cornerRadius
            )
            NSColor.black.set()
            bezierPath.fill()
            return true
        }

        maskImage.capInsets = EdgeInsets(
            top: cornerRadius,
            left: cornerRadius,
            bottom: cornerRadius,
            right: cornerRadius
        )

        maskImage.resizingMode = NSImageResizingMode.stretch

        return maskImage
    }

    func createBrightOSDBrightnessImageView() {

        let width = CGFloat(200)
        let height = CGFloat(200)

        let xPosition = CGFloat(0)
        let yPosition = CGFloat(0)

        let brightOSImage = BrightOSDBrightnessImageView(
            frame: CGRect(
                x: xPosition,
                y: yPosition,
                width: width,
                height: height
            )
        )

        brightOSDWindow?.contentView?.addSubview(brightOSImage)
    }

    func createBrightOSDLevelIndicator() {

        let width = 200
        let height = 8

        let xPosition = 20
        let yPosition = 20

        brightOSDLevelIndicator = BrightOSDLevelIndicator(
            frame: CGRect(
                x: xPosition,
                y: yPosition,
                width: width - (2*xPosition),
                height: height
            )
        )

        brightOSDLevelIndicator?.minValue = Config.OSDLevelIndicator.minValue
        brightOSDLevelIndicator?.maxValue = Config.OSDLevelIndicator.maxValue

        brightOSDWindow?.contentView?.addSubview(brightOSDLevelIndicator!)
    }
    
    func registerBrightOSDListener() {
        
        DistributedNotificationCenter.default.addObserver(
            self,
            selector: #selector(brightOSDNotificationHandler),
            name: Notification.Name("BrightOSDNotification"),
            object: nil
        )
    }
    
    func brightOSDNotificationHandler(_ notification: Notification) {

        let brightness = notification.userInfo?["brightness"] as! Int32
        Config.OSDLevelIndicator.currentValue = brightness

        let mode = notification.userInfo?["mode"] as! String

        switch( mode ) {
            case "dark":
                Config.currentOSDMode = Config.OSDModes.dark
                break
            case "light":
                Config.currentOSDMode = Config.OSDModes.light
                break
            default:
                break
        }

        updateAndRenderBrightOSD()
    }
    
    func updateAndRenderBrightOSD() {
        
        brightOSDFadeOutTimer?.invalidate()
        brightOSDFadeOutTimer = nil
        
        // set mode
        setOSDWindowAndVisualEffectViewMode()

        // set brightness
        brightOSDLevelIndicator?.intValue = Config.OSDLevelIndicator.currentValue
        
        // begin
        showAndFadeOutBrightOSDWindow()
    }
    
    func showAndFadeOutBrightOSDWindow() {
        
        let windowShowDuration = 1.0
        let windowFadeOutDuration = 1.5
        
        brightOSDWindow?.alphaValue = 1.0
        
        brightOSDFadeOutTimer = Timer.scheduledTimer(
            timeInterval: windowShowDuration,
            target: self,
            selector: #selector(fadeOutBrightOSDWindowBegin),
            userInfo: windowFadeOutDuration,
            repeats: false
        )
    }
    
    func fadeOutBrightOSDWindowBegin(timer:Timer) {
        
        let fadeOutDuration = timer.userInfo as! Double
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            
            context.duration = fadeOutDuration
            brightOSDWindow?.animator().alphaValue = 0.0
            
        })
    }
}
