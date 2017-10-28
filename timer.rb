$LOAD_PATH << '.'
require 'rubygems'
require 'gosu'
include Gosu

class Timer



   def timer(x_time)

     @timero = 0

     @timero +=1

     if @timero == x_time

        @timero = 0
     end

     if @timero >= 100
       @timero = x_time
     end

    @timero
   end

end