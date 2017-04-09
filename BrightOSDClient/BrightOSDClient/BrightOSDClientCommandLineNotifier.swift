//
//  BrightOSDClientCommandLineNotifier.swift
//  BrightOSDClient
//
//  Created by Jonathan James Cosgrove on 09/04/2017.
//  Copyright © 2017 Jonathan James Cosgrove. All rights reserved.
//

import Cocoa

class BrightOSDClientCommandLineNotifier: NSObject {

    override init() {
        super.init()
        translateCommandLineArgumentsToNotification()
    }

    func translateCommandLineArgumentsToNotification() {

        let cli = CommandLine()

        let brightness = IntOption(
            shortFlag: "b",
            longFlag: "brightness",
            required: false,
            helpMessage: "level"
        )

        let mode = StringOption(
            shortFlag: "m",
            longFlag: "mode",
            required: false,
            helpMessage: "light or dark"
        )

        let silent = BoolOption(
            shortFlag: "s",
            longFlag: "silent",
            required: false,
            helpMessage: "silent"
        )

        cli.addOptions(brightness, mode, silent)

        do {
            try cli.parse()
        } catch {
            cli.printUsage(error)
            exit(EX_USAGE)
        }

        var brightnessVal = Config.defaultBrightnessValue

        if ( brightness.wasSet ) {

            brightnessVal = brightness.value!

            let brightnessWithinRange = (Config.OSDLevelIndicator.minValue...Config.OSDLevelIndicator.maxValue).contains(brightnessVal)
            
            if ( brightnessWithinRange ) {

                if (!silent.wasSet || silent.wasSet && !silent.value) {
                    print("Sent: Brightness")
                    print("Value: " + String(brightnessVal))
                }
            } else if (brightnessVal <= Config.OSDLevelIndicator.minValue) {
                
                brightnessVal = Config.OSDLevelIndicator.minValue
            } else if (brightnessVal >= Config.OSDLevelIndicator.maxValue) {
                
                brightnessVal = Config.OSDLevelIndicator.maxValue
            }
        }
        
        var modeVal = Config.defaultModeValue

        if ( mode.wasSet ) {

            modeVal = mode.value!

            let validModeValue = ["dark","light"].contains((modeVal)!)

            if ( validModeValue ) {

                if (!silent.wasSet || silent.wasSet && !silent.value) {
                    print("Sent: Mode")
                    print("Value: " + modeVal!)
                }
            }
        }

        DistributedNotificationCenter.default.post(
            name: Notification.Name("BrightOSDNotification"),
            object: nil,
            userInfo:[
                "brightness": brightnessVal,
                "mode": modeVal!
            ]
        )
    }
}
