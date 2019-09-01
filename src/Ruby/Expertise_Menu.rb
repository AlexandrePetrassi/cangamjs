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
# Requires : CaRaCrAzY_Core, CaRaCrAzY_Expertise
# Version  : 0.00
# Date     : 1900.01.01
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

($imported ||= {})[:CCPet_Expertise_Menu] = true

$imported[:CCPet_Expertise_Menu] = {
  :version    => 1.00,
  :requires   => [:CCPet_Expertise_Core],
} if ($imported ||= {})[:CCPet_Expertise_Menu]

#===============================================================================
# ** CaRaCrAzY
#-------------------------------------------------------------------------------
#   Module used for Namespacing the Expertise System
#   Everything about this system is contained inside this module.
#===============================================================================

module CaRaCrAzY

  #-----------------------------------------------------------------------------
  # * Enables the display of expertise points on main menu
  #-----------------------------------------------------------------------------
  #   Feel free to disable this feature if it conflicts with another script
  #   that also alters the simple_status window.
  #-----------------------------------------------------------------------------
  FEATURE_STATUS_WINDOW_EXPERTISE_DISPLAY = true
  
  #-----------------------------------------------------------------------------
  # * Enables the shining effect to the [Expertise] option
  #-----------------------------------------------------------------------------
  #   This feature enables a shining effect on the [Expertise] command that
  #   is activated whenever a party member still has some unallocated
  #   Expertise points.
  #   
  #   if FEATURE_MENU_COMMAND is disabled, this feature has no effect.
  #-----------------------------------------------------------------------------
  FEATURE_SHINE = true
  
  #=============================================================================
  # ** Vocab
  #-----------------------------------------------------------------------------
  #  Additional Vocabulary.
  #=============================================================================
  
  #-----------------------------------------------------------------------------
  # [Expertise] Menu Option
  #-----------------------------------------------------------------------------
  #   This is name of the option displayed in the main menu for accessing the
  #   Expertise Scene.
  #-----------------------------------------------------------------------------
  CMD_EXPERTISE = "Expertise"
  
  #-----------------------------------------------------------------------------
  # * Expertise Points, abbreviated.
  #-----------------------------------------------------------------------------
  #   This is the text displayed alongside the current Expertise Point amount
  #   an actor has.
  #-----------------------------------------------------------------------------
  XPRTS_POINTS_A = "EP"
  
  #=============================================================================
  # REST OF THE SCRIPT
  #-----------------------------------------------------------------------------
  # The script itself starts here.
  # You are welcome to read it, but do not modify the below code unless you 
  # know exactly what you are doing.
  # No support will be provided to solve problems caused by edited code.
  #=============================================================================

  #=============================================================================
  # ** Xprts
  #-----------------------------------------------------------------------------
  #   This section adds commands for controlling the Menu Entry
  #=============================================================================

  module ::Xprts
    #---------------------------------------------------------------------------
    # * Directly Invokes the Expertise Menu for the last selected actor. [a134]
    #---------------------------------------------------------------------------
    # * Directly Invokes the Expertise Menu for a specific actor. [b134]
    #---------------------------------------------------------------------------
    #     member_index : Party member's ID in the menu screen (Starting at zero)
    #---------------------------------------------------------------------------
    def self.expertise_scene(member_index = nil)
      if member_index && member = $game_party.members[member_index]
        $game_party.menu_actor = member
      end
      SceneManager.call(Scene_Expertise)
    end
    #---------------------------------------------------------------------------
    # * If called without arguments, this method returns the [Expertise]'s
    #   command enabled status. [a334]
    #---------------------------------------------------------------------------
    # * It will set the [Expertise]'s command enabled stauts. [b334]
    #
    #   While false, the [Expertise] command will be displayed as grayed out.
    #---------------------------------------------------------------------------
    def self.expertise_command_enabled(value = nil)
      if value == nil
        $game_system.expertise_command_enabled 
      else
        $game_system.expertise_command_enabled = value
      end
    end
    #---------------------------------------------------------------------------
    # * If called without arguments, this method returns the [Expertise]'s
    #   command visibility status. [c334]
    #---------------------------------------------------------------------------
    #   It will set the [Expertise]'s command visibility stauts. [d334]
    #
    #   While false, the [Expertise] command will be displayed as an empty
    #   entry.
    #---------------------------------------------------------------------------
    def self.expertise_command_visible(value = nil)
      if value == nil
        $game_system.expertise_command_visible
      else
        $game_system.expertise_command_visible = value
      end
    end
    #---------------------------------------------------------------------------
    # * If called without arguments, this method returns the [Expertise]'s
    #   command presence status. [e334]
    #---------------------------------------------------------------------------
    #   It will set the [Expertise]'s command presence stauts. [f334]
    #
    #   While false, the [Expertise] command will not be displayed at all.
    #---------------------------------------------------------------------------
    def self.expertise_command_present(value = nil)
      if value == nil
        $game_system.expertise_command_present 
      else
        $game_system.expertise_command_present = value
      end
    end
  end

  #=============================================================================
  # ** Window_MenuCommand
  #-----------------------------------------------------------------------------
  #   Conditionally aliasing methods in Window_MenuCommand class
  #=============================================================================

  class ::Window_MenuCommand
    #---------------------------------------------------------------------------
    #   Add Expertise command to the Main Commands list
    #---------------------------------------------------------------------------
    alias add_main_commands_caracrazy_fa45h add_main_commands
    def add_main_commands(*args)
      result = add_main_commands_caracrazy_fa45h(*args)
      add_expertise_to_menu if $game_system.expertise_command_present
      result
    end
  end

  #=============================================================================
  # ** Window_MenuCommand
  #-----------------------------------------------------------------------------
  #   Conditionally aliasing methods in Window_MenuCommand class
  #   if FEATURE_SHINE is true
  #=============================================================================

  class ::Window_MenuCommand
    #---------------------------------------------------------------------------
    #   Updates the shining command effect
    #---------------------------------------------------------------------------
    alias update_caracrazy_maa87jt update
    def update(*args)
      result = update_caracrazy_maa87jt(*args)
      draw_shining_expertise_command
      result
    end 
  end if FEATURE_SHINE

  #=============================================================================
  # ** Scene_Menu
  #-----------------------------------------------------------------------------
  #   Conditionally aliasing methods inside Scene_Menu class
  #=============================================================================

  class ::Scene_Menu
    #---------------------------------------------------------------------------
    #   Create Command Window
    #---------------------------------------------------------------------------
    alias create_command_window_caracrazy_uras4 create_command_window
    def create_command_window(*args)
      result = create_command_window_caracrazy_uras4(*args)
      @command_window.set_handler(:expertise, method(:command_personal))
      result
    end
    #---------------------------------------------------------------------------
    #   [OK] Personal Command
    #---------------------------------------------------------------------------
    alias on_personal_ok_caracrazy_8m1ja on_personal_ok
    def on_personal_ok(*args)
      result = on_personal_ok_caracrazy_8m1ja(*args)
      Xprts.expertise_scene if @command_window.current_symbol == :expertise
      result
    end
  end

  #=============================================================================
  # ** Window_Base
  #-----------------------------------------------------------------------------
  #   Conditionally aliasing methods inside Window_Base class
  #   if FEATURE_STATUS_WINDOW_EXPERTISE_DISPLAY is true
  #=============================================================================

  class ::Window_Base
    #---------------------------------------------------------------------------
    #   Displays the actor's Expertise points on simple_status_window
    #---------------------------------------------------------------------------
    alias draw_actor_simple_status_caracrazy_a82a1e draw_actor_simple_status
    def draw_actor_simple_status (actor, x, y, *args)
      result = draw_actor_simple_status_caracrazy_a82a1e(actor, x, y, *args)
      draw_actor_expertise_points(actor, x + 60, y + line_height)
      result
    end
  end if FEATURE_STATUS_WINDOW_EXPERTISE_DISPLAY
  
  #=============================================================================
  # ** Game_System
  #-----------------------------------------------------------------------------
  #  Class containing additional data to be inserted into Game_System
  #=============================================================================

  class ::Game_System
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_accessor :expertise_command_enabled # main menu option enabled status
    attr_accessor :expertise_command_visible # main menu option visible status
    attr_accessor :expertise_command_present # main menu option present status
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    alias initialize_caracrazy_ma645a initialize
    def initialize
      initialize_caracrazy_ma645a
      @expertise_command_enabled = true
      @expertise_command_visible = true
      @expertise_command_present = true
    end
  end

  #=============================================================================
  # ** Scene_Window
  #-----------------------------------------------------------------------------
  #  Module that subscribes to the Scene_Expertise events
  #=============================================================================
  
  module Scene_Window
    #---------------------------------------------------------------------------
    # * Public class attributes
    #---------------------------------------------------------------------------
    attr_accessor :scene  # The current scene this object is participating
    #---------------------------------------------------------------------------
    # * Custom scene setter
    #---------------------------------------------------------------------------
    def scene=(scene)
      @scene = scene
      scene.windows << self
      update
      refresh
    end
    #---------------------------------------------------------------------------
    # * Gets the current selected command from command_window
    #---------------------------------------------------------------------------
    def command
      scene.command_window.command if scene && scene.command_window
    end
    #---------------------------------------------------------------------------
    # * Gets the current selected item(skill) from item_window
    #---------------------------------------------------------------------------
    def item
      scene.item_window.item if scene && scene.item_window
    end
    #---------------------------------------------------------------------------
    # * Gets the current selected actor in the scene
    #---------------------------------------------------------------------------
    def actor; scene.actor if scene; end
    #---------------------------------------------------------------------------
    # * Gets the scene's viewport
    #---------------------------------------------------------------------------
    def viewport; scene.viewport if scene; end
    #---------------------------------------------------------------------------
    # * Gets the scene's help window
    #---------------------------------------------------------------------------
    def help_window; scene.help_window if scene; end
    #---------------------------------------------------------------------------
    # * Gets the scene's item window
    #---------------------------------------------------------------------------
    def item_window; scene.item_window if scene; end
    #---------------------------------------------------------------------------
    # * Gets the scene's command window
    #---------------------------------------------------------------------------
    def command_window; scene.command_window if scene; end
    #---------------------------------------------------------------------------
    # * Placeholder method called when the on_actor_change event is raised
    #---------------------------------------------------------------------------
    def on_actor_change; end
    #---------------------------------------------------------------------------
    # * Placeholder method called when the on_item_change event is raised
    #---------------------------------------------------------------------------
    def on_item_change; end
    #---------------------------------------------------------------------------
    # * Placeholder method called when the on_command_change event is raised
    #---------------------------------------------------------------------------
    def on_command_change; end
    #--------------------------------------------------------------------------
    # * Update Help
    #--------------------------------------------------------------------------
    def update_help; end
  end
  
  #=============================================================================
  # ** Scene_Expertise
  #-----------------------------------------------------------------------------
  #  This class performs the processing of the Expertise Screen.
  #=============================================================================

  class Scene_Expertise < Scene_MenuBase
    attr_reader :actor            # the current selected actor
    attr_reader :viewport         # this scene's viewport
    attr_reader :help_window      # this scene's help window
    attr_reader :item_window      # this scene's item window (Expertise List)
    attr_reader :command_window   # this scene's command window (Expertise cmd)
    attr_reader :status_window    # this scene's inspector window
    attr_reader :windows          # Windows subscribing to this scene events
    #---------------------------------------------------------------------------
    # * Start Processing
    #---------------------------------------------------------------------------
    def start
      super
      @windows = []
      create_help_window
      create_command_window
      create_item_window
      create_status_window
    end
    #---------------------------------------------------------------------------
    # * Creates the Command window
    #---------------------------------------------------------------------------
    def create_command_window
      @command_window = Window_ExpertiseCommand.new
      @command_window.y     = @help_window.height
      @command_window.width = Graphics.width * 0.65
      @command_window.scene = self
      @command_window.set_handler(:skill,    method(:command_skill))
      @command_window.set_handler(:cancel,   method(:return_scene))
      @command_window.set_handler(:pagedown, method(:next_actor))
      @command_window.set_handler(:pageup,   method(:prev_actor))
    end
    #---------------------------------------------------------------------------
    # * Creates the Expertise window
    #---------------------------------------------------------------------------
    def create_item_window
      wx = 0
      wy = @command_window.y + @command_window.height
      ww = Graphics.width
      wh = Graphics.height - wy
      @item_window = Window_ExpertiseList.new(wx, wy, ww, wh)
      @item_window.scene = self
      @item_window.set_handler(:ok    , method(:on_item_ok))
      @item_window.set_handler(:cancel, method(:on_item_cancel))
    end
    #---------------------------------------------------------------------------
    # * Creates the Status window
    #---------------------------------------------------------------------------
    def create_status_window
      wx = Graphics.width * 0.65
      wy = @command_window.y
      ww = Graphics.width * 0.35
      wh = @command_window.height
      @status_window = Window_ExpertiseStatus.new(wx, wy, ww, wh)
      @status_window.scene = self
    end
    #---------------------------------------------------------------------------
    # * Command :skill
    #---------------------------------------------------------------------------
    def command_skill
      @item_window.activate
      @item_window.select_last
    end
    #---------------------------------------------------------------------------
    # * Command :ok
    #---------------------------------------------------------------------------
    def on_item_ok
      @actor.last_skill.object = @item_window.skill
    end
    #---------------------------------------------------------------------------
    # * Command :cancel
    #---------------------------------------------------------------------------
    def on_item_cancel
      @item_window.unselect
      @command_window.activate
      on_item_change
    end
    #---------------------------------------------------------------------------
    # * Plays the use skill SE
    #---------------------------------------------------------------------------
    def play_se_for_item
      Sound.play_use_skill
    end
    #---------------------------------------------------------------------------
    # * Actor change event
    #---------------------------------------------------------------------------
    def on_actor_change
      @windows.each(&:on_actor_change)
    end
    #---------------------------------------------------------------------------
    # * Item change event
    #---------------------------------------------------------------------------
    def on_item_change
      @windows.each(&:on_item_change)
      help_window.set_item(item_window.item)
    end
    #---------------------------------------------------------------------------
    # * Command change event
    #---------------------------------------------------------------------------
    def on_command_change
      @windows.each(&:on_command_change)
      help_window.clear
    end
    #---------------------------------------------------------------------------
    # * Determine if Common Event Is Reserved
    #    Transition to the map screen if the event call is reserved.
    #---------------------------------------------------------------------------
    def check_common_event
      SceneManager.goto(Scene_Map) if $game_temp.common_event_reserved?
    end
  end
  
  #=============================================================================
  # ** Window
  #-----------------------------------------------------------------------------
  #  Module containing new ways to draw stuff in game windows
  #=============================================================================
  
  module Window
    class << self
      #-------------------------------------------------------------------------
      # * Returns a different golden shade based on frame_count
      #-------------------------------------------------------------------------
      def golden_shine
        golden_shades[shine_index]
      end
      #-------------------------------------------------------------------------
      # * Bitmap containing 32 pixels of golden shades
      #-------------------------------------------------------------------------
      def golden_shades
        @golden_shades ||= gradient(
          Color.new(112, 96, 96),
          Color.new(256, 224, 144)
        )
      end
    end
  end
  
  #=============================================================================
  # ** Window_ExpertiseStatus
  #-----------------------------------------------------------------------------
  #  Window for displaying the remaining actor's EP
  #=============================================================================
  
  class Window_ExpertiseStatus < Window_Selectable
    #---------------------------------------------------------------------------
    # * Macros
    #---------------------------------------------------------------------------
    include Window
    include Scene_Window
    #---------------------------------------------------------------------------
    # * Refresh
    #---------------------------------------------------------------------------
    def refresh
      create_contents
      # icon
      rect = item_rect_for_text(0)
      draw_actor_icon(actor, rect.x, rect.y)
      #EP
      change_color(actor.expertise_points > 0 ? normal_color : crisis_color)
      draw_text(rect, actor.expertise_points, 2)
      rect.width -= contents.text_size(" #{actor.expertise_points}").width
      #EP Text
      change_color(system_color)
      draw_text(rect, XPRTS_POINTS_A, 2)
      width = contents.text_size(XPRTS_POINTS_A).width
      #Name
      change_color(normal_color)
      rect.x += 24
      draw_text(rect, actor.name)
    end
    #---------------------------------------------------------------------------
    # * Refresh
    #---------------------------------------------------------------------------
    def refresh
      create_contents
      # Icon
      rect = item_rect_for_text(0)
      draw_actor_icon(actor, rect.x, rect.y)
      # EP
      change_color(actor.expertise_points > 0 ? normal_color : crisis_color)
      draw_text(rect, actor.expertise_points, 2)
      # EP Text
      rect.width -= contents.text_size(" #{actor.expertise_points}").width
      change_color(system_color)
      draw_text(rect, XPRTS_POINTS_A, 2)
      # Actor's Name
      rect.x += 25
      change_color(normal_color)
      draw_text(rect, actor.name)
    end
    #---------------------------------------------------------------------------
    # On Actor change event
    #---------------------------------------------------------------------------
    def on_actor_change
      refresh
    end
  end
  
  #=============================================================================
  # ** Window_ExpertiseList
  #-----------------------------------------------------------------------------
  #  Window for displaying a list of available skills
  #=============================================================================

  class Window_ExpertiseList < Window_Selectable
    #---------------------------------------------------------------------------
    # * Macros
    #---------------------------------------------------------------------------
    include Window
    include Scene_Window
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(x, y, width, height)
      super
      @data = []
    end
    #---------------------------------------------------------------------------
    # * Get Number of Items
    #---------------------------------------------------------------------------
    def item_max
      @data ? @data.size : 1
    end
    #---------------------------------------------------------------------------
    # * Current Selected Item
    #---------------------------------------------------------------------------
    def item
      @data && index >= 0 ? @data[index] : nil
    end
    #---------------------------------------------------------------------------
    # * Include in Skill List? 
    #---------------------------------------------------------------------------
    def include?(skill)
      skill && skill.xtype == command && !command.to_s.empty?
    end
    #---------------------------------------------------------------------------
    # * Display Skill in Enabled State?
    #---------------------------------------------------------------------------
    def enable?(item)
      actor && actor.expertise_points?
    end
    #---------------------------------------------------------------------------
    # * Create Expertise List
    #---------------------------------------------------------------------------
    def make_expertise_list
      @data = actor ? actor.skills.select { |skill| include?(skill) } : []
    end
    #---------------------------------------------------------------------------
    # * Draw Skill
    #---------------------------------------------------------------------------
    def draw_item(index)
      return unless skill = @data[index]
      rect = item_rect(index)
      draw_item_name(skill, rect.x, rect.y, enable?(skill))
      draw_expertise(subrect(rect, 0.7), skill)
    end
    #---------------------------------------------------------------------------
    # * Draws a skill's current expertise
    #---------------------------------------------------------------------------
    def draw_expertise(rect, skill)
      base  = actor.expertise(skill.id).allocations
      change_color(normal_color)
      draw_text(subrect(rect, 0.6), base, 2)
    end
    #---------------------------------------------------------------------------
    # * Refresh
    #---------------------------------------------------------------------------
    def refresh
      make_expertise_list
      create_contents
      draw_all_items
    end
    #---------------------------------------------------------------------------
    # * Is the current selected skill valid for expertise allocation?
    #---------------------------------------------------------------------------
    def allocatable?
      actor.expertise_points? && include?(item)
    end
    #---------------------------------------------------------------------------
    # * Processing When OK Button Is Pressed
    #---------------------------------------------------------------------------
    def process_ok
      return Sound.play_buzzer unless allocatable?
      actor.allocate_expertise(item.id)
      actor.last_expertise = item
      Sound.play_equip
      refresh
      scene.status_window.refresh
    end
    #---------------------------------------------------------------------------
    # * Restore Previous Selection Position
    #---------------------------------------------------------------------------
    def select_last
      select(@data.index(actor.last_expertise) || 0)
    end
    #---------------------------------------------------------------------------
    # * Calling event if cursor moves
    #---------------------------------------------------------------------------
    def select(index)
      last_index = @index
      super
      scene.on_item_change if scene && index != last_index
    end
    #---------------------------------------------------------------------------
    # On Actor change event
    #---------------------------------------------------------------------------
    def on_actor_change
      refresh
      self.oy = 0
    end
    #---------------------------------------------------------------------------
    # * On Command change event
    #---------------------------------------------------------------------------
    def on_command_change
      refresh
      self.oy = 0
    end
    #---------------------------------------------------------------------------
    # * Get Digit Count
    #---------------------------------------------------------------------------
    def col_max
      return 2
    end
  end
  
  #=============================================================================
  # ** Window_ExpertiseCommand
  #-----------------------------------------------------------------------------
  #  This window is for selecting Expertise Types on the Expertise screen.
  #=============================================================================

  class Window_ExpertiseCommand < Window_HorzCommand
    #---------------------------------------------------------------------------
    # * Macros
    #---------------------------------------------------------------------------
    include Scene_Window
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize
      super(0, 0)
    end
    #---------------------------------------------------------------------------
    # * Get Window Width
    #---------------------------------------------------------------------------
    def window_width
      Graphics.width * 0.65
    end
    #---------------------------------------------------------------------------
    # * Get Digit Count
    #---------------------------------------------------------------------------
    def col_max
      return 3
    end
    #---------------------------------------------------------------------------
    # * Create Command List
    #---------------------------------------------------------------------------
    def make_command_list
      return unless actor
      actor.added_expertise_types.sort.each do |xtype|
        add_command(xtype, :skill, true, xtype)
      end
    end
    #---------------------------------------------------------------------------
    # * Select Option
    #---------------------------------------------------------------------------
    def select(index)
      super(index)
      refresh
      scene.on_command_change if scene
    end
    #--------------------------------------------------------------------------
    # * Restore Previous Selection Position
    #--------------------------------------------------------------------------
    def select_last
      if skill = actor.last_expertise
        select_ext(skill.xtype)
      else
        select(0)
      end
    end
    #--------------------------------------------------------------------------
    # * Current Selected Command
    #--------------------------------------------------------------------------
    def command
      current_ext
    end
    #---------------------------------------------------------------------------
    # On Actor change event
    #---------------------------------------------------------------------------
    def on_actor_change
      refresh
      select_last
      activate
    end
  end
  
  #=============================================================================
  # ** Window_Expertise
  #-----------------------------------------------------------------------------
  #  Class for drawing expertise data
  #=============================================================================
  
  class ::Window_Base
    #---------------------------------------------------------------------------
    # * Macros
    #---------------------------------------------------------------------------             
    include Window                     
    #---------------------------------------------------------------------------
    # * Draws an actor current expertise_points
    #---------------------------------------------------------------------------
    def draw_actor_expertise_points(actor, x, y, width = 56)
      return unless Xprts.expertise_command_visible
      ep = actor.expertise_points? || return
      
      rect = Rect.new(x, y, width, line_height)
      change_color(system_color)
      draw_text(subrect(rect, -0.6), XPRTS_POINTS_A)
      
      change_color(normal_color)
      draw_text(subrect(rect, 0.4), ep, 2)
    end
  end
  
  #=============================================================================
  # ** Window_Expertise_MenuCommand
  #-----------------------------------------------------------------------------
  #  Class for drawing expertise data on the main menu
  #=============================================================================
  
  class ::Window_MenuCommand
    class << self
      #-------------------------------------------------------------------------
      # * Public class attributes
      #-------------------------------------------------------------------------
      attr_accessor :expertise_command_index # Main menu command index
    end
    #---------------------------------------------------------------------------
    # * Draws the Expertise Command with a shine effect
    #---------------------------------------------------------------------------
    def draw_shining_expertise_command
      return unless expertise_command_shining?
      change_color(Window.golden_shine)
      rect = item_rect_for_text(self.class.expertise_command_index)
      draw_text(rect, CMD_EXPERTISE, alignment)
    end
    #---------------------------------------------------------------------------
    # * Returns true if the expertise command must enable its shining effect
    #---------------------------------------------------------------------------
    def expertise_command_shining?
      Xprts.expertise_command_enabled &&
      Xprts.expertise_command_visible &&
      Xprts.expertise_command_present &&
      party_expertise_remaining?
    end
    #---------------------------------------------------------------------------
    # * True if any Party Actor still has Expertise points to invest.
    #---------------------------------------------------------------------------
    def party_expertise_remaining?
      $game_party.battle_members.any?(&:expertise_points?)
    end
    #---------------------------------------------------------------------------
    # * Adds the expertise command to the main menu
    #---------------------------------------------------------------------------
    def add_expertise_to_menu
      visible = Xprts.expertise_command_visible
      enabled = Xprts.expertise_command_enabled
      return add_command("", :expertise, false) unless visible
      self.class.expertise_command_index = item_max
      add_command(CMD_EXPERTISE, :expertise, enabled)
    end
  end

  #=============================================================================
  # ** Game_Actor
  #-----------------------------------------------------------------------------
  #  Class containing additional data to be inserted into Game_Actor
  #=============================================================================
  
  class ::Game_Actor
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_accessor   :last_expertise   # For cursor memorization:  Skill
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    alias initialize_caracrazy_asf87fa initialize
    def initialize(*args)
      initialize_caracrazy_asf87fa(*args)
      @last_expertise = RPG::Skill.new
    end
    #---------------------------------------------------------------------------
    # * Lists all xtypes (Expertise Types) this actor has from his Expertises
    #---------------------------------------------------------------------------
    def added_expertise_types
      skills.map(&:xtype).uniq.compact
    end
  end
  
  #=============================================================================
  # ** RPG::Skill
  #-----------------------------------------------------------------------------
  #  Class containing additional data to be inserted into RPG::Skill
  #=============================================================================
  
  class RPG::Skill
    #---------------------------------------------------------------------------
    # * Expertise_Type - Similar to Skill's stype, but for Expertises
    #---------------------------------------------------------------------------
    def xtype
      @xtype ||= retrieve_xtype_data
    end
    #---------------------------------------------------------------------------
    # * xtype from a retrieved notetag
    #---------------------------------------------------------------------------
    def retrieve_xtype_data
      (expertise_tag || {})[:st]
    end
    #---------------------------------------------------------------------------
    # * Match_data from the first match of <Expertise: xtype>
    #---------------------------------------------------------------------------
    def expertise_tag
      Notetag.scan_tags(note, :expertise).first
    end
  end
  
  ##############################################################################
  # ** Expertise_Menu_x_Expertise_Bonus_Patches
  #=============================================================================
  # Compatibility patches for Expertise_Bonus
  # This module is only added to the game if Expertise_Bonus is present
  ##############################################################################
  
  module Expertise_Menu_x_Expertise_Bonus_Patches
    
    #===========================================================================
    # ** Window_ExpertiseList
    #---------------------------------------------------------------------------
    #  Window for displaying a list of available skills
    #===========================================================================

    class CaRaCrAzY::Window_ExpertiseList
      #-------------------------------------------------------------------------
      # * Draws a skill's current expertise (base + Total)
      #-------------------------------------------------------------------------
      alias draw_expertise_caracrazy_jl0ia27 draw_expertise
      def draw_expertise(rect, skill)
        draw_expertise_caracrazy_jl0ia27(rect, skill)
        total = actor.expertise(skill.id).total
        change_color(param_change_color(total))
        draw_text(subrect(rect, -0.3), "#{total}←", 2) unless total.zero?
      end
    end
  
    #===========================================================================
    # ** RPG::Skill
    #---------------------------------------------------------------------------
    #  Class containing additional data to be inserted into RPG::Skill
    #===========================================================================
  
    class RPG::Skill
      #-------------------------------------------------------------------------
      # * Array of Inherited descriptors, also including the Expertise Type.
      #-------------------------------------------------------------------------
      def descriptors
        @descriptors ||= retrieve_bonus_from_data + [xtype.to_s.downcase, id.to_s]
      end
    end
  end if $imported[:CCPet_Expertise_Bonus]
end if ($imported ||= {})[:CCPet] && Get.requires_met?(:CCPet_Expertise_Menu)

#-------------------------------------------------------------------------------
# End of script.
#-------------------------------------------------------------------------------
