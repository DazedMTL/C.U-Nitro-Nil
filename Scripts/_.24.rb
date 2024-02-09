#==============================================================================
# ■入手インフォメーション(装備品個別管理対応) for RGSS3 Ver1.02-β
# □作成者 kure
#
# 導入位置
# 装備品個別管理より下
#
#===============================================================================
$kure_base_script = {} if $kure_base_script == nil
$kure_base_script[:Gain_infomation] = 105
p "入手インフォメーション"

module KURE
  module Gain_Info
    #基本設定-------------------------------------------------------------------
      #インフォメーション表示フレーム数
      VIEW_INFO_TIME = 150
    
      #最大表示項目数
      MAX_LOG = 5
    
      #ログ出力対象シーン
      #獲得ログを取得するシーンを配列で設定
      LOG_SCENE = [Scene_Map, Scene_Item]
      
    #動作設定-------------------------------------------------------------------
      #ゴールド獲得時に表示するアイコンのID
      GOLD_ICON = 0
      
      #ゴールド獲得時のメッセージ
      GOLD_INFO = "Mo Obtained"
      
      #インフォメーションに表示するアイコンのID
      INFO_ICON = 230
      
  end
end

#==============================================================================
# ■ Game_Temp
#==============================================================================
class Game_Temp
  #--------------------------------------------------------------------------
  # ● 入手したアイテムのデータを入力(追加定義)
  #--------------------------------------------------------------------------
  def item_info_add(item, amount)
    return unless KURE::Gain_Info::LOG_SCENE.include?(SceneManager.scene.class)
    
    @gain_item_list ||= []
    return unless item
    @gain_item_list.push([item, amount, 0])
  end
  #--------------------------------------------------------------------------
  # ● 入手したアイテムのデータを入力(追加定義)
  #--------------------------------------------------------------------------
  def gold_info_add(amount)
    return unless KURE::Gain_Info::LOG_SCENE.include?(SceneManager.scene.class)
    
    @gain_item_list ||= []
    @gain_item_list.push([KURE::Gain_Info::GOLD_ICON, amount, 1])
  end
  #--------------------------------------------------------------------------
  # ● インフォメーションのテキストを入力(追加定義)
  #--------------------------------------------------------------------------
  def text_info_add(text, ignore = false)
    return if !ignore && !KURE::Gain_Info::LOG_SCENE.include?(SceneManager.scene.class)
    
    @gain_item_list ||= []
    @gain_item_list.push([KURE::Gain_Info::INFO_ICON, text, 2])
  end
  #--------------------------------------------------------------------------
  # ● 入手したアイテムのデータを出力(追加定義)
  #--------------------------------------------------------------------------
  def item_info_output
    return [] unless @gain_item_list
    return @gain_item_list
  end
  #--------------------------------------------------------------------------
  # ● 入手したアイテムのデータの存在判定(追加定義)
  #--------------------------------------------------------------------------
  def item_info_view?
    return false unless @gain_item_list
    return false if @gain_item_list == []
    return true
  end
  #--------------------------------------------------------------------------
  # ● 入手したアイテムのデータをクリア(追加定義)
  #--------------------------------------------------------------------------
  def item_info_clear
    @gain_item_list = []
  end
end

#==============================================================================
# ■ Game_Interpreter(追加定義)
#==============================================================================
class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● インフォメーションを追加(追加定義)
  #--------------------------------------------------------------------------
  def add_info(text, ignore = false)
    $game_temp.text_info_add(text, ignore)
  end
end

#==============================================================================
# ■ Game_Party
#==============================================================================
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● 入手したアイテムのデータを記録(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_gain_info_before_memory_get_item memory_get_item if $kure_base_script[:SortOut]
  def memory_get_item(item, amount)
    $game_temp.item_info_add(item, amount) if amount > 0
    k_gain_info_before_memory_get_item(item, amount)
  end
  #--------------------------------------------------------------------------
  # ● アイテムの増加（減少)(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_gain_info_before_gain_item gain_item
  def gain_item(item, amount, include_equip = false, change_equip = false, recycle_slot = true)
    if $kure_base_script[:SortOut]
      k_gain_info_before_gain_item(item, amount, include_equip, change_equip, recycle_slot)
    else
      $game_temp.item_info_add(item, amount) if amount > 0
      k_gain_info_before_gain_item(item, amount, include_equip)
    end
  end
  #--------------------------------------------------------------------------
  # ● 所持金の増加（減少）(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_gain_info_before_gain_gold gain_gold
  def gain_gold(amount)
    $game_temp.gold_info_add(amount) if amount > 0
    k_gain_info_before_gain_gold(amount)
  end
end

#==============================================================================
# ■ Scene_Map
#==============================================================================
class Scene_Map < Scene_Base
  #--------------------------------------------------------------------------
  # ● 全ウィンドウの作成(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_gain_info_before_create_all_windows create_all_windows
  def create_all_windows
    k_gain_info_before_create_all_windows
    create_item_info_window
  end
  #--------------------------------------------------------------------------
  # ● インフォメーションウィンドウの作成(追加定義)
  #--------------------------------------------------------------------------
  def create_item_info_window
    @item_info_window = Window_Gain_item_Info.new
    @item_info_window.close
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新(エイリアス再定義)
  #--------------------------------------------------------------------------
  alias k_gain_info_before_update update
  def update
    if $game_temp.item_info_view?
      @item_info_window.open($game_temp.item_info_output)
      $game_temp.item_info_clear
    end
    k_gain_info_before_update
  end
end

#==============================================================================
# ■ Window_Gain_item_Info
#==============================================================================
class Window_Gain_item_Info < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(0, Graphics.height, window_width, fitting_height(1))
    self.opacity = 0
    self.contents_opacity = 0
    @show_count = 0
    @list = []
    refresh
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return 352
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    if @show_count > 0
      update_fadein
      @show_count -= 1
    elsif @show_count == 0
      update_list
      @show_count -= 1
    else
      update_fadeout
    end
  end
  #--------------------------------------------------------------------------
  # ● フェードインの更新
  #--------------------------------------------------------------------------
  def update_fadein
    self.contents_opacity += 16
  end
  #--------------------------------------------------------------------------
  # ● リストの更新
  #--------------------------------------------------------------------------
  def update_list
    if @list.size < KURE::Gain_Info::MAX_LOG + 1
      @list = [] 
    else
      draw_data = @list[0..KURE::Gain_Info::MAX_LOG - 1]
      KURE::Gain_Info::MAX_LOG.times{@list.delete_at(0)}
    end
  end
  #--------------------------------------------------------------------------
  # ● フェードアウトの更新
  #--------------------------------------------------------------------------
  def update_fadeout    
    if @list == []
      self.contents_opacity -= 8
    else
      open([])
    end
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウを開く
  #--------------------------------------------------------------------------
  def open(list)
    @list += list
    
    
    self.height = fitting_height([@list.size, KURE::Gain_Info::MAX_LOG].min)
    self.y = Graphics.height - fitting_height([@list.size, KURE::Gain_Info::MAX_LOG].min)
    
    refresh
    @show_count = KURE::Gain_Info::VIEW_INFO_TIME
    self.contents_opacity = 0
    self
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウを閉じる
  #--------------------------------------------------------------------------
  def close
    @show_count = 0
    self
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウを閉じる
  #--------------------------------------------------------------------------
  def closed?
    return true if @show_count < 1
    return false
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    draw_background(contents.rect)
    
    @list.each_with_index{|data,index|
      case data[2]
      when 0
        draw_item_name(data[0], 0, line_height * index, true)
        change_color(tp_gauge_color2)
        draw_text(0, line_height * index, window_width - 30, line_height, data[1].to_s + " Obtained", 2)
        change_color(normal_color)
      when 1
        draw_icon(data[0], 0, line_height * index, true)
        draw_text(24, line_height * index, window_width - 30, line_height, KURE::Gain_Info::GOLD_INFO)
        change_color(mp_gauge_color2)
        draw_text(0, line_height * index, window_width - 30, line_height, data[1].to_s + Vocab::currency_unit, 2)
        change_color(normal_color)
      when 2
        draw_icon(data[0], 0, line_height * index, true)
        change_color(mp_gauge_color2)
        draw_text(24, line_height * index, window_width - 30, line_height, data[1].to_s)
        change_color(normal_color)
      end
    }
  end
  #--------------------------------------------------------------------------
  # ● 背景の描画
  #--------------------------------------------------------------------------
  def draw_background(rect)
    contents.gradient_fill_rect(rect, back_color1, back_color2)
  end
  #--------------------------------------------------------------------------
  # ● 背景色 1 の取得
  #--------------------------------------------------------------------------
  def back_color1
    Color.new(0, 0, 0, 120)
  end
  #--------------------------------------------------------------------------
  # ● 背景色 2 の取得
  #--------------------------------------------------------------------------
  def back_color2
    Color.new(0, 0, 0, 0)
  end
end