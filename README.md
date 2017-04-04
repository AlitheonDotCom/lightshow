# lightshow
Lights, Camera, Action!

A collection of scripts for controlling DMX lights and DSLR cameras. It's built using Ruby, OLA, and gPhoto2:
- Ruby: http://rubylang.org/
- OLA: https://www.openlighting.org/
- gPhoto2: http://www.gphoto.org/doc/remote/

# Setup
You need `Ruby` v2.0.0 or newer, `gPhoto2`, and the `OLA` toolchain:

OSX Homebrew
```
brew install ruby
brew install ola
brew install gphoto2
```

# Command Line Arguments

| Argument | Description | Default Value |
| -------- | ----------- | ------------- |
| --image-dir | The directory to output images to. | './images/' |
| --prefix | The filename prefix to use when generating images. | Current UTC timestamp |
| --extension | The filename extension to use when generating images. | 'cr2' |
| --cam-settings | A JSON object that maps camera settings to use for the acquisition. | See below |
| --dmx | A JSON object that maps sequence labels to DMX inputs. | See below |
| --dmx-dev-id | The device ID of your DMX controller. Run `ola_dev_info` to find your device ID. | 10 |

## Default Camera Configs

```
{
  "iso": 100,
  "aperture": 5.6,
  "imageformat": 40
}
```

You can get all of the camera settings using `gphoto2 --list-config` and `gphoto2 --get-config FOO`. See the gPhoto2 man page for more info.

## Default DMX Sequence Configs

```
{
  "L0": "255,128,255,128,255,128,255,128",
  "L1": "255,128,0,0,0,0,0,0",
  "L2": "0,0,255,128,0,0,0,0",
  "L3": "0,0,0,0,255,128,0,0",
  "L4": "0,0,0,0,0,0,255,128",
  "L5": "255,128,255,128,0,0,0,0",
  "L6": "0,0,255,128,255,128,0,0",
  "L7": "0,0,0,0,255,128,255,128",
  "L8": "255,128,0,0,0,0,255,128",
  "L9": "255,128,0,0,255,128,0,0",
  "L10": "0,0,255,128,0,0,255,128"
}
```

## Examples

Run the script with a custom DMX sequence:

```
./capture_sequence.rb --dmx "{\"foo\":\"255,255,255,255\"}"
```

# Troubleshooting

## Can't Connect to Camera

Try killing `PTPCamera`.

```
ps aux | grep PTPCamera
kill FOO
```

## Can't Connect to DMX Controller

Make sure you have the latest `RDM` drivers.

For EntTec:
1. Install PRO-Manager: http://support.enttec.com/aleph/?main_menu=Products&pn=79003
2. Launch PRO-Manager
3. Select your device from the drop-down list
4. Click the "Update Firmware" button at the bottom and select "RDM"
5. Exit the PRO-Manager when the update is complete
6. Restart your computer

Also, make sure that **only one software suite is running at a time**, i.e. kill `olad` before starting `PRO-Manager` and vice-versa.

```
ps aux | grep olad
kill FOO
```

See this doc for more information: https://www.openlighting.org/ola/getting-started/device-specific-configuration/#Sending_DMX
