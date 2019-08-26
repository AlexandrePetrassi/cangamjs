=begin
#==============================================================================
# ** Victor Engine - Toggle Target
#------------------------------------------------------------------------------
# Author : Victor Sant
#
# Version History:
#  v 1.00 - 2013.01.24 > First relase
#  v 1.01 - 2013.02.13 > Added scope toggle on menus
#                      > Compatibility with Action Effectiveness
#------------------------------------------------------------------------------
#  This script allows to setup certain action to have a option to toggle the
# targets of the action. You can switch between single/all targers or between
# allies/opponents. You can also setup actions to deal less damage if targeting
# all or have them to have the damage divided by the number of targets.
#------------------------------------------------------------------------------
# Compatibility
#   Requires the script 'Victor Engine - Basic Module' v 1.35 or higher
#   If used with 'Victor Engine - ' place this bellow it.
#
# * Overwrite methods
#   class Game_Action
#     def item
#     def attack?
#
# * Alias methods
#   class Game_Battler < Game_BattlerBase
#     def item_value_recover_hp(user, item, effect)
#     def item_value_recover_mp(user, item, effect)
#     def item_value_gain_tp(user, item, effect)
#     def item_apply(user, item)
#     def apply_guard(damage)
#     def use_item(item)
#
#   class Scene_Battle < Scene_Base
#     def update_all_windows
#     def command_attack
#     def on_skill_ok
#     def on_item_ok
#
#------------------------------------------------------------------------------
# Instructions:
#  To instal the script, open you script editor and paste this script on
#  a new section bellow the Materials section. This script must also
#  be bellow the script 'Victor Engine - Basic'
#
#------------------------------------------------------------------------------
# Skills and Items note tags
#   Tags to be used on the Skills and Items note box in the database
#
#  <scope toggle>
#   Actions with this tag can switch between single/all targers.
#
#  <target toggle>
#   Actions with this tag can switch between allies/opponents.
#
#  <split damage>
#   Actions with this tag will have it's damage divided by the number of
#   targets.
#
#  <all rate: x%>
#   Actions with this tag will have it's damage multiplied b x% when targeting
#   all, valid only with the tag <scope toggle>
#     x : damage rate
#
#  <scope validation>
#   Valid only on actions with <scope toggle>. Actions with this tag will be
#   only allowed to be toggled if the actor have the <scope validation> trait.
#
#  <target validation>
#   Valid only on actions with <target toggle>. Actions with this tag will be
#   only allowed to be toggled if the actor have the <target validation> trait.
#
#------------------------------------------------------------------------------
# Actors, Classes, States, Weapons and Armos note tags
#   Tags to be used on the Actors, Classes, States, Weapons and Armos note
#   box in the database
#
#  <scope validation>
#   This tag add a trait that allows to toggle the scope of actions with the
#   <scope validation> tag
#
#  <target validation>
#   This tag add a trait that allows to toggle the targets of actions with the
#   <target validation> tag
#
#------------------------------------------------------------------------------
# Additional instructions:
#
#   The <split damage> can be used on any actions, even the ones without the
#   tag <scope toggle>.
#
#==============================================================================

#==============================================================================
# ** Victor Engine
#------------------------------------------------------------------------------
#   Setting module for the Victor Engine
#==============================================================================

module Victor_Engine
  #--------------------------------------------------------------------------
  # * Setup the key that must be pressed for toggling scope (One / All)
  #    :A >> keyboard Shift  :B >> keyboard X      :C >> keyboard Z
  #    :X >> keyboard A      :Y >> keyboard S      :Z >> keyboard D
  #    :L >> keyboard Q      :R >> keyboard W
  #   you can add more than one key, you can press any of them
  #--------------------------------------------------------------------------
  VE_TOGGLE_SCOPE_KEYS = [:L, :R]
  #--------------------------------------------------------------------------
  # * Setup the key that must be pressed for toggling targets (Ally / Enemy)
  #    :A >> keyboard Shift  :B >> keyboard X      :C >> keyboard Z
  #    :X >> keyboard A      :Y >> keyboard S      :Z >> keyboard D
  #    :L >> keyboard Q      :R >> keyboard W
  #   you can add more than one key, you can press any of them
  #--------------------------------------------------------------------------
  VE_TOGGLE_TARGET_KEYS  = [:X, :Y]
  #--------------------------------------------------------------------------
  # * required
  #   This method checks for the existance of the basic module and other
  #   VE scripts required for this script to work, don't edit this
  #--------------------------------------------------------------------------
  def self.required(name, req, version, type = nil)
    if !$imported[:ve_basic_module]
      msg = "The script '%s' requires the script\n"
      msg += "'VE - Basic Module' v%s or higher above it to work properly\n"
      msg += "Go to http://victorenginescripts.wordpress.com/ to download this script."
      msgbox(sprintf(msg, self.script_name(name), version))
      exit
    else
      self.required_script(name, req, version, type)
    end
  end
  #--------------------------------------------------------------------------
  # * script_name
  #   Get the script name base on the imported value
  #--------------------------------------------------------------------------
  def self.script_name(name, ext = "VE")
    name = name.to_s.gsub("_", " ").upcase.split
    name.collect! {|char| char == ext ? "#{char} -" : char.capitalize }
    name.join(" ")
  end
end

$imported ||= {}
$imported[:ve_toggle_target] = 1.01
Victor_Engine.required(:ve_toggle_target, :ve_basic_module, 1.35, :above)

#==============================================================================
# ** RPG::UsableItem
#------------------------------------------------------------------------------
#  This is the superclass for skills and items.
#==============================================================================

class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # * New method: need_selection?
  #--------------------------------------------------------------------------
  def need_selection?
    @scope > 0
  end
  #--------------------------------------------------------------------------
  # * New method: scope_validation?
  #--------------------------------------------------------------------------
  def scope_validation?
    note =~ /<SCOPE VALIDATION>/i && scope_toggle?
  end
  #--------------------------------------------------------------------------
  # * New method: target_validation?
  #--------------------------------------------------------------------------
  def target_validation?
    note =~ /<TARGET VALIDATION>/i && target_toggle?
  end
  #--------------------------------------------------------------------------
  # * New method: scope_toggle?
  #--------------------------------------------------------------------------
  def scope_toggle?
    note =~ /<SCOPE TOGGLE>/i
  end
  #--------------------------------------------------------------------------
  # * New method: target_toggle?
  #--------------------------------------------------------------------------
  def target_toggle?
    note =~ /<TARGET TOGGLE>/i
  end
  #--------------------------------------------------------------------------
  # * New method: split_damage?
  #--------------------------------------------------------------------------
  def split_damage?
    note =~ /<SPLIT DAMAGE>/i
  end
  #--------------------------------------------------------------------------
  # * New method: all_rate
  #--------------------------------------------------------------------------
  def all_rate
    return @all_rate if @all_rate
    regexp       = /<ALL RATE: *(\d+)%?>/i 
    @all_rate = note =~ regexp ? $1.to_f / 100.0 : 1.0
    @all_rate
  end
  #--------------------------------------------------------------------------
  # * New method: scope_switch
  #--------------------------------------------------------------------------
  def scope_switch
    scope = @scope
    @scope = 2  if scope == 1
    @scope = 1  if scope == 2
    @scope = 8  if scope == 7
    @scope = 7  if scope == 8
    @scope = 10 if scope == 9
    @scope = 9  if scope == 10
  end
  #--------------------------------------------------------------------------
  # * New method: target_switch
  #--------------------------------------------------------------------------
  def target_switch
    scope  = @scope
    @scope = 7 if scope == 1
    @scope = 1 if scope == 7
    @scope = 8 if scope == 8
    @scope = 2 if scope == 2
  end
end

#==============================================================================
# ** Game_Action
#------------------------------------------------------------------------------
#  This class handles battle actions. This class is used within the
# Game_Battler class.
#==============================================================================

class Game_Action
  #--------------------------------------------------------------------------
  # * Overwrite method: item
  #--------------------------------------------------------------------------
  def item
    @object = nil                if @item.is_nil?
    @object = @item.object.clone if different_object? && !@item.is_nil?
    @object
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: attack?
  #--------------------------------------------------------------------------
  def attack?
    @item.object == $data_skills[subject.attack_skill_id]
  end
  #--------------------------------------------------------------------------
  # * New method: different_object?
  #--------------------------------------------------------------------------
  def different_object?
    @object.class != @item.object.class || !@object ||
    @object.id    != @item.object.id
  end
  #--------------------------------------------------------------------------
  # * New method: setup_scope
  #--------------------------------------------------------------------------
  def setup_scope(scope)
    item.scope = scope if item
  end
  #--------------------------------------------------------------------------
  # * New method: scope_switch
  #--------------------------------------------------------------------------
  def scope_switch
    return unless item
    item.scope_switch
  end
  #--------------------------------------------------------------------------
  # * New method: target_switch
  #--------------------------------------------------------------------------
  def target_switch
    return unless item
    item.target_switch
  end
end

#==============================================================================
# ** Game_Battler
#------------------------------------------------------------------------------
#  This class deals with battlers. It's used as a superclass of the Game_Actor
# and Game_Enemy classes.
#==============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Alias method: item_effect_recover_hp
  #--------------------------------------------------------------------------
  alias :item_value_recover_hp_ve_toggle_target :item_value_recover_hp
  def item_value_recover_hp(user, item, effect)
    value = item_value_recover_hp_ve_toggle_target(user, item, effect)
    value *= @all_damage / [@split_damage, 1].max
  end
  #--------------------------------------------------------------------------
  # * Alias method: item_effect_recover_mp
  #--------------------------------------------------------------------------
  alias :item_value_recover_mp_ve_toggle_target :item_value_recover_mp
  def item_value_recover_mp(user, item, effect)
    value = item_value_recover_mp_ve_toggle_target(user, item, effect)
    value *= @all_damage / [@split_damage, 1].max
  end
  #--------------------------------------------------------------------------
  # * Alias method: item_effect_recover_tp
  #--------------------------------------------------------------------------
  alias :item_value_recover_tp_ve_toggle_target :item_value_recover_tp
  def item_value_recover_tp(user, item, effect)
    value = item_value_recover_tp_ve_toggle_target(user, item, effect)
    value *= @all_damage / [@split_damage, 1].max
  end
  #--------------------------------------------------------------------------
  # * Alias method: item_apply
  #--------------------------------------------------------------------------
  alias :item_apply_ve_toggle_target :item_apply
  def item_apply(user, item)
    make_damage_rate(user, item)
    item_apply_ve_toggle_target(user, item)
  end
  #--------------------------------------------------------------------------
  # * Alias method: apply_guard
  #--------------------------------------------------------------------------
  alias :apply_guard_all_ve_toggle_target :apply_guard
  def apply_guard(damage)
    damage  = apply_guard_all_ve_toggle_target(damage)
    damage *= @all_damage
    damage /= [@split_damage, 1].max
    damage
  end
  #--------------------------------------------------------------------------
  # * Alias method: use_item
  #--------------------------------------------------------------------------
  alias :use_item_all_ve_toggle_target :use_item
  def use_item(item)
    @target_size = set_target_size(item)
    use_item_all_ve_toggle_target(item)
  end
  #--------------------------------------------------------------------------
  # * New method: make_damage_all_rate
  #--------------------------------------------------------------------------
  def make_damage_rate(user, item)
    @all_damage   = user.all_damage?(item)   ? item.all_rate    : 1.0
    @split_damage = user.split_damage?(item) ? user.target_size : 1.0
  end
  #--------------------------------------------------------------------------
  # * New method: all_damage?
  #--------------------------------------------------------------------------
  def all_damage?(item)
    item.for_all? && item.scope_toggle? && target_size > 1
  end
  #--------------------------------------------------------------------------
  # * New method: split_damage?
  #--------------------------------------------------------------------------
  def split_damage?(item)
    item.for_all? && item.split_damage? && target_size > 1
  end
  #--------------------------------------------------------------------------
  # * New method: target_size
  #--------------------------------------------------------------------------
  def target_size
    @target_size ? @target_size : 1
  end
  #--------------------------------------------------------------------------
  # * New method: set_target_size
  #--------------------------------------------------------------------------
  def set_target_size(item)
    return opponents_unit.alive_members.size if item.for_opponent?
    return friends_unit.dead_members.size    if item.for_dead_friend?
    return friends_unit.alive_members.size   if item.for_friend?
    return 1
  end
  #--------------------------------------------------------------------------
  # * New method: scope_toggle?
  #--------------------------------------------------------------------------
  def scope_toggle?(item)
    !item.scope_validation? || get_all_notes =~ /<SCOPE VALIDATION>/i
  end
  #--------------------------------------------------------------------------
  # * New method: target_toggle?
  #--------------------------------------------------------------------------
  def target_toggle?(item)
    !item.target_validation? || get_all_notes =~ /<TARGET VALIDATION>/i
  end
end

#==============================================================================
# ** Window_Selectable
#------------------------------------------------------------------------------
#  This window contains cursor movement and scroll functions.
#==============================================================================

class Window_Selectable < Window_Base
  #--------------------------------------------------------------------------
  # * New method: set_action
  #--------------------------------------------------------------------------
  def set_action(action)
    @action = action
  end
  #--------------------------------------------------------------------------
  # * New method: scope_toggle?
  #--------------------------------------------------------------------------
  def scope_toggle?(battler)
    active && VE_TOGGLE_SCOPE_KEYS.any? {|i| Input.trigger?(i) } &&
    @action && @action.scope_toggle? && battler.scope_toggle?(@action)
  end
  #--------------------------------------------------------------------------
  # * New method: target_toggle?
  #--------------------------------------------------------------------------
  def target_toggle?(battler)
    active  && VE_TOGGLE_TARGET_KEYS.any? {|i| Input.trigger?(i) } &&
    @action && @action.target_toggle? && battler.target_toggle?(@action)
  end
  #--------------------------------------------------------------------------
  # * New method: menu_toggle?
  #--------------------------------------------------------------------------
  def menu_toggle?(item)
    @action = item
    active && $game_party.alive_members.any? {|actor| scope_toggle?(actor) }
  end
end

#==============================================================================
# ** Scene_ItemBase
#------------------------------------------------------------------------------
#  This is the superclass for the classes that performs the item and skill
# screens.
#==============================================================================

class Scene_ItemBase < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Overwrite method: item
  #--------------------------------------------------------------------------
  def item
    @item ? @item : @item_window.item
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: update_all_windows
  #--------------------------------------------------------------------------
  def update_all_windows
    super
    update_actor_toggle if @actor_window.menu_toggle?(item)
  end
  #--------------------------------------------------------------------------
  # * Alias method: on_actor_cancel
  #--------------------------------------------------------------------------
  alias :on_actor_cancel_ve_toggle_target :on_actor_cancel
  def on_actor_cancel
    on_actor_cancel_ve_toggle_target
    @item = nil
  end
  #--------------------------------------------------------------------------
  # * New method: update_actor_toggle
  #--------------------------------------------------------------------------
  def update_actor_toggle
    @item = item.clone
    @item.scope_switch
    @actor_window.select_for_item(item)
  end
end

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#  This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # * Overwrite method: update_all_windows
  #--------------------------------------------------------------------------
  alias :update_all_ve_toggle_target :update_all_windows
  def update_all_windows
    update_target_scope_toggle
    $imported[:ve_active_time_battle] ? update_all_ve_toggle_target : super
  end
  #--------------------------------------------------------------------------
  # * Alias method: command_attack
  #--------------------------------------------------------------------------
  alias :command_attack_ve_toggle_target :command_attack
  def command_attack
    set_window_action($data_skills[BattleManager.actor.attack_skill_id])
    command_attack_ve_toggle_target
  end
  #--------------------------------------------------------------------------
  # * Alias method: on_skill_ok
  #--------------------------------------------------------------------------
  alias :on_skill_ok_ve_toggle_target :on_skill_ok
  def on_skill_ok
    set_window_action(@skill_window.item)
    on_skill_ok_ve_toggle_target
  end
  #--------------------------------------------------------------------------
  # * Alias method: on_item_ok
  #--------------------------------------------------------------------------
  alias :on_item_ok_ve_toggle_target :on_item_ok
  def on_item_ok
    set_window_action(@item_window.item)
    on_item_ok_ve_toggle_target
  end
  #--------------------------------------------------------------------------
  # * New method: set_window_action
  #--------------------------------------------------------------------------
  alias :set_window_action_ve_toggle_target :set_window_action if $imported[:ve_target_arrow]
  def set_window_action(item)
    if $imported[:ve_target_arrow]
      set_window_action_ve_toggle_target(item)
    else
      @enemy_window.set_action(item) if item.for_opponent?
      @actor_window.set_action(item) if item.for_friend?
      @enemy_window.cursor_all = item.for_opponent? && item.for_all?
      @actor_window.cursor_all = item.for_friend?   && item.for_all?
    end
  end
  #--------------------------------------------------------------------------
  # * New method: update_target_scope_toggle
  #--------------------------------------------------------------------------
  def update_target_scope_toggle
    update_scope_toggle
    update_target_toggle
  end
  #--------------------------------------------------------------------------
  # * New method: update_scope_toggle
  #--------------------------------------------------------------------------
  def update_scope_toggle
    actor = BattleManager.actor
    return update_enemy_scope if @enemy_window.scope_toggle?(actor)
    return update_actor_scope if @actor_window.scope_toggle?(actor)
  end
  #--------------------------------------------------------------------------
  # * New method: update_target_toggle
  #--------------------------------------------------------------------------
  def update_target_toggle
    actor = BattleManager.actor
    return update_enemy_toggle if @enemy_window.target_toggle?(actor)
    return update_actor_toggle if @actor_window.target_toggle?(actor)
  end
  #--------------------------------------------------------------------------
  # * New method: update_enemy_scope
  #--------------------------------------------------------------------------
  def update_enemy_scope
    BattleManager.actor.input.scope_switch
    set_window_action(BattleManager.actor.input.item)
    @enemy_window.update_cursor
  end
  #--------------------------------------------------------------------------
  # * New method: update_actor_scope
  #--------------------------------------------------------------------------
  def update_actor_scope
    BattleManager.actor.input.scope_switch
    set_window_action(BattleManager.actor.input.item)
    @actor_window.update_cursor
  end
  #--------------------------------------------------------------------------
  # * New method: update_enemy_toggle
  #--------------------------------------------------------------------------
  def update_enemy_toggle
    BattleManager.actor.input.target_switch
    set_window_action(BattleManager.actor.input.item)
    @enemy_window.hide.deactivate
    select_actor_selection
  end
  #--------------------------------------------------------------------------
  # * New method: update_actor_toggle
  #--------------------------------------------------------------------------
  def update_actor_toggle
    BattleManager.actor.input.target_switch
    set_window_action(BattleManager.actor.input.item)
    @actor_window.hide.deactivate
    select_enemy_selection
  end
end
=end