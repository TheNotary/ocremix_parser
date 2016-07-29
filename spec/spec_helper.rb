$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pry'
require 'ocremix_parser'
require 'fileutils'

# spoof the home directory so testing doesn't wreck crap on the system
spoofed_home_dir = '/tmp/ocremix_parser_test_home'
FileUtils.rm_rf spoofed_home_dir
FileUtils.mkdir_p spoofed_home_dir

ENV['HOME'] = spoofed_home_dir
