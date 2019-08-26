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

($imported ||= {})[:CaRaCrAzY_Core] = 1.00

#===============================================================================
# ** CaRaCrAzY
#-------------------------------------------------------------------------------
#   Module used for Namespacing the Expertise System
#   Everything about this system is contained inside this module.
#===============================================================================

module CaRaCrAzY
  
  #-----------------------------------------------------------------------------
  # * Debug mode
  #-----------------------------------------------------------------------------
  #  Scripts requiring this module may log info in the game console.
  #  Disable this flag if you do not wish those info being logged.
  #-----------------------------------------------------------------------------
  DEBUG = true
  
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
      #     recursions : additional iterations for shrinking to 1/4, 1/8...
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
    #-------------------------------------------------------------------------
    def draw_actor_icon(actor, x, y, enabled = true)
      draw_face_icon(actor.face_name, actor.face_index, x, y, enabled)
    end
    #-------------------------------------------------------------------------
    # * Draw Face Graphic
    #     enabled : Enabled flag. When false, draw semi-transparently.
    #-------------------------------------------------------------------------
    def draw_face_icon(face_name, face_index, x, y, enabled = true)
      bitmap = Window.face_icon(face_name)
      rect = Rect.new(face_index % 4 * 24, face_index / 4 * 24, 24, 24)
      contents.blt(x, y, bitmap, rect, enabled ? 255 : translucent_alpha)
    end
    #---------------------------------------------------------------------------
    # * Slices a rect
    #     horizontal : slice's horizontal ratio between -1.0 and 1.0
    #     vertical   : slice's vertical ratio between -1.0 and 1.0
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
      #-------------------------------------------------------------------------
      def scan_tags(note, tag)
        note.to_enum(:scan, regex(tag)).map { Regexp.last_match }
      end
      #-------------------------------------------------------------------------
      # * Regex for retrieving notetags in the following formats:
      #   <tag>
      #   <tag> lunatic </tag>
      #   <tag: a>
      #   <tag: a> lunatic </tag>
      #   <tag: a, b>
      #   <tag: a, b> lunatic </tag>
      #   <tag: a, b, c>
      #   <tag: a, b, c> lunatic </tag>
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
  # ** Get
  #-----------------------------------------------------------------------------
  #  Module for safely accessing database references
  #=============================================================================

  class ::Get
    class << self
      #-------------------------------------------------------------------------
      # * Returns the actor from the database
      #-------------------------------------------------------------------------
      #     id: Actor's Database ID
      #-------------------------------------------------------------------------
      def actor(id)
        $game_actors[id] || log "Cannot find actor of index #{id}"
      end
      #-------------------------------------------------------------------------
      # * Returns the actor from the party
      #-------------------------------------------------------------------------
      #     id: Actor's position between 0 and 3 in current battle party
      #-------------------------------------------------------------------------
      def member(id)
        $game_party.members[id] || log "Cannot find member of index #{id}"
      end
      #-------------------------------------------------------------------------
      # * Returns the class from the database
      #-------------------------------------------------------------------------
      #     id: Class's Database ID
      #-------------------------------------------------------------------------
      def class(id)
        $data_classes[id] || log "Cannot find class of index #{id}"
      end
      #-------------------------------------------------------------------------
      # * Returns the skill from the database
      #-------------------------------------------------------------------------
      #     id: Skill's Database ID
      #-------------------------------------------------------------------------
      def skill(id)
        $data_skills[id] || log "Cannot find skill of index #{id}"
      end
      #-------------------------------------------------------------------------
      # * Returns the item from the database
      #-------------------------------------------------------------------------
      #     id: Item's Database ID
      #-------------------------------------------------------------------------
      def item(id)
        $data_items[id] || log "Cannot find item of index #{id}"
      end
      #-------------------------------------------------------------------------
      # * Returns the weapon from the database
      #-------------------------------------------------------------------------
      #     id: Weapon's Database ID
      #-------------------------------------------------------------------------
      def weapon(id)
        $data_weapon[id] || log "Cannot find weapon of index #{id}"
      end
      #-------------------------------------------------------------------------
      # * Returns the armor from the database
      #-------------------------------------------------------------------------
      #     id: Armor's Database ID
      #-------------------------------------------------------------------------
      def armor(id)
        $data_armor[id] || log "Cannot find armor of index #{id}"
      end
      #-------------------------------------------------------------------------
      # * Returns the enemy from the database
      #-------------------------------------------------------------------------
      #     id: Enemy's Database ID
      #-------------------------------------------------------------------------
      def enemy(id)
        $data_enemies[id] || log "Cannot find enemy of index #{id}"
      end
      #-------------------------------------------------------------------------
      # * Returns the troop from the database
      #-------------------------------------------------------------------------
      #     id: Troop's Database ID
      #-------------------------------------------------------------------------
      def troop(id)
        $data_troops[id] || log "Cannot find troop of index #{id}"
      end
    end
  end
  
  class ::Object;  def to_h;      Hash[self]; end; end
  class ::Hash;    def to_h;      self;       end; end
  class ::Numeric; def positive?; self >= 0;  end; end

  def self.log(info);            end unless DEBUG
  def self.log(info); puts info; end if     DEBUG
    
end
  
#-------------------------------------------------------------------------------
# End of script.
#-------------------------------------------------------------------------------
