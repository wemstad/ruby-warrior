class Player 
  def initialize
    @maxhealth = 20
    @previoushealth = @maxhealth
    @directions = [:forward, :backward, :left, :right]  
    @retracting = false
    @hurt = 10 
    @first = true  
  end
  
  def play_turn(warrior)
    # add your code here
    @warrior = warrior 
    pre_action
    action    
    post_action
  end 
  
  def action
    if attacking
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
  
  def attacking        
    number_of_attackers = 0
    attacking_dir = :forward
    @directions.each do |direction|
      if !@warrior.feel(direction).empty? && !@warrior.feel(direction).wall? && !@warrior.feel(direction).captive?
          attacking_dir = direction
          number_of_attackers += 1
      end
    end
    if number_of_attackers == 1
      @warrior.attack!(attacking_dir)
      return true
    elsif number_of_attackers >= 2
      @warrior.bind!(attacking_dir)
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
    if @warrior.health != @maxhealth
      @warrior.rest!
      return true
    end
    return false
  end 
  
  def walking  
    @direction = @warrior.direction_of_stairs
    if !@positions.empty?  
      @direction = @warrior.direction_of(@positions[0])
      while @warrior.feel(@direction).stairs? || @warrior.feel(@direction).wall?
        switch_direction
      end
    end      
    @warrior.walk!(@direction)  
    return true
  end 
  
  def switch_direction
    index = @directions.index(@direction)
    @direction = @directions.at(index + 1 % @directions.length)
  end
  
  def pre_action
    @positions = @warrior.listen
    puts @positions
  end
  
  def post_action
    
  end
  
end
