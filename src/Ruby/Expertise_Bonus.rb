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

($imported ||= {})[:CaRaCrAzY_Expertise_Bonus] = 1.00

#===============================================================================
# ** CaRaCrAzY
#-------------------------------------------------------------------------------
#   Module used for Namespacing the Expertise System
#   Everything about this system is contained inside this module.
#===============================================================================

module CaRaCrAzY
  
  #=============================================================================
  # Symbols used to compose the different bonus notetags.
  #=============================================================================
  
  NTAG_FLAT     = :flat    # Flat Notetag symbol
  NTAG_ADD      = :add     # Add Notetag symbol
  NTAG_MULT     = :mult    # Mult Notetag symbol
  NTAG_IFLAT    = :iflat   # IFlat Notetag symbol
  NTAG_IADD     = :iadd    # IAdd Notetag symbol
  NTAG_IMULT    = :imult   # IMult Notetag symbol
  NTAG_SYNERGY  = :synergy # Synergy Notetag symbol

  #=============================================================================
  # REST OF THE SCRIPT
  #-----------------------------------------------------------------------------
  # The script itself starts here.
  # You are welcome to read it, but do not modify the below code unless you 
  # know exactly what you are doing.
  # No support will be provided to solve problems caused by edited code.
  #=============================================================================
  
  #=============================================================================
  # ** Bonus_Mode
  #-----------------------------------------------------------------------------
  #   This class defines a Bonus_Mode Object. Bonus_Mode holds information
  #   about how bonuses behave and how they are displayed.
  #=============================================================================
  
  class Bonus_Mode
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_reader :tag           # Bonus_Mode's notetag, i.e. <actor-bonus-[tag]>
    attr_reader :operation     # Operation to join indiviual terms
    attr_reader :reduction     # Operation to join all bonuses of this mode
    attr_reader :neutral_value # Initial value when joining terms
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(const_name, operation, reduction, neutral_value)
      @tag           = CaRaCrAzY.const_get("NTAG_#{const_name}", false)
      @operation     = operation
      @reduction     = reduction
      @neutral_value = neutral_value
    end
    #---------------------------------------------------------------------------
    # * List of all bonuses which are of a certain mode and scope regarding 
    #   this particular expertise skill
    #     mode  : the bonus mode object
    #     scope : :party, :actor or nil
    #       if scope is nil, all scopes are evaluated.
    #---------------------------------------------------------------------------
    def bonuses(expertise)
      self.class.scopes(expertise).flat_map do |tag, list|
        list.flat_map { |item| retrieve_bonuses(expertise, item, tag) }
      end
    end
    #---------------------------------------------------------------------------
    # * Retrieves all pertinent bonuses for this expertise that are contained
    #   inside a given item and matches the given scope and mode.
    #---------------------------------------------------------------------------
    def retrieve_bonuses(expertise, item, scope)
      item.bonuses(self, scope).select do |bonus|
        expertise.descriptors.include?(bonus.descriptor)
      end
    end
    #---------------------------------------------------------------------------
    # * Sum or product of all Bonus Type products
    #---------------------------------------------------------------------------
    def total_bonus(expertise)      
      bonuses(expertise)
        .select { |bonus| bonus.enabled?(expertise.actor) }
        .map(&:value)
        .reduce(neutral_value, operation)
    end
    #---------------------------------------------------------------------------
    # * Sum or product of all Bonus Type products
    #---------------------------------------------------------------------------
    def self.total(expertise, base = 0)
      BONUSES.reduce(base) do |base, mode|
        base.method(mode.reduction).(mode.total_bonus(expertise))
      end
    end
    #---------------------------------------------------------------------------
    # * Scopes hash
    #     returns: Array of BaseItems that may grant bonuses to this expertise.
    #---------------------------------------------------------------------------
    def self.scopes(expertise)
      Hash[
        :party => $game_party.all_base_items,
        :actor => expertise.actor.inventory,
      ]
    end
  end
  
  #=============================================================================
  # ** Individual_Bonus_Mode
  #-----------------------------------------------------------------------------
  #   This specialized class defines a Individual_Bonus_Mode Object. It is a 
  #   special bonus type that calculates all its bonuses terms individually for 
  #   each descriptor. That means individual bonuses of different descriptors 
  #   won't affect one another.
  #=============================================================================
  
  class Individual_Bonus_Mode < Bonus_Mode
    #---------------------------------------------------------------------------
    # * Value of a term, which is the sum or product of all individual bonuses
    #   matching specific mode and descriptor
    #---------------------------------------------------------------------------  
    def individual_term(expertise, descriptor)
      bonuses(expertise)
        .select { |bonus| bonus.descriptor == descriptor }
        .select { |bonus| bonus.enabled?(expertise.actor) }
        .map(&:value)
        .reduce(neutral_value, operation)
    end
    #---------------------------------------------------------------------------
    # * Hash of all terms separated by descriptor
    #     returns : Hash { descriptor => term value}
    #---------------------------------------------------------------------------
    def individual_terms(expertise)
      expertise.descriptors
        .map { |desc| [desc, individual_term(expertise, desc)] }.to_h
    end
    #---------------------------------------------------------------------------
    # * Product of indivual bonuses of all modes matching the descriptor
    #   This is basically multiplying the iflat, iadd and imult bonuses of a
    #   single descriptor.
    #---------------------------------------------------------------------------
    def self.descriptor_term(expertise, descriptor)
      IBONUSES
        .map { |mode| mode.individual_terms(expertise) }
        .map { |term| term[descriptor] }.reduce(:*)
    end
    #---------------------------------------------------------------------------
    # * Sum of every descriptor term
    #   Descriptor terms resulting in negative values are discarded.
    #---------------------------------------------------------------------------
    def self.total(expertise, base = 0)
      expertise.descriptors
        .map { |descriptor| descriptor_term(expertise, descriptor) }
        .select(&:positive?).reduce(0,:+)
    end
  end
  
  #=============================================================================
  # ** Synergy_Bonus_Mode
  #-----------------------------------------------------------------------------
  #   This specialized class defines a Synergy_Bonus_Mode Object. It is a 
  #   special bonus that adds up a percentage of another skill's base 
  #   expertise into another skill's total expertise.
  #=============================================================================
  
  class Synergy_Bonus_Mode < Bonus_Mode
    #---------------------------------------------------------------------------
    # * List of all bonuses which are Synergies.
    #---------------------------------------------------------------------------
    def bonuses(expertise)
      expertise.skill.synergies
    end
    #---------------------------------------------------------------------------
    # * Sum of all points gained by synergies
    #---------------------------------------------------------------------------
    def self.total(expertise, base = 0)
      actor = expertise.actor
      SYNERGY.bonuses(expertise)
        .map { |bonus| actor.expertise(bonus.item.id).allocations * bonus.value }
        .reduce(0,:+).floor
    end
  end
  
  #-----------------------------------------------------------------------------
  # Const: Synergy Bonus data
  #-----------------------------------------------------------------------------
  SYNERGY = Synergy_Bonus_Mode.new(:SYNERGY, :*, :+, 0)
  #-----------------------------------------------------------------------------
  # Const: Normal Bonuses Data
  #-----------------------------------------------------------------------------
  BONUSES = [
    Bonus_Mode.new(:FLAT, :+, :+, 0),
    Bonus_Mode.new(:ADD , :+, :*, 1),
    Bonus_Mode.new(:MULT, :*, :*, 1),
  ]
  #-----------------------------------------------------------------------------
  # Const: Individual Bonuses Data
  #-----------------------------------------------------------------------------
  IBONUSES = [
    Individual_Bonus_Mode.new(:IFLAT, :+, :+, 0),
    Individual_Bonus_Mode.new(:IADD , :+, :*, 1),
    Individual_Bonus_Mode.new(:IMULT, :*, :*, 1),
  ]
  #-----------------------------------------------------------------------------
  # Const: Default scope used for bonuses notetags lacking the scope parameter
  #-----------------------------------------------------------------------------
  DEFAULT_SCOPE = :actor

  #=============================================================================
  # ** Game_Actor
  #-----------------------------------------------------------------------------
  #  Class containing additional data to be inserted into Game_Actor
  #=============================================================================
  
  class ::Game_Actor
    #---------------------------------------------------------------------------
    # * Get the total expertise value of a skill
    #---------------------------------------------------------------------------
    def xprts(skill_id)
      expertise(skill_id).total
    end
    #---------------------------------------------------------------------------
    # * Allocated points in a given Expertise
    #---------------------------------------------------------------------------
    def base_expertise(skill_id)
      expertise(skill_id).allocations
    end
    #---------------------------------------------------------------------------
    # * Total expertise of a skill by taking Bonuses into account
    #---------------------------------------------------------------------------
    def total_expertise(skill_id)
       expertise(skill_id).total
    end
  end
  
  #=============================================================================
  # ** Expertise
  #-----------------------------------------------------------------------------
  #  Class containing expertise data (Allocations, Synergies, Bonuses etc)
  #=============================================================================
  
  class Expertise
    #---------------------------------------------------------------------------
    # * Total expertise taking Synergies, bonuses and multipliers into account
    #---------------------------------------------------------------------------
    def total
      synergies = Synergy_Bonus_Mode.total(self, 0)
      iterms    = Individual_Bonus_Mode.total(self, 0)
      Bonus_Mode.total(self, allocations + synergies + iterms).floor
    end
    #---------------------------------------------------------------------------
    # * Inherited Bonus Types.
    #---------------------------------------------------------------------------
    def descriptors
      skill.descriptors
    end
  end
  
  #=============================================================================
  # ** RPG::Skill
  #-----------------------------------------------------------------------------
  #  Class containing additional data to be inserted into RPG::Skill
  #=============================================================================
  
  class RPG::Skill
    #---------------------------------------------------------------------------
    # * List of Synergies
    #---------------------------------------------------------------------------
    def synergies
      @synergies ||= retrieve_synergy_data
    end
    #---------------------------------------------------------------------------
    # * Array of Inherited descriptors
    #---------------------------------------------------------------------------
    def descriptors
      @descriptors ||= retrieve_bonus_from_data
    end
    #---------------------------------------------------------------------------
    # * Synergy Hash from retrieved notetags
    #---------------------------------------------------------------------------
    def retrieve_synergy_data
      synergy_tag.map { |tag| Synergy.new(tag[:st].to_i, tag[:nd]) }
    end
    #---------------------------------------------------------------------------
    # * Array of Inherited descriptors, retrieved notetags
    #---------------------------------------------------------------------------
    def retrieve_bonus_from_data
      bonus_from_tag.map { |tag| tag[:st] }
    end
    #---------------------------------------------------------------------------
    # * Match_data from all matches of <Synergy: skill_id, value>
    #---------------------------------------------------------------------------
    def synergy_tag
      Notetag.scan_tags(note, :synergy)
    end
    #---------------------------------------------------------------------------
    # * Match_data from all matches of <Descriptor: descriptor, [predicate]>
    #---------------------------------------------------------------------------
    def bonus_from_tag
      Notetag.scan_tags(note, "descriptor".to_sym)
    end
  end
  
  #=============================================================================
  # ** Expertise_Bonus
  #-----------------------------------------------------------------------------
  #  Class containing expertise bonus data to be inserted into RPG::BaseItem
  #  Used almost exclusively to extract notetags about expertise bonuses.
  #=============================================================================
  
  class RPG::BaseItem
    #---------------------------------------------------------------------------
    # * Retrieves a list of bonuses which are of a certain mode and scope
    #---------------------------------------------------------------------------
    def bonuses(mode, scope)
      @bonuses ||= {}
      @bonuses[[mode.tag, scope]] ||= retrieve_bonuses_data(mode, scope)
    end
    #---------------------------------------------------------------------------
    # * Bonuses Hash from retrieved notetags
    #---------------------------------------------------------------------------
    def retrieve_bonuses_data(mode, scope = nil)
      bonus_tag(mode, scope).map do |tag|
        Bonus.new(self, tag[:st], tag[:nd], tag[:lu], mode, scope || DEFAULT_SCOPE)
      end + (scope == DEFAULT_SCOPE ? retrieve_bonuses_data(mode) : [])
    end
    #---------------------------------------------------------------------------
    # * Match_data from all matches of <{scope}-bonus-{mode}>
    #---------------------------------------------------------------------------
    def bonus_tag (mode, scope = nil)
      tag = [scope, "bonus", mode.tag].compact * "-"
      Notetag.scan_tags(note, tag.to_sym)
    end
  end
  
  #=============================================================================
  # ** Bonus_Base
  #-----------------------------------------------------------------------------
  #  Represents a single bonus provenient from a RPG::BaseItem
  #=============================================================================
  
  class Bonus_Base
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_reader :item
    attr_reader :value
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(item, value)
      @item  = item
      @value = value.to_f
    end
  end
  
  #=============================================================================
  # ** Synergy
  #-----------------------------------------------------------------------------
  #  Represents a single synergy bonus
  #=============================================================================

  class Synergy < Bonus_Base
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(skill_id, value)
      @descriptor = skill_id.to_s
      super($data_skills[skill_id], value)
    end
    #---------------------------------------------------------------------------
    # * The Bonus_Mode of this bonus is always SYNERGY
    #---------------------------------------------------------------------------
    def mode
      SYNERGY
    end
    #---------------------------------------------------------------------------
    # * The bonus enabled status
    #---------------------------------------------------------------------------
    def enabled?(actor = nil)
      actor ? actor.skill_learn?(item) : false
    end
  end
  
  #=============================================================================
  # ** Bonus
  #-----------------------------------------------------------------------------
  #  Represents a single bonus.
  #=============================================================================

  class Bonus < Bonus_Base
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_reader :descriptor, :name, :mode, :scope
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(item,value,desc = "",enabled = nil,mode = nil,scope = DEFAULT_SCOPE)
      super(item, value)
      @descriptor = desc.to_s
      @enabled    = eval("Proc.new {|a, i| #{(enabled || true).to_s} }")
      @mode       = mode
      @scope      = scope
    end
    #---------------------------------------------------------------------------
    # Text's color
    #---------------------------------------------------------------------------
    def color
      scope == DEFAULT_SCOPE ? super : 21
    end
    #---------------------------------------------------------------------------
    # * The bonus enabled status
    #---------------------------------------------------------------------------
    def enabled?(actor = nil)
      actor && @enabled ? @enabled.(actor, item) : super
    end
  end
end

#-------------------------------------------------------------------------------
# End of script.
#-------------------------------------------------------------------------------
