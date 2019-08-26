=begin
#===============================================================================
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
#===============================================================================
# ▼ Script Information
#===============================================================================
# Script   : Expertise System
# Author   : CaRa_CrAzY Petrassi
# Level    : Advanced (Support for Notetags, Module Config and Lunatic Mode)
# Requires : n/a
# Version  : 1.00
# Date     : 2019.04.22
#
#===============================================================================
# ▼ Description
#===============================================================================
# This script enables : 
# • Players to expend earned Expertise Points to improve a character's Skills.
# • Skill bonuses from equipment, statuses, carried items, or any BaseItem.
# • Access to a Menu for Expertise Point allocation and bonus inspecting.
#
#===============================================================================
# ▼ Table of Contents
#===============================================================================
# 1. Terms of use ........................................................[p001]
# 2. Installation ........................................................[p002]
# 3. Demo Project ........................................................[p003]
# 4. Instructions ........................................................[p004]
# 4.1. Instructions - List of Features ...................................[p014]
#   I    - Expertise .....................................................[p114]
#   II   - Expertise Points ..............................................[p214]
#   III  - Expertise Point Growth Formula ................................[p314]
#   IV   - Expertise Menu Scene ..........................................[p414]
#   V    - Main Menu Entry ...............................................[p514]
#   VI   - Main Menu Expertise Points Display ............................[p614]
#   VII  - Expertise Types ...............................................[p714]
#   VIII - Expertise Bonuses .............................................[p814]
#   IX   - Expertise Bonus Inspector .....................................[p914]
# 4.2. Instructions - List of Notetags ...................................[p024]
#   I    - Expertise Notetag .............................................[p124]
#   II   - Expertise-Growth Notetag ......................................[p224]
#   III  - Bonus Notetags and variations .................................[p324]
#   IV   - Synergy Notetag ...............................................[p424]
#   V    - Descriptor Notetag ............................................[p524]
# 4.3. Instructions - List of Script Calls ...............................[p034]
#   I    - Invoke Expertise Menu .........................................[p134]
#   II   - Get Expertise Value ...........................................[p234]
#   III  - Toogle Expertise Menu Entry ...................................[p334]
# 4.4. Instructions - Expertise Bonuses ..................................[p044]
#   I    - What are Bonuses ..............................................[p144]
#   II   - Expertise Types ...............................................[p244]
#   III  - Descriptors ...................................................[p344]
#   IV   - Scopes ........................................................[p444]
#   V    - Modes .........................................................[p544]
#   VI   - Individual Modes ..............................................[p644]
#   VII  - Synergy .......................................................[p744]
#   VIII - Conditional Bonuses ...........................................[p844]
#   IX   - Bonus Algorithm: How the final values are calculated ..........[p944]
# 5. Configuration .......................................................[p005]
# 5.1. Configuration - Basic Features ....................................[p015]
#   I    - Expertise Point Awarding on Level Up ..........................[p115]
#   II   - Expertise Display in Main Menu ................................[p215]
#   III  - Expertise Menu Entry in Main Menu .............................[p315]
#   IV   - Expertise Menu Entry Visual Effects ...........................[p415]
#   V    - General Expertise Growth Formula ..............................[p515]
# 5.2. Configuration - Vocabulary ........................................[p025]
# 5.3. Configuration - Notetags ..........................................[p035]
# 6. Compatibility .......................................................[p006]
# 6.1. Compatibility - Aliases ...........................................[p016]
# 6.2. Compatibility - New Methods .......................................[p026]
# 7. Version History .....................................................[p007]
#
#===============================================================================
# 1. Terms of Use [p001]
#===============================================================================
# 1. Use permitted for non-commercial and commercial games.
# 2. This header must be preserved.
# 3. This script is provided as-is.
#
#===============================================================================
# 2. Installation [p002]
#===============================================================================
# Open your script editor and paste this script on a new section bellow the
# Materials section, then follow the instructions for setting it up properly.
#
#===============================================================================
# 3. Demo Project [p003]
#===============================================================================
# You can download a demo project showcasing all this script's features by
# following any of the links bellow:
#   • GitHub         : https://placeholder
#   • GitLab         : https://placeholder
#   • Itch.io        : https://placeholder
#   • Steam Workshop : https://placeholder
#
# For general discussions, follow the link:
#   • RPG Maker Web  : https://placeholder
#
#===============================================================================
# 4. Instructions [p004]
#===============================================================================
# If no conflicts occur, after installing this script without further 
# configuration and pressing the playtest button you will see a new entry in 
# the main menu called [Expertise].
#
# This new option leads to the Expertise Menu scene, a place where the player
# may allocate Expertise Points to improve the Expertise of a party member in 
# any learned Skill. This menu is optional and can be disabled if you wish.
#
# At first no skills will be listed under the new Expertise Menu, even if a
# character has already learned some skills. For a learned skill to be listed 
# under this menu, you need to mark it as an Expertise Skill in the database 
# using the following notetag:
#  <expertise: x>
#  x : Expertise Type's name
#
# Expertise Types are analogous to Skill Types, and group together skills in
# categories under the Expertise Menu, like Skill Types do in the Skills Menu.
#
# To earn Expertise Points, a character needs to Level Up. After each Level Up
# some Expertise Points are awarded to that character based on a formula which 
# can be edited as you see fit by using an advanced notetag.
# 
# Many of these features can be disabled if not needed. If you choose to 
# disable all of them, you can still invoke the Expertise Menu, allocate or
# award expertise points from direct script calls through events. Read the 
# following sections for more info.
# 
#===============================================================================
# 4.1. Instructions - List of Features [p014]
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# In this section you will find information describing this script's features.
# Some are very straight forward, but others require further reading and will
# redirect you to the proper sections.
#
#-------------------------------------------------------------------------------
# I - Expertise [p114]
#-------------------------------------------------------------------------------
#   Each Actor's skill may have an Expertise value associated with it. This 
#   value can be used later to set skill checks or used in formulas for damage
#   calculations and the like. They can also vary based on different bonus
#   types provenient from equipment, inventory items and much more. The 
#   possibilities are up to you as a developer.
#   The Expertise is this script's core feature, thus it cannot be disabled.
#
#   Go to [p814] for more info about Bonuses
#
#-------------------------------------------------------------------------------
# II - Expertise Points [p214]
#-------------------------------------------------------------------------------
#   Actors may earn Expertise Points to later invest in Expertise for their 
#   skills. These points can be earned automatically at Level Up or manually
#   by some sort of event you come to design.
#
#   The amount of Expertise Points awarded to an Actor at Level Up is dependant
#   on a formula.
#   Go to [p314] for more info about Expertise Point Growth Formula.
#
#   The automatic Level Up Expertise Point awarding can be disabled entirely by
#   setting a configuration flag. 
#   Go to [p115] for more info about Expertise Point Awarding on Level Up.
#
#-------------------------------------------------------------------------------
# III - Expertise Point Growth Formula [p314]
#-------------------------------------------------------------------------------
#   A custom formula can be set up using a notetag to designate an Expertise
#   Point Growth Rate for a particular actor. A general formula can also be
#   set at the configuration section which is applied for any actors lacking a
#   custom Expertise Point Growth Formula.
#   These formulas function in a similar fashion to regular damage formulas, so
#   you could write "a.mat + 1", for example, to achieve a behaviour that
#   every time an Actor Levels Up, it will be awarded a quantity of Expertise
#   Points equal to its Magical Attack Power plus One.
#
#   Go to [p224] for more info about the Expertise_Growth Notetag.
#   Go to [p515] for more info about the General Growth Formula Configuration.
#
#-------------------------------------------------------------------------------
# IV - Expertise Menu Scene [p414]
#-------------------------------------------------------------------------------
#   This menu allows the allocation of Expertise Points and the inspection of
#   Expertise Bonuses.
#   It can be accessed by the Main Menu or can be invoked directly by script
#   calls.
#
#   Go to [p134] for more info about how to manualy invoke the Expertise Menu.
#   Go to [p914] for more info about the Expertise Bonus Inspector.
#
#-------------------------------------------------------------------------------
# V - Main Menu Entry [p514]
#-------------------------------------------------------------------------------
#   An Entry at the Main Menu options that leads to the Expertise Menu scene is
#   enabled by default. You can disable this feature completely or you can 
#   choose to keep it enabled and toogle it on/off or invisible/visible midgame
#   by script calls.
#   If you disable this feature at the script configuration, it will not be
#   added to your game, thus invoking the script calls to toogle it on or off
#   will do nothing. If you want the possibility to toogle it on/off during
#   mid-game you must keep this feature enabled.
#   This entry in the main menu has also a "shining" visual effect designed to
#   feedback the player that some party members has unallocated Expertise
#   Points.
#
#   Go to [p315] for more info about how to config the Main Menu Entry.
#
#   Go to [p415] for more info about how to config the Visual Effects for the
#   Main Menu Entry.
#
#   Go to [p334] for more info about how to toogle the Main Menu Entry on/off
#   or visible/invisible during mid-game.
#
#-------------------------------------------------------------------------------
# VI - Main Menu Expertise Points Display [p614]
#-------------------------------------------------------------------------------
#   By default, an Expertise Point counter is displayed in the Main Menu at the
#   Actor's Simple Status Window Card, right next to their level, if the actor 
#   in question has Expertise Points available.
#   This feature may conflict or overlap with any other script that changes or
#   adds new information to that area.
#
#   Go to [p215] for more information about how to completly disable this
#   functionallty.
#
#-------------------------------------------------------------------------------
# VII - Expertise Types [p714]
#-------------------------------------------------------------------------------
#   Every skill can have a Skill Type which is defined in the Database, but
#   they will not come with an Expertise Type. To assign an Expertise Type to a
#   skill you need to put the following notetag in the skill's note field:
#     <expertise: xtype>
#
#   Go to [p244] for more info about Expertise Types
#   Go to [p124] for more info about the Expertise Notetag
#
#-------------------------------------------------------------------------------
# VIII - Expertise Bonuses [p814]
#-------------------------------------------------------------------------------
#   Skills can have their Expertise Value increased or decreased by bonuses.
#   These bonuses may come from any Item, Armor, Weapon, Status, or even Actors
#   or Classes.
#   These bonuses can be applied in a myriad of ways and deserve their own 
#   topic.
#
#   Go to [p044] for more info about Expertise Bonuses
#
#-------------------------------------------------------------------------------
# IX - Expertise Bonus Inspector [p914]
#-------------------------------------------------------------------------------
#   The Bonus Inspector displays detailed information about every bonus
#   currently affecting the selected skill.
#
#===============================================================================
# 4.2. Instructions - List of Notetags [p024]
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This section describes the notetags added by this script, explaining where
# they should be inserted, what they do and which parameters they admit.
#
# Notetag Syntax:
#   To type a notetag used by this script, it must be initiated with the "less
#   than" sign, closed by "greater than" sign, the tagname and the first
#   parameter must be separated by a colon and all following parameters must be 
#   separated by commas... confusing? Not so much. Just follow this pattern: 
#
#     <tagname: first_parameter, second_parameter, third_parameter >
#
# Lunatic Expressions:
#   Some advanced notetags admit actual RGSS code as a special parameter that 
#   we are going to call in this script as Lunatic Expressions in honour to the
#   famous Lunatic Mode scripts widely accepted by the comunity.
#   These expressions must be inserted after the opening notetag. To mark its 
#   end point, a Closing Notetag must be inserted after the expression itself.
#   The Closing Notetag is just a tag initiated with "less than" signfollowed 
#   by a "foward slash", plus the name tag's name and closed by "greater than"
#   sign, for example:
#
#     <tagname: first_parameter, second_parameter, third_parameter >
#       // Actual RGSS code
#     </tagname >
#
#-------------------------------------------------------------------------------
# I - Expertise Notetag [p124]
#-------------------------------------------------------------------------------
#   Use this notetag if you want a skill to be listed under the Expertise Menu.
#
#   syntax     : <expertise: xtype >
#   scope      : Skill's note field.
#   parameters : 
#     xtype : (text) Expertise_Type's name assigned to the Skill.
#
#   Examples:
#     <expertise: Crafting >
#     <expertise: Wizardry >
#     <expertise: Combat >
#
#-------------------------------------------------------------------------------
# II - Expertise-Growth Notetag [p224]
#-------------------------------------------------------------------------------
#   Use this notetag if you want an Actor to earn Expertise Points following a
#   different formula from everyone else.
#
#   syntax     : <expertise-growth > // growth formula </expertise-growth >
#   scope      : Actor's note field.
#   parameters : none
#   Lunatic Expression :
#     a       : the Actor receiving the Expertise Points.
#     returns : (number) Should express the Expertise Points received per Level.
#
#   Examples:
#     <expertise-growth > a.mat / 10 </expertise-growth >
#     <expertise-growth > a.luk * 5 + 1 </expertise-growth >
#     <expertise-growth > 5 </expertise-growth >
#
#-------------------------------------------------------------------------------
# III - Bonus Notetags and variations [p324]
#-------------------------------------------------------------------------------
#   The Bonus notetag receives some special parameters called MODE and SCOPE at
#   its tagname before passing its regular parameters. 
#   Go to [p044] for detailed info about how to choose among the many MODEs and 
#   SCOPEs combinations that better suits your cases.
#
#   syntax     : <bonus : value, descriptor, MODE, SCOPE> // condition </bonus>
#   scope      : Actor, Class, Skill, Item, Weapon, Armor or Status note field.
#   parameters : 
#     valye : 
#       (integer) The plain numeric bonus when MODE is flat or iflat.
#       (decimal) The percentual bonus when MODE is add, mult, iadd or imult.
#     descriptor :
#       (text) A custom filter for which skills benefit from this bonus.
#       (integer) The ID of the skill which will benefit from this bonus.
#       (xtype) The Expertise Type of the skills which benifit from this bonus.
#     [condition] :
#       (formula) The bonus isn't applied when false.
#   special    : 
#     SCOPE => Can be either ACTOR or PARTY.
#     MODE  => Can be FLAT, ADD, MULT, IFLAT, IADD or IMULT.
#
#   Examples:
#     <actor-bonus-flat: 10, Crafting >
#     <actor-bonus-mult: 0.01, Fire >
#     <actor-bonus-add: 0.85, Wizardry, (a.hp / a.mhp) < 0.1 >
#     <party-bonus-iflat: -10, 26, a.hp == a.mhp >
#
#-------------------------------------------------------------------------------
# IV - Synergy Notetag [p424]
#-------------------------------------------------------------------------------
#   Use this notetag if you want a Skill's Expertise Value to change based on
#   another Skill's Expertise value.
#
#   syntax     : <synergy: skill_id, percentage >
#   scope      : Skill's note field.
#   parameters :
#     skill_id   => (integer) The Skill's ID in the database.
#     percentage => (decimal) A decimal number representing a percentage.
#
#   Example:
#     <synergy: 30, 0.2 >
#     <synergy: 29, 1 >
#     <synergy: 31, -0.2 >
#
#-------------------------------------------------------------------------------
# V - Descriptor Notetag [p524]
#-------------------------------------------------------------------------------
#   Use this notetag if you want a skill to benefit from a bonus that uses a
#   custom descriptor instead of its own Expertise_Type or skill_id.
#
#   syntax     : <descriptor: descriptor, [condition] >
#   scope      : Skill's note field.
#   parameters : 
#     descriptor => (text) The descriptor assigned to this skill.
#
#   examples:
#     <descriptor: Fire >
#     <descriptor: Crafting >
#     <descriptor: Gathering >
#
#===============================================================================
# 4.3. Instructions - List of Script Calls [p034]
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This section describes the Script Calls you can use to manage this system
# through events along the game flow.
#
# This is a list of all the methods contained in the CC module:
#   CC.expertise_scene....................................................[a134]
#   CC.expertise_scene(member_index)......................................[b134]
#   CC.member_total_expertise(member_index, skill_id).....................[a234]
#   CC.member_base_expertise(member_index, skill_id)......................[b234]
#   CC.actor_total_expertise(actor_id, skill_id)..........................[c234]
#   CC.actor_base_expertise(actor_id, skill_id)...........................[d234]
#   CC.expertise_command_enabled..........................................[a334]
#   CC.expertise_command_enabled(value)...................................[b334]
#   CC.expertise_command_visible..........................................[c334]
#   CC.expertise_command_visible(value)...................................[d334]
#   CC.expertise_command_present..........................................[e334]
#   CC.expertise_command_present(value)...................................[f334]
#
#-------------------------------------------------------------------------------
# I - Invoke Expertise Menu [p134]
#-------------------------------------------------------------------------------
#   You can directly open the Expertise Menu through script calls.
#   There are two methods for this purpose, which are:
#     CC.expertise_scene
#     CC.expertise_scene(member_index)
#
#   If invoked without any parameters it will open up the Expertise Scene for
#   the last selected party member, otherwise it will open for the party
#   member which corresponds for the passed index.
#
#   Note that the Member index should not be confused as being the Actor ID.
#   The Member index is the Actor's position in the main menu, which is 
#   altered by formation command mid-game.
#   The Actor ID is the Actor's position in the database and it is constant
#   throughout the whole game's execution.
#   
#   Methods:
#     CC.expertise_scene
#       Parameters : None
#
#     CC.expertise_scene(member_index)
#       member_index: integer
#         Optionally, it can be invoked by passing a party member index for 
#         openning up the Expertise Scene for that party member. Party Member 
#         indexes vary from 0 to 3. Zero is the first member and three is the 
#         last one.
#
#-------------------------------------------------------------------------------
# II - Get Expertise Values [p234]
#-------------------------------------------------------------------------------
#   There are four methods that can be used to retrieve Expertise values.
#   These methods variants are:
#     CC.member_total_expertise(member_index, skill_id)
#     CC.member_base_expertise(member_index, skill_id)
#     CC.actor_total_expertise(actor_id, skill_id)
#     CC.actor_base_expertise(actor_id, skill_id)
#
#   If you are looking for a method to be used in a damage formula, you should
#   look in the RPG::Actor class methods instead. These methods are not fit for
#   that purpose. The methods listed here are designed to be used in events.
#   Go to [] for more info about RPG::Actor methods.
#
#   "Member" vs "Actor"
#
#     "Member" variants
#     If you need to retrieve the expertise value of an actor based on its
#     POSITION IN THE PARTY, you should used the methods starting with "member",
#     which are member_total_expertise and member_base_expertise.
#
#     "Actor" variants
#     If you need to retrieve the expertise value of a FIXED ACTOR based on its
#     DATABASE ID, you should use the methods starting with "actor", which are
#     actor_total_expertise and actor_base_expertise.
#
#   "Total" vs "Base"
#
#     "Total" variants
#     If you need the expertise value of a skill WHILE taking in account all
#     its BONUSES, you should use the methods stating "total" in their name,
#     which are member_total_expertise and actor_total_expertise.
#
#    "Base" variants
#     If you need the expertise value of a skill WITHOUT taking any bonuses into
#     account, you should use the methods stating "base" in their name, which
#     are member_base_expertise and actor_base_expertise.
#
#   Go to [a234] for more info about member_total_expertise method.
#   Go to [b234] for more info about member_base_expertise method.
#   Go to [c234] for more info about actor_total_expertise method.
#   Go to [d234] for more info about actor_base_expertise method.
#
#-------------------------------------------------------------------------------
# III - Toogle Expertise Menu Entry [p334]
#-------------------------------------------------------------------------------
#   An Entry at the Main Menu options that leads to the Expertise Menu scene is
#   enabled by default. There are three methods you can use to control this
#   feature's behaviour.
#     CC.expertise_command_enabled(value)
#     CC.expertise_command_visible(value)
#     CC.expertise_command_present(value)
#
#   If you disable this feature at the script configuration, it will not be
#   added to your game, thus invoking the script calls to toogle it on or off
#   will do nothing. If you want the possibility to toogle it on/off during
#   mid-game you must keep this feature enabled.
#
#   NOTE: These features are only available if you leave the menu entry option
#   enabled at the script configuration!
#
#   Methods:
#     CC.expertise_command_enabled(value)
#       value       : true or false
#       Description :
#         This option controls if the [Expertise] command is grayed out or not, 
#         which means that if can be activated or not.
#         If you want to temporary disable the [Expertise] command from the main
#         menu's entries, rendering it in a grayed out state, you may call this 
#         method passing the value as false. Or if you want to re-enable it, 
#         pass the value as true.
#
#     CC.expertise_command_visible(value)
#       value       : true or false
#       Description :
#         This method works in a similar way to the "enabled" version, but 
#         instead of graying out the option, it will render the option 
#         invisible. It is still selectable, but can't be triggered as it were 
#         grayed out.
#         This command is useful for pre-tutorial stages of your game when you 
#         want to hide this feature from the menu, but still hint that sometime 
#         in the future something will ocupy that space.
#
#     CC.expertise_command_present(value)
#       value       : true or false
#       Description :
#         This method controls if the [Expertise] command will present in the 
#         main menu or not, acting in a similar manner as disabling this feature
#         completelly from the game. The difference is that this is reversible.
#
#   NOTE: These methods can also be called without any arguments. If called
#   this manner, instead of changing their values, they will just return the
#   current value. This is useful if you need to store the current value in a 
#   variable, for example.
#
#===============================================================================
# 4.4. Instructions - Expertise Bonuses [p044]
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
# This section describes how Bonuses work and how they can be setted up.
#
# NOTE: Before you read this section, it is highly recommended that you first 
# take the tutorial by downloading the demo project at the provided links at the 
# top of this header, since bonuses have many different configurations that 
# slighty changes their behaviour. By taking the tutorial you may have a visual
# representation of their workings on the fly.
#
#-------------------------------------------------------------------------------
# I - What are Bonuses [p144]
#-------------------------------------------------------------------------------
#   Bonuses are modifiers that affects the expertise of your characters. These
#   modifiers can increase or decrease their actual expertise values in a
#   miriad of ways.
#   For example, you as developer can assign a bonus to an armor that while
#   equipped may increase a character's expertise by +5 points in some gathering
#   skill; or you can assign a bonus to an amulet that increase's the expertise
#   of all fire based skills; or even a status effect that halves every skill's
#   expertise value.
#   However, these bonuses can overlap with each other while active at the same
#   time. Take the example from the last paragraph. A skill may get a +5 first
#   and then be halved, or it can be halved first and then get a +5. The outcome
#   will differ from each case.
#   It is up to you to choose the right bonus types for achieving the result you
#   desire.
#
#   For a quick overview:
#     Scopes are the Who the bonus affects
#     Modes are How the bonus take effect
#     Descriptors are What skills are affected.
#
#-------------------------------------------------------------------------------
# II - Expertise Types [p244]
#-------------------------------------------------------------------------------
#   Expertise Types are analogous to Skill Types, and group together skills in
#   categories under the Expertise Menu, however their purpose is not only to
#   serve as a tool for sorting skills in the Expertise Menu, they are also a 
#   requirement if you want the skill displayed at the Expertise Menu. 
#   Controlling the Skill Type and Expertise Type enables you, as developer,
#   to choose if a skill will be displayed at the Skills Menu, Expertise Menu,
#   or Both.
#   Furthermore, Expertise Types are also considered bonus descriptors, which
#   mean that you don't to need assign a custom descriptor for each skill of the
#   same Expertise Type since you can use the Expertise Type itself as bonus
#   descriptor to grant bonuses to those skills.
#
#   Go to [p344] for more info about Descriptors
#   Go to [p124] for more info about the Expertise Notetag
#
#-------------------------------------------------------------------------------
# III - Descriptors [p344]
#-------------------------------------------------------------------------------
#   Descriptors are a tool for grouping skills together to enable them to 
#   receive a bonus from a certain kind. A bonus marked to act uppon a 
#   descriptor affects every skill in that group.
#
#   Descriptors are assigned to skills using the <descriptor: x > notetag.
#
#   A skill may have multiple descriptors assigned to it, or none at all.
#   Also, every skill ID is considered as a "singleton" descriptor for its own
#   skill, and a skill's Expertise Type is also considered a descriptor.
#
#                                 -- EXAMPLE --
#
#   Let's suppose we want to design some Skills for a wizard character. 
#
#   We are going to create some spells that are going to act as normal skills 
#   and also as "Wizardry" Expertises, which are "Flames", "Fireball" and 
#   "Blizzard". We also are going to create a "Drain" spell that won't have an
#   Expertise Type.
#   Additionally we create some pure Expertise Skills which are under the
#   "Knowledge" Expertise Type, they are: "Fire Elementals" and "Ice Elementals"
#   By pure Expertise Skill, I mean that they cannot be used in combat as 
#   regular skills since they are assigned with [none] as their Skill Type.
#    
#   Then we want to assign descriptors to the skills:
#     [Fire] to Flames, Fireball and Fire Elementals
#     [Ice] to Blizzard and Ice Elementals.
#     [AreaSpell] to Fireball and Blizzard.
#   To achieve that, we are going to use the <descriptor> notetag.
#   Just type:
#     <descriptor: fire >
#   Inside the notefield of Flames, Fireball and Fire Elementals skills, then
#   write this inside the Blizzard and Ice Elemental's notefield:
#     <descriptor: ice >
#   And, to finish it, we are going to add a second descriptor
#   to both Fireball and Blizzard, since we want these two spells to receive
#   bonuses from sources that increase the effectiveness of skills which hit
#   multiple targets at once. Write this in both Fireball and Blizzard:
#     <descriptor: AreaSpell >
#     
#   So our skill set will look like this:
#   
#     Name              Skill Type    Expertise Type  Descriptors
#
#     Flames            Magic         Wizardry        Fire
#     Fireball          Magic         Wizardry        Fire, AreaSpell
#     Blizzard          Magic         Wizardry        Ice, AreaSpell
#     Drain             Magic         None            None
#     Fire Elementals   None          Knowledge       Fire
#     Ice Elementals    None          Knowledge       Ice
#
#   Now we are ready to design some Bonuses to affect the Expertise our wizard
#   has in those skills.
#
#   We can create an Amulet that while equiped can grant +5 to every fire skill,
#   and for that we just need to use the following notetag inside an equippable
#   accessory's note field in the database:
#     <actor-bonus-flat: +5, Fire >
#   Doing that, when our wizard equips the amulet, his "Flames", "Fireball" and
#   "Fire Elementals" skill's expertise value will get a +5 bonus.
#   Don't mind about the sintax yet. Explanations about the meaning of "actor"
#   and "flat" in the notetag's name will be explained in the two followinf 
#   sections: SCOPE and MODE respectively.
#
#   It's possible to do exactly the same thing we did to our Fire skills to our
#   Ice skills using the following notetag:
#     <actor-bonus-flat: +5, Ice >
#   This way, the wizard's "Blizzard" and "Ice Elementals" will get the bonus.
#
#   Probably by now you are already getting the grasp about how this works.
#   If we write a notetag as follows:
#     <actor-bonus-flat: +5, AreaSpell >
#   Then, "Fireball" and "Blizzard" will get a +5 bonus.
#
#   But what if we want to create an amulet that grants a bonus to all spells
#   of our mage? Well. We could create a new Descriptor to include every spell
#   in the same category, but that is not necessary since, for convenience,
#   Expertise Types are also counted as Descriptors themselves, so we can just 
#   write:
#     <actor-bonus-flat: +1, Wizardry >
#   So every skill under the Expertise Type "Wizardry" will receive the bonus.
#   In our example these spells are "Flames", "Fireball" and "Blizzard".
#
#   We can do the same with our knowledge skills, by writing:
#     <actor-bonus-flat: +1, Knowledge >
#   Both "Fire Elementals" and "Ice Elementals" will get the bonus.
#   
#   I hope you have noticed that we have created a Drain Spell which has no
#   Expertise Type. This skill won't show up in the Expertise Menu, thus it
#   can't have any Expertise Points allocated by the Player, but that doesn't
#   mean it can't have any Expertise Value associated with at all.
#   You can still access its expertise value by script calls like any other 
#   skill and you can also create bonuses that affect only this skill in 
#   particular.
#   To do that you need to pass the skill's ID as if it was a descriptor. So
#   let's suppose our drain spell's database ID is 49, we could write:
#     <actor-bonus-flat: +10, 49 >
#   And then our "Drain" skill would get a +10 bonus while our amulet is 
#   equiped.
#   Still, the skill's expertise bonuses can't be inspected since the skill
#   itself will not show in the Expertise Menu. It will just show up as a
#   regular skill in the skills menu.
#
#                              Just to reinforce it:
#         The Skill's ID and EXPERTISE TYPE can be used as DESCRIPTORS.
#
#   The next two sections will explain the meaning of the "actor" and "flat"
#   words in the bonus notetag.
#   
#-------------------------------------------------------------------------------
# IV - Scopes [p444]
#-------------------------------------------------------------------------------
#   Scopes dictate the pre-condition for the bonus to take effect and which 
#   actors will benefit from the bonus. There are only two possible scopes:
#   ACTOR and PARTY.
#
#   Actor:
#     Pre-condition : The Item, Status or Class must be equiped by an Actor.
#     Affects       : A single actor equiping the item.
#     Description   :
#       When a bonus is scoped as Actor, it will only take effect if an actor
#       is equipping the item which has the bonus.
#       While the bonus is in effect, it will only affect the actor which is
#       equipping the item in question.
#       If the item is not equipable, a bonus scoped as Actor will never take
#       effect.
#       However, note that this system considers ACTORS, CLASSES, SKILLS and 
#       STATUSES as valid items for bonuses, this means that, Actors are 
#       considered to be equipping their learned skills, their current classes,
#       their current statuses and are also always equipping themselves!
#       With that in mind, you can assign permanent-bonuses to actors which can
#       function like some sort of trait or racial bonus. Or you can assign 
#       class bonuses which wear off when a character change classes. Or even a 
#       temporary bonus associated with a status effect.
#
#   Party:
#     Pre-condition : The Item must be in possession of the party itself.
#     Affects       : Every actor currently in the party.
#     Description   :
#       A party scoped bonus affects all actors in the party, in contrast to 
#       actor scoped bonuses which affects just a single actor.
#       For a Bonus scoped as Party to take affect, the item which holds the
#       the bonus must br present in the party in any way. This means a bonus 
#       will trigger even the item is not equipped, but if the item is sold, 
#       consumed or removed from the inventory, the bonus will cease.
#       Bearing in mind that ACTORS, CLASSES, SKILLS and STATUSES can also
#       grant party bonuses, their simple presence in the party will trigger
#       the bonus, affecting all party members. This is useful for cursed items
#       or aura statuses.
#
#-------------------------------------------------------------------------------
# V - Modes [p544]
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
# VI - Individual Modes [p644]
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
# VII - Synergy [p744]
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
# VIII - Conditional Bonuses [p844]
#-------------------------------------------------------------------------------
#
#-------------------------------------------------------------------------------
# IX - Bonus Algorithm: How the final values are calculated [p944]
#-------------------------------------------------------------------------------
#
#===============================================================================
# 5. Configuration [p005]
#===============================================================================
#
#===============================================================================
# 6. Compatibility [p006]
#===============================================================================
# This script was designed for RPG Maker VX Ace only. It doesn't work in other
# RPG Maker softwares.
#
#===============================================================================
# 7. Version History [p007]
#===============================================================================
# Version 1.00 - 2019.04.22
#   Initial release
#
#===============================================================================

($imported ||= {})[:CaRaCrAzY_Expertise] = 1.00

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
  # * Adds an [Expertise] option to the main menu
  #-----------------------------------------------------------------------------
  #   Disable this feature if the [Expertise] menu entry conflicts with another
  #   script.
  #
  #   Beware that if you disable this feature, you will need to call the 
  #   Scene_Expertise manually from somewhere else in your game, by calling
  #     CC.expertise_scene.
  #
  #   Furthermore, if you disable this feature, these commands will also be
  #   removed, thus, if called mid-game, they won't have any effect at all:
  #     CC.expertise_command_enabled, 
  #     CC.expertise_command_visible and
  #     CC.expertise_command_present
  #-----------------------------------------------------------------------------
  FEATURE_MENU_COMMAND = true
  
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
  XPTS_POINTS_A = "EP"
  
  #=============================================================================
  # ** Bonus Vocabulary
  #-----------------------------------------------------------------------------
  #   These are the constants used to display bonus information.
  #
  #   There are 7 types of bonuses included in this script that affects a skill
  #   expertise's final value. Here you can alter thier displaying behaviour
  #   by changing these values.
  #
  #   For more information about bonuses, read the Instructions section.
  #=============================================================================
  
  #-----------------------------------------------------------------------------
  # * Bonus Names
  #-----------------------------------------------------------------------------
  #   This text is Displayed as a header before listing any bonus of the 
  #   discribed type.
  #-----------------------------------------------------------------------------
  NAME_SYNERGY  = "Synergy"                          # List's Header for Synergy
  NAME_FLAT     = "Flat"                             # List's Header for Flat
  NAME_ADD      = "Additive"                         # List's Header for Add
  NAME_MULT     = "Multiplier"                       # List's Header for Mult
  NAME_IFLAT    = "Flat"                             # List's Header for IFlat
  NAME_IADD     = "Additive"                         # List's Header for IAdd
  NAME_IMULT    = "Multiplier"                       # List's Header for IMult
  
  #-----------------------------------------------------------------------------
  # * Empty list entries
  #-----------------------------------------------------------------------------
  #   
  #-----------------------------------------------------------------------------
  NONE_SYNERGY  = "None"                             # Empty Synergy list
  NONE_FLAT     = nil                                # Empty Flat list
  NONE_ADD      = nil                                # Empty Add list
  NONE_MULT     = nil                                # Empty Mult list
  NONE_IFLAT    = nil                                # Empty IFlat list
  NONE_IADD     = nil                                # Empty IAdd list
  NONE_IMULT    = nil                                # Empty IMult list
  
  HELP_SYNERGY  = "Inter-Expertise Synergic Bonuses.Unlearned skills are displayed translucently."
  HELP_FLAT     = "Flat Bonuses.\nParty bonuses are displayed in yellow."
  HELP_ADD      = "Additive Multipliers.\nParty bonuses are displayed in yellow."
  HELP_MULT     = "Multiplicative Bonuses.\nParty bonuses are displayed in yellow."
  HELP_IFLAT    = "Individual Flat Bonuses.\nParty bonuses are displayed in yellow."
  HELP_IADD     = "Individual Additive Multipliers.\nParty bonuses are displayed in yellow."
  HELP_IMULT    = "Individual Multiplicative Bonuses.\nParty bonuses are displayed in yellow."
  
  DESC_SYNERGY  = "<value> of <desc>'s expertise is added as bonus."
  DESC_FLAT     = "\\c[23][<desc>]\\c[0]: Adds <value> to this skill's final value."
  DESC_ADD      = "\\c[23][<desc>]\\c[0]: Adds <value> to this skill's final multiplier."
  DESC_MULT     = "\\c[23][<desc>]\\c[0]: Multiplies this skill's final value by <value>."
  DESC_IFLAT    = "\\c[23][<desc>]\\c[0]: Adds <value> to this skill's [<desc>] value."
  DESC_IADD     = "\\c[23][<desc>]\\c[0]: Adds <value> to this skill's [<desc>] multiplier."
  DESC_IMULT    = "\\c[23][<desc>]\\c[0]: Multiplies this skill's [<desc>] value by <value>."
  
  NTAG_SYNERGY  = "synergy"                          # Synergy Notetag symbol
  NTAG_FLAT     = "flat"                             # Flat Notetag symbol
  NTAG_ADD      = "add"                              # Add Notetag symbol
  NTAG_MULT     = "mult"                             # Mult Notetag symbol
  NTAG_IFLAT    = "iflat"                            # IFlat Notetag symbol
  NTAG_IADD     = "iadd"                             # IAdd Notetag symbol
  NTAG_IMULT    = "imult"                            # IMult Notetag symbol
  
  PROC_COLOR_SYNERGY = Proc.new { |v| v > 0 ? 24 : 25 }
  PROC_COLOR_FLAT    = Proc.new { |v| v > 0 ? 24 : 25 }
  PROC_COLOR_ADD     = Proc.new { |v| v > 0 ? 24 : 25 }
  PROC_COLOR_MULT    = Proc.new { |v| v > 1 ? 24 : 25 }
  PROC_COLOR_IFLAT   = Proc.new { |v| v > 0 ? 24 : 25 }
  PROC_COLOR_IADD    = Proc.new { |v| v > 0 ? 24 : 25 }
  PROC_COLOR_IMULT   = Proc.new { |v| v > 1 ? 24 : 25 }
  
  PROC_TEXT_SYNERGY  = Proc.new { |v| "#{:+ if v > 0}#{(v * 100).floor}%" }
  PROC_TEXT_FLAT     = Proc.new { |v| "#{:+ if v > 0}#{v.floor}" }
  PROC_TEXT_ADD      = Proc.new { |v| "#{:+ if v > 0}#{(v * 100).floor}%" }
  PROC_TEXT_MULT     = Proc.new { |v| "#{(v * 100 - 100).floor}%" }
  PROC_TEXT_IFLAT    = Proc.new { |v| "#{:+ if v > 0}#{v.floor}" }
  PROC_TEXT_IADD     = Proc.new { |v| "#{:+ if v > 0}#{(v * 100).floor}%" }
  PROC_TEXT_IMULT    = Proc.new { |v| "#{(v * 100 - 100).floor}%" }
  
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
    attr_reader :name          # Name displayed as a header in bonus lists
    attr_reader :help_text     # Help Text displayed for bonus headers
    attr_reader :description   # Help text displayed for each bonus entry
    attr_reader :none_text     # Text for displaying an empty bonus list
    attr_reader :operation     # Operation to join indiviual terms
    attr_reader :reduction     # Operation to join all bonuses of this mode
    attr_reader :neutral_value # Initial value when joining terms
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(const_name, operation, reduction, neutral_value)
      @tag           = CaRaCrAzY.const_get("NTAG_#{const_name}", false)
      @name          = CaRaCrAzY.const_get("NAME_#{const_name}", false)
      @help_text     = CaRaCrAzY.const_get("HELP_#{const_name}", false)
      @description   = CaRaCrAzY.const_get("DESC_#{const_name}", false)
      @none_text     = CaRaCrAzY.const_get("NONE_#{const_name}", false)
      @display_color = CaRaCrAzY.const_get("PROC_COLOR_#{const_name}", false)
      @display_text  = CaRaCrAzY.const_get("PROC_TEXT_#{const_name}", false)
      @operation     = operation
      @reduction     = reduction
      @neutral_value = neutral_value
    end
    #---------------------------------------------------------------------------
    # * Creates a Display Header for Bonus lists in Expertise Screen
    #---------------------------------------------------------------------------
    def header(value = "")
      unless @header
        @header = Header.new
        @header.text = @name
        @header.description = @help_text
      end
      @header.value_text = value
      @header
    end
    #---------------------------------------------------------------------------
    # * Creates an entry for empty Bonus lists in Expertise Screen
    #---------------------------------------------------------------------------
    def empty_entry
      return @empty_entry if @empty_memo
      @empty_memo = true
      return nil unless @none_text
      @empty_entry = Header.new
      @empty_entry.text        = @none_text
      @empty_entry.color       = 0
      @empty_entry.description = ""
      @empty_entry.padding     = 8
      @empty_entry
    end
    #---------------------------------------------------------------------------
    # * Returns an array with the Header and the empty entry, if the empty
    #   entry is not nil, otherwise returns an empty array.
    #---------------------------------------------------------------------------
    def header_with_empty
      empty_entry ? [header, empty_entry] : []
    end
    #---------------------------------------------------------------------------
    # * Inserts the Header at the start of the array. If the array is empty,
    #   the empty_entry is used instead.
    #---------------------------------------------------------------------------
    def header_with_bonuses(bonuses = [])
      bonuses.first ? [header] + bonuses : header_with_empty
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
    #---------------------------------------------------------------------------
    # * Value's text. The text displayed on the header's right
    #---------------------------------------------------------------------------
    def display_color(value)
      @display_color.(value)
    end
    #---------------------------------------------------------------------------
    # * Value's text. The text displayed on the header's right
    #---------------------------------------------------------------------------
    def display_text(value)
      @display_text.(value)
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
    # * Sorts the bonuses by descriptor and inserts a header before each
    #   descriptor group
    #---------------------------------------------------------------------------
    def header_with_bonuses(bonuses = [])
      return header_with_empty unless bonuses.first
      descriptors = {}
      bonuses.each do |bonus|
        (descriptors[bonus.display_descriptor] ||= []) << bonus
      end
      descriptors.flat_map { |desc, bonuses| [header(desc)] + bonuses }
    end
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
    # * List of all bonuses which are of a certain mode and scope regarding 
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
        .map { |bonus| actor.expertise(bonus.item).allocations * bonus.value }
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
  # ** CC
  #-----------------------------------------------------------------------------
  #   Convenience Commands Module.
  #   This module contains some simple commands for smooth system interaction.
  #
  #   You will problably need them at some point, so read carefully the 
  #   instructions for correct use.
  #
  #   Beware that some commands change their behaviour depending on your setup.
  #-----------------------------------------------------------------------------
  #   This sections contains commands that are always present regardless of 
  #   your setup
  #=============================================================================

  module ::CC
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
    # * Returns the total expertise of a party member's skill, taking into 
    #   account all its synergies and bonuses. [a234]
    #---------------------------------------------------------------------------
    #     member_index : Actor index in the Party Menu (Between zero and three)
    #     skill_id     : Skill's ID in the Data Base
    #---------------------------------------------------------------------------
    def self.member_total_expertise(member_index, skill_id)
      if member = $game_party.members[member_index] 
        self.actor_total_expertise(member.id, skill_id)
      else
        puts "Not found party member of index #{member_index}"
      end
    end
    #---------------------------------------------------------------------------
    # * Returns the value of how many expertise points were allocated in a
    #   party member's skill. [b234]
    #---------------------------------------------------------------------------
    #     member_index : Actor index in the Party Menu (Between zero and three)
    #     skill_id     : Skill's ID in the Data Base
    #---------------------------------------------------------------------------
    def self.member_base_expertise(member_index, skill_id)
      if member = $game_party.members[member_index]
        self.actor_base_expertise(member.id, skill_id)
      else
        puts "Not found party member of index #{member_index}"
      end
    end
    
    #---------------------------------------------------------------------------
    # * Returns the total expertise of an actor's skill, taking into account
    #   all its synergies and bonuses. [c234]
    #---------------------------------------------------------------------------
    #     actor_id : Actor's ID in the Data Base
    #     skill_id : Skill's ID in the Data Base
    #---------------------------------------------------------------------------
    def self.actor_total_expertise(actor_id, skill_id)
      actor = $game_actors[actor_id]
      skill = $data_skills[skill_id]
      puts "Not found actor of index #{actor_id}" unless actor
      puts "Not found skill of index #{skill_id}" unless skill
      return 0 unless actor && skill
      actor.total_expertise(skill)
    end
    #---------------------------------------------------------------------------
    # * Returns the value of how many expertise points were allocated in an
    #   actor's skill. [d234]
    #---------------------------------------------------------------------------
    #     actor_id : Actor's ID in the Data Base
    #     skill_id : Skill's ID in the Data Base
    #---------------------------------------------------------------------------
    def self.actor_base_expertise(actor_id, skill_id)
      actor = $game_actors[actor_id]
      skill = $data_skills[skill_id]
      puts "Not found actor of index #{actor_id}" unless actor
      puts "Not found skill of index #{skill_id}" unless skill
      return 0 unless actor && skill
      actor.base_expertise(skill)
    end
  end

  #=============================================================================
  # ** CC
  #-----------------------------------------------------------------------------
  #   This section adds commands for when FEATURE_MENU_COMMAND is enabled
  #=============================================================================

  module ::CC
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
  end if FEATURE_MENU_COMMAND

  #=============================================================================
  # ** CC
  #-----------------------------------------------------------------------------
  #   This section adds commands for when FEATURE_MENU_COMMAND is disabled
  #=============================================================================

  module ::CC
    #---------------------------------------------------------------------------
    # * Always returns false because FEATURE_MENU_COMMAND is disabled
    #---------------------------------------------------------------------------
    def self.expertise_command_enabled(_ = nil)
      false
    end
    #---------------------------------------------------------------------------
    # * Always returns false because FEATURE_MENU_COMMAND is disabled
    #---------------------------------------------------------------------------
    def self.expertise_command_visible(_ = nil)
      false
    end
    #---------------------------------------------------------------------------
    # * Always returns false because FEATURE_MENU_COMMAND is disabled
    #---------------------------------------------------------------------------
    def self.expertise_command_present(_ = nil)
      false
    end
  end unless FEATURE_MENU_COMMAND

  #=============================================================================
  # ** Window_MenuCommand
  #-----------------------------------------------------------------------------
  #   Conditionally aliasing methods in Window_MenuCommand class
  #   if FEATURE_MENU_COMMAND is true
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
  end if FEATURE_MENU_COMMAND

  #=============================================================================
  # ** Window_MenuCommand
  #-----------------------------------------------------------------------------
  #   Conditionally aliasing methods in Window_MenuCommand class
  #   if FEATURE_SHINE and FEATURE_MENU_COMMAND are true
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
  end if FEATURE_SHINE && FEATURE_MENU_COMMAND

  #=============================================================================
  # ** Scene_Menu
  #-----------------------------------------------------------------------------
  #   Conditionally aliasing methods inside Scene_Menu class
  #   if FEATURE_MENU_COMMAND is true
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
      CC.expertise_scene if @command_window.current_symbol == :expertise
      result
    end
  end if FEATURE_MENU_COMMAND

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
  end
  
  #=============================================================================
  # ** Game_Player
  #=============================================================================

  class ::Game_Player
    #---------------------------------------------------------------------------
    # * Marks the expert_party extended inventory's cache as dirty
    #---------------------------------------------------------------------------
    alias refresh_caracrazy_79aga refresh
    def refresh(*args)
      result = refresh_caracrazy_79aga(*args)
      $game_party.need_refresh = true
      result
    end
  end

  #=============================================================================
  # ** Game_Actor
  #=============================================================================
  
  class ::Game_Actor
    #---------------------------------------------------------------------------
    #   Marks the expert_party extended inventory's cache as dirty
    #---------------------------------------------------------------------------
    alias refresh_caracrazy_8a7ha refresh
    def refresh(*args)
      result = refresh_caracrazy_8a7ha(*args)
      $game_party.need_refresh = true
      result
    end
    #---------------------------------------------------------------------------
    #   Marks the expert_party extended inventory's cache as dirty
    #---------------------------------------------------------------------------
    alias learn_skill_caracrazy_5asg1 learn_skill
    def learn_skill(*args)
      result = learn_skill_caracrazy_5asg1(*args)
      $game_party.need_refresh = true
      result
    end
    #---------------------------------------------------------------------------
    #   Marks the expert_party extended inventory's cache as dirty
    #---------------------------------------------------------------------------
    alias forget_skill_caracrazy_sa5f4 forget_skill
    def forget_skill(*args)
      result = forget_skill_caracrazy_sa5f4(*args)
      $game_party.need_refresh = true
      result
    end
  end

  #=============================================================================
  # ** Game_Party
  #=============================================================================

  class ::Game_Party
    #---------------------------------------------------------------------------
    #   Marks the expert_party extended inventory's cache as dirty
    #---------------------------------------------------------------------------
    alias gain_item_caracrazy_4v51F gain_item
    def gain_item(*args)
      result = gain_item_caracrazy_4v51F(*args)
      $game_party.need_refresh = true
      result
    end
    #---------------------------------------------------------------------------
    #   Marks the expert_party extended inventory's cache as dirty
    #---------------------------------------------------------------------------
    alias add_actor_caracrazy_5v1a98 add_actor
    def add_actor(*args)
      result = add_actor_caracrazy_5v1a98(*args)
      $game_party.need_refresh = true
      result
    end
    #---------------------------------------------------------------------------
    #   Marks the expert_party extended inventory's cache as dirty
    #---------------------------------------------------------------------------
    alias remove_actor_caracrazy_aan15 remove_actor
    def remove_actor(*args)
      result = remove_actor_caracrazy_aan15(*args)
      $game_party.need_refresh = true
      result
    end
  end
  
  #=============================================================================
  # ** Cara_Crazy_System
  #-----------------------------------------------------------------------------
  #  Class containing additional data to be inserted into RPG:System
  #  Note that this class is only added to the game if FEATURE_MENU_COMMAND is
  #  Enabled
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
  end if FEATURE_MENU_COMMAND

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
    # * Gets the scene's inspector window
    #---------------------------------------------------------------------------
    def inspector_window; scene.inspector_window if scene; end
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
    attr_reader :inspector_window # this scene's inspector window
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
      create_inspector_window
      create_item_window
      create_status_window
    end
    #---------------------------------------------------------------------------
    # * Creates the Command window
    #---------------------------------------------------------------------------
    def create_command_window
      @command_window = Window_ExpertiseCommand.new
      @command_window.y           = @help_window.height
      @command_window.scene       = self
      @command_window.set_handler(:skill,    method(:command_skill))
      @command_window.set_handler(:cancel,   method(:return_scene))
      @command_window.set_handler(:pagedown, method(:next_actor))
      @command_window.set_handler(:pageup,   method(:prev_actor))
    end
    #---------------------------------------------------------------------------
    # * Creates the Inspector window
    #---------------------------------------------------------------------------
    def create_inspector_window
      wx = Graphics.width / 2
      wy = @command_window.y + @command_window.height * 2
      ww = Graphics.width / 2
      wh = Graphics.height - wy
      @inspector_window = Window_Inspector.new(wx, wy, ww, wh)
      @inspector_window.scene = self
      @inspector_window.set_handler(:cancel, method(:on_item_cancel))
    end
    #---------------------------------------------------------------------------
    # * Creates the Expertise window
    #---------------------------------------------------------------------------
    def create_item_window
      wx = 0
      wy = @command_window.y + @command_window.height
      ww = Graphics.width / 2
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
      wx = Graphics.width / 2
      wy = @command_window.y + @command_window.height
      ww = Graphics.width / 2
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
      @inspector_window.unselect
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
      # * Returns a cached shriked version of a faceset
      #-------------------------------------------------------------------------
      def face_icon(face_name)
        Cached_face_icon(face_name)
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
      draw_text(rect, XPTS_POINTS_A, 2)
      width = contents.text_size(XPTS_POINTS_A).width
      #Name
      change_color(normal_color)
      rect.x += 24
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
    # * Draw Expertise
    #---------------------------------------------------------------------------
    def draw_item(index)
      return unless skill = @data[index]
      rect = item_rect(index)
      draw_item_name(skill, rect.x, rect.y, enable?(skill))
      draw_expertise(subrect(rect, 0.7), skill)
    end
    #---------------------------------------------------------------------------
    # * Draws a skill's current expertise (base + Total)
    #---------------------------------------------------------------------------
    def draw_expertise(rect, skill)
      base  = actor.base_expertise(skill)
      total = actor.total_expertise(skill)

      change_color(normal_color)
      draw_text(subrect(rect, 0.6), base, 2)

      change_color(param_change_color(total))
      draw_text(subrect(rect, -0.3), "#{total}←", 2) unless total.zero?
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
    # * Is the current selected Expertise skill is valid for point allocation?
    #---------------------------------------------------------------------------
    def allocatable?
      actor.expertise_points? && include?(item)
    end
    #---------------------------------------------------------------------------
    # * Processing When OK Button Is Pressed
    #---------------------------------------------------------------------------
    def process_ok
      return Sound.play_buzzer unless allocatable?
      actor.allocate_expertise(item)
      Sound.play_equip
      refresh
      scene.status_window.refresh
    end
    #---------------------------------------------------------------------------
    # * Navigates to the inspector window when RIGHT is pressed
    #---------------------------------------------------------------------------
    def cursor_right(*_)
      Sound.play_cursor
      deactivate
      inspector_window.activate
      inspector_window.select([inspector_window.index, 0].max)
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
      Graphics.width
    end
    #---------------------------------------------------------------------------
    # * Get Digit Count
    #---------------------------------------------------------------------------
    def col_max
      return 5
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
  # ** Window_Inspector
  #-----------------------------------------------------------------------------
  #  Window for inspecting Expertise Bonuses.
  #=============================================================================

  class Window_Inspector < Window_Selectable
    #---------------------------------------------------------------------------
    # * Macros
    #---------------------------------------------------------------------------
    include Scene_Window
    include Window
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(wx, wy, ww, wh)
      super
      hide
    end
    #---------------------------------------------------------------------------
    # * Get Number of Items
    #---------------------------------------------------------------------------
    def item_max
      @data ? @data.size : 1
    end
    #---------------------------------------------------------------------------
    # * Create Bonus List
    #---------------------------------------------------------------------------
    def make_bonus_list
      return unless item
      @data = (IBONUSES + BONUSES << SYNERGY).flat_map do |mode|
        mode.header_with_bonuses(mode.bonuses(expertise))
      end
    end
    #---------------------------------------------------------------------------
    # * Draw Bonus
    #---------------------------------------------------------------------------
    def draw_item(index)
      return unless @data && (bonus = @data[index])
      draw_bonus(bonus, item_rect_for_text(index))
    end
    #---------------------------------------------------------------------------
    # * Draw the bonus icon, text and value
    #---------------------------------------------------------------------------
    def draw_bonus(bonus, rect)
      enabled = bonus.enabled?(actor)
      draw_bonus_icon(bonus.icon, rect.x + 8, rect.y, enabled)
      change_color(text_color(bonus.value_color), enabled)
      draw_text(rect, bonus.value_text, 2)
      rect.x += bonus.padding
      change_color(text_color(bonus.color), enabled)
      draw_text(rect, bonus.text)
    end
    #---------------------------------------------------------------------------
    # * Draw the bonus' icon
    #---------------------------------------------------------------------------
    def draw_bonus_icon(icon, x, y, enabled)
      if icon[:name]
        draw_face_icon(icon[:name], icon[:index], x, y, enabled) 
      elsif icon[:index]
        draw_icon(icon[:index], x, y, enabled)
      end
    end
    #---------------------------------------------------------------------------
    # * Get Expertise Data from skill
    #---------------------------------------------------------------------------
    def expertise
      actor.expertise(item)
    end
    #--------------------------------------------------------------------------
    # * Get Expertise Bonus
    #--------------------------------------------------------------------------
    def bonus
      @data && index >= 0 ? @data[index] : nil
    end
    #---------------------------------------------------------------------------
    # * Refresh
    #---------------------------------------------------------------------------
    def refresh
      make_bonus_list
      create_contents
      draw_all_items
    end
    #---------------------------------------------------------------------------
    # * Navigates to the expertise window when LEFT is pressed
    #---------------------------------------------------------------------------
    def cursor_left(*_)
      Sound.play_cursor
      deactivate
      item_window.activate
      help_window.set_item(item)
    end
    #---------------------------------------------------------------------------
    # * Item change event
    #---------------------------------------------------------------------------
    def on_item_change
      if item
        show
      else
        select(0)
        hide
      end
      unselect
      refresh
      self.oy = 0
    end
    #---------------------------------------------------------------------------
    # * Bonus selection event
    #---------------------------------------------------------------------------
    def select(index)
      super
      help_window.set_item(bonus)
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
      return unless CC.expertise_command_visible
      ep = actor.expertise_points? || return
      
      rect = Rect.new(x, y, width, line_height)
      change_color(system_color)
      draw_text(subrect(rect, -0.6), XPTS_POINTS_A)
      
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
      return unless CC.expertise_command_enabled
      return unless CC.expertise_command_visible
      return unless party_expertise_remaining?
      change_color(Window.golden_shine)
      rect = item_rect_for_text(self.class.expertise_command_index)
      draw_text(rect, CMD_EXPERTISE, alignment)
    end
    #---------------------------------------------------------------------------
    # * True if any Party Actor still has Expertise points to invest.
    #---------------------------------------------------------------------------
    def party_expertise_remaining?
      $game_party.battle_members.any? do |actor|
        actor.expertise_points?
      end
    end
    #---------------------------------------------------------------------------
    # * Adds the expertise command to the main menu
    #---------------------------------------------------------------------------
    def add_expertise_to_menu
      visible = CC.expertise_command_visible
      enabled = CC.expertise_command_enabled
      return add_command("", :expertise, false) unless visible
      self.class.expertise_command_index = item_max
      add_command(CMD_EXPERTISE, :expertise, enabled)
    end
  end
  
  #=============================================================================
  # ** Expert_Party
  #-----------------------------------------------------------------------------
  #  Class containing additional data to be inserted into Game_Party
  #=============================================================================
  
  class ::Game_Party
    #---------------------------------------------------------------------------
    # Returns true if cached items must be refreshed
    #---------------------------------------------------------------------------
    def need_refresh
      @need_refresh
    end
    #---------------------------------------------------------------------------
    # Mark the chached items as dirt or clean
    #---------------------------------------------------------------------------
    def need_refresh=(value)
      Expertise.refresh if value
      @need_refresh = value
    end
    #---------------------------------------------------------------------------
    # * Array containing every BaseItem currently added to the party, which
    #   means: Inventory Items, Equiped Items, Skills, States, Classes and the
    #   actors themselves.
    #---------------------------------------------------------------------------
    def all_base_items
      return @all_party_base_items unless need_refresh
      @need_refresh = false
      @all_party_base_items = battle_members
        .map { |actor| actor.inventory(true) }
        .concat(all_items)
        .flatten
        .uniq
    end
  end

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
    attr_accessor :need_refresh     # When true, will re-calculate inventory
    attr_reader   :last_expertise   # For cursor memorization:  Skill
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    alias initialize_caracrazy_o21a7j initialize
    def initialize(*args)
      initialize_caracrazy_o21a7j(*args)
      @expertises       = {}
      @expertise_points = 0
      @last_expertise   = RPG::Skill.new
    end
    #---------------------------------------------------------------------------
    # * Get the total expertise value of a skill
    #---------------------------------------------------------------------------
    def xpts(skill_id)
      expertises[skill_id].total
    end
    #---------------------------------------------------------------------------
    # * Game_Actor's particular memoized inventory
    #---------------------------------------------------------------------------
    def inventory(force_refresh = false)
      return @inventory unless need_refresh || force_refresh
      need_refresh = false
      @inventory = all_base_items
    end
    #---------------------------------------------------------------------------
    # * Set expertise_points
    #---------------------------------------------------------------------------
    def expertise_points=(value)
      Expertise.refresh
      @expertise_points = [0, value].max
    end
    #---------------------------------------------------------------------------
    # * False unless expertise_points are not zero else return expertise pts
    #---------------------------------------------------------------------------
    def expertise_points?
      expertise_points > 0 ? expertise_points : false
    end
    #---------------------------------------------------------------------------
    # * Lists all xtypes (Expertise Types) this actor has from his Expertises
    #---------------------------------------------------------------------------
    def added_expertise_types
      skills.map(&:xtype).uniq.compact
    end
    #---------------------------------------------------------------------------
    # * Get expertise data for a given Expertise
    #---------------------------------------------------------------------------
    def expertise(skill)
      expertises[skill.id] ||= Expertise.new(self, skill)
    end
    #---------------------------------------------------------------------------
    # * Allocated points in a given Expertise
    #---------------------------------------------------------------------------
    def base_expertise(skill)
      expertise(skill).allocations
    end
    #---------------------------------------------------------------------------
    # * Total expertise of a skill by taking Bonuses into account
    #---------------------------------------------------------------------------
    def total_expertise(skill)
       expertise(skill).total
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
    # * Removes a expertise point from the actor to increase skill expertise
    #---------------------------------------------------------------------------
    def allocate_expertise(skill)
      self.expertise_points -= 1
      expertise(skill).allocate
      @last_expertise = skill
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
    # * List of all base_items this Game_Actor is carrying, including the 
    #   actor itself.
    #---------------------------------------------------------------------------
    def all_base_items
      return [] unless alive?
      [actor, self.class] + weapons + armors + skills + states
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
  end
  
  #=============================================================================
  # ** Expertise
  #-----------------------------------------------------------------------------
  #  Class containing expertise data (Allocations, Synergies, Bonuses etc)
  #=============================================================================
  
  class Expertise
    class << self
      #-------------------------------------------------------------------------
      # Memoization flag used to mark if expertises shall recalculate values.
      #-------------------------------------------------------------------------
      def memoizer
        @memoizer ||= 1
      end
      #-------------------------------------------------------------------------
      # * forces expertises to recalculate, by changing the memoizer
      #-------------------------------------------------------------------------
      def refresh
        @memoizer ||= 1
        @memoizer += 1 
      end
    end
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
    #---------------------------------------------------------------------------
    # * Total expertise taking Synergies, bonuses and multipliers into account
    #---------------------------------------------------------------------------
    def total
      return @memo if @memoizer && @memoizer == self.class.memoizer
      @memoizer = self.class.memoizer
      synergies = Synergy_Bonus_Mode.total(self, 0)
      iterms = Individual_Bonus_Mode.total(self, 0)
      @memo = Bonus_Mode.total(self, allocations + synergies + iterms).floor
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
    # * Expertise_Type - Similar to Skill's stype, but for Expertises
    #---------------------------------------------------------------------------
    def xtype
      @xtype ||= retrieve_xtype_data
    end
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
      return @descriptors if @descritors
      @descriptors = retrieve_bonus_from_data + [xtype.to_s.downcase, id.to_s]
    end
    #---------------------------------------------------------------------------
    # * xtype from a retrieved notetag
    #---------------------------------------------------------------------------
    def retrieve_xtype_data
      (expertise_tag || {})[:st]
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
    # * Match_data from the first match of <Expertise: xtype>
    #---------------------------------------------------------------------------
    def expertise_tag
      Notetag.scan_tags(note, :expertise).first
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
  # ** Bonus_Header
  #-----------------------------------------------------------------------------
  #  Represents an abstract bonus entry inside the bonus inspector to serve as
  #  a separator between different bonus types
  #=============================================================================
  
  class Header
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_accessor :text         # The text displayed on the left
    attr_accessor :color        # Text's color
    attr_accessor :padding      # Text's identation
    attr_accessor :value_text   # Value's text. The text displayed on the right
    attr_accessor :value_color  # Value's text color
    attr_accessor :icon         # Hash of Iconset name and index {:name, :index}
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize
      @text        = ""
      @color       = 16
      @value_text  = ""
      @value_color = 0
      @padding     = 0
      @icon        = {}
    end
    #---------------------------------------------------------------------------
    # * Description text displayed in the Help Window
    #---------------------------------------------------------------------------
    def description=(value)
      @description = process_special_tags(value)
    end
    #---------------------------------------------------------------------------
    # * Description text displayed in the Help Window
    #---------------------------------------------------------------------------
    def description
      @description ||= process_special_tags(mode.description.to_s)
    end
    #---------------------------------------------------------------------------
    # * Replaces special tags
    #---------------------------------------------------------------------------
    def process_special_tags(str)
      result = str.clone
      result.gsub!(/<desc>/i)  { display_descriptor }
      result.gsub!(/<value>/i) { "\\c[#{value_color}]#{value_text}\\c[0]" }
      result.gsub!(/<name>/i)  { mode.name }
      word_wrap(result)
    end
    #---------------------------------------------------------------------------
    # * Returns an integer if descriptor is an integer, otherwise returns nil
    #---------------------------------------------------------------------------
    def is_descriptor_a_skill?
      return @descriptor_skill if @descriptor_skill_memo
      @descriptor_skill_memo = true
      @descriptor_skill = $data_skills[is_descriptor_an_integer? || 0]
    end
    #---------------------------------------------------------------------------
    # * Creates a nice display string for the bonus descriptor
    #---------------------------------------------------------------------------
    def display_descriptor
      (skill = is_descriptor_a_skill?) ? skill.name : @descriptor.capitalize
    end
    #---------------------------------------------------------------------------
    # * Returns an integer if descriptor is an integer, otherwise returns nil
    #---------------------------------------------------------------------------
    def is_descriptor_an_integer?
      Integer(descriptor) rescue nil
    end
    #---------------------------------------------------------------------------
    # * Insert line breaks based on line_width
    #---------------------------------------------------------------------------
    def word_wrap(text, line_width = 52)
      text.split("\n").collect! do |line|
        if line.length > line_width 
          line.gsub(/(.{1,#{line_width}})(\s+|$)/, "\\1\n").strip 
        else
          line
        end
      end * "\n"
    end
    #---------------------------------------------------------------------------
    # * The header enabled status
    #---------------------------------------------------------------------------
    def enabled?(*args)
      true
    end
  end
  
  #=============================================================================
  # ** Bonus_Base
  #-----------------------------------------------------------------------------
  #  Represents a single bonus provenient from a RPG::BaseItem
  #=============================================================================
  
  class Bonus_Base < Header
    #---------------------------------------------------------------------------
    # * Public instance attributes
    #---------------------------------------------------------------------------
    attr_reader :item, :value
    #---------------------------------------------------------------------------
    # * Object Initialization
    #---------------------------------------------------------------------------
    def initialize(item, value)
      super()
      @item       = item
      @value      = value.to_f
      @color      = 0
      @descriptor = item.name
    end
    #---------------------------------------------------------------------------
    # * The text displayed on the left
    #---------------------------------------------------------------------------
    def text
      item.name
    end
    #---------------------------------------------------------------------------
    # * Padding
    #---------------------------------------------------------------------------
    def padding
      super + (icon[:index] ? 32 : 8)
    end
    #---------------------------------------------------------------------------
    # * Creates a hash containing info about the image used as the bonus' icon
    #     returns : {:name, :index}
    #---------------------------------------------------------------------------
    def icon
      return @icon if @icon_memo
      @icon_memo = true
      if item.respond_to?(:face_name)
        @icon[:index] = item.face_index
        @icon[:name ] = item.face_name
      elsif item.respond_to?(:icon_index)
        @icon[:index] = item.icon_index
      end
      @icon
    end
    #---------------------------------------------------------------------------
    # * Value's color. The color of the text displayed on the right
    #---------------------------------------------------------------------------
    def value_color
      return @value_color if @value_color_memo
      @value_color_memo = true
      @value_color = mode.display_color(value)
    end
    #---------------------------------------------------------------------------
    # * Value's text. The text displayed on the right
    #---------------------------------------------------------------------------
    def value_text
      return @value_text if @value_text_memo
      @value_text_memo = true
      @value_text = mode.display_text(value)
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
  
  class ::Object;  def to_h;      Hash[self]; end; end
  class ::Hash;    def to_h;      self;       end; end
  class ::Numeric; def positive?; self >= 0;  end; end
    
end

#-------------------------------------------------------------------------------
# End of script.
#-------------------------------------------------------------------------------
=end