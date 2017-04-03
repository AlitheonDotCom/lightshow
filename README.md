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

## Default Camera Configs

```
{
  "iso": 100,
  "aperture": 5.6,
  "imageformat": 40,
  "shutterspeed": 0
}
```

You can get all of the camera settings using `gphoto2 --list-config` and `gphoto2 --get-config FOO`. See the gPhoto2 man page for more info.

## Default DMX Sequence Configs

```
{
  "p0": "255,128,255,128,255,128,255,128",
  "p1": "255,128,0,0,0,0,0,0",
  "p2": "0,0,255,128,0,0,0,0",
  "p3": "0,0,0,0,255,128,0,0",
  "p4": "0,0,0,0,0,0,255,128"
}
```

## Examples

Run the script with a custom DMX sequence:

```
./capture_sequence.rb --dmx "{\"foo\":\"255,255,255,255\"}"
```
