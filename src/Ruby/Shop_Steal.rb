#===============================================================================
#              ________                                            
#              ___  __ \   ______     _______ _   ____  __   _____ 
#              __  /_/ /   _  __ \    __  __ `/   _  / / /   _  _ \
#              _  _, _/    / /_/ /    _  /_/ /    / /_/ /    /  __/
#              /_/ |_|     \____/     _\__, /     \__,_/     \___/ 
#                                     /____/                       
#       ________                           _____                          
#       __  ___/   _____  __   ________    __  /_   _____     _______ ___ 
#       _____ \    __  / / /   __  ___/    _  __/   _  _ \    __  __ `__ \
#       ____/ /    _  /_/ /    _(__  )     / /_     /  __/    _  / / / / /
#       /____/     _\__, /     /____/      \__/     \___/     /_/ /_/ /_/ 
#                  /____/      
#                                                        by CaRa_CrAzY Petrassi
#===============================================================================
#
# ▼ Triacular - Steal Shop v1.07
# -- Last Updated: 2019.06.12
# -- Level: Easy, Normal
# -- Requires: n/a
#
#==============================================================================
#==============================================================================
# ▼ Introduction
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script allows stealing of items in scene shop, made for RPG Maker VX Ace.
#
# Please give credit to Triacular
# free for non-commercial and commercial uses
#==============================================================================
($imported ||= {})[:Triacular_ShopSteal] = 1.07
#==============================================================================
# ▼ Versions Updates
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# 2019-01-26 - Initial script                         - Triacular
# 2019-01-27 - Reduced duplicate parts                - Triacular
# 2019-02-12 - Added switch to disable script         - Triacular
# 2019-02-13 - Added alias, removed global switches   - Roninator2
# 2019-03-03 - Changed to not show the number window  - Roninator2
# 2019-03-13 - Several Changes. Listed below          - CaRaCrAzY_Petrassi
#   ▼ [Compatibility]
#     Moved all classes inside a namespace module
#     Added version data to $imported global variable
#   ▼ [Convenience]
#     Moved constants to the module root
#     Transformed the DICE constant into VARIABLE_STEAL_BONUS
#   ▼ [Features]
#     Displays the Stealing Success rate insteand of item's price.
#     Added a constant for controling the [steal] command's position in the list
#     Added a switch to enable or disable steal command mid-game
#     Added a constant for inputing a formula for General Stealing Success Rate
#     Entries in the shop that has zero percent chance of stealing are disabled
#     Added notetag support for editing Custom Stealing Success Rate formulas
#     Added a constant for controlling the Maximum Stealing Success Rate
# 2019-06-12 - Command requires a thief in the party  - CaRaCrAzY_Petrassi
#==============================================================================
#==============================================================================
# ▼ Notetags
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This script support the following notetags:
#
#-------------------------------------------------------------------------------
#   <steal: x/>
#-------------------------------------------------------------------------------
#   This will add a custom calculation method for a particular item. This
#   means that the default Success Rate formula will be replaced for this one.
#     x : formula
#
#   Considerations about the Formula:
#   The formula is an actual piece of code that will be evaluated, its final
#   output must be a number between zero and one that will be converted into a
#   percentage; and these are the following values that will be passed to it:
#     a : Game Party   (Same thing as $game_party)
#     b : item         (The item itself)
#     p : item's price (converted to float, used for calculating divisions)
#
#   Examples:
#   <steal: a.agi / p> 
#   <steal: 0.5>
#   <steal: a.agi / (a.agi + p / 10.0)>
#
#-------------------------------------------------------------------------------
#   <thief/>
#-------------------------------------------------------------------------------
#   This will enable the party to use the [Steal] command from shops.
#   This notetag works either for Actors, Classes, Equipments and Statuses.
#
#   Actors:
#     When inserting the <thief/> notetag inside an Actor's note field, the
#     [steal] command from shops will always be available whenever this actor
#     is present and alive in the current party.
#
#   Classes:
#     When inserting the <thief/> notetag inside a Class' note field, the 
#     [steal] command from shops will always be available whenever an actor is 
#     present and alive in the party which class is marked with the <thief/> 
#     notetag.
#
#   Armors or Weapons:
#     When inserting the <thief/> notetag inside an Armor or Weapon's note
#     field, the [steal] command from shops will always be available whenever an
#     actor is present, alive and equipping the item marked with the <thief/>
#     notetag.
#
#   Statuses:
#     When inserting the <thief/> notetag inside a Status note field, the 
#     [steal] command from shops will always be available whenever an actor is
#     present, alive and affected by the status marked with the <thief/>
#     notetag.
#
#==============================================================================

#===============================================================================
# ** TRIACULAR
#-------------------------------------------------------------------------------
#   Module used for namespacing the Shop Steal System
#   Everything about this system is contained inside this module.
#===============================================================================

module TRIACULAR
  #-----------------------------------------------------------------------------
  # * ID of the Switch that enables the script
  #-----------------------------------------------------------------------------
  SWITCH_ENABLE        = 22     
  
  #-----------------------------------------------------------------------------
  # * ID of the Switch that will become ON when stealing fails
  #-----------------------------------------------------------------------------
  SWITCH_STEAL         = 21      

  #-----------------------------------------------------------------------------
  # * ID of the Switch that enable/disable the shop's [Steal] command at runtime
  #-----------------------------------------------------------------------------
  SWITCH_COMMAND       = 23     

  #-----------------------------------------------------------------------------
  # * ID of the Variable responsible for giving a percent bonus to steal chance
  #-----------------------------------------------------------------------------
  VARIABLE_STEAL_BONUS = 20      
  
  #-----------------------------------------------------------------------------
  # * [Steal] command's name in the Shop's command list
  #-----------------------------------------------------------------------------
  VOCAB_STEAL          = "Steal" 
  
  #-----------------------------------------------------------------------------
  # * Steal command's position at Shop's command list
  #   Useful if you want the [Steal] command to appear between [Buy] or [Sell]
  #-----------------------------------------------------------------------------
  COMMAND_POSITION     = 2       
  
  #-----------------------------------------------------------------------------
  # * Dynamically increases the number of columns in Shop's command list to fit
  #   the [Steal] command entry.
  #-----------------------------------------------------------------------------
  DYNAMIC_COL_COUNT    = true    
  
  #-----------------------------------------------------------------------------
  # * General Stealing Success Rate formula usef for all items lacking a Custom
  #   Stealing Formula notetag.
  #-----------------------------------------------------------------------------
  #     a : Game Party (Same thing as $game_party)
  #     b : item
  #     p : item's price (converted to float, used for calculating divisions)
  #-----------------------------------------------------------------------------
  STEAL_FORMULA        = "a.agi / p"
  
  #-----------------------------------------------------------------------------
  # * Maximum Stealing Rate chance
  #-----------------------------------------------------------------------------
  STEAL_RATE_CAP       = 0.9
  
  #==============================================================================
  # ** Window_ShopCommand
  #------------------------------------------------------------------------------
  #  Wraping and redefining methods inside Window_ShopCommand class
  #==============================================================================
  
  class ::Window_ShopCommand
    #--------------------------------------------------------------------------
    # * Create Command List
    #--------------------------------------------------------------------------
    alias r2_make_cl_m2dfff98   make_command_list
    def make_command_list
      r2_make_cl_m2dfff98
      if $game_switches[SWITCH_ENABLE]
        enabled  = Steal.enabled? #$game_switches[SWITCH_COMMAND]
        position = COMMAND_POSITION
        Steal.insert_command(@list, position, VOCAB_STEAL, :steal, enabled)
      end
    end 
    #--------------------------------------------------------------------------
    # * Get Digit Count
    #--------------------------------------------------------------------------
    alias cc_cm_majdffh46   col_max
    def col_max
      cc_cm_majdffh46 + ($game_switches[SWITCH_ENABLE] ? 1 : 0)
    end if DYNAMIC_COL_COUNT
  end
  
  #=============================================================================
  # ** Scene_Shop
  #-----------------------------------------------------------------------------
  #   Wraping and redefining methods inside Scene_Shop class
  #=============================================================================

  class ::Scene_Shop
    #--------------------------------------------------------------------------
    # * Start Processing
    #--------------------------------------------------------------------------
    alias r2_start_45nf3  start
    def start
      r2_start_45nf3
      create_steal_window
    end
    #--------------------------------------------------------------------------
    # * Create Command Window
    #--------------------------------------------------------------------------
    alias r2_create_cw_64rgu  create_command_window
    def create_command_window
      r2_create_cw_64rgu
      @command_window.set_handler(:steal, method(:command_steal))
    end
    #--------------------------------------------------------------------------
    # * Create Steal Window
    #--------------------------------------------------------------------------
    def create_steal_window
      wy                          = @dummy_window.y
      wh                          = @dummy_window.height
      @steal_window               = Window_ShopSteal.new(0, wy, wh, @goods)
      @steal_window.viewport      = @viewport
      @steal_window.help_window   = @help_window
      @steal_window.status_window = @status_window
      @steal_window.hide
      @steal_window.set_handler(:ok,     method(:on_steal_ok))
      @steal_window.set_handler(:cancel, method(:on_steal_cancel))
    end
    #--------------------------------------------------------------------------
    # * The current selected item
    #--------------------------------------------------------------------------
    def item
      @steal_window.item
    end
    #--------------------------------------------------------------------------
    # * [Steal] Command
    #--------------------------------------------------------------------------
    def command_steal
      @dummy_window.hide
      activate_steal_window
    end
    #--------------------------------------------------------------------------
    # * Category Steal [Cancel]
    #--------------------------------------------------------------------------
    def on_steal_cancel
      @command_window.activate
      @dummy_window.show
      @steal_window.hide
      @status_window.hide
      @status_window.item = nil
      @help_window.clear
    end
    #--------------------------------------------------------------------------
    # * Category Steal [OK]
    #--------------------------------------------------------------------------
    def on_steal_ok
      do_steal(1)
    end
    #--------------------------------------------------------------------------
    # * Quantity Input [OK]
    #--------------------------------------------------------------------------
    def activate_steal_window
      @steal_window.show.activate
      @status_window.show
    end
    #--------------------------------------------------------------------------
    # * Execute Steal
    #--------------------------------------------------------------------------
    def do_steal(number)
      if rand <= item.rate
        $game_party.gain_item(item, number)
        activate_steal_window
      else
        $game_switches[SWITCH_STEAL] = true
        SceneManager.goto(Scene_Map)
      end
    end
  end
  
  #=============================================================================
  # ** RPG::BaseItem
  #-----------------------------------------------------------------------------
  #  Class containing steal data to be inserted into RPG::BaseItem
  #  Used almost exclusively to extract notetags about stealing.
  #=============================================================================
  
  class ::RPG::BaseItem
    #-------------------------------------------------------------------------
    # * Calculates the chances of stealing this item
    #-------------------------------------------------------------------------
    def rate
      rate = steal_rate_formula.($game_party, self, price.to_f)
      rate += $game_variables[VARIABLE_STEAL_BONUS] / 100.0
      [[rate, 0].max, STEAL_RATE_CAP].min
    end
    #---------------------------------------------------------------------------
    # * Formula for calculating the chances of stealing this item from a shop
    #---------------------------------------------------------------------------
    def steal_rate_formula
      @steal_rate_formula ||= retrieve_steal_rate_data
    end
    #---------------------------------------------------------------------------
    # * Steal Rate formula from a retrieved notetag
    #---------------------------------------------------------------------------
    def retrieve_steal_rate_data
      if match_data = steal_rate_tag
        eval("lambda {|a, b, p| #{match_data[:value]} }")
      else
        Steal.default_rate
      end
    end
    #---------------------------------------------------------------------------
    # * Match_data from all matches of <steal: formula>
    #---------------------------------------------------------------------------
    def steal_rate_tag
      Notetag.scan_tags(note, :steal).first
    end
    #---------------------------------------------------------------------------
    # * Is this baseItem marked with the <thief> notetag?
    #---------------------------------------------------------------------------
    def thief?
      return @thief if @thief_memo
      @thief_memo = true
      @thief ||= Notetag.scan_tags(note, :thief, :plain).first
    end
  end

  #=============================================================================
  # ** Window_ShopSteal
  #-----------------------------------------------------------------------------
  #  This window displays a list of steal goods on the shop screen.
  #=============================================================================

  class Window_ShopSteal < Window_Selectable
    #--------------------------------------------------------------------------
    # * Public Instance Variables
    #--------------------------------------------------------------------------
    attr_reader :status_window # Status window
    #--------------------------------------------------------------------------
    # * Object Initialization
    #--------------------------------------------------------------------------
    def initialize(x, y, height, shop_goods)
      super(x, y, window_width, height)
      @shop_goods = shop_goods
      refresh
      select(0)
    end
    #--------------------------------------------------------------------------
    # * Get Window Width
    #--------------------------------------------------------------------------
    def window_width
      return 304
    end
    #--------------------------------------------------------------------------
    # * Get Number of Items
    #--------------------------------------------------------------------------
    def item_max
      @data ? @data.size : 1
    end
    #--------------------------------------------------------------------------
    # * Get Item
    #--------------------------------------------------------------------------
    def item
      @data[index]
    end
    #--------------------------------------------------------------------------
    # * Get Activation State of Selection Item
    #--------------------------------------------------------------------------
    def current_item_enabled?
      enable?(@data[index])
    end
    #--------------------------------------------------------------------------
    # * Get Price of Item
    #--------------------------------------------------------------------------
    def price(item)
      @price[item]
    end
    #--------------------------------------------------------------------------
    # * Display in Enabled State?
    #--------------------------------------------------------------------------
    def enable?(item)
      item && price(item) > 0 && !$game_party.item_max?(item)
    end
    #--------------------------------------------------------------------------
    # * Refresh
    #--------------------------------------------------------------------------
    def refresh
      make_item_list
      create_contents
      draw_all_items
    end
    #--------------------------------------------------------------------------
    # * Create Item List
    #--------------------------------------------------------------------------
    def make_item_list
      containers = [$data_items, $data_weapons, $data_armors]
      @data = @shop_goods.map { |goods| item = containers[goods[0]][goods[1]] }
      @price = Hash[@data.map { |item| [item, item.rate] }]
    end
    #--------------------------------------------------------------------------
    # * Draw Item
    #--------------------------------------------------------------------------
    def draw_item(index)
      item = @data[index]
      rect = item_rect(index)
      draw_item_name(item, rect.x, rect.y, enable?(item))
      rect.width -= 4
      draw_text(rect, "#{(price(item) * 100).to_i}%", 2)
    end
    #--------------------------------------------------------------------------
    # * Set Status Window
    #--------------------------------------------------------------------------
    def status_window=(status_window)
      @status_window = status_window
      call_update_help
    end
    #--------------------------------------------------------------------------
    # * Update Help Text
    #--------------------------------------------------------------------------
    def update_help
      @help_window.set_item(item) if @help_window
      @status_window.item = item if @status_window
    end
  end
  
  #=============================================================================
  # ** Steal
  #-----------------------------------------------------------------------------
  #  Class containing system's additional data
  #=============================================================================
  
  module Steal
    #-------------------------------------------------------------------------
    # * Default Stealing Success formula defined at the start of the script.
    #   This formula is used for items lacking a <steal:formula> Notetag.
    #-------------------------------------------------------------------------
    def self.default_rate
      @default_rate ||= eval("lambda {|a, b, p| #{STEAL_FORMULA} }")
    end
    #-------------------------------------------------------------------------
    # * Inserts a command in any position of a command list.
    #-------------------------------------------------------------------------
    def self.insert_command(list, position, name, symbol, enabled)
      command = {name: name, symbol: symbol, enabled: enabled}
      list.insert([[position, 0].max, list.size].min, command)
    end
    #--------------------------------------------------------------------------
    # * Is steal command enabled?
    #--------------------------------------------------------------------------
    def self.enabled?
      $game_switches[SWITCH_COMMAND] && self.party_has_thief?
    end
    #--------------------------------------------------------------------------
    # * Check if party has a thief or if any equiped item grants thief skills.
    #--------------------------------------------------------------------------
    def self.party_has_thief?
      $game_party.battle_members
        .map(&method(:actor_items))
        .flatten()
        .find(&:thief?)
    end
    #---------------------------------------------------------------------------
    # * List of all base_items this Game_Actor is carrying, including the 
    #   actor itself.
    #---------------------------------------------------------------------------
    def self.actor_items(actor)
      return [] unless actor.alive?
      [actor.actor, actor.class]
        .concat(actor.weapons)
        .concat(actor.armors)
        .concat(actor.skills)
        .concat(actor.states)
    end
  end
  
  #=============================================================================
  # ** Notetag
  #-----------------------------------------------------------------------------
  #  Module for extracting Notetags
  #=============================================================================
  
  module Notetag
    class << self
      #-------------------------------------------------------------------------
      # * Extracts notetag data matching the given pattern type
      #-------------------------------------------------------------------------
      #     note : The note field or string
      #     tag  : The tag's name i.e. :Expertise will search for <Expertise>
      #     type : The notetag's pattern (:plain, :single or :pair)
      #-------------------------------------------------------------------------
      def scan_tags(note, tag, type = :single)
        note.to_enum(:scan, pattern(tag, type)).map { Regexp.last_match }
      end
      
      private
      #-------------------------------------------------------------------------
      # * Return a regex for the given pattern to match the given tag_name
      #-------------------------------------------------------------------------
      def pattern(tag, type)
        method(type).(tag)
      end
      #-------------------------------------------------------------------------
      # * Regex for retrieving a notetag containing only one value
      #     base format: <tag_name> or <tag_name:opt>
      #-------------------------------------------------------------------------
      def plain(tag_name)
        %r{
          (?: <\s*#{tag_name}\s*) # < tag_name    the tag name
          (?: :\s*(?<opt>  .+?))? # : optional    the optional value
          (?: \s*\/>)             # />            the tag closing
        }ix
      end
      #-------------------------------------------------------------------------
      # * Regex for retrieving a notetag containing only one value
      #     base format: <tag_name:value> or <tag_name:value,opt>
      #-------------------------------------------------------------------------
      def single(tag_name)
        %r{
          (?: <\s*#{tag_name}\s*) # < tag_name    the tag name
          (?: :\s*(?<value>.+?))  # : value       the second value
          (?: ,\s*(?<opt>  .+?))? # , optional    the optional value
          (?: \s*\/>)             # />            the tag closing
        }ix
      end
      #-------------------------------------------------------------------------
      # * Regex for retrieving a notetag containing two values
      #     base format: <tag_name:key,value> or <tag_name:key,value,opt>
      #-------------------------------------------------------------------------
      def pair(tag_name)
        %r{
          (?: <\s*#{tag_name}\s*) # < tag_name    the tag name
          (?: :\s*(?<key>  .+?))  # : key         the first value
          (?: ,\s*(?<value>.+?))  # , value       the second value
          (?: ,\s*(?<opt>  .+?))? # , optional    the optional value
          (?: \s*\/>)             # />            the tag closing
        }ix
      end
    end
  end
end

#-------------------------------------------------------------------------------
# End of script.
#-------------------------------------------------------------------------------
  