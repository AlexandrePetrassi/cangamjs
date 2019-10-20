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
# Script   : CaRaCrAzY Core
# Author   : CaRa_CrAzY Petrassi
# Level    : 
# Requires : n/a
# Version  : 0.00
# Date     : 1900.01.01
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

($imported ||= {})[:CCPet] = true &&
{
  version:  1.00,
  requires: { }
}

#===============================================================================
# ** CCPet
#-------------------------------------------------------------------------------
#   Module used for Namespacing the Expertise System
#   Everything about this system is contained inside this module.
#===============================================================================

module CCPet
  #-----------------------------------------------------------------------------
  # * Debug mode
  #-----------------------------------------------------------------------------
  #  Scripts requiring this module may log info in the game console.
  #  Disable this flag if you do not wish info being logged.
  #-----------------------------------------------------------------------------
  DEBUG = true

  ##############################################################################
  # Aspect_Inventory
  #=============================================================================
  #   Manages the caching of a Base_Items list associated with battle members,
  # like a personal inventory for each actor.
  ##############################################################################

  module Aspect_Inventory

    #===========================================================================
    # ** Game_Player
    #===========================================================================

    class ::Game_Player
      #-------------------------------------------------------------------------
      # * Marks the party extended inventory's cache as dirty
      #-------------------------------------------------------------------------
      alias refresh_caracrazy_79aga refresh
      def refresh(*args)
        result = refresh_caracrazy_79aga(*args)
        $game_party.need_refresh = true
        result
      end
    end

    #===========================================================================
    # ** Game_Actor
    #===========================================================================
    
    class ::Game_Actor
      #-------------------------------------------------------------------------
      #   Marks the party extended inventory's cache as dirty
      #-------------------------------------------------------------------------
      alias refresh_caracrazy_8a7ha refresh
      def refresh(*args)
        result = refresh_caracrazy_8a7ha(*args)
        $game_party.need_refresh = true
        result
      end
      #-------------------------------------------------------------------------
      #   Marks the party extended inventory's cache as dirty
      #-------------------------------------------------------------------------
      alias learn_skill_caracrazy_5asg1 learn_skill
      def learn_skill(*args)
        result = learn_skill_caracrazy_5asg1(*args)
        $game_party.need_refresh = true
        result
      end
      #-------------------------------------------------------------------------
      #   Marks the party extended inventory's cache as dirty
      #-------------------------------------------------------------------------
      alias forget_skill_caracrazy_sa5f4 forget_skill
      def forget_skill(*args)
        result = forget_skill_caracrazy_sa5f4(*args)
        $game_party.need_refresh = true
        result
      end
    end

    #===========================================================================
    # ** Game_Party
    #===========================================================================

    class ::Game_Party
      #-------------------------------------------------------------------------
      #   Marks the party extended inventory's cache as dirty
      #-------------------------------------------------------------------------
      alias gain_item_caracrazy_4v51F gain_item
      def gain_item(*args)
        result = gain_item_caracrazy_4v51F(*args)
        $game_party.need_refresh = true
        result
      end
      #-------------------------------------------------------------------------
      #   Marks the party extended inventory's cache as dirty
      #-------------------------------------------------------------------------
      alias add_actor_caracrazy_5v1a98 add_actor
      def add_actor(*args)
        result = add_actor_caracrazy_5v1a98(*args)
        $game_party.need_refresh = true
        result
      end
      #-------------------------------------------------------------------------
      #   Marks the party extended inventory's cache as dirty
      #-------------------------------------------------------------------------
      alias remove_actor_caracrazy_aan15 remove_actor
      def remove_actor(*args)
        result = remove_actor_caracrazy_aan15(*args)
        $game_party.need_refresh = true
        result
      end
    end
    
    #===========================================================================
    # ** Game_Party
    #---------------------------------------------------------------------------
    #  Class containing additional data to be inserted into Game_Party
    #===========================================================================
    
    class ::Game_Party
      #-------------------------------------------------------------------------
      # * Public instance attributes
      #-------------------------------------------------------------------------
      attr_accessor :need_refresh # Mark the cached items list as dirty
      #-------------------------------------------------------------------------
      # * Array containing every BaseItem currently added to the party, which
      #   means: Inventory Items, Equiped Items, Skills, States, Classes and the
      #   actors themselves.
      #-------------------------------------------------------------------------
      def inventory
        return @inventory unless need_refresh
        @need_refresh = false
        @inventory = battle_members
          .map { |actor| actor.inventory(true) }
          .concat(all_items)
          .flatten
          .uniq
      end
    end

    #===========================================================================
    # ** Game_Actor
    #---------------------------------------------------------------------------
    #  Class containing additional data to be inserted into Game_Actor
    #===========================================================================
    
    class ::Game_Actor
      #-------------------------------------------------------------------------
      # * Public instance attributes
      #-------------------------------------------------------------------------
      attr_accessor :need_refresh     # When true, will re-calculate inventory
      #-------------------------------------------------------------------------
      # * Game_Actor's particular memoized inventory
      #-------------------------------------------------------------------------
      def inventory(force_refresh = false)
        return @inventory unless need_refresh || force_refresh || !@inventory
        need_refresh = false
        @inventory = all_base_items
      end
      #-------------------------------------------------------------------------
      # * List of all base_items this Game_Actor is carrying, including the 
      #   actor itself.
      #-------------------------------------------------------------------------
      def all_base_items
        return [] unless alive?
        [actor, self.class] + weapons + armors + skills + states
      end
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
      # * Returns a cached shrinked version of a faceset
      #-------------------------------------------------------------------------
      def face_icon(face_name)
        Cached_face_icon(face_name)
      end
      #-------------------------------------------------------------------------
      # * Generates an array containing a color gradation from c1 to c2
      #     c1   : Initial gradient's color
      #     c2   : Final gradient's color
      #     size : How many shades will be generated
      #-------------------------------------------------------------------------
      def gradient(c1, c2, size = 32)
        (bmp = Bitmap.new(size, 1)).gradient_fill_rect(0, 0, size, 1, c1, c2)
        (0..size).map { |i| bmp.get_pixel(i, 0) }
      end
      #-------------------------------------------------------------------------
      # * Index of which shade will be rendered based on current frame_count
      #-------------------------------------------------------------------------
      def shine_index(size = 32)
        (Graphics.frame_count % (size * 2) - size).abs
      end
      #-------------------------------------------------------------------------
      # * Returns a cached shriked version of a faceset
      #-------------------------------------------------------------------------
      def Cached_face_icon(face_name)
        face_icon_hash = @face_icon_hash ||= {}
        face_icon_hash[face_name] ||= shrink(Cache.face(face_name), 1)
      end
      #-------------------------------------------------------------------------
      # * Shrinks a bitmap by half its size while performing smoothing
      #     bitmap     : the image being halved
      #     recursions : additional iterations for shrinking to 1/4, 1/8...
      #
      #     returns: A shrinked bitmap
      #-------------------------------------------------------------------------
      def shrink(bitmap, recursions = 0)
        result = Bitmap.new(bitmap.width / 2, bitmap.height / 2)
        4.times do |i|
          src_rect = Rect.new(i % 2, i / 2, bitmap.width, bitmap.height)
          result.stretch_blt(result.rect, bitmap, src_rect, i == 0 ? 255 : 64)
        end
        recursions <= 0 ? result : shrink(result, recursions - 1)
      end
    end
    #-------------------------------------------------------------------------
    # * Draw Actor Face Graphic
    #     actor   : Actor which will have its face graphic rendered as an icon
    #     x       : X position on screen the icon will start rendering
    #     y       : Y position on screen the icon will start rendering
    #     enabled : if true, renders the icon translucently
    #-------------------------------------------------------------------------
    def draw_actor_icon(actor, x, y, enabled = true)
      draw_face_icon(actor.face_name, actor.face_index, x, y, enabled)
    end
    #-------------------------------------------------------------------------
    # * Draw Face Graphic
    #     face_name  : the faceset's file name in the cache module
    #     face_index : the face's index in the faceset
    #     x          : Horizontal position the face will render on screen
    #     y          : Vertical position the face will render on screen
    #     enabled    : Enabled flag. When false, draw semi-transparently.
    #-------------------------------------------------------------------------
    def draw_face_icon(face_name, face_index, x, y, enabled = true)
      bitmap = Window.face_icon(face_name)
      rect = Rect.new(face_index % 4 * 24, face_index / 4 * 24, 24, 24)
      contents.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
    end
    #---------------------------------------------------------------------------
    # * Slices a rect
    #     rect       : the reference rect
    #     horizontal : slice's horizontal ratio between -1.0 and 1.0
    #     vertical   : slice's vertical ratio between -1.0 and 1.0
    #
    #     returns: New sliced rect instance
    #---------------------------------------------------------------------------
    #   Inputing positive ratios results in an amount of the width or height to
    #   be taken away and put back into the x or y position for compensation, 
    #   generating a rect with its ending bounds the same as the original rect.
    #
    #   Inputing negative ratios results in just taking the width or height 
    #   away, without compensating x or y values, thus generating a rect with 
    #   the starting bounds the same as the original rect. This is the same as 
    #   just changing the rect's width or height values.
    #---------------------------------------------------------------------------
    def subrect(rect, horizontal, vertical = 0.0)
      w = rect.width  * horizontal
      h = rect.height * vertical
      
      a = rect.x      + [w, 0].max
      c = rect.width  - w.abs
      b = rect.y      + [h, 0].max
      d = rect.height - h.abs
      
      Rect.new(a, b, c, d)
    end
    #---------------------------------------------------------------------------
    # * Destructively slices a rect
    #     rect       : the rect being sliced
    #     horizontal : slice's horizontal ratio between -1.0 and 1.0
    #     vertical   : slice's vertical ratio between -1.0 and 1.0
    #
    #     returns: The rect itself after slicing
    #---------------------------------------------------------------------------
    #   Inputing positive ratios results in an amount of the width or height to
    #   be taken away and put back into the x or y position for compensation, 
    #   without changing its ending bounds.
    #
    #   Inputing negative ratios results in just taking the width or height 
    #   away, without compensating x or y values, thus changing the rect's
    #   ending bounds while leaving its starting bounds untouched.
    #---------------------------------------------------------------------------
    def subrect!(rect, horizontal, vertical = 0.0)
      w = rect.width  * horizontal
      h = rect.height * vertical
      
      rect.x      += [w, 0].max
      rect.width  -= w.abs
      rect.y      += [h, 0].max
      rect.height -= h.abs
      
      return rect
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
      #     note : The note field or string
      #     tag  : The tag's name i.e. :Expertise will search for <Expertise>
      #
      #     returns: Array of MatchData objects holding matched notetags info
      #-------------------------------------------------------------------------
      def scan_tags(note, tag)
        note.to_enum(:scan, regex(tag)).map { Regexp.last_match }
      end
      #-------------------------------------------------------------------------
      # * Regex for retrieving notetags in the following formats:
      #   <tag>
      #   <tag> code </tag>
      #   <tag: a>
      #   <tag: a> code </tag>
      #   <tag: a, b>
      #   <tag: a, b> code </tag>
      #   <tag: a, b, c>
      #   <tag: a, b, c> code </tag>
      #-------------------------------------------------------------------------
      def regex(tag)
        %r{
          (<\s*#{tag}\s*)            # <tag    the tag name
          (:\s*(?<st>.*?)?           # :first  the first value (optional)
          (,\s*(?<nd>.*?))?          # ,second the second value (optional)
          (,\s*(?<rd>.*?))?)?        # ,third  the third value (optional)
          (>\s*)                     # >       closing tag
          # Lunatic Mode (optional)
          (                          #         Grouping lunatic mode
            (?<lu>.*?)               #         the lunatic expression's content
            (\s*<\s*\/\s*#{tag}\s*>) # </tag>  the end tag for lunatic mode
          )?                         #         Closing lunatic mode group
        }ixm
      end
    end
  end

  #=============================================================================
  # ** CCPet
  #-----------------------------------------------------------------------------
  #  Module for accessing database references while logging errors
  #=============================================================================

  class << self
    #---------------------------------------------------------------------------
    # * Easy database actor access
    #     id: Actor's Database ID
    #
    #     returns: the actor from the database
    #---------------------------------------------------------------------------
    def actor(id)
      $game_actors[id] || log("Cannot find actor of index #{id}")
    end
    #---------------------------------------------------------------------------
    # * Easy battle party member access
    #     id: Actor's position between 0 and 3 in current battle party
    #
    #     returns: the actor from the party
    #---------------------------------------------------------------------------
    def member(id)
      $game_party.members[id] || log("Cannot find member of index #{id}")
    end
    #---------------------------------------------------------------------------
    # * Validates script requirements
    #     script: Symbol used to define the script in the $imported hash
    #     version: (used only for recursive calls) Minimum version number
    #
    #     returns: true if the requirements are met
    #---------------------------------------------------------------------------
    def requires_met?(script, version = 0)
      data = ($imported[script] = ImportationData.convert $imported[script])
      return false unless data && data >= version
      data.requires.keys.all? { |key| requires_met?(key, data.requires[key]) }
    end
  end

  class << self
    old_requires_met? = requires_met?
    def requires_met?(*args)
      return @memo[args] unless defined? (@memo ||= {})[args]
      @memo[args] = old_requires_met?.(*args)
    end
  end

  class << self
    old_requires_met? = requires_met?
    def requires_met?(script, version = 0.0)  
      result = old_requires_met?.(script, version)
      status = result ? "SUCCESS" : "FAILURE"
      puts("Requirements for #{script} version#{version} : #{status}")
      result
    ends
  end if DEBUG

  class ::Object;  def to_h;      Hash[self]; end; end
  class ::Hash;    def to_h;      self;       end; end
  class ::Numeric; def positive?; self >= 0;  end; end
  
  module ::Kernel;
    private
    def log(*args); puts(*args); end if     DEBUG
    def log(*args);         nil; end unless DEBUG
  end
  
  #=============================================================================
  # ** ImportationData
  #-----------------------------------------------------------------------------
  #  Represents "Script Importing" information, holding number versions a
  #  required scripts hash.
  #
  #  Note: Objects of this class behaves like numbers if used as number, by
  # assuming the value of its version number.
  #  Also, objects of this class behaves like hashes too, if used as such.
  #=============================================================================
  class ImportationData
    class << self
      #-------------------------------------------------------------------------
      # * Converts data into Importation Data
      #     data : Can be either a boolean, number or Hash
      #
      #     returns: ImportationData Object if data is a Numeric or a Hash
      #     returns: false if data is false or nil
      #     returns: The own data if it is an instance of ImportationData
      #-------------------------------------------------------------------------
      def convert(data)
        return false unless data
        return data if data.is_a? ImportationData
        ImportationData.new data
      end
    end
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(data)
      @hash     = data.is_a?(Hash) ? data : {}
      @version  = (@hash[:version ] ||= data.is_a?(Numeric) ? data : 0.00)
      @requires = (@hash[:requires] ||= {})
    end
    #---------------------------------------------------------------------------
    # * Gets the script's version number
    #---------------------------------------------------------------------------
    def version
      @hash[:version] ||= 0
    end
    #---------------------------------------------------------------------------
    # * Gets the script's required scripts
    #---------------------------------------------------------------------------
    def requires
      @hash[:requires] ||= {}
    end
    #---------------------------------------------------------------------------
    # * Delegates calls version, and then to the hash itself.
    #---------------------------------------------------------------------------
    #   This method makes this object behave like its a number if used as number
    # and make this object behave like a hash if its used like a hash.
    #   When used as number, it will assume the value of its version number.
    #---------------------------------------------------------------------------
    def method_missing(method, *args, &block)
      return version.send(method, *args, &block) if version.respond_to?(method)
      return   @hash.send(method, *args, &block) if   @hash.respond_to?(method)
      super(method, *args, &block)
    end
    #---------------------------------------------------------------------------
    # * Overrides the respond_to? method to inform this method can work as a
    # number or hash.
    #---------------------------------------------------------------------------
    def respond_to?(method, include_private = false)
      version.respond_to?(method, include_private) ||
        @hash.respond_to?(method, include_private) ||
                    super(method, include_private)
    end
    #---------------------------------------------------------------------------
    # * Overrides the is_a? method to inform this method can work as a
    # number or hash.
    #---------------------------------------------------------------------------
    def is_a? (*args)
      version.is_a?(*args) || @hash.is_a?(*args) || super(*args)
    end
    #---------------------------------------------------------------------------
    # * Overrides the to_s to show the hash contents
    #---------------------------------------------------------------------------
    def to_s
      @hash.to_s
    end
  end
end if ($imported ||= {})[:CCPet]
  
#-------------------------------------------------------------------------------
# End of script.
#-------------------------------------------------------------------------------

class CrossCut

  def initialize(clazz)
    @clazz = clazz
  end

  def around(meth, &advice)
    new_name = next_name(meth)
    @clazz.alias_method(new_name, meth)
    @clazz.define_method(meth) do |*args, &block|
      advice.(method(new_name), *args, &block)
    end
  end

  def after(meth, &advice)
    new_name = next_name(meth)
    @clazz.alias_method(new_name, meth)
    @clazz.define_method(meth) do |*args, &block|
      result = method(new_name).(*args, &block)
      advice.(result, *args, &block)
      result
    end
  end

  def after!(meth, &advice)
    new_name = next_name(meth)
    @clazz.alias_method(new_name, meth)
    @clazz.define_method(meth) do |*args, &block|
      result = method(new_name).(*args, &block)
      advice.(result, *args, &block)
    end
  end

  def before(meth, &advice)
    new_name = next_name(meth)
    @clazz.alias_method(new_name, meth)
    @clazz.define_method(meth) do |*args, &block|
      advice.(*args, &block)
      method(new_name).(*args, &block)
    end
  end

  private

  def next_name(base)
    name = base
    nesting = 0
    name = calc_name(base, nesting+=1) while taken?(name)
    name
  end
  
  def calc_name(base, nesting)
    "cut#{nesting}_#{base}".to_sym
  end

  def taken?(name)
    @clazz.instance_methods.include? name
  end
end

class Class
  def cut
    @cross_cut ||= CrossCut.new(self)
  end
end

class Clazz
  def olds(str)
    puts str
    yield
    return 4
  end
end

Clazz.new.olds("very old") { puts "very old block" }

class Clazz
  cut.around :olds do |old, str, &block|
    a =  old.call str, &block
    puts str*2
    block.call
    a
  end
end

class Clazz
  cut.around :olds do |old, str, other, &block|
    a = old.call(str) { puts "fezes"}
    puts str + other
    block.call
    a
  end

  cut.before :olds do |str, other, &block|
    puts "BEFORE"
  end

  cut.after :olds do |r, str, other, &block|
    puts "After:#{r}"
    next 2
  end
end

Clazz.new.olds("oldson", "asdasda") { puts "blockson"}