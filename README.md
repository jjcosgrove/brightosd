# BrightOSD

macOS BezelUI client/server apps for displaying brightness OSD when using external monitors.

## Demo

[![Demo](https://j.gifs.com/DRKpMn.gif)](https://www.youtube.com/watch?v=_4sBzKckLJ8)

## Approach

I created a simple client/server pair which communicates* using: [DistributedNotificationCenter](https://developer.apple.com/reference/foundation/distributednotificationcenter)

*uni-directionally, from client to server only

The code is mostly Swift-based. No images are used, as I instead chose to draw the brightness image manually using: [NSBezierPath](https://developer.apple.com/reference/appkit/nsbezierpath)

The end result is OK, IMHO but there is probably scope to improve the colors/transparencies - although, for me I can now see the OSD more clearly when viewing above a very dark background (unlike stock BezelUI OSDs)

## Install

Build both BrightOSDClient and BrightOSDServer with Xcode and copy binaries to your $PATH:
```
/usr/local/bin
```

## Usage

Start BrightOSDServer:

```
brightosdserver &
```

Send desired brightness and mode (light/dark) to BrightOSDServer using BrightOSDClient:

```
brightosdclient -b 10 -m dark
```

Or

```
brightosdclient -b 5 -m light -s
```

etc...

## Options (BrightOSDClient)
```
-b brightness level (Int: 0-16)
-m mode (String: light or dark)
-s silent/suppressed output
```

## Tips

1. Install ddcctl - from [here](https://github.com/kfix/ddcctl)
2. Install Hammerspoon - from [here](https://github.com/Hammerspoon/hammerspoon)

use something like the following to allow the existing F1/F2 (brightness) keys to execute required commands (note this is for dual AOC monitors):

```
local minBrightOSDBrightness = 0
local maxBrightOSDBrightness = 16
local currentBrightOSDBrightness = maxBrightOSDBrightness

local maxMonitorBrightness = 100
local currentMonitorBrightness = maxMonitorBrightness

local tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)

  local keyCode = event:getKeyCode()

  if (keyCode == 145 or keyCode == 144) then

    -- brightness down
    if (keyCode == 145) then

      if ( currentBrightOSDBrightness - 1 >= 0) then
        currentBrightOSDBrightness = currentBrightOSDBrightness - 1
        currentMonitorBrightness = math.floor(maxMonitorBrightness/maxBrightOSDBrightness*currentBrightOSDBrightness + 0.5)

        hs.execute('/usr/local/bin/ddcctl -d 1 -b ' .. currentMonitorBrightness)
        hs.execute('/usr/local/bin/ddcctl -d 2 -b ' .. currentMonitorBrightness)
      end

    end

     -- brightness up
    if (keyCode == 144) then

      if ( currentBrightOSDBrightness + 1 <= maxBrightOSDBrightness) then
         currentBrightOSDBrightness = currentBrightOSDBrightness + 1
         currentMonitorBrightness = math.floor(maxMonitorBrightness/maxBrightOSDBrightness*currentBrightOSDBrightness + 0.5)

         hs.execute('/usr/local/bin/ddcctl -d 1 -b ' .. currentMonitorBrightness)
         hs.execute('/usr/local/bin/ddcctl -d 2 -b ' .. currentMonitorBrightness)
      end

    end

    hs.execute('/usr/local/bin/brightosdclient -b ' .. currentBrightOSDBrightness)

  end

  return false
end):start()
```

You should then have a fairly decent brightness control for your external monitors on macOS.

## Notes

I cannot help you with ddcctl, or Hammerspoon. Please raise any issues you have with either tool, directly with the author(s).

## Contribute

Bugs or feature requests/contributions can be done via:

[https://github.com/jjcosgrove/brightosd/issues](https://github.com/jjcosgrove/brightosd/issues)

## Authors

* Just me for now.
