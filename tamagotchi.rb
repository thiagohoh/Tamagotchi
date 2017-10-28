$LOAD_PATH << '.'
require 'rubygems'
require 'gosu'

include Gosu

class Tamagotchi

  def initialize

    @image = Gosu::Image.new('media/dogu.gif')

    #@jif = Gosu::Image.new('media/te.gif')

    @yammy = Gosu::Sample.new('media/yummy.wav')

    @happy = 100
    @health = 100
    @hunger = 0
    @state = :Normal
    @decay = 0
    @decay_hunger = 0
    @decay_health = 0
    @dirty = 0
    @x = @y = 0.0

  end


  def warp(x, y)
    @x, @y = x, y
  end


  def feed

    @yammy.play
    @hunger -= rand(30...50)
    @dirty += rand(1...5)
    if @hunger <= 0
      @hunger = 0
    end


  end

  def walk

    @happy += rand(5...10)
    @hunger +=rand(1...5)
    @health -= rand(1...5)
    @dirty += rand(1...5)

    if @happy > 100
      @happy = 100
    end

  end


  def heal

    @health += 10

    if @health > 100
      @health = 100
    end

    @state = :Normal

  end

  def draw

    @image.draw(70,140,10)
   # @jif.draw(9,8,0)

  end

  def dead
    true
  end

  def states

    if  @health == 0
      @state = :Dead
      return @state
    end

    if @hunger == 100
      @sate = :Dead
      return @state
    end

   if @hunger > 75
     @state = :Hungry
   end

   if @health < 30
     @state = :Sick
   end

   if @happy < 35
     @state = :Sad
   end



    @state

  end



  def happy_decay

    @decay +=1

    if @decay == 150
        @happy -= rand(1...5)
        @decay = 0
    end

    if @happy <35
      @state = :Sad
    end

    if @happy <= 0
      @happy = 0
    end

    @happy

  end

  def hunger_decay

    @decay_hunger +=1

    if @decay_hunger == 150
        @hunger += rand(1...5)
        @decay_hunger = 0

    end

    if @hunger >= 100
      @hunger = 100
      @state = :Dead

    end

    @hunger
  end


  def health_decay
    @decay_health +=1

    if @decay_health == 200
      @health -= rand(1...5)
      @decay_health = 0
    end

    if @health <= 0
      @health = 0
      @state =:Dead
    end

    @health
  end

  def bath

    @dirty = 0
    @health += rand(5...15)

  end

  def mini_game

    @hunger += 20
    @happy += 30

    if @happy > 100
       @happy = 100
    end
    if @hunger > 80
      @hunger = 80
    end

  end

  def dirty_show
    @dirty
  end

  def reset
    @happy = 100
    @health = 100
    @hunger = 0
    @state = :Normal
    @dirty = 0
  end

  def save

    aFile = File.new('save/save_file.txt', 'w')
    aFile.puts @happy
    aFile.puts @hunger
    aFile.puts @health
    aFile.puts @state
    aFile.puts @dirty
  end


  def load
    arrei = IO.readlines('save/save_file.txt')
    @happy = arrei[0].to_i
    @hunger = arrei[1].to_i
    @health = arrei[2].to_i
    @state = arrei[3]
    @dirty = arrei[4].to_i
    @state.delete!("\n")

  end

end