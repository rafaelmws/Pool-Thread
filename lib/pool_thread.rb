require 'java'

class PoolThread

	def initialize (commands, simultaneously=1)

	  @pool = []
	  @waiting = commands
	  simultaneously.times { new_thread }
	end
    
  def new_thread

    @pool << Thread.new do |t|
      Thread.stop
      system Thread.current[:call].to_s
    end
  end
    
  def run_pool
  
    @pool.each do |thread| 
      waiting = @waiting.length > 0
      
      if (thread.status == "sleep" and waiting)
        thread[:call] = @waiting[-1]
        @waiting.delete_at(@waiting.length - 1)
        thread.run
                  
      elsif ((thread.status == nil or thread.status == false) and waiting)
        thread.kill
        @pool.delete(thread)
        new_thread
      end
    end
    
    Thread.new { sleep 0.1; run_pool }.join if (@waiting.length > 0)      
  end

end
