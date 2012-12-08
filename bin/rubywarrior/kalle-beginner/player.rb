class Player
  def initialize
    @maxhealth = 20
    @previoushealth = @maxhealth
    @direction = :forward  
    @retracting = false
    @hurt = 10 
    @first = true
  end

  def play_turn(warrior) 
    if @first
      @first = false
      if warrior.look(:backward)[0].to_s == "Captive" || (warrior.look(:backward)[1].to_s == "Captive" && warrior.look(:backward)[0].to_s == "nothing"  )
        warrior.pivot!
        return
      end
    end
    @warrior = warrior
    pre_actions
    action
    post_actions    
  end

  def action 
    if shooting
      return
    elsif rescueing
      return
    elsif attacking 
      return
    elsif walking
      return
    else
      @warrior.rest!
    end
  end
    
  def shooting 
    if should_shoot
      @warrior.shoot!
      return true 
    end
    return false
  end
  
  def rescueing
    if @warrior.feel.captive?
      @warrior.rescue!
      return true
    end
    return false
  end

  def attacking
    if !@warrior.feel.empty? && !@warrior.feel.wall?
      @warrior.attack!
      return true
    end
    return false
  end     
  
  def walking  
    if no_hinders
      @warrior.walk!
      return true
    end
    if @warrior.health >= @maxhealth - 4
      if @warrior.feel.wall?
        @warrior.pivot! 
        return true
      end
      if @retracting
        @retracting = false
        change_direction
      end
      @warrior.walk!
      return true
    end
    if @got_hurt 
      if !can_flee || !is_hurt
        @warrior.walk!
        return true
      end
      if can_flee 
        if !@retracting
          change_direction
        end
        @retracting = true 
        @warrior.walk!(@direction)
        return true
      end
    end
    return false           
  end  
   
  def should_shoot
    @warrior.look[0].to_s == "Wizard" ||( @warrior.look[1].to_s == "Wizard" && @warrior.look[0].to_s == "nothing" ) || ( @warrior.look[2].to_s == "Wizard" && @warrior.look[0].to_s == "nothing" && @warrior.look[1].to_s == "nothing" ) || !can_flee && is_hurt && (( @warrior.look[1].to_s == "Archer" && @warrior.look[0].to_s == "nothing" ) || ( @warrior.look[2].to_s == "Archer" && @warrior.look[0].to_s == "nothing" && @warrior.look[1].to_s == "nothing" )) 
  end
  
  def is_hurt 
    @warrior.health <= @hurt
  end
    
  def can_run_for_it
         @warrior.look[0].to_s == "stairs" ||( @warrior.look[1].to_s == "stairs" && @warrior.look[0].to_s == "nothing" ) || ( @warrior.look[2].to_s == "stairs" && @warrior.look[0].to_s == "nothing" && @warrior.look[1].to_s == "nothing" )
  end
  
  def change_direction
    if @direction == :backward
      @direction = :forward
    elsif @direction == :forward
      @direction = :backward
    end
  end

  def no_hinders
      (@warrior.look[0].to_s == "nothing" && @warrior.look[1].to_s == "wall") || (@warrior.look[0].to_s == "nothing" && @warrior.look[1].to_s == "nothing" && @warrior.look[2].to_s == "wall") ||
      (@warrior.look[0].to_s == "nothing" && @warrior.look[1].to_s == "Captive")
  end

  def pre_actions 
    @got_hurt = @previoushealth > @warrior.health 
    @can_flee = can_flee
  end

  def post_actions
    @previoushealth = @warrior.health
  end
   
  def can_flee
    (@warrior.look[0].to_s == "nothing" && @warrior.look[1].to_s == "Archer" && @warrior.look(:backward)[0].to_s == "nothing" && @warrior.look(:backward)[1].to_s == "nothing") || (@warrior.look[0].to_s == "nothing" && @warrior.look[1].to_s == "nothing" && @warrior.look[2].to_s == "Archer" && @warrior.look(:backward)[0].to_s == "nothing") 
  end

end