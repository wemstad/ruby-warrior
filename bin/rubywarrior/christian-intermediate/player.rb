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
    if !@positions.empty?
      @warrior.walk!(@warrior.direction_of(@positions[0]))
      return true
    end
    @warrior.walk!(@warrior.direction_of_stairs)  
    return true
  end 
  
  def pre_action
    @positions = @warrior.listen
    puts @positions
  end
  
  def post_action
    
  end
  
end
