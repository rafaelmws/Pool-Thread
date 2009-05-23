require 'java'
require 'pool_thread'

commands = []

(1..6).each { commands << "firefox" }

pool = PoolThread.new commands, simultaneously=3

pool.run_pool
