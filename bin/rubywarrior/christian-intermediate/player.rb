class Player 
  def initialize
    @maxhealth = 20
    @previoushealth = @maxhealth
    @directions = [:forward, :left, :backward, :right]  
    @retracting = false
    @hurt = 10
    @first = true  
    @is_ticking = false
  end
  
  def play_turn(warrior)
    # add your code here
    @warrior = warrior 
    pre_action
    action    
    post_action
  end 
  
  def action
    if ticking
      return
    elsif attacking
      return 
    elsif resting
      return 
    elsif rescuing 
      return
    elsif walking
      return
    else
      push "WHUUUTT"
    end
      
  end
  
  def ticking
     if @is_ticking 
       if @warrior.feel(@direction).captive?
         @warrior.rescue!(@direction) 
         return true
       end  
       if !@warrior.feel(@direction).empty? && !@warrior.feel(@direction).wall? && !@warrior.feel(@direction).captive?
         attacking 
         return true
       end    
       puts is_hurt(0)
       puts exists_enemies
       if is_hurt(0) && exists_enemies
          @warrior.rest!
          return true
        end
       while !@warrior.feel(@direction).empty?  
         switch_direction
       end
       if @direction != nil       
         @warrior.walk!(@direction)
         return true
       end         
       puts "Failed"
       return false
     end
     return false
  end   
  
  def attacking        
    number_of_attackers = 0
    attacking_dir = []
    @directions.each do |direction|
      if !@warrior.feel(direction).empty? && !@warrior.feel(direction).wall? && !@warrior.feel(direction).captive?
        attacking_dir.push(direction)
        number_of_attackers += 1
      end
    end
    if number_of_attackers == 1 
      regex = /ludge, [a-zA-Z]*ludge,/ 
      m = regex.match(@warrior.look.to_s)
      unless m 
        @warrior.attack!(attacking_dir[0])  
        return true
      end
      if not_close_to_captive && !is_hurt(5)
         @warrior.detonate!
      else
         @warrior.attack!(attacking_dir[0]) 
      end 
      return true   
    elsif number_of_attackers >= 2 
      i = 0
      while attacking_dir[i] == @direction
        i += 1
      end
      @warrior.bind!(attacking_dir[i])
      return true
    end
    return false
  end
  
  def rescuing
    @directions.each do |direction|
      if @warrior.feel(direction).captive?
          @warrior.rescue!(direction)
          return true
      end
    end  
    return false
  end
    
  def resting
    if @warrior.health != @maxhealth && !@positions.empty? 
      @warrior.rest!
      return true
    end
    return false
  end 
  
  def walking  
    while (@warrior.feel(@direction).stairs? || @warrior.feel(@direction).wall?) && !@positions.empty?
      switch_direction
    end    
    @warrior.walk!(@direction)  
    return true
  end 
  
  def switch_direction
    index = @directions.index(@direction) 
    @direction = @directions.at((index + 1).modulo(@directions.length))
  end
  
  def is_hurt(padding)
    @warrior.health < @hurt - padding
  end 
  
  def not_close_to_captive
    i = 100
    @positions.each do |position|
      if position.captive?
        j = @warrior.distance_of(position)
        if i > j
          i = j
        end
      end
    end
    i > 0
  end
  
  def exists_enemies 
    @positions.each do |position|
      if position.enemy?
        return true
      end
    end
    return false
  end
  
  def pre_action
    @positions = @warrior.listen 
    if @positions.empty?
      @direction = @warrior.direction_of_stairs 
    else
      @direction = @warrior.direction_of(@positions[0])
    end   
    @positions.each do |position|
      if position.ticking?  
        @is_ticking = true
        @position = position 
        @direction = @warrior.direction_of(@position)
        return
      end
    end
    @is_ticking = false
  end
  
  def post_action
    
  end
  
end
