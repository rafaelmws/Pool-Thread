require 'java'
require 'rubygems'
require 'pool_thread'

commands = []

(1..6).each { commands << "mono mono_window/window.exe" }

pool = PoolThread.new commands, simultaneously=3

pool.run_pool
