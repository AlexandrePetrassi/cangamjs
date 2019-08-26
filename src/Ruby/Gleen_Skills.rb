#-------------------------------------------------------------------------------
# Sistema de Perícia
# Autor: Gleen
# Versão: 1.0
# Data: 17/07/2012
#-------------------------------------------------------------------------------
# Introduz niveis de pericia para manejo de armas, elementos mágicos, magias e
# habilidades. Os niveis de pericia em armas e elementos mágicos possibilitam
# que os personagens aprendam novas habilidades/magias. Os niveis de pericia
# em habilidades e mágicas aumentam o poder dos mesmos.
#
#-------------------------------------------------------------------------------
# Indice
#-------------------------------------------------------------------------------
# 1. Termos de uso
# 2. Instalação
# 3. Instruções de uso
# 4. Configuração
# 4.1. Configuração - Elementos Válidos
# 4.2. Configuração - Armas Válidas
# 4.3. Configuração - Taxa de Crescimento
# 4.4. Configuração - Requerimentos de aprendizado
# 5. Compatibilidade
#
#-------------------------------------------------------------------------------
# 1. Termos de uso
#-------------------------------------------------------------------------------
# 1. O uso do script é permitido para jogos não-comerciais e comerciais.
# 2. Você deve dar créditos ao criador deste script
# 3. Você não pode se dar créditos por compartilhar esse script em outros locais
# 4. Você é livre para editar qualquer parte deste código.
# 5. Não será prestado suporte em erros causados por edição de terceiros
# 6. Não será prestado suporte em erros causados por problemas de compatibilidade
# 
#-------------------------------------------------------------------------------
# 2. Instalação
#-------------------------------------------------------------------------------
# Copie este script para uma nova seção abaixo da seção Scripts Adicionais do
# seu projeto. Leia os comentários do script para saber como configurá-lo e 
# utilizá-lo de maneira correta.
#
#-------------------------------------------------------------------------------
# 3. Instruções de uso
#-------------------------------------------------------------------------------
# Após instalar este script, você precisa configurar os elementos e armas
# válidas para suas classes, eles determinaram respectivamente quais elementos
# e tipos de arma darão pontos de pericia quando utilizados.
#
# Depois de configurar os elementos e armas válidas, você deve configurar a
# taxa de crescimento das armas e das habilidades, elas determinam o valor bruto
# de pericia que darão ao personagem quando utilizadas.
#
# O próximo passo é configurar os requerimentos de aprendizado de cada habilidade.
# Quando os requirmentos para uma determinada habilidade forem alcançados por
# um personagem que possa utilizar a mesma, o personagem aprenderá a habilidade.
#
# Por fim, é necessário configurar a lista de habilidades de cada personagem.
# Esta lista indica quais habilidades o personagem pode aprender através deste
# sistema. AVISO: O sistema não impede que habilidades ainda possam ser aprendidas
# da meneira padrão do maker, através de niveis.
#
#-------------------------------------------------------------------------------
# 4. Configuração
#-------------------------------------------------------------------------------
# Esta seção descreve as configurações que podem e/ou devem ser feitas para o
# funcionamento deste sistema.
#
#-------------------------------------------------------------------------------
# 4.1. Configuração - Elementos Válidos
#-------------------------------------------------------------------------------
# Você pode limitar os elementos que darão pontos de pericia quando utilizados
# por uma determinada classe. Para limitar os elementos que dão pontos de 
# pericia adicione uma nota no campo de notas da classe:
#
# <elemento: X> Onde X é o ID do elemento que dará os pontos
#
# AVISO: Este sistema não impede que um personagem utilize uma skill que não
# seja de um dos elementos válidos. Você deve configurar corretamente as
# habilidades em seu banco de dados para condizer com os elementos válidos que 
# você determina.
#
#-------------------------------------------------------------------------------
# 4.2. Configuração - Armas válidas
#-------------------------------------------------------------------------------
# Você pode limitar quais tipos de arma darão pontos de pericia quando utilizados
# por uma determinada classe. Para limitar os tipos de arma que dão pontos de
# pericia adicione uma nota no campo de notas da classe:
#
# <armamento: X> Onde X é o ID do tipo de arma que dará os pontos
#
# AVISO: Este sistema não impede que um personagem equipe um armamento que não
# seja de uma das armas válidas. Você deve configurar corretamente as restrições
# de equipamento para suas classes no banco de dados para condizer com as armas
# válidas que você determinou.
#
#-------------------------------------------------------------------------------
# 4.3. Configuração - Taxa de crescimento
#-------------------------------------------------------------------------------
# Taxa de crescimento é o valor bruto de experiência que a utilização de uma
# habilidade ou o tipo do equipamento irá beneficiar ao personagem quando
# utilizado. 
#
# Por exemplo, ao realizar um ataque fisico, será considerado a taxa de 
# crescimento de um ataque fisico mais a taxa de crescimento do equipamento 
# utilizado. Suponhamos que a taxa de crescimento do ataque fisico é 1, e do
# equipamento utilizado é 6. Ao realizar um ataque fisico, os pontos de exp
# brutos dado a estas pericias seriam 7.
#
# Para configurar a taxa de crescimento das habilidades e dos equipamentos,
# adicione uma nota no campo notas das habilidades e equipamentos:
#
# <taxa_exp: X> Onde X é a taxa de crescimento 
#
#-------------------------------------------------------------------------------
# 4.4. Configuração - Requerimentos de aprendizado
#-------------------------------------------------------------------------------
# Requerimentos de aprendizado são os requerimentos de niveis em elementos 
# mágicos e tipos de arma de uma determinada habilidade. Quando alcançados por
# um personagem que possa utilizá-la, o mesmo irá aprender esta habilidade
#
# AVISO: Este sistema não impede que o personagem ainda possa aprender suas
# habilidades pelo sistema padrão do maker, se você deseja impedir o aprendizado
# baseado em niveis do personagem, edite seu banco de dados para condizer com o
# que deseja.
#
# Para configurar os requerimentos para uma habilidade, adicione  uma nota no
# campo de notas da habilidade:
#
# <require: WEAPON id: X lvl: Y> ou <require: MAGIC id: X lvl: Y>
#
# Onde:
#
# WEAPON/ MAGIC: indica se é um tipo de arma ou um elemento mágico
# X: ID do tipo de arma/elemento mágico requerido
# Y: Nivel requerido
# 
#-------------------------------------------------------------------------------
# 5. Compatibilidade
#-------------------------------------------------------------------------------
# Segue uma lista de classes e métodos da engine padrão que são modificados por
# este script. Se você utiliza algum script que modifique os mesmos métodos ou
# classes, a chance de ter um problema de compatibilidade pode aumentar.
#
# BattleManager -> display_exp
# BattleManager -> battle_end
# Game_ActionResult -> clear
# Game_Battler -> item_apply
# Game_Actor -> setup
# Window_MenuCommand -> add_original_commands
# Window_BattleLog -> display_action_results
# Scene_Menu -> create_command_window
#-------------------------------------------------------------------------------
module Gleen
    #-----------------------------------------------------------------------------
    # Configurações
    #-----------------------------------------------------------------------------
    # As constantes abaixo determinam as opções e outras informações pertinentes
    # á utilização do sistem de pericia. Leia os comentários que descrevem as
    # opções e alterem caso seja necessário.
    #-----------------------------------------------------------------------------
    module Setup
      #---------------------------------------------------------------------------
      # NÃO ALTERE ESTA PARTE
      #---------------------------------------------------------------------------
      WEAPON = 0  # Código para indicar o uso de tipo de arma
      MAGIC = 1   # Código para indicar o uso de um elemento mágico
      #---------------------------------------------------------------------------
      # ALTERE ABAIXO DE ACORDO COM SUA NECESSIDADE
      #---------------------------------------------------------------------------
      WEAPON_MAXLEVEL = 99        # Level máximo para pericia em um tipo de arma
      MAGIC_MAXLEVEL = 99         # Level máximo para pericia em um elemento mágico
      DEFAULT_REQUIRED_EXP = 100  # Padrão da quantia de EXP requerida para lvl up
      PHYSICAL_ELEMENT = 1        # Elemento fisico padrão. Toda habilidade que possua esse elemento dará pontos para a arma
      MASK_UNLEARNED_SKILL = true # Se deve mascarar o nome das skills não aprendidas
      MASK_REQUIRED_LEVEL = true  # Se deve mascarar o niveis de requerimento das skills não aprendidas
      MASK_HELP_TEXT = true       # Se deve mascarar o texto de ajuda das skills não aprendidas
      LEVEL_THRESHOLD = 5         # Limite de nivel abaixo para mascara do nivel, enqnto o requerimento for X ou mais levels acima do atual, irá mascarar o texto.
      MASK_CHARACTER = "?"        # Caracter que irá mascarar os textos
      PLAY_LEVEL_UP_SOUND = true  # Tocar SE quando uma pericia subir de nivel
      #---------------------------------------------------------------------------
      # Abaixo configure as opções da reprodução de som para level up caso esteja
      # utilizando o efeito de reproduzir um som
      # Padrão: ["Nome do arquivo", volume, tom]
      #---------------------------------------------------------------------------
      LEVEL_UP_SOUND = ["Decision2", 80, 80]
      #---------------------------------------------------------------------------
      # Abaixo configure a mensagem a ser exibida quando adquirir pontos em
      # pericia.
      # Formato: [nome do personagem] ganhou [pontos] pontos de pericia em [nome da pericia]
      #---------------------------------------------------------------------------
      EXP_GAINED_TEXT = "%s ganhou %s pontos de pericia em %s"
      #---------------------------------------------------------------------------
      # Abaixo configure a mensagem a ser exibida quando subir de nivel em pericia
      # Formato: [nome do personagem] subiu seu nivel de pericia em [nome da pericia]
      #---------------------------------------------------------------------------
      LEVEL_UP_TEXT = "%s subiu seu nivel de pericia em %s"
      #---------------------------------------------------------------------------
      # Abaixo configura a mensagem a ser exibida quando um personagem aprender
      # uma nova habilidade.
      # Formato: [nome do personagem] aprendeu [nome da habilidade
      #---------------------------------------------------------------------------
      LEARN_SKILL_TEXT = "%s aprendeu %s!"
      #---------------------------------------------------------------------------
      # Hash da listagem de skills
      #---------------------------------------------------------------------------
      # Lista as skills que os personagens podem aprender através do sistema de
      # pericia. O hash deve ser preenchido da seguinte forma:
      #
      # ID do personagem no banco de dados => [id da skill 1, id da skill 2, ...]
      #
      #---------------------------------------------------------------------------
      # EXEMPLO
      #---------------------------------------------------------------------------
      # Abaixo segue um exemplo da configuração do personagem de ID 1 no banco de
      # dados.
      #
      # 1 => [23,32,52,56,57,59,60]
      #
      # Desta forma, o personagem de ID 1 poderá aprender as habilidades dos IDs
      # 23,32,52,56,57,59 e 60.
      #
      #---------------------------------------------------------------------------
      SKILL_LIST = {}
      #---------------------------------------------------------------------------
      # Hash dos tipos de armas
      #---------------------------------------------------------------------------
      # Customização dos tipos de armamento, este hash amplia a customização dos
      # elementos. O ID de entrada neste hash se refere a uma entrada na seção
      # tipos de arma do banco de dados.
      #
      # ID => {
      #        :icon_id
      #        :custom_exp?
      #        :custom_required_exp
      #        :advanced?
      #        :base_types
      #       }
      #
      # icon_id: Indice do icone que representará o tipo de arma no iconset
      # custom_exp?: True/false. Indica se deve utilizar um requerimento de exp
      #              customizado.
      # custom_required_exp: Se custom_exp? for true, determina o requerimento de
      #                      exp necessário para subir de nivel.
      # advanced?: True/false. Indica se este tipo de arma é um tipo avançado.
      # base_types: Se advanced for true, este array aponta para os IDs dos tipos
      #             base. Ao receber experiência, ambos os tipos base irão
      #             receber EXP.
      #
      #---------------------------------------------------------------------------
      # EXEMPLO:
      #---------------------------------------------------------------------------
      # Abaixo o exemplo de configuração do tipo de arma Machado, que no banco de
      # dados padrão é o ID 1.
      #
      # 1 => { :icon_id => 144,           # Indice do icone da arma no iconset
      #        :custom_exp? => false,     # Não utilizar requerimento customizado
      #        :custom_required_exp => 0, # Uma vez que não usa requerimento customizado, o valor é 0
      #        :advanced? => false,       # Não é um elemento avançado
      #        :base_types => []          # Uma vez que não é elemento avançado, o array é vazio.
      #  },
      #
      #---------------------------------------------------------------------------
      WEAPON_TYPES = {}
      #---------------------------------------------------------------------------
      # Hash dos elementos mágicos
      #---------------------------------------------------------------------------
      # Customização dos elementos mágicos, este hash amplia a customização dos
      # elementos. O ID de entrada neste hash se refere a uma entrada na seção
      # elementos do banco de dados
      #
      # ID => {
      #        :icon_id
      #        :custom_exp?
      #        :custom_required_exp
      #        :advanced?
      #        :base_types
      #       }
      #
      # icon_id: Indice do icone que representará o elemento mágico no iconset
      # custom_exp?: True/false. Indica se deve utilizar um requerimento de exp
      #              customizado.
      # custom_required_exp: Se custom_exp? for true, determina o requerimento de
      #                      exp necessário para subir de nivel.
      # advanced?: True/false. Indica se este elemento é um elemento avançado.
      # base_types: Se advanced for true, este array aponta para os IDs dos
      #             elementos base. Ao receber experiência, ambos os tipos base 
      #             irão receber EXP.
      #
      #---------------------------------------------------------------------------
      # EXEMPLO:
      #---------------------------------------------------------------------------
      # Abaixo o exemplo da configuração do elemento Fogo, que no banco de dados
      # padrão é o elemento de ID 3.
      #
      # 3 => {  :icon_id => 96,             # Indice do icone do elemento no iconset
      #         :custom_exp? => false,      # Não usará um requerimento customizado
      #         :custom_required_exp => 0,  # Uma vez que não usa requerimento customizado, o valor é 0
      #         :advanced? => false,        # Não é um elemento avançado
      #         :base_types => []           # Uma vez que não é elemento avançado, o array é vazio.
      #  },
      #
      #---------------------------------------------------------------------------
      MAGIC_ELEMENTS = {}
    end
    #-----------------------------------------------------------------------------
    # NÃO EDITE ESTA PARTE
    #-----------------------------------------------------------------------------
    def self.get_skill_requirements(skill)
      target = $data_skills[skill].note
      regexp = /<require: ([\w]+) id: ([\d]+) lvl: ([\d]+)%?>/i
      result = target.scan(regexp)
      return result
    end
  end
  
  #-------------------------------------------------------------------------------
  # BattleManager
  #-------------------------------------------------------------------------------
  module BattleManager
    class << self
      #---------------------------------------------------------------------------
      # Listando os alias
      #---------------------------------------------------------------------------
      alias old_display_exp display_exp
      alias old_battle_end battle_end
      #---------------------------------------------------------------------------
      # Mostrando Texto de recebimento de EXP
      #---------------------------------------------------------------------------
      def display_exp
        old_display_exp
        $game_party.all_members.each do |actor|
          if actor.tmp_wexp.size > 0
            actor.tmp_wexp.each{|key,value|
              arma = $data_system.weapon_types[key]
              fmt = Gleen::Setup::EXP_GAINED_TEXT 
              $game_message.add('\.' + sprintf(fmt, actor.name, value.to_s, arma))
            }
          end
          if actor.tmp_mexp.size > 0
            actor.tmp_mexp.each{|key,value|
              elemento = $data_system.elements[key]
              fmt = Gleen::Setup::EXP_GAINED_TEXT 
              $game_message.add('\.' + sprintf(fmt, actor.name, value.to_s, elemento))
            }
          end
        end
      end
      #---------------------------------------------------------------------------
      # Encerrando batalha
      #---------------------------------------------------------------------------
      def battle_end(result)
        clear_temp_exp
        old_battle_end(result)
      end    
    end
    #-----------------------------------------------------------------------------
    # Limpa a Experiência temporaria
    #-----------------------------------------------------------------------------
    def self.clear_temp_exp
      $game_party.all_members.each do |actor|
        actor.tmp_wexp = {} if actor.tmp_wexp.size > 0
        actor.tmp_mexp = {} if actor.tmp_mexp.size > 0
      end
    end
  end
  
  #-------------------------------------------------------------------------------
  # Game_ActionResult
  #-------------------------------------------------------------------------------
  class Game_ActionResult
    #-----------------------------------------------------------------------------
    # Inclui o modulo Gleen::Setup
    #-----------------------------------------------------------------------------
    include Gleen::Setup
    #-----------------------------------------------------------------------------
    # Variaveis de acesso publico
    #-----------------------------------------------------------------------------
    attr_accessor :skill_levelup
    attr_accessor :user_target
    attr_accessor :level_target
    attr_accessor :learned_skill
    attr_accessor :skill_learned
    #-----------------------------------------------------------------------------
    # Listagem dos alias
    #-----------------------------------------------------------------------------
    alias old_clear clear
    #-----------------------------------------------------------------------------
    # Limpa os resultados
    #-----------------------------------------------------------------------------
    def clear
      old_clear
      clear_levelup
    end
    #-----------------------------------------------------------------------------
    # Limpa o texto a ser desenhado
    #-----------------------------------------------------------------------------
    def clear_levelup
      @skill_levelup = false
      @learned_skill = false
    end
    #-----------------------------------------------------------------------------
    # Desenha o text de level up
    #-----------------------------------------------------------------------------
    def draw_skill_levelup
      if @skill_levelup
        fmt = LEVEL_UP_TEXT
        sprintf(fmt, @user_target, @level_target)
      end
    end
    #-----------------------------------------------------------------------------
    # Desenha o texto quando aprende uma nova habilidade
    #-----------------------------------------------------------------------------
    def draw_learned_skill
      if @learned_skill
        fmt = LEARN_SKILL_TEXT
        sprintf(fmt, @user_target, @skill_learned)
      end
    end
  end
  
  #-------------------------------------------------------------------------------
  # Game_Battler
  #-------------------------------------------------------------------------------
  class Game_Battler < Game_BattlerBase
    #-----------------------------------------------------------------------------
    # inclui o modulo Gleen::Setup
    #-----------------------------------------------------------------------------
    include Gleen::Setup
    #-----------------------------------------------------------------------------
    # * Aplicar habilidades/itens
    #     user : usuário
    #     item : habilidade/item
    #-----------------------------------------------------------------------------
    def item_apply(user, item)
      @result.clear
      @result.used = item_test(user, item)
      @result.missed = (@result.used && rand >= item_hit(user, item))
      @result.evaded = (!@result.missed && rand < item_eva(user, item))
      if @result.hit?
        process_exp(user, item) if user.actor?
        unless item.damage.none?
          @result.critical = (rand < item_cri(user, item))
          make_damage_value(user, item)
          execute_damage(user)
        end
        item.effects.each {|effect| item_effect_apply(user, item, effect) }
        item_user_effect(user, item)
      end
    end
    #-----------------------------------------------------------------------------
    # Processa o ganho de pontos de pericia
    #-----------------------------------------------------------------------------
    def process_exp(user, item)
      if normal_attack?(item)
        add_weapon_exp(user)
      else
        elements = get_element(item)
        if elements.is_a?(Array)
          for i in 0...elements.size
            if elements[i] == PHYSICAL_ELEMENT
              add_weapon_exp(user)
            else
              add_magic_exp(user, item, elements[i])
            end
          end
        else
          if elements == PHYSICAL_ELEMENT
            add_weapon_exp(user)
          else
            add_magic_exp(user, item, elements)
          end
        end
      end
    end
    #-----------------------------------------------------------------------------
    # Adiciona exp dos elementos mágicos
    #-----------------------------------------------------------------------------
    def add_magic_exp(user, item, element)
      return if !MAGIC_ELEMENTS.include?(element)
      old_level = user.magic_level(element)
      actor = $game_party.members[user.index]
      exp = get_exp(item)
      if actor.tmp_mexp.include?(element)
        actor.tmp_mexp[element] += exp
      else
        actor.tmp_mexp[element] = exp
      end
      actor.add_exp(MAGIC, element, exp)
      new_level = user.magic_level(element)
      if new_level > old_level
        do_level_up(user, MAGIC, element)
      end
    end
    #-----------------------------------------------------------------------------
    # Adiciona exp das armas
    #-----------------------------------------------------------------------------
    def add_weapon_exp(user)
      weapon = get_weapon(user)
      return if !WEAPON_TYPES.include?(weapon[1])
      old_level = user.weapon_level(weapon[1])
      exp = get_exp(weapon[0])
      actor = $game_party.members[user.index]
      if actor.tmp_wexp.include?(weapon[1])
        actor.tmp_wexp[weapon[1]] += exp
      else
        actor.tmp_wexp[weapon[1]] = exp
      end
      actor.add_exp(WEAPON, weapon[1], exp)
      new_level = user.weapon_level(weapon[1])
      if new_level > old_level
        do_level_up(user, WEAPON, weapon[1])
      end
    end
    #-----------------------------------------------------------------------------
    # Executa ação de Level Up
    #-----------------------------------------------------------------------------
    def do_level_up(user, type, target)
      Audio.se_play("Audio/SE/" + LEVEL_UP_SOUND[0], LEVEL_UP_SOUND[1], LEVEL_UP_SOUND[2]) if PLAY_LEVEL_UP_SOUND
      @result.user_target = user.name
      @result.skill_levelup = true
      case type
      when 0
        item = $data_system.weapon_types[target]
      when 1
        item = $data_system.elements[target]
      end
      @result.level_target = item
      learn_skills(user)
    end
    #-----------------------------------------------------------------------------
    # Aprende Habilidades
    #-----------------------------------------------------------------------------
    def learn_skills(user)
      SKILL_LIST[user.actor.id].each do |skill|
        if can_learn_skill?(user, skill) && !user.skills.include?($data_skills[skill])
          user.learn_skill(skill)
          @result.learned_skill = true
          @result.user_target = user.name
          @result.skill_learned = $data_skills[skill].name
        end
      end
    end
    #-----------------------------------------------------------------------------
    # Pode aprender a habilidade?
    #-----------------------------------------------------------------------------
    def can_learn_skill?(user, skill)
      requirements = Gleen::get_skill_requirements(skill)
      error = 0
      for i in 0...requirements.size
        case requirements[i][0]
        when "WEAPON"
          level = user.weapon_level(requirements[i][1].to_i)
          error += 1 if level < requirements[i][2].to_i
        when "MAGIC"
          level = user.magic_level(requirements[i][1].to_i)
          error += 1 if level < requirements[i][2].to_i
        end
      end
      if error == 0
        return true
      else
        return false
      end
    end
    #-----------------------------------------------------------------------------
    # É um ataque normal?
    #-----------------------------------------------------------------------------
    def normal_attack?(item)
      return true if item.id == attack_skill_id
    end
    #-----------------------------------------------------------------------------
    # Seleciona o tipo do armamento
    # user: id do personagem
    #-----------------------------------------------------------------------------
    def get_weapon(user)
      weapon = user.equips[0]
      type = user.equips[0].wtype_id
      return [weapon, type]
    end
    #-----------------------------------------------------------------------------
    # Seleciona o elemento mágico
    # Se o elemento for avançado, retorna todos os elementos base do elemento
    # avançados
    # skill: skill utilizada
    #-----------------------------------------------------------------------------
    def get_element(skill)
      element =  skill.damage.element_id
      return element if !MAGIC_ELEMENTS.include?(element)
      if MAGIC_ELEMENTS[element][:advanced?]
        return MAGIC_ELEMENTS[element][:base_types]
      else
        return element
      end
    end
    #-----------------------------------------------------------------------------
    # Retorna a Taxa de EXP de um equipamento
    # target: id do equipamento
    #-----------------------------------------------------------------------------
    def get_exp(target)
      regexp = /<taxa_exp: (\d+)%?>/i
      exp = target.note.scan(regexp)
      n = []
      for i in 0...exp.size
        n.push(exp[i][0].to_i)
      end
      return n[0]
    end
  end
  
  #-------------------------------------------------------------------------------
  # Game_Actor
  #-------------------------------------------------------------------------------
  class Game_Actor
    #-----------------------------------------------------------------------------
    # inclui o modulo Gleen::Setup
    #-----------------------------------------------------------------------------
    include Gleen::Setup
    #-----------------------------------------------------------------------------
    # Variaveis publicas
    #-----------------------------------------------------------------------------
    attr_accessor :weapon_exp, :magic_exp, :tmp_wexp, :tmp_mexp
    attr_reader :weapon_maxlvl, :magic_maxlvl, :valid_elements, :valid_weapons
    #-----------------------------------------------------------------------------
    # Listando os alias
    #-----------------------------------------------------------------------------
    alias old_setup setup
    #-----------------------------------------------------------------------------
    # Setup
    #-----------------------------------------------------------------------------
    def setup(actor_id)
      old_setup(actor_id)
      @weapon_exp = {}
      @magic_exp = {}
      @tmp_wexp = {}
      @tmp_mexp = {}
      @weapon_maxlvl = WEAPON_MAXLEVEL
      @magic_maxlvl = MAGIC_MAXLEVEL
      @valid_elements = get_elements
      @valid_weapons = get_weapons
    end
    #-----------------------------------------------------------------------------
    # Retorna o level de uma determinada pericia com arma
    # type: Id do tipo de arma
    #-----------------------------------------------------------------------------
    def weapon_level(type)
      return 0 if !@weapon_exp.include?(type)
      lvl = WEAPON_TYPES[type][:custom_exp?] ? @weapon_exp[type] / WEAPON_TYPES[type][:custom_required_exp] : @weapon_exp[type] / DEFAULT_REQUIRED_EXP
      if lvl <= @weapon_maxlvl
        return lvl
      else
        return @weapon_maxlvl
      end
    end
    #-----------------------------------------------------------------------------
    # Retorna o level de uma determinada pericia em elemento mágico
    # element: o Id do elemento mágico
    #-----------------------------------------------------------------------------
    def magic_level(element)
      return 0 if !@magic_exp.include?(element)
      lvl = MAGIC_ELEMENTS[element][:custom_exp] ? @magic_exp[element] / MAGIC_ELEMENTS[element][:custom_required_exp] : @magic_exp[element] / DEFAULT_REQUIRED_EXP
      if lvl <= @magic_maxlvl
        return lvl
      else
        return @magic_maxlvl
      end
    end
    #-----------------------------------------------------------------------------
    # Adiciona EXP
    # target: 0 = equipamento, 1 = magia
    # Type: ID do tipo de equipamento/elemento mágico
    # amount: quantidade a ser adicionada
    #-----------------------------------------------------------------------------
    def add_exp(target, type, amount)
      case target
      when 0
        if @weapon_exp.include?(type)
          @weapon_exp[type] += amount if weapon_level(type) < @weapon_maxlvl
        else
          @weapon_exp[type] = amount
        end
      when 1
        if @magic_exp.include?(type)
          @magic_exp[type] += amount if magic_level(type) < @magic_maxlvl
        else
          @magic_exp[type] = amount
        end
      end
    end
    #-----------------------------------------------------------------------------
    # Remove EXP
    # target: 0 = equipamento, 1 = magia
    # type: ID do tipo de equipamento/elemento mágico
    # amount: quantidade a ser adicionada
    #-----------------------------------------------------------------------------
    def remove_exp(target, type, amount)
      case target
      when 0
        @weapon_exp[type] -= amount if @weapon_exp.include?(type)
        @weapon_exp[type] = 0 if @weapon_exp[type] < 0
      when 1
        @magic_exp[type] -= amount if @magic.exp.include?(type)
        @magic_exp[type] = 0 if @magic_exp[type] < 0
      end
    end
    #-----------------------------------------------------------------------------
    # Seleciona os elementos que o herói pode utilizar
    #-----------------------------------------------------------------------------
    def get_elements
      target = $data_classes[@class_id].note
      regexp = /<elemento: (\d+)%?>/i
      elements = target.scan(regexp)
      n = []
      for i in 0...elements.size
        n.push(elements[i][0].to_i)
      end
      return n
    end
    #-----------------------------------------------------------------------------
    # Seleciona os tipos de arma que o heróis pode utilizar
    #-----------------------------------------------------------------------------
    def get_weapons
      target = $data_classes[@class_id].note
      regexp = /<armamento: (\d+)%?>/i
      weapons = target.scan(regexp)
      n = []
      for i in 0...weapons.size
        n.push(weapons[i][0].to_i)
      end
      return n
    end
    #-----------------------------------------------------------------------------
    # Razão da experiência de armas
    #-----------------------------------------------------------------------------
    def rate_wexp(weapon)
      return 0 if !WEAPON_TYPES.include?(weapon)
      if WEAPON_TYPES[weapon][:custom_exp?]
        rate = @weapon_exp[weapon].to_f % WEAPON_TYPES[weapon][:custom_required_exp]
        return rate / WEAPON_TYPES[weapon][:custom_required_exp]
      else
        rate = @weapon_exp[weapon].to_f % DEFAULT_REQUIRED_EXP
        return rate / DEFAULT_REQUIRED_EXP
      end
    end
    #-----------------------------------------------------------------------------
    # Razão da experiência dos elementos mágicos
    #-----------------------------------------------------------------------------
    def rate_mexp(magic)
      return 0 if !MAGIC_ELEMENTS.include?(magic)
      if MAGIC_ELEMENTS[magic][:custom_exp?]
        rate = @magic_exp[magic].to_f % MAGIC_ELEMENTS[magic][:custom_required_exp]
        return rate / MAGIC_ELEMENTS[magic][:custom_required_exp]
      else
        rate = @magic_exp[magic].to_f % DEFAULT_REQUIRED_EXP
        return rate / DEFAULT_REQUIRED_EXP
      end
    end
  end
  
  #-------------------------------------------------------------------------------
  # Window_Base
  #-------------------------------------------------------------------------------
  # Novos métodos para o sistema de pericia
  #-------------------------------------------------------------------------------
  class Window_Base < Window
    #-----------------------------------------------------------------------------
    # Inclui o modulo básico
    #-----------------------------------------------------------------------------
    include Gleen::Setup
    #-----------------------------------------------------------------------------
    # Desenha o level de pericia para uma determinada arma
    #-----------------------------------------------------------------------------
    def draw_weapon_level(actor, weapon, x, y)
      change_color(system_color)
      draw_text(x, y, 32, line_height, Vocab::level_a)
      change_color(normal_color)
      draw_text(x + 10, y, 32, line_height, actor.weapon_level(weapon), 2)
    end
    #-----------------------------------------------------------------------------
    # Desenha a barra de experiência para armas
    #-----------------------------------------------------------------------------
    def draw_weaponexp_bar(actor, weapon, x, y, width = 100)
      draw_gauge(x, y, width, actor.rate_wexp(weapon), tp_gauge_color1, tp_gauge_color2)
    end
    #-----------------------------------------------------------------------------
    # Desenha o level de pericia para um determinado elemento
    #-----------------------------------------------------------------------------
    def draw_magic_level(actor, magic, x, y)
      change_color(system_color)
      draw_text(x, y, 32, line_height, Vocab::level_a)
      change_color(normal_color)
      draw_text(x + 10, y, 32, line_height, actor.magic_level(magic), 2)
    end
    #-----------------------------------------------------------------------------
    # Desenha a barra de experiência para elementos mágicos
    #-----------------------------------------------------------------------------
    def draw_magicexp_bar(actor, magic, x, y, width = 100)
      draw_gauge(x, y, width, actor.rate_mexp(magic), tp_gauge_color1, tp_gauge_color2)
    end
    #-----------------------------------------------------------------------------
    # Desenha as informações do movimento
    #-----------------------------------------------------------------------------
    def draw_move_information(item, x, y, enabled = true, width = 172)
      return unless item
      if !enabled && MASK_UNLEARNED_SKILL
        draw_icon(item.icon_index, x, y)
        draw_text(x + 30, y, width, line_height, item.name.gsub(/[\S+]/, MASK_CHARACTER))
      else
        draw_icon(item.icon_index, x, y, enabled)
        change_color(normal_color, enabled)
        draw_text(x + 30, y, width, line_height, item.name)
      end
    end
    #-----------------------------------------------------------------------------
    # Desenha os requerimentos da habilidade
    #-----------------------------------------------------------------------------
    def draw_skill_requirements(actor,item, x, y, enabled = true)
      requirements = Gleen::get_skill_requirements(item.id)
      for i in 0...requirements.size
        if i != 0
          x = (x + 58)
        end
        case requirements[i][0]
        when "WEAPON"
          make_font_smaller
          draw_icon(WEAPON_TYPES[requirements[i][1].to_i][:icon_id],x,y)
          change_color(hp_gauge_color2)
          draw_text(x + 24, y + 4, 32, line_height, Vocab::level_a)
          change_color(normal_color)
          if !enabled && MASK_REQUIRED_LEVEL
            level = actor.weapon_level(requirements[i][1].to_i)
            threshold = requirements[i][2].to_i - level
            if threshold >= LEVEL_THRESHOLD
              draw_text(x + 38, y + 4, 32, line_height, requirements[i][2].gsub(/[\S+]/, MASK_CHARACTER))
            else
              draw_text(x + 38, y + 4, 32, line_height, requirements[i][2])
            end
          else
            draw_text(x + 38, y + 4, 32, line_height, requirements[i][2])
          end
          make_font_bigger
        when "MAGIC"
          make_font_smaller
          draw_icon(MAGIC_ELEMENTS[requirements[i][1].to_i][:icon_id],x,y)
          change_color(hp_gauge_color2)
          draw_text(x + 24, y + 4, 32, line_height, Vocab::level_a)
          change_color(normal_color)
          if !enabled && MASK_REQUIRED_LEVEL
            level = actor.magic_level(item)
            threshold = requirements[i][2].to_i - level
            if threshold >= LEVEL_THRESHOLD
              draw_text(x + 38, y + 4, 32, line_height, requirements[i][2].gsub(/[\S+]/, MASK_CHARACTER))
            else
              draw_text(x + 38, y + 4, 32, line_height, requirements[i][2])
            end
          else
            draw_text(x + 38, y + 4, 32, line_height, requirements[i][2])
          end
          make_font_bigger
        end
      end
    end
  end
  
  #-------------------------------------------------------------------------------
  # Window_Help
  #-------------------------------------------------------------------------------
  class Window_Help < Window_Base
    #-----------------------------------------------------------------------------
    # Exibe informações da skill
    #-----------------------------------------------------------------------------
    def skill_helper(skill, enabled = true)
      skill = $data_skills[skill]
      target = skill.description
      if !enabled && MASK_HELP_TEXT
        set_text(target.gsub(/[\S+]/, MASK_CHARACTER))
      else
        set_text(target)
      end
    end
  end
  
  #-------------------------------------------------------------------------------
  # Window_CharInfo
  #-------------------------------------------------------------------------------
  class Window_CharInfo < Window_Base
    #-----------------------------------------------------------------------------
    # inicialização
    #-----------------------------------------------------------------------------
    def initialize(actor)
      super(0,0,234, line_height * 5)
      @actor = actor
      refresh
    end
    #-----------------------------------------------------------------------------
    # Definição do Herói
    #-----------------------------------------------------------------------------
    def actor=(actor)
      return if @actor == actor
      @actor = actor
      refresh
    end
    #-----------------------------------------------------------------------------
    # Desenha as informações na tela
    #-----------------------------------------------------------------------------
    def refresh
      contents.clear
      draw_actor_face(@actor, 0, 0)
      draw_actor_name(@actor, 106, 0)
      draw_actor_class(@actor, 106, line_height * 1)
      draw_actor_level(@actor, 106, line_height * 2)
    end
  end
  
  
  #-------------------------------------------------------------------------------
  # Window_SkillLevels
  #-------------------------------------------------------------------------------
  # Mostra os niveis de pericia do personagem em cada um de seus elementos e tipos
  # de arma
  #-------------------------------------------------------------------------------
  class Window_SkillLevels < Window_Base
    #-----------------------------------------------------------------------------
    # Inicialização
    #-----------------------------------------------------------------------------
    def initialize(actor)
      super(0,0, 310, line_height * 5)
      @actor = actor
      refresh
    end
    #-----------------------------------------------------------------------------
    # Definição do herói
    #-----------------------------------------------------------------------------
    def actor=(actor)
      return if @actor == actor
      @actor = actor
      refresh
    end
    #-----------------------------------------------------------------------------
    # Desenha as informações na tela
    #-----------------------------------------------------------------------------
    def refresh
      contents.clear
      for i in 0...@actor.valid_weapons.size
        draw_icon(WEAPON_TYPES[@actor.valid_weapons[i]][:icon_id], 0, line_height * i)
        weapon = WEAPON_TYPES.index(WEAPON_TYPES[@actor.valid_weapons[i]])
        draw_weaponexp_bar(@actor, weapon, 30, line_height * i)
        draw_weapon_level(@actor, weapon, 30, line_height * i)
      end
      for i in 0...@actor.valid_elements.size
        draw_icon(MAGIC_ELEMENTS[@actor.valid_elements[i]][:icon_id], 150, line_height * i)
        magic = MAGIC_ELEMENTS.index(MAGIC_ELEMENTS[@actor.valid_elements[i]])
        draw_magicexp_bar(@actor, magic, 180, line_height * i)
        draw_magic_level(@actor, magic, 180, line_height * i)
      end
    end
  end
  
  #-------------------------------------------------------------------------------
  # Window_MoveList
  #-------------------------------------------------------------------------------
  class Window_MoveList < Window_Selectable
    #-----------------------------------------------------------------------------
    # Inicialização
    #-----------------------------------------------------------------------------
    def initialize(height)
      super(0,0,Graphics.width, height)
      @data = []
    end
    #-----------------------------------------------------------------------------
    # Definição do herói
    #-----------------------------------------------------------------------------
    def actor=(actor)
      return if @actor == actor
      @actor = actor
      refresh
    end
    #-----------------------------------------------------------------------------
    # Enable?
    #-----------------------------------------------------------------------------
    def enable?(item)
      return true if @actor.skills.include?(item)
    end
    #-----------------------------------------------------------------------------
    # Aquisição do número máximo de itens
    #-----------------------------------------------------------------------------
    def item_max
      @data ? @data.size : 1
    end
    #-----------------------------------------------------------------------------
    # Criação da lista de itens
    #-----------------------------------------------------------------------------
    def make_item_list
      actor = @actor.actor.id
      @data = SKILL_LIST[actor] ? SKILL_LIST[actor] : []
    end
    #-----------------------------------------------------------------------------
    # item
    #-----------------------------------------------------------------------------
    def item
      @data && index >= 0 ? @data[index] : nil
    end
    #-----------------------------------------------------------------------------
    # Desenho de um item
    #-----------------------------------------------------------------------------
    def draw_item(index)
      skill = @data[index]
      if skill
        skill = $data_skills[skill]
        rect = item_rect(index)
        rect.width -= 4
        draw_move_information(skill, rect.x, rect.y, enable?(skill))
        draw_skill_requirements(@actor, skill, rect.x + 130, rect.y, enable?(skill))
      end
    end
    #-----------------------------------------------------------------------------
    # Atualização da janela de ajuda
    #-----------------------------------------------------------------------------
    def update_help
      if item != nil
        skill = $data_skills[item] 
        @help_window.skill_helper(item, enable?(skill))
      else
        @help_window.set_text("")
      end
    end
    #-----------------------------------------------------------------------------
    # refresh
    #-----------------------------------------------------------------------------
    def refresh
      make_item_list
      create_contents
      draw_all_items
    end
  end
  
  #-------------------------------------------------------------------------------
  # Window_MenuCommand
  #-------------------------------------------------------------------------------
  class Window_MenuCommand < Window_Command
    #-----------------------------------------------------------------------------
    # Adição de comandos próprios
    #-----------------------------------------------------------------------------
    def add_original_commands
      add_command("Movimentos", :moves)
    end
  end
  
  #-------------------------------------------------------------------------------
  # Window_BattleLog
  #-------------------------------------------------------------------------------
  class Window_BattleLog < Window_Selectable
    #-----------------------------------------------------------------------------
    # Listagem dos alias
    #-----------------------------------------------------------------------------
    alias old_display_action_results display_action_results
    #-----------------------------------------------------------------------------
    # Mostra os resultados das ações
    #-----------------------------------------------------------------------------
    def display_action_results(target, item)
      if target.result.used
        display_skill_levelup(target, item)
        display_learned_skill(target, item)
      end
      old_display_action_results(target, item)
    end
    #-----------------------------------------------------------------------------
    # Mostra o texto de level up de uma pericia
    #-----------------------------------------------------------------------------
    def display_skill_levelup(target, item)
      return if !target.result.skill_levelup
      add_text(target.result.draw_skill_levelup)
      wait
    end
    #-----------------------------------------------------------------------------
    # Mostra o texto de ter aprendido uma nova habilidade
    #-----------------------------------------------------------------------------
    def display_learned_skill(target, item)
      return if !target.result.learned_skill
      add_text(target.result.draw_learned_skill)
      wait
    end
  end
  
  
  #-------------------------------------------------------------------------------
  # Scene_Menu
  # Alterações para a nova cena de skill
  #-------------------------------------------------------------------------------
  class Scene_Menu < Scene_MenuBase
    #-----------------------------------------------------------------------------
    # Listando os alias
    #-----------------------------------------------------------------------------
    alias old_create_command_window create_command_window
    #-----------------------------------------------------------------------------
    # Cria a janela de Comando
    #-----------------------------------------------------------------------------
    def create_command_window
      old_create_command_window
      @command_window.set_handler(:moves, method(:command_move))
    end
    #-----------------------------------------------------------------------------
    # Seleciona o actor e inicia a cena de skill
    #-----------------------------------------------------------------------------
    def command_move
      @status_window.select_last
      @status_window.activate
      @status_window.set_handler(:ok, method(:on_ok_move))
      @status_window.set_handler(:cancel, method(:on_personal_cancel))
    end
    #-----------------------------------------------------------------------------
    # Iniciando a cena de skill
    #-----------------------------------------------------------------------------
    def on_ok_move
      SceneManager.call(Scene_Moves)
    end
  end
  
  #-------------------------------------------------------------------------------
  # Scene_Moves
  #-------------------------------------------------------------------------------
  class Scene_Moves < Scene_MenuBase
    #-----------------------------------------------------------------------------
    # Inicialização do processo
    #-----------------------------------------------------------------------------
    def start
      super
      @char_window = Window_CharInfo.new(@actor)
      @skill_window = Window_SkillLevels.new(@actor)
      @skill_window.x = @char_window.width
      @help_window = Window_Help.new
      @help_window.y = Graphics.height - @help_window.height
      @move_window = Window_MoveList.new(Graphics.height - (@skill_window.height + @help_window.height))
      @move_window.y = @skill_window.height
      @move_window.actor = @actor
      @move_window.index = 0
      @move_window.active = true
      @move_window.help_window = @help_window
      @move_window.set_handler(:cancel,   method(:return_scene))
      @move_window.set_handler(:pagedown, method(:next_actor))
      @move_window.set_handler(:pageup,   method(:prev_actor))
    end
    #-----------------------------------------------------------------------------
    # Mudança de Herói
    #-----------------------------------------------------------------------------
    def on_actor_change
      @char_window.actor = @actor
      @skill_window.actor = @actor
      @move_window.actor = @actor
      @move_window.activate
    end
  end