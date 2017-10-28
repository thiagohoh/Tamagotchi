$LOAD_PATH << '.'
require 'rubygems'
require 'gosu'
require 'Player.rb'
require 'Star'
require 'tamagotchi'
require 'timer'
include Gosu
class Main < Gosu::Window # window

    def initialize #initializer

      super 640 , 480 #:fullscreen => true dimensions
      self.caption = ' Tamagotchi' #window caption

      @song = Gosu::Song.new('media/ahosong.mp3')
      @song_mini_game = Gosu::Song.new('media/Xgon.mp3')

      @background_image = Gosu::Image.new('media/wallhaven-448448.jpg', :tileable => true) #backgrtoubnd
      @bg_image_mini = Gosu::Image.new('media/mini_gamebg.jpg', :tileable => true) #backgrtoubnd
      @bg_image_mini_end = Gosu::Image.new('media/joinha.gif', :tileable => true) #backgrtoubnd


      @state_feed_image = Gosu::Image.new ('media/feed.gif')
      @state_walk_image = Gosu::Image.new ('media/walk450x450.bmp')
      @state_dirty_image = Gosu::Image.new ('media/dirty500x400.bmp')
      @state_clean_image = Gosu::Image.new ('media/clean500.bmp')
      @state_heal_image = Gosu::Image.new ('media/doc.png')
      @state_dead_image = Gosu::Image.new ('media/dead.jpg')
      @state_instru_image = Gosu::Image.new ('media/dead.jpg')

      @tamagotchi = Tamagotchi.new
      @tamagotchi.warp(406,406)

      @player = Player.new # instanciate a player
      @player.warp(320, 240)# location

      @star_anim = Gosu::Image.load_tiles('media/star.png', 25, 25) #stars animations
      @stars = Array.new# array of stars

      @font = Gosu::Font.new(20) # cria fonte seta 20
      @happy_font = Gosu::Font.new(20) # cria fonte seta 20
      @hunger_font = Gosu::Font.new(20) # cria fonte seta 20
      @health_font = Gosu::Font.new(20) # cria fonte seta 20
      @dirty_font = Gosu::Font.new(20) # cria fonte seta 20
      @mini_htp = Gosu::Font.new(20) # cria fonte seta 20
      @mini_htp2 = Gosu::Font.new(20) # cria fonte seta 20
      @mini_htp3 = Gosu::Font.new(20) # cria fonte seta 20
      @mini_htp4 = Gosu::Font.new(20) # cria fonte seta 20
      @mini_htp5 = Gosu::Font.new(20) # cria fonte seta 20
      @dead_msg = Gosu::Font.new(20) # cria fonte seta 20
      @dead_msg2 = Gosu::Font.new(20) # cria fonte seta 20
      @staterino = Gosu::Font.new(20) # cria fonte seta 20

      @c1 = Gosu::Font.new(20) # cria fonte seta 20
      @c2 = Gosu::Font.new(20) # cria fonte seta 20
      @c3 = Gosu::Font.new(20) # cria fonte seta 20
      @c4 = Gosu::Font.new(20) # cria fonte seta 20
      @c5 = Gosu::Font.new(20) # cria fonte seta 20
      @c6 = Gosu::Font.new(20) # cria fonte seta 20
      @c7 = Gosu::Font.new(20) # cria fonte seta 20
      @c8 = Gosu::Font.new(20) # cria fonte seta 20
      @c9 = Gosu::Font.new(20) # cria fonte seta 20
      @c10 = Gosu::Font.new(20) # cria fonte seta 20

      @song.play(true) # song to play and loop
      @state = :menu


    end



    def update

      if @state == :mini_game

        @song_mini_game.play(true)

        if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT #if key pressed do
          @player.turn_left
        end
        if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT#if key pressed do
          @player.turn_right
        end
        if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0#if key pressed do
          @player.accelerate
        end

        @player.move
        @player.collect_stars(@stars) #colletc stars

        if rand(100) < 4 and @stars.size < 25 #where stars going to show
          @stars.push(Star.new(@star_anim))
        end

        if @player.score == 100
          @state = :mini_end
        end

      end

      if @state == :menu

          @song.play(true)

        if Gosu.button_down? Gosu::KB_F

          @tamagotchi.feed
          @state = :feed

        end

        if Gosu.button_down? Gosu::KB_W

           @tamagotchi.walk
           @state = :to_walk

        end

        if Gosu.button_down? Gosu::KB_S

          @tamagotchi.bath
          @state = :clean

        end

        if Gosu.button_down? Gosu::KB_M
             @tamagotchi.mini_game
            @state = :mini_game_instructions

        end

        if Gosu.button_down? Gosu::KB_H

          @tamagotchi.heal
          @state = :heal

        end

        if Gosu.button_down? Gosu::KB_J
            @tamagotchi.save
        end

        if Gosu.button_down? Gosu::KB_L
             @tamagotchi.load

        end

        if Gosu.button_down? Gosu::KB_I
          @state = :instru
        end


      end


      if @tamagotchi.states == :Dead
          @state = :dead
        if Gosu.button_down? Gosu::KB_R

          @tamagotchi.reset
          @state = :menu

        end


      end

    end

  def draw
    if @state == :menu

      @background_image.draw(-40, -40, ZOrder::BACKGROUND) #background draw
      @tamagotchi.draw
      @tamagotchi.happy_decay

      if @tamagotchi.dirty_show > 60
        @state_dirty_image.draw(70,40,10)
        @health_font.draw('DIRTY BOY', 410, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      end

      @happy_font.draw("Happy: #{@tamagotchi.happy_decay}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      @hunger_font.draw("Hunger: #{@tamagotchi.hunger_decay}", 110, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      @health_font.draw("Health: #{@tamagotchi.health_decay}", 210, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      @staterino.draw("State: #{@tamagotchi.states}", 520, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
    end


    if @state == :mini_game

      @player.draw # draw player
      @stars.each { |star| star.draw } # drwa stars
      @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW) #draw font

    end


    if @state == :feed

      @background_image.draw(-40, -40, ZOrder::BACKGROUND) #background draw
      @state_feed_image.draw(40,40,10)

      @happy_font.draw("Happy: #{@tamagotchi.happy_decay}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      @hunger_font.draw("Hunger: #{@tamagotchi.hunger_decay}", 110, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      @health_font.draw("Health: #{@tamagotchi.health_decay}", 210, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)

      if Gosu.button_down? Gosu::KB_B
        @state = :menu

      end
    end


    if @state == :to_walk
      @background_image.draw(-40, -40, ZOrder::BACKGROUND) #background draw
      @state_walk_image.draw(50,30,10)

      @happy_font.draw("Happy: #{@tamagotchi.happy_decay}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      @hunger_font.draw("Hunger: #{@tamagotchi.hunger_decay}", 110, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      @health_font.draw("Health: #{@tamagotchi.health_decay}", 210, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)

      if Gosu.button_down? Gosu::KB_B
        @state = :menu

      end

    end

    if @state == :clean

      @background_image.draw(-40, -40, ZOrder::BACKGROUND) #background draw
      @state_clean_image.draw(70,40,10)

      @health_font.draw('CLEAN BOY - Press B', 410, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      @happy_font.draw("Happy: #{@tamagotchi.happy_decay}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      @hunger_font.draw("Hunger: #{@tamagotchi.hunger_decay}", 110, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
      @health_font.draw("Health: #{@tamagotchi.health_decay}", 210, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)

      if Gosu.button_down? Gosu::KB_B
        @state = :menu

      end

    end


    if @state == :mini_game_instructions

      @bg_image_mini.draw(-70, -70, ZOrder::BACKGROUND) #background draw

      @mini_htp.draw('* Use the arrow keys to move and collect the stars', 20, 60, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      @mini_htp2.draw('* Score 100 points to win', 20, 90, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      @mini_htp3.draw('* Press `S` to start', 20, 120, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)

      if Gosu.button_down? Gosu::KB_S
        @state = :mini_game


      end

    end


    if @state == :mini_end

      @bg_image_mini_end.draw(40, 40, ZOrder::BACKGROUND) #background draw
      @mini_htp4.draw('* Press `B` to go back', 20, 400, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @mini_htp5.draw('YOU WON !', 250, 350, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)

      if Gosu.button_down? Gosu::KB_B

        @state = :menu
      end

    end

    if @state == :heal
      @state_heal_image.draw(150,5,10)
      @mini_htp4.draw('* Press `B` to go back', 20, 420, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      if Gosu.button_down? Gosu::KB_B

        @state = :menu
      end
    end


    if @state == :dead

      @state_dead_image.draw(120,5,10)
      @dead_msg.draw('* Press `R` to restart', 20, 420, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @dead_msg2.draw('* The Dog died you monster!!', 20, 400, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    end

    if @state == :instru


      @c1.draw('*Esc - quit game', 20, 20, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @c2.draw('*f - feed', 20, 40, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @c3.draw('*b - back from almost all instances', 20, 60, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @c4.draw('*j - saves 1 save per user', 20, 80, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @c5.draw('*l - load', 20, 100, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @c6.draw('*m - mini game', 20, 120, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @c7.draw('*s - shower/ start mini game', 20, 140, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @c8.draw('*r - restart the game when dead', 20, 160, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @c9.draw('*H - heal', 20, 180, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
      @c10.draw('*w - walk', 20, 200, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)

      if Gosu.button_down? Gosu::KB_B

        @state = :menu
      end

    end

  end

  def button_down(id)

      if id == Gosu::KB_ESCAPE # if escape close game
        close
      else
        super
      end

  end

   def needs_cursor?
      true
   end

end

window = Main.new
window.show
