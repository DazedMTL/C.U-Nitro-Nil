#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#
#戦闘中に装備入れ替え
#
#個別コマンドに「装備」を追加し、
#戦闘中の装備入れ替えを可能にします。
#
#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★

#------------------------------------------------------------------------------
#設定項目
module MARU_battleequip
  SWITCH = 989 #「装備コマンド」を有効にするスイッチ
#------------------------------------------------------------------------------
end

#==============================================================================
# ■ Window_ActorCommand
#------------------------------------------------------------------------------
# 　バトル画面で、アクターの行動を選択するウィンドウです。
#==============================================================================

class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  alias ma0075make_command_list make_command_list
  def make_command_list
    ma0075make_command_list
    add_equip_command if $game_switches[MARU_battleequip::SWITCH] == true
  end
  #--------------------------------------------------------------------------
  # ● アイテムコマンドをリストに追加
  #--------------------------------------------------------------------------
  def add_equip_command
    add_command("Equipment", :equip)
  end
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● 全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias ma0075_create_all_windows create_all_windows
  def create_all_windows
    ma0075_create_all_windows
    create_equip_window if $game_switches[MARU_battleequip::SWITCH] == true
  end
  #--------------------------------------------------------------------------
  # ● アクターコマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias ma0075_create_actor_command_window create_actor_command_window
  def create_actor_command_window
    ma0075_create_actor_command_window
    @actor_command_window.set_handler(:equip, method(:command_equip))
  end
  #--------------------------------------------------------------------------
  # ● 装備ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_equip_window
    @status_equip_window = Window_EquipStatus.new(0, @help_window.height)
    @status_equip_window.visible = false
    @status_equip_window.viewport = @viewport
    wx = @status_equip_window.width
    wy = @help_window.height
    ww = Graphics.width - @status_equip_window.width
    @command_equip_window = Window_EquipCommand.new(wx, wy, ww)
    @command_equip_window.visible = false
    @command_equip_window.deactivate
    @command_equip_window.viewport = @viewport
    @command_equip_window.help_window = @help_window
    @command_equip_window.set_handler(:equip,    method(:command_equip_e))
    @command_equip_window.set_handler(:optimize, method(:command_optimize))
    @command_equip_window.set_handler(:clear,    method(:command_clear))
    @command_equip_window.set_handler(:cancel,   method(:on_command_cancel))
    wx = @status_equip_window.width
    wy = @command_equip_window.y + @command_equip_window.height
    ww = Graphics.width - @status_equip_window.width
    @slot_window = Window_EquipSlot.new(wx, wy, ww)
    @slot_window.visible = false
    @slot_window.viewport = @viewport
    @slot_window.help_window = @help_window
    @slot_window.status_window = @status_equip_window
    @slot_window.set_handler(:ok,       method(:on_slot_ok))
    @slot_window.set_handler(:cancel,   method(:on_slot_cancel))
    wx = 0
    wy = @slot_window.y + @slot_window.height
    ww = Graphics.width
    wh = Graphics.height - wy
    @item_equip_window = Window_EquipItem.new(wx, wy, ww, wh)
    @item_equip_window.visible = false
    @item_equip_window.viewport = @viewport
    @item_equip_window.help_window = @help_window
    @item_equip_window.status_window = @status_equip_window
    @item_equip_window.set_handler(:ok,     method(:on_item_equip_ok))
    @item_equip_window.set_handler(:cancel, method(:on_item_equip_cancel))
    @slot_window.item_window = @item_equip_window
  end
  #--------------------------------------------------------------------------
  # ● コマンド［装備］
  #--------------------------------------------------------------------------
  def command_equip
    @help_window.show
    @actor = BattleManager.actor
    @status_equip_window.actor = @actor
    @slot_window.actor = @actor
    @item_equip_window.actor = @actor
    @status_equip_window.refresh
    @status_equip_window.show
    @command_equip_window.refresh
    @command_equip_window.show.activate
    @slot_window.refresh
    @slot_window.show
    @item_equip_window.refresh
    @item_equip_window.show
  end
  #--------------------------------------------------------------------------
  # ● コマンド［装備変更］
  #--------------------------------------------------------------------------
  def command_equip_e
    @slot_window.activate
    @slot_window.select(0)
  end
  #--------------------------------------------------------------------------
  # ● コマンド［最強装備］
  #--------------------------------------------------------------------------
  def command_optimize
    Sound.play_equip
    @actor.optimize_equipments
    @status_equip_window.refresh
    @slot_window.refresh
    @command_equip_window.activate
  end
  #--------------------------------------------------------------------------
  # ● コマンド［全て外す］
  #--------------------------------------------------------------------------
  def command_clear
    Sound.play_equip
    @actor.clear_equipments
    @status_equip_window.refresh
    @slot_window.refresh
    @command_equip_window.activate
  end
  #--------------------------------------------------------------------------
  # ● コマンド［キャンセル］
  #--------------------------------------------------------------------------
  def on_command_cancel
    @help_window.hide
    @status_equip_window.hide
    @command_equip_window.hide
    @slot_window.hide
    @item_equip_window.hide
    @actor_command_window.activate
    @actor_command_window.select(0)
  end
  #--------------------------------------------------------------------------
  # ● スロット［決定］
  #--------------------------------------------------------------------------
  def on_slot_ok
    @item_equip_window.activate
    @item_equip_window.select(0)
  end
  #--------------------------------------------------------------------------
  # ● スロット［キャンセル］
  #--------------------------------------------------------------------------
  def on_slot_cancel
    @slot_window.unselect
    @command_equip_window.activate
  end
  #--------------------------------------------------------------------------
  # ● アイテム［決定］
  #--------------------------------------------------------------------------
  def on_item_equip_ok
    Sound.play_equip
    @actor.change_equip(@slot_window.index, @item_equip_window.item)
    @slot_window.activate
    @slot_window.refresh
    @item_equip_window.unselect
    @item_equip_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● アイテム［キャンセル］
  #--------------------------------------------------------------------------
  def on_item_equip_cancel
    @slot_window.activate
    @item_equip_window.unselect
  end
end