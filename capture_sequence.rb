#!/usr/bin/env ruby
#
# Executes a sequence of lighting configurations, capturing at each point in the sequence.
#

require 'fileutils'
require 'open3'
require 'json'
require 'time'

DEFAULT_SEQUENCES = {
  'L0' => '255,128,255,128,255,128,255,128',
  'L1' => '255,128,0,0,0,0,0,0',
  'L2' => '0,0,255,128,0,0,0,0',
  'L3' => '0,0,0,0,255,128,0,0',
  'L4' => '0,0,0,0,0,0,255,128',
  'L5' => '255,128,255,128,0,0,0,0',
  'L6' => '0,0,255,128,255,128,0,0',
  'L7' => '0,0,0,0,255,128,255,128',
  'L8' => '255,128,0,0,0,0,255,128',
  'L9' => '255,128,0,0,255,128,0,0',
  'L10' => '0,0,255,128,0,0,255,128'
}

DEFAULT_CAM_SETTINGS = {
  'iso' => 100,
  'aperture' => 5.6,
  'imageformat' => 40
}

# Parse CLI args
ARG_MAP = Hash[*ARGV]
IMAGE_DIR = ARG_MAP['--image-dir'] || './images/'
FILE_PREFIX = ARG_MAP['--prefix'] || Time.now.utc.iso8601
FILE_EXTENSION = ARG_MAP['--extension'] || 'cr2'
CAM_SETTINGS = JSON.parse(ARG_MAP['--cam-settings'] || JSON.generate(DEFAULT_CAM_SETTINGS))
SEQUENCES = JSON.parse(ARG_MAP['--dmx'] || JSON.generate(DEFAULT_SEQUENCES))
DMX_DEVICE_ID = (ARG_MAP['--dmx-dev-id'] || '10').to_i

IMAGE_DIR += File::SEPARATOR unless IMAGE_DIR.end_with?(File::SEPARATOR)

# Test if required tools are available on the path
raise 'ola_streaming_client was not found. Please install OLA tools and ensure they are available on your PATH' unless system('which ola_streaming_client > /dev/null 2>&1')
raise 'gphoto2 was not found. Please install gPhoto2 and ensure it is available on your PATH' unless system('which gphoto2 > /dev/null 2>&1')

cam_args = CAM_SETTINGS.map{ |k,v| "--set-config '#{k}=#{v}'" }.join(' ')

FileUtils.mkdir_p(IMAGE_DIR)

# Patch the port to the DMX universe in olad
cmd = "ola_patch -d #{DMX_DEVICE_ID} -p 0 -u 1"
puts Open3.capture3(cmd)

SEQUENCES.each do |label, sequence|
  begin
    # Configure the lights
    cmd = "ola_streaming_client --dmx '#{sequence}'"
    puts cmd
    stdout, stderr, status = Open3.capture3(cmd)
    #puts stdout
    raise stderr if !stderr.nil? && !stderr.empty?

    # Capture the photo
    filename = "#{FILE_PREFIX}_#{label}.#{FILE_EXTENSION}"
    cmd = "gphoto2 #{cam_args} --filename '#{filename}' --capture-image-and-download"
    puts cmd
    stdout, stderr, status = Open3.capture3(cmd)
    #puts stdout
    raise stderr if !stderr.nil? && !stderr.empty?

    # Move the photo
    FileUtils.mv(filename, IMAGE_DIR + filename)
  rescue Exception => e
    puts "ERROR: Failed to process '#{label}': #{e.message}"
  end
end
