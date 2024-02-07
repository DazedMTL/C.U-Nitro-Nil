#==============================================================================
# ★ RGSS3_自動戦闘 Ver1.01
#==============================================================================
=begin

作者：tomoaky
webサイト：ひきも記 (http://hikimoki.sakura.ne.jp/)

パーティコマンドに『オート』と『リピート』、２種類のコマンドを追加します。
オートは全アクターがそのターンだけ自動戦闘の状態となります、
リピートは全アクターが前のターンにとった行動を自動選択します。

おまけ機能の完全自動戦闘スイッチ（初期設定では７番）がオンになっている間は
エンカウントからマップシーンへ戻るまでがすべて自動化されます。

=== 注意点 ===
  ・前のターンと同じ行動がコスト不足などで実行できない場合は攻撃になります
  ・１ターン目にリピートを選択した場合は全アクターの行動が攻撃になります
  ・前ターン開始時に選択されている行動がリピート対象となります、
    コスト不足でリピート内容が変化した場合、次ターン以降も変化したままです

使用するゲームスイッチ（初期設定）
  0007, 0008

2012.01.17  Ver1.01
  ・逃げるコマンド失敗後にリピートコマンドが正しく動作しない不具合を修正
  
2011.12.15  Ver1.0
  公開

=end

#==============================================================================
# □ 設定項目
#==============================================================================
module TMATBTL
  SW_FULLAUTO = 997     # 完全自動戦闘フラグとして扱うゲームスイッチ番号
  SW_FULLFAST = 997     # 完全自動戦闘の早送りフラグとして扱うゲームスイッチ番号
end

#==============================================================================
# ■ Vocab
#==============================================================================
module Vocab
  AutoBattle    = "オート"         # 自動戦闘コマンド名
  RepeatBattle  = "リピート"       # 繰り返し戦闘コマンド名
end

#==============================================================================
# ■ Game_Temp
#==============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :repeat_commands          # 前ターンの行動内容
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias tmatbtl_game_temp_initialize initialize
  def initialize
    tmatbtl_game_temp_initialize
    @repeat_commands = []
  end
end

#==============================================================================
# ■ Window_Message
#==============================================================================
class Window_Message
  #--------------------------------------------------------------------------
  # ● 入力待ち処理
  #--------------------------------------------------------------------------
  alias tmatbtl_window_message_input_pause input_pause
  def input_pause
    if $game_party.in_battle && $game_switches[TMATBTL::SW_FULLAUTO]
      wait($game_switches[TMATBTL::SW_FULLFAST] ? 30 : 60)
    else
      tmatbtl_window_message_input_pause
    end
  end
end

#==============================================================================
# ■ Window_PartyCommand
#==============================================================================
class Window_PartyCommand
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  alias tmatbtl_window_partycommand_make_command_list make_command_list
  def make_command_list
    tmatbtl_window_partycommand_make_command_list
    add_command(Vocab::AutoBattle,   :auto)
    add_command(Vocab::RepeatBattle, :repeat)
  end
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  # ● 早送り判定
  #--------------------------------------------------------------------------
  alias tmatbtl_scene_battle_show_fast? show_fast?
  def show_fast?
    tmatbtl_scene_battle_show_fast? || ($game_switches[TMATBTL::SW_FULLAUTO] &&
      $game_switches[TMATBTL::SW_FULLFAST])
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias tmatbtl_scene_battle_create_party_command_window create_party_command_window
  def create_party_command_window
    tmatbtl_scene_battle_create_party_command_window
    @party_command_window.set_handler(:auto,   method(:command_auto))
    @party_command_window.set_handler(:repeat, method(:command_repeat))
  end
  #--------------------------------------------------------------------------
  # ● パーティコマンド選択の開始
  #--------------------------------------------------------------------------
  alias tmatbtl_scene_battle_start_party_command_selection start_party_command_selection
  def start_party_command_selection
    tmatbtl_scene_battle_start_party_command_selection
    if $game_switches[TMATBTL::SW_FULLAUTO]
      command_auto unless scene_changing?
    end
  end
  #--------------------------------------------------------------------------
  # ● 戦闘開始
  #--------------------------------------------------------------------------
  alias tmatbtl_scene_battle_battle_start battle_start
  def battle_start
    tmatbtl_scene_battle_battle_start
    $game_temp.repeat_commands = []
  end
  #--------------------------------------------------------------------------
  # ● ターン開始
  #--------------------------------------------------------------------------
  alias tmatbtl_scene_battle_turn_start turn_start
  def turn_start
    $game_party.members.each_with_index do |actor, i|
      next unless actor.inputable?
      $game_temp.repeat_commands[i] = []
      actor.actions.each do |action|
        $game_temp.repeat_commands[i].push(action.clone)
      end
    end
    tmatbtl_scene_battle_turn_start
  end
  #--------------------------------------------------------------------------
  # ○ コマンド［オート］
  #--------------------------------------------------------------------------
  def command_auto
    $game_party.members.each do |actor|
      actor.make_auto_battle_actions if actor.inputable?
    end
    @party_command_window.deactivate
    turn_start
  end
  #--------------------------------------------------------------------------
  # ○ コマンド［リピート］
  #--------------------------------------------------------------------------
  def command_repeat
    $game_party.members.each_with_index do |actor, i|
      next unless actor.inputable?
      actor.actions.clear
      if !$game_temp.repeat_commands[i] || $game_temp.repeat_commands[i].empty?
        $game_temp.repeat_commands[i] =
          [Game_Action.new(actor).set_attack.evaluate]
      end
      $game_temp.repeat_commands[i].each do |action|
        actor.actions.push(action.clone)
        actor.actions[actor.actions.size - 1].set_attack unless action.valid?
      end
    end
    @party_command_window.deactivate
    turn_start
  end
end

