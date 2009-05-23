#require 'java'

class PoolThread

    def initialize 
        @pool = []
        @finished = []
        @waiting = []
        (1..6).each { @waiting << "firefox" }
    end
    
    def create(num=1)
        (1..num).each { new_thread }
    end

    def new_thread
        @pool << Thread.new do
            Thread.stop
            key = fast_token
            cmd = Thread.current[:call].to_s
            puts "#{cmd} - [#{key}]"

            thread = Thread.current

            out = system cmd

            run_pool thread
        end    
    end
    
    def start_process
        @pool.each do |thread| 
            if (thread.status == "sleep" and @waiting.length > 0)
                obj = @waiting[-1]
                @waiting.delete(obj)
                thread[:call] = obj
                thread.run
                thread.join
            end
        end
                
        @finished.each { |thread| Thread.kill thread }
        @finished.clear()
    end
    
    def run_pool( thread )
        @pool.delete(thread)
        @finished.push thread
        new_thread if @waiting.length > 0
        start_process  if @waiting.length > 0
    end
    
    def is_any_running?
        any_running = false
        @pool.each { |thread| any_running = true if thread.status == "run" }
    end

    def pool
        @pool
    end
    
    def finished
    	@finished
    end

    def fast_token
      values = [
        rand(0x0010000),
        rand(0x0010000),
        rand(0x0010000),
        rand(0x0010000),
        rand(0x0010000),
        rand(0x1000000),
        rand(0x1000000),
      ]
      "%04x%04x%04x%04x%04x%06x%06x" % values
    end

end

pool = PoolThread.new
pool.create 3
pool.start_process

