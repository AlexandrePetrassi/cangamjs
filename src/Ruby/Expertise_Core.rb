#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#         ______                                    __     _               
#        / ____/  _  __   ____     ___     _____   / /_   (_)  _____   ___ 
#       / __/    | |/_/  / __ \   / _ \   / ___/  / __/  / /  / ___/  / _ \
#      / /___   _>  <   / /_/ /  /  __/  / /     / /_   / /  (__  )  /  __/
#     /_____/  /_/|_|  / .___/   \___/  /_/      \__/  /_/  /____/   \___/ 
#                     /_/                                                  
#              _____                     __                     
#             / ___/   __  __   _____   / /_   ___     ____ ___ 
#             \__ \   / / / /  / ___/  / __/  / _ \   / __ `__ \
#            ___/ /  / /_/ /  (__  )  / /_   /  __/  / / / / / /
#           /____/   \__, /  /____/   \__/   \___/  /_/ /_/ /_/ 
#                   /____/                          
#                                                        by CaRa_CrAzY Petrassi
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# ▼ Script Information
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# Script   : Expertise Core
# Author   : CaRa_CrAzY Petrassi
# Level    : 
# Requires : n/a
# Version  : 0.00
# Date     : 1900.01.01
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

($imported ||= {})[:CaRaCrAzY_Expertise_Core] = 1.00

#===============================================================================
# ** CaRaCrAzY
#-------------------------------------------------------------------------------
#   Module used for Namespacing the Expertise System
#   Everything about this system is contained inside this module.
#===============================================================================

module CaRaCrAzY
  
  #-----------------------------------------------------------------------------
  # * Awards Expertise points to actors on Level Up.
  #-----------------------------------------------------------------------------
  #   Feel free to disable this feature if you do not want Actors to gain 
  #   expertise points on Level Up.
  #
  #   You may opt to disable this feature if it conflicts with other script
  #   that also alters the Level Up in some way.
  #
  #   Beware that if you disable this feature, you will need to award 
  #   expertise points manually from somewhere else in your game.
  #-----------------------------------------------------------------------------
  FEATURE_EXPERTISE_POINTS_ON_LEVEL_UP = true
  
  #-----------------------------------------------------------------------------
  # * General Expertise Growth Formula for all Actors.
  #-----------------------------------------------------------------------------
  #   This constant is the general formula used for Actors lacking a custom 
  #   Expertise Growth Formula.
  #
  #   Read the Instructions on Notetags section if you want a custom formula
  #   applied for a particular Actor.
  #
  #   Be sure to write your formula between "quotes"!
  #   
  #   parameters:
  #     a : the Actor receiving the Expertise Points from the formula's result.
  #-----------------------------------------------------------------------------
  DEFAULT_GROWTH_FORMULA = "a.mat / 10"
  
  #=============================================================================
  # REST OF THE SCRIPT
  #-----------------------------------------------------------------------------
  # The script itself starts here.
  # You are welcome to read it, but do not modify the below code unless you 
  # know exactly what you are doing.
  # No support will be provided to solve problems caused by edited code.
  #=============================================================================

  #=============================================================================
  # ** Game_Actor
  #=============================================================================
  
  class ::Game_Actor
    #---------------------------------------------------------------------------
    #   Awards expertise on actor level up
    #---------------------------------------------------------------------------
    alias level_up_caracrazy_zmfa4 level_up
    def level_up(*args)
      award_expertise
      level_up_caracrazy_zmfa4(*args)
    end
  end if FEATURE_EXPERTISE_POINTS_ON_LEVEL_UP

  #=============================================================================
  # ** Game_Actor
  #-----------------------------------------------------------------------------
  #  Class containing additional data to be inserted into Game_Actor
  #=============================================================================
  
  class ::Game_Actor
    class << self
      #-------------------------------------------------------------------------
      # * Default Expertise growth formula defined at the start of the script.
      #   This formula is used for actors lacking a <expertise_growth> Notetag.
      #-------------------------------------------------------------------------
      def default_growth
        @default_growth = eval("lambda {|a| #{DEFAULT_GROWTH_FORMULA} }")
      end
      #-------------------------------------------------------------------------
      # * Array for caching all custom growth formulas
      #-------------------------------------------------------------------------
      def growths
        @growths ||= []
      end
    end
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_reader   :expertises       # Allocations Hash { skill_id, expertise }
    attr_reader   :expertise_points # Unallocated Expertise Points
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    alias initialize_caracrazy_o21a7j initialize
    def initialize(*args)
      initialize_caracrazy_o21a7j(*args)
      @expertises       = {}
      @expertise_points = 0
    end
    #---------------------------------------------------------------------------
    # * Get the total expertise value of a skill
    #---------------------------------------------------------------------------
    def xprts(skill_id)
      expertise(skill_id).allocations
    end
    #---------------------------------------------------------------------------
    # * Set expertise_points
    #---------------------------------------------------------------------------
    def expertise_points=(value)
      @expertise_points = [0, value].max
    end
    #---------------------------------------------------------------------------
    # * False unless expertise_points are not zero else return expertise pts
    #---------------------------------------------------------------------------
    def expertise_points?
      expertise_points > 0 ? expertise_points : false
    end
    #---------------------------------------------------------------------------
    # * Get expertise data for a given Expertise
    #---------------------------------------------------------------------------
    def expertise(skill)
      skill = $data_skills[skill] if skill.is_a? Numeric
      expertises[skill.id] ||= Expertise.new(self, skill)
    end
    #---------------------------------------------------------------------------
    # * Allocated points in a given Expertise
    #---------------------------------------------------------------------------
    def base_expertise(skill)
      expertise(skill).allocations
    end
    #---------------------------------------------------------------------------
    # * Awards the actor expertise_points based on its growth formula
    #---------------------------------------------------------------------------  
    def award_expertise
      self.expertise_points += expertise_growth.(self).floor
    end
    #---------------------------------------------------------------------------
    # * Formula for calculating how many points the actor gains on Level Up
    #---------------------------------------------------------------------------
    def expertise_growth
      Game_Actor.growths[actor.id] ||= retrieve_growth_data
    end
    #---------------------------------------------------------------------------
    # * Removes expertise points from the actor to increase skill expertise
    #---------------------------------------------------------------------------
    def allocate_expertise(skill, points = 1)
      expertise(skill).allocate(points)
      self.expertise_points -= points
    end
    #---------------------------------------------------------------------------
    # * Respec all allocated expertise from an expertise skill
    #---------------------------------------------------------------------------
    def respec_expertise(skill)
      value = expertise(skill).allocations
      expertise(skill).allocate(-value)
      self.expert_points += value
    end
    #---------------------------------------------------------------------------
    # * Growth formula from a retrieved <expertise_growth> notetag.
    #   If the notetag is not found, returns the default formula instead
    #---------------------------------------------------------------------------
    def retrieve_growth_data
      if match = growth_tag
        eval("lambda {|a| #{match[:lu]} }") 
      else
        Game_Actor.default_growth
      end
    end
    #---------------------------------------------------------------------------
    # * Match_data from one match of:
    #     <expertise-growth> formula </expertise-growth>
    #---------------------------------------------------------------------------
    def growth_tag
      Notetag.scan_tags(actor.note, "expertise-growth".to_sym).first
    end
    #---------------------------------------------------------------------------
    # * Makes a "dice" roll based on a difficulty rate for the actor's skill.
    #   Returns true if the value rolled is LESS THAN the skill's expertise,
    #   otherwise returns false.
    #
    #   If the roll matches exactly the skill's expertise, it still counts as 
    #   failure, which means skills with zero expertise will NEVER succeed
    #   the check.
    #---------------------------------------------------------------------------
    #     skill_id   : Skill's ID in the Data Base
    #     difficulty : Random Number's highest possible value
    #
    #     returns: true or false, meaning success or failure respectivelly.
    #---------------------------------------------------------------------------
    def xprts_check?(skill_id, difficulty)
      expertise = xprts(skill_id)
      roll      = Random.rand(difficulty)
      result    = roll < expertise
      log "Rolling expertise: #{roll} < #{expertise} = #{result}"
      result
    end
    #---------------------------------------------------------------------------
    # * Makes a "dice" roll based on a difficulty rate for the actor's skill.
    #   Returns true if the value rolled is LESS THAN OR EQUALS TO the skill's
    #   expertise, otherwise returns false.
    #
    #   If the roll matches exactly the skill's expertise, it counts as a 
    #   success, which means skills with zero expertise still has a chance of
    #   succeeding the check.
    #---------------------------------------------------------------------------
    #     skill_id   : Skill's ID in the Data Base
    #     difficulty : Random Number's highest possible value
    #
    #     returns: true or false, meaning success or failure respectivelly.
    #---------------------------------------------------------------------------
    def xprts_soft?(skill_id, difficulty)
      expertise = xprts(skill_id)
      roll      = Random.rand(difficulty)
      result    = roll <= expertise
      log "Rolling expertise: #{roll} <= #{expertise} = #{result}"
      result
    end
    #---------------------------------------------------------------------------
    # * Makes a "dice" roll based on a difficulty rate. Returns the difference 
    #   between the number rolled and the expertise.
    #
    #   Positive numbers mean successes and negative numbers mean failures.
    #
    #   Bear in mind that is up to you, as a developer, to treat zero as a 
    #   failure or a success.
    #   Skills with zero expertise won't have a chance of succeding if zero is
    #   accounted as a failure.
    #---------------------------------------------------------------------------
    #     skill_id   : Skill's ID in the Data Base
    #     difficulty : Random Number's highest possible value
    #
    #     returns : The success/failure margin expressed by an Integer.
    #---------------------------------------------------------------------------
    def xprts_rate(skill_id, difficulty)
      expertise = xprts(skill_id)
      roll      = Random.rand(difficulty)
      result    = xprts(skill_id) - roll
      log "Rolling rated expertise: #{expertise} - #{roll} = #{result}"
      result
    end
  end
  
  #=============================================================================
  # ** Expertise
  #-----------------------------------------------------------------------------
  #  Class containing expertise data (Allocations, Synergies, Bonuses etc)
  #=============================================================================
  
  class Expertise
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_reader :actor       # Actor owning the skill
    attr_reader :skill       # skill owning this expertise
    attr_reader :allocations # Total allocated points.
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(actor, skill)
      @actor       = actor
      @skill       = skill
      @allocations = 0
    end
    #---------------------------------------------------------------------------
    # * Total allocated points
    #---------------------------------------------------------------------------
    def allocate(value = 1)
      @allocations += value
    end
  end
end

#-------------------------------------------------------------------------------
# End of script.
#-------------------------------------------------------------------------------