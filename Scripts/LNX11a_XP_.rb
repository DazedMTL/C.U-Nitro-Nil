#==============================================================================
# ★ RGSS3-Extension
# LNX11a_XPスタイルバトル
# 　戦闘画面をRPGツクールXP準拠のものに変更します。
#
# 　version   : 1.11 (13/06/19)
# 　author    : ももまる
# 　reference : http://peachround.blog.fc2.com/blog-entry-9.html
#
#==============================================================================

#==============================================================================
# ■ LNXスクリプト導入情報
#==============================================================================
$lnx_include = {} if $lnx_include == nil
$lnx_include[:lnx11a] = 111 # version
p "OK:LNX11a_XPスタイルバトル ver1.11"

module LNX11
  #--------------------------------------------------------------------------
  # ● 正規表現
  #--------------------------------------------------------------------------
  # アクター：バトラーグラフィック = "ファイル名"
  RE_BATTLER = /(?:バトラーグラフィック|battler_graphic)\s*=\s*"([^"]*)"/i
  # アイテム/スキル：使用時アニメ = アニメーションID
  RE_USE_ANIMATION = /(?:使用時アニメ|use_animation)\s*=\s*(\d+)/i
  # アイテム/スキル：ヘルプ説明 = "説明文"
  RE_SHORT_DESCRIPTION =/(?:ヘルプ説明|short_description)\s*=\s*"([^"]*)"/i
  # アイテム/スキル：ヘルプ非表示
  RE_USABLEITEM_NO_DISPLAY = /(?:ヘルプ非表示|no_display)/i
  # アイテム/スキル：使用時追加ウェイト = duration
  RE_DISPLAY_WAIT = /(?:使用時追加ウェイト|display_wait)\s*=\s*(\d+)/i
  # アイテム/スキル：終了時追加ウェイト = duration
  RE_END_WAIT = /(?:終了時追加ウェイト|end_wait)\s*=\s*(\d+)/i
  # 敵キャラ：通常攻撃アニメ = アニメーションID
  RE_ATK_ANIMATION = /(?:通常攻撃アニメ|atk_animation)\s*=\s*(\d+)/i
  # ステート：ステートアニメ = アニメーションID
  RE_STATE_ANIMATION = /(?:ステートアニメ|state_animation)\s*=\s*(\d+)/i
  # ステート：ポップアップ表示名 = "表示名"
  RE_STATE_DISPLAY = /(?:ポップアップ表示名|display_name)\s*=\s*"([^"]*)"/i
  # ステート：ポップアップ非表示
  RE_STATE_NO_DISPLAY = /(?:ポップアップ非表示|no_display)/i
  # ステート：付加ポップアップ非表示
  RE_STATE_ADD_NO_DISPLAY = /(?:付加ポップアップ非表示|add_no_display)/i
  # ステート：解除ポップアップ非表示
  RE_STATE_REM_NO_DISPLAY = /(?:解除ポップアップ非表示|remove_no_display)/i
  # ステート：有利なステート
  RE_STATE_ADVANTAGE = /(?:有利なステート|advantage_state)/i
  # ステート：ポップアップタイプ = type_id
  RE_STATE_TYPE = /(?:ポップアップタイプ|popup_type)\s*=\s*(\d+)/i
  # ステート：付加ポップアップタイプ = type_id
  RE_STATE_ADD_TYPE = /(?:付加ポップアップタイプ|add_popup_type)\s*=\s*(\d+)/i
  # ステート：解除ポップアップタイプ = type_id
  RE_STATE_REM_TYPE=/(?:解除ポップアップタイプ|remove_popup_type)\s*=\s*(\d+)/i
  # ステート：修飾文字非表示
  RE_STATE_NO_DECORATION = /(?:修飾文字非表示|no_decoration)/i
  # ステート：付加修飾文字非表示
  RE_STATE_ADD_NO_DECORATION = /(?:付加修飾文字非表示|add_no_decoration)/i
  # ステート：解除修飾文字非表示
  RE_STATE_REM_NO_DECORATION = /(?:解除修飾文字非表示|remove_no_decoration)/i
  # <<ver1.10>>
  # ステート：付加ポップアップ表示名 = "表示名"
  RE_STATE_ADD_DISPLAY = 
  /(?:付加ポップアップ表示名|add_display_name)\s*=\s*"([^"]*)"/i
  # ステート：解除ポップアップ表示名 = "表示名"
  RE_STATE_REM_DISPLAY = 
  /(?:解除ポップアップ表示名|remove_display_name)\s*=\s*"([^"]*)"/i
  #--------------------------------------------------------------------------
  # ● バトルステータス更新
  #--------------------------------------------------------------------------
  # LNX11.バトルステータス更新
  def self.battle_status_refresh
    $game_temp.battle_status_refresh
  end
  def self.バトルステータス更新
    self.battle_status_refresh
  end  
  #--------------------------------------------------------------------------
  # ● アクターエリア表示/非表示
  #--------------------------------------------------------------------------
  # LNX11.アクターエリア表示
  def self.actor_area_show
    self.actor_show
    self.status_show
    self.actor_bg_show
  end
  def self.アクターエリア表示
    self.actor_area_show
  end
  # LNX11.アクターエリア非表示
  def self.actor_area_hide
    self.actor_hide
    self.status_hide
    self.actor_bg_hide
  end
  def self.アクターエリア非表示
    self.actor_area_hide
  end
  #--------------------------------------------------------------------------
  # ● アクター表示/非表示
  #--------------------------------------------------------------------------
  # LNX11.アクター表示
  def self.actor_show
    $game_party.actor_invisible = false
  end
  def self.アクター表示
    self.actor_show
  end
  # LNX11.アクター非表示
  def self.actor_hide
    $game_party.actor_invisible = true
  end
  def self.アクター非表示
    self.actor_hide
  end
  #--------------------------------------------------------------------------
  # ● バトルステータス表示/非表示
  #--------------------------------------------------------------------------
  # LNX11.バトルステータス表示
  def self.status_show
    $game_party.status_invisible = false
    self.battle_status_refresh
  end
  def self.バトルステータス表示
    self.status_show
  end
  # LNX11.バトルステータス非表示
  def self.status_hide
    $game_party.status_invisible = true
    self.battle_status_refresh
  end
  def self.バトルステータス非表示
    self.status_hide
  end
  #--------------------------------------------------------------------------
  # ● アクター背景表示/非表示
  #--------------------------------------------------------------------------
  # LNX11.アクター背景表示
  def self.actor_bg_show
    $game_party.actor_bg_invisible = false
  end
  def self.アクター背景表示
    self.actor_bg_show
  end
  # LNX11.アクター背景非表示
  def self.actor_bg_hide
    $game_party.actor_bg_invisible = true
  end
  def self.アクター背景非表示
    self.actor_bg_hide
  end  
  #--------------------------------------------------------------------------
  # ● バトラーグラフィックのスクリプト指定
  #--------------------------------------------------------------------------
  # LNX11.バトラーグラフィック(id, filename)
  def self.battler_graphic(id ,filename)
    if id.is_a?(Numeric) && filename.is_a?(String)
      p "LNX11a:バトラーグラフィックを変更しました:ID#{id} #{filename}"
      $game_actors[id].battler_graphic_name = filename
    else
      errormes =  "LNX11a:バトラーグラフィック指定の引数が正しくありません。"
      p errormes, "LNX11a:バトラーグラフィックの指定は行われませんでした。"
      msgbox errormes
    end
  end
  def self.バトラーグラフィック(id ,filename)
    self.battler_graphic(id ,filename)
  end
  #--------------------------------------------------------------------------
  # ● 任意のポップアップを生成
  #--------------------------------------------------------------------------
  # LNX11.ポップアップ(battler, popup, type, color, deco)
  def self.make_popup(battler, popup, type = 0, color = :hp_damage, deco = nil)
    return unless $game_party.in_battle
    target = self.battler_search(battler)
    unless target.is_a?(Game_Battler)
      p "LNX11a:任意のポップアップの生成に失敗しました。バトラー指定が"
      p "LNX11a:間違っているか、バトラーが存在していない可能性があります。"
      return
    end
    $game_temp.popup_data.popup_custom(target, popup, type, color, deco)   
  end
  def self.ポップアップ(battler, popup, type=0, color=:hp_damage, deco=nil)
    self.make_popup(battler, popup, type, color, deco)
  end
  #--------------------------------------------------------------------------
  # ● バトラー指定
  #--------------------------------------------------------------------------
  def self.battler_search(val)
    if val.is_a?(String)
      # 名前指定
      a = ($game_party.members + $game_troop.members).find {|b| b.name == val }
      return a
    elsif val.is_a?(Array)
      # インデックス指定
      case val[0]
      when :actor ; return $game_party.members[val[1]]
      when :enemy ; return $game_troop.members[val[1]]
      else        ; return nil
      end
    else
      # オブジェクト
      return val
    end
  end
  #--------------------------------------------------------------------------
  # ● バトルログプッシュ
  #--------------------------------------------------------------------------
  # LNX11.バトルログ(text)
  def self.battle_log_push(text)
    return unless $game_party.in_battle
    case BATTLELOG_TYPE
    when 0..1 # バトルログ
      BattleManager.log_window.add_text(text)
    when 2 # 簡易ヘルプ表示
      BattleManager.helpdisplay_set(text, 0)
    end
  end
  def self.バトルログ(text)
    self.battle_log_push(text)
  end
  #--------------------------------------------------------------------------
  # ● バトルログ消去
  #--------------------------------------------------------------------------
  # LNX11.バトルログ消去
  def self.battle_log_clear
    return unless $game_party.in_battle
    case BATTLELOG_TYPE
    when 0 # バトルログ
      BattleManager.log_window.clear
    when 1 # 蓄積型
      BattleManager.log_window.clear
      $game_temp.battlelog_clear = true
      self.battle_wait(1)
    when 2 # 簡易ヘルプ
      BattleManager.helpdisplay_clear(0)
    end
  end
  def self.バトルログ消去
    self.battle_log_clear
  end
  #--------------------------------------------------------------------------
  # ● バトルウェイト
  #--------------------------------------------------------------------------
  # LNX11.バトルウェイト(duration)
  def self.battle_wait(duration)
    return unless $game_party.in_battle
    BattleManager.log_window.abs_wait(duration)
  end
  def self.バトルウェイト(duration)
    self.battle_wait(duration)
  end
  #--------------------------------------------------------------------------
  # ● 設定値
  # 　※ 設定を変更する場合、LNX11aconf を使用してください。
  #--------------------------------------------------------------------------
  # <<ver1.00>>
  if !$lnx_include[:lnx11aconf] || 
     $lnx_include[:lnx11aconf] && $lnx_include[:lnx11aconf] < 100
  DEFAULT_BATTLER_GRAPHIC = 0
  DEFAULT_BG_COLOR        = [Color.new(0, 0, 0, 0), Color.new(0, 0, 0, 0)]
  ACTOR_SCREEN_TONE       = false
  TP_POPUP_TYPE           = 1
  INDEXZERO_NO_POPUP      = true
  ACTOR_BACKGROUND        = 2
  ACTOR_BACKGROUND_HEIGHT = 112
  ACTOR_BG_GRADIENT_COLOR = [Color.new(0, 0, 0, 96), Color.new(0, 0, 0, 224)]
  BATTLELOG_TYPE  =  1
  STORAGE_LINE_NUMBER     = 6
  STORAGE_LINE_HEIGHT     = 20
  STORAGE_UP_MESSAGE_TIME = 90
  STORAGE_TURNEND_CLEAR   = true
  STORAGE_OFFSET = {:x => 0, :y => 6}
  STORAGE_FONT   = {:size => 20, :out_color => Color.new(0, 0, 0, 192)}
  STORAGE_GRADIENT_COLOR = [Color.new(0, 0, 0, 128), Color.new(0, 0, 0, 0)]
  POPUP_ADD_WAIT          = 6
  HELPDISPLAY_TYPE        = 1
  HELPDISPLAT_WAIT        = 20
  HELPDISPLAT_END_WAIT    = 24
  HELPDISPLAY_DESCRIPTION = {:size => 20, :delimiter => " "}
  MESSAGE_TYPE  =  2
  MESSAGE_WINDOW_BACKGROUND  = 1
  MESSAGE_WINDOW_POSITION    = 0
  MESSAGE_WAIT = {:battle_start => [120, false], :victory   => [ 60, false], 
                  :defeat       => [120, false], :escape    => [120, false], 
                  :drop_item    => [ 60,  true], :levelup   => [ 60,  true]}
  MESSAGE_WINDOW_ENEMY_NAMES = false
  LEVELUP_SE  = RPG::SE.new("Up4", 90, 100)
  DROPITEM_SE = RPG::SE.new("Item3", 80, 125)
  ACTOR_CENTERING  =  true
  ACTOR_SPACING_ADJUST = 32
  ACTOR_OFFSET  = {:x => -16, :y => 0}
  ACTOR_PADDING = {:side => 4, :bottom => 8}
  SCREEN_ANIMATION_OFFSET = 128
  STATUS_OFFSET = {:x => 64, :y => -12}
  STATUS_SIDE_PADDING   = 6
  STATUS_WIDTH          = 72
  STATUS_AUTOADJUST     = true
  STATUS_LINE_HEIGHT    = 22
  STATUS_NAME_SIZE      = 20
  STATUS_PARAM_SIZE     = 23
  STATUS_GAUGE_OPACITY  = 192
  ACTOR_COMMAND_NOSCROLL   = true
  ACTOR_COMMAND_HORIZON    = false
  ACTOR_COMMAND_ALIGNMENT  = 0
  ACTOR_COMMAND_WIDTH      = 128
  ACTOR_COMMAND_POSITION   = 0
  ACTOR_COMMAND_Y_POSITION = 0
  ACTOR_COMMAND_OFFSET  = {:x => 0, :y => -16}
  PARTY_COMMAND_HORIZON   = true
  PARTY_COMMAND_ALIGNMENT = 1
  PARTY_COMMAND_WIDTH     = Graphics.width
  PARTY_COMMAND_XY        = {:x => 0, :y => 0}
  CURSOR_NAME       = ""
  CURSOR_TONE     = Tone.new(-34, 0, 68)
  CURSOR_ANI_SPEED  = 3
  CURSOR_SPEED      = 3
  CURSOR_BLINK      = true
  CURSOR_MINMAX     = {:min => 48, :max => Graphics.height}
  CURSOR_OFFSET     = {:x => 0, :y => 0}
  HELP_ACTOR_PARAM = {:hp => true ,:mp => true ,:tp => true ,:state => true }
  HELP_ENEMY_PARAM = {:hp => false,:mp => false,:tp => false,:state => true }
  HELP_PARAM_WIDTH    = 72
  RANDOMSCOPE_DISPLAY = 1
  ACTOR_POPUP_POSITION   = 3
  ENEMY_POPUP_POSITION   = 1
  LEVELUP_POPUP_POSITION = 3
  ACTOR_POPUP_Y     =  -100
  LEVELUP_POPUP_Y   =  -112
  NUMBER_FONT   =  ["Arial Black", "VL Gothic"]
  TEXT_FONT     =  ["Arial Black", "VL Gothic"]
  TEXT_FONT_MCS =  ["VL Gothic"]
  LARGE_NUMBER  =  {:fontsize => 38, :spacing => -4, :line_height => 26}
  SMALL_NUMBER  =  {:fontsize => 28, :spacing => -4, :line_height => 20}
  TEXT_SIZERATE     = {:normal => 0.8, :left_right => 0.7, :top_bottom => 0.6}
  TEXT_SIZERATE_MCS = 0.9
  DECORATION_NUMBER = { 
  :critical    => ["CRITICAL", 8], :weakness    => ["WEAKNESS", 8],
  :resist      => ["RESIST"  , 8], :mp_damage   => ["\mp"     , 4],
  :mp_plus     => ["\mp+"    , 4], :mp_minus    => ["\mp-"    , 4],
  :tp_plus     => ["\tp+"    , 4], :tp_minus    => ["\tp-"    , 4]}
  DECORATION_TEXT = {
  :add_state   => "+%s",      :rem_state   => "-%s",
  :add_buff    => "%s UP",    :add_debuff  => "%s DOWN",
  :rem_buff    => "-%s Buff"}
  POPUP_VOCAB = {
  :miss        => "MISS!",      :counter     => "Counter",
  :reflection  => "Reflection", :substitute  => "Substitute",
  :levelup     => "LEVELUP!"}
  POPUP_VOCAB_PARAMS = [
  "MAX\hp","MAX\mp","ATK","DEF","MATK","MDEF","AGI","LUCK"]
  POPUP_COLOR = {
  :hp_damage     => [Color.new(255, 255, 255), Color.new(  0,   0,   0)],
  :critical      => [Color.new(255, 255,  80), Color.new(224,  32,   0)],
  :weakness      => [Color.new(255, 255, 255), Color.new(  0,  56, 144)],
  :resist        => [Color.new(232, 224, 216), Color.new( 56,  48,  40)],
  :hp_recovery   => [Color.new( 96, 255, 128), Color.new(  0,  64,  32)],
  :mp_damage     => [Color.new(248,  80, 172), Color.new( 48,   0,  32)],
  :mp_recovery   => [Color.new(160, 240, 255), Color.new( 32,  48, 144)],
  :tp_damage     => [Color.new(248, 240,  64), Color.new(  0,  80,  40)],
  :add_state     => [Color.new(255, 255, 255), Color.new(  0,  56, 144)],
  :rem_state     => [Color.new(224, 232, 240), Color.new( 32,  64, 128, 128)],
  :add_badstate  => [Color.new(255, 255, 255), Color.new(  0,   0,   0)],
  :rem_badstate  => [Color.new(224, 224, 224), Color.new( 32,  32,  32, 128)],
  :add_buff      => [Color.new(255, 255, 192), Color.new( 96,  64,   0)],
  :add_debuff    => [Color.new(200, 224, 232), Color.new( 40,  48,  56)],
  :rem_buff      => [Color.new(224, 224, 224), Color.new( 32,  32,  32, 128)],
  :counter       => [Color.new(255, 255, 224), Color.new(128,  96,   0)],
  :reflection    => [Color.new(224, 255, 255), Color.new(  0,  96, 128)],
  :substitute    => [Color.new(224, 255, 224), Color.new(  0, 128,  64)],
  :levelup       => [Color.new(255, 255, 255), Color.new(  0,   0,   0)],
  }
  POPUP_TYPE = {
  :miss          =>   0,:hp_damage     =>   0,:hp_slipdamage =>   1,
  :hp_recovery   =>   0,:hp_regenerate =>   1,:hp_drain      =>   0,
  :hp_drainrecv  =>   0,:mp_damage     =>   0,:mp_slipdamage =>   1,
  :mp_recovery   =>   0,:mp_regenerate =>   1,:mp_drain      =>   0,
  :mp_drainrecv  =>   0,:mp_paycost    =>  -1,:tp_damage     =>   1,
  :tp_charge     =>  -1,:tp_gain       =>   7,:tp_regenerate =>   1,
  :tp_paycost    =>  -1,:add_state     =>   2,:rem_state     =>   2,
  :add_badstate  =>   2,:rem_badstate  =>   2,:add_debuff    =>   3,
  :rem_buff      =>   3,:counter       =>   6,:reflection    =>   6,
  :substitute    =>   4,}
  LARGE_MOVEMENT = {
  :inirate    => 6.4,  :gravity      => 0.68,  :side_scatter => 1.2,
  :ref_height =>  32,  :ref_factor   => 0.60,  :ref_count    =>   2,
                       :duration     =>   40,  :fadeout      =>  20 }
  SMALL_MOVEMENT = {
  :inirate    => 4.4,  :gravity      => 0.60,  :side_scatter => 0.0,
  :ref_height =>  12,  :ref_factor   => 0.70,  :ref_count    =>   0,
                       :duration     =>   60,  :fadeout      =>  16 }
  RISE_MOVEMENT     = {:rising_speed => 0.75,  :line_spacing => 0.9,
                       :duration     =>   40,  :fadeout      =>   8 }
  SLIDE_MOVEMENT    = {:x_speed      =>    2,  :line_spacing => 0.9,
                       :duration     =>   50,  :fadeout      =>  32 }
  OVERLAY_MOVEMENT  = {:duration     =>   36,  :fadeout      =>  32 }
  FIX_TARGET_CHECKE     = true
  GUARD_TARGET_CHECKE   = true
  SMART_TARGET_SELECT   = true
  LAST_TARGET           = true
  LAST_PARTY_COMMAND    = true 
  LAST_ACTOR_COMMAND    = true
  TROOP_X_SORT          = true
  PARTY_COMMAND_SKIP    = true
  FITTING_LIST          = true
  ENHANCED_WHITEN       = true
  DISABLED_DAMAGE_SHAKE = true
  TROOP_X_SCREEN_FIX    = true
  TROOP_Y_OFFSET        = 0
  end
  # <<ver1.10>>
  if !$lnx_include[:lnx11aconf] || 
    $lnx_include[:lnx11aconf] && $lnx_include[:lnx11aconf] < 110
  LARGE_NUMBER_NAME = ""
  SMALL_NUMBER_NAME = ""
  LARGE_BUFFS_NAME  = ""
  SMALL_BUFFS_NAME  = ""
  end
end

#==============================================================================
# ■ [追加]:Popup_Data
#------------------------------------------------------------------------------
# 　戦闘中のポップアップをまとめて扱うクラス。ポップアップスプライトの
# initialize 時に自身を参照させて、ポップアップ内容を定義する際にも使います。
#==============================================================================

class Popup_Data
  #--------------------------------------------------------------------------
  # ● クラス変数
  #--------------------------------------------------------------------------
  @@make_methods = {} # ポップアップ作成メソッドのハッシュ
  #--------------------------------------------------------------------------
  # ● 定数(ポップアップのタイプID)
  #--------------------------------------------------------------------------
  SPRING_LARGE  = 0
  SPRING_SMALL  = 1
  RISING_LARGE  = 2
  RISING_SMALL  = 3
  SLIDING_LARGE = 4
  SLIDING_SMALL = 5
  OVERLAY_LARGE = 6
  OVERLAY_SMALL = 7
  LEVELUP       = :levelup
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :type       # ポップアップのタイプ
  attr_accessor :popup      # 表示する内容
  attr_accessor :popup_size # ポップアップの大きさ
  attr_accessor :color      # 色
  attr_accessor :deco       # 修飾文字
  attr_accessor :battler    # ポップアップするバトラー
  attr_accessor :delay      # 表示開始までの時間
  attr_accessor :viewport   # ビューポート
  attr_accessor :popup_wait # ポップアップウェイト
  attr_accessor :buff_data  # 能力強化/弱体 <<ver1.10>>
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @sprites = []
    @viewport = Viewport.new
    @viewport.z = 120 # ポップアップの Z 座標
    spb = Sprite_PopupBase.new
    spb.create_number
    spb.dispose
    set_methods
    refresh
  end
  #--------------------------------------------------------------------------
  # ● ポップアップ生成メソッドの登録
  #--------------------------------------------------------------------------
  def set_methods
    @@make_methods[SPRING_LARGE]  = method(:makeup_spring_large)
    @@make_methods[SPRING_SMALL]  = method(:makeup_spring_small)
    @@make_methods[RISING_LARGE]  = method(:makeup_rising_large)
    @@make_methods[RISING_SMALL]  = method(:makeup_rising_small)
    @@make_methods[SLIDING_LARGE] = method(:makeup_sliding_large)
    @@make_methods[SLIDING_SMALL] = method(:makeup_sliding_small)
    @@make_methods[OVERLAY_LARGE] = method(:makeup_overlay_large)
    @@make_methods[OVERLAY_SMALL] = method(:makeup_overlay_small)
    @@make_methods[LEVELUP]       = method(:makeup_levelup)
  end
  #--------------------------------------------------------------------------
  # ● スプライト解放
  #--------------------------------------------------------------------------
  def dispose
    @sprites.each {|sprite| sprite.dispose}
    @viewport.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @sprites.each do |sprite|
      sprite.update
      @sprites.delete(sprite) if sprite.disposed?
    end
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    @type  = 0
    @popup = nil
    @popup_size = :large
    @color = :hp_damage
    @deco = ["", -1] # [テキスト, テキストの位置]
    @battler = nil
    @delay = 0
    @popup_wait = false
    # <<ver1.10>> 能力強化/弱体ポップアップを画像で表示する際に利用
    @buff_data = [-1, -1] # [能力, 強化or弱体or解除]
  end
  #--------------------------------------------------------------------------
  # ● ポップアップを生成
  #--------------------------------------------------------------------------
  def makeup
    if @@make_methods[@type]
      @@make_methods[@type].call
      @popup_wait = true
    end
  end
  #--------------------------------------------------------------------------
  # ● ポップアップウェイト
  # 　バトルログタイプが [2:ヘルプ表示] の場合のみ実行されます。
  #--------------------------------------------------------------------------
  def add_wait
    return if LNX11::BATTLELOG_TYPE != 2 || !@popup_wait
    LNX11::POPUP_ADD_WAIT.times {BattleManager.log_window.abs_wait(1)}
    @popup_wait = false
  end
  #--------------------------------------------------------------------------
  # ● ポップアップ生成メソッド
  # 　これらのメソッドを @@make_methods に登録して呼び出します。
  # これはポップアップタイプの拡張を容易にするための仕様です。
  #--------------------------------------------------------------------------
  def makeup_spring_large
    # @type   0 : 跳ねるポップアップ(大)
    @popup_size = :large
    @sprites.push(Sprite_PopupSpring.new(self))
  end
  def makeup_spring_small
    # @type   1 : 跳ねるポップアップ(小)
    @popup_size = :small
    @delay = @battler.popup_delay[1]
    @sprites.push(Sprite_PopupSpring.new(self))
  end
  def makeup_rising_large
    # @type   2 : ゆっくり上昇(大)
    @popup_size = :large
    @delay = @battler.popup_delay[2]
    @sprites.push(Sprite_PopupRising.new(self))
  end
  def makeup_rising_small
    # @type   3 : ゆっくり上昇(小)
    @popup_size = :small      
    @delay = @battler.popup_delay[2]
    @sprites.push(Sprite_PopupRising.new(self))
  end
  def makeup_sliding_large
    # @type   4 : スライド(大)
    @popup_size = :large
    @delay = @battler.popup_delay[3]
    @sprites.push(Sprite_PopupSliding.new(self))
  end
  def makeup_sliding_small
    # @type   5 : スライド(小)
    @popup_size = :small
    @delay = @battler.popup_delay[3]
    @sprites.push(Sprite_PopupSliding.new(self))      
  end
  def makeup_overlay_large
    # @type   6 : オーバーレイ(大)
    @popup_size = :large
    @sprites.push(Sprite_PopupOverlay.new(self))
  end
  def makeup_overlay_small
    # @type   7 : オーバーレイ(小)
    @popup_size = :small
    @sprites.push(Sprite_PopupOverlay.new(self))
  end
  def makeup_levelup
    # @type :levelup : レベルアップ
    @battler.popup_delay[3] = 0
    @popup_size = :large
    @sprites.push(Sprite_PopupLevelUp.new(self))
  end
  #--------------------------------------------------------------------------
  # ● TP のポップアップが有効か？
  #--------------------------------------------------------------------------
  def tp_popup_enabled?(target)
    return false if !$data_system.opt_display_tp
    return true  if LNX11::TP_POPUP_TYPE == 0 # すべてポップアップ
    return true  if LNX11::TP_POPUP_TYPE == 1 && target.actor? # アクターのみ
    false # ポップアップしない
  end
  #--------------------------------------------------------------------------
  # ● 任意のポップアップ
  #--------------------------------------------------------------------------
  def popup_custom(target, popup, type = 0, color = :hp_damage, deco = nil)
    refresh
    @battler = target
    @popup = popup
    type = LNX11::POPUP_TYPE[type] if type.is_a?(Symbol)
    @type = type
    @color = color
    @deco = LNX11::DECORATION_NUMBER[deco] if deco.is_a?(Symbol)
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● レベルアップのポップアップ
  #--------------------------------------------------------------------------
  def popup_levelup(target)
    # 戦闘に参加している場合のみポップアップ
    return unless $game_party.battle_members.include?(target)
    refresh
    @type = :levelup
    @battler = target
    @popup = LNX11::POPUP_VOCAB[:levelup]
    @color = :levelup
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● 単一テキストのポップアップ
  #--------------------------------------------------------------------------
  def popup_text(target, type)
    refresh
    @type = LNX11::POPUP_TYPE[type]
    @battler = target
    @popup = LNX11::POPUP_VOCAB[type]
    @color = type
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● ミスのポップアップ
  #--------------------------------------------------------------------------
  def popup_miss(target, item)
    refresh
    @type = LNX11::POPUP_TYPE[:miss]
    @battler = target
    @popup = LNX11::POPUP_VOCAB[:miss]
    @color = :hp_damage
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● HP ダメージポップアップ
  #--------------------------------------------------------------------------
  def popup_hp_damage(target, item)
    return if target.result.hp_damage == 0 && item && !item.damage.to_hp?
    refresh
    @popup = target.result.hp_damage
    @battler = target
    if target.result.hp_drain > 0
      # 被吸収
      @type = LNX11::POPUP_TYPE[:hp_drain]
      # 弱点/耐性
      if target.result.element_rate > 1
        @deco = LNX11::DECORATION_NUMBER[:weakness]
        @color = :weakness
      elsif target.result.element_rate < 1
        @deco = LNX11::DECORATION_NUMBER[:resist]
        @color = :resist
      else
        @color = :hp_damage
      end
    elsif target.result.hp_damage > 0
      # ダメージ
      @type = LNX11::POPUP_TYPE[:hp_damage]
      @color = :hp_damage
      if target.result.critical
        # クリティカル
        @deco = LNX11::DECORATION_NUMBER[:critical]
        @color = :critical
      end
      # 弱点/耐性
      if target.result.element_rate > 1
        @deco = LNX11::DECORATION_NUMBER[:weakness]
        @color = :weakness if @color != :critical
      elsif target.result.element_rate < 1
        @deco = LNX11::DECORATION_NUMBER[:resist]
        @color = :resist if @color != :critical
      end
    elsif target.result.hp_damage < 0
      # 回復
      @type = LNX11::POPUP_TYPE[:hp_recovery]
      @color = :hp_recovery
    else
      # 0 ダメージ
      @type = LNX11::POPUP_TYPE[:hp_damage]
      @color = :hp_damage
    end 
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● MP ダメージポップアップ
  #--------------------------------------------------------------------------
  def popup_mp_damage(target, item)
    return if target.dead? || target.result.mp_damage == 0
    refresh
    @popup = target.result.mp_damage
    @battler = target
    @deco = LNX11::DECORATION_NUMBER[:mp_damage]
    if target.result.mp_drain > 0
      # 被吸収
      @type = LNX11::POPUP_TYPE[:mp_drain]
      @color = :mp_damage
    elsif target.result.mp_damage > 0
      # ダメージ
      @type = LNX11::POPUP_TYPE[:mp_damage]
      @color = :mp_damage
    elsif target.result.mp_damage < 0
      # 回復
      @type = LNX11::POPUP_TYPE[:mp_recovery]
      @color = :mp_recovery
    end
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● TP ダメージポップアップ
  #--------------------------------------------------------------------------
  def popup_tp_damage(target, item)
    return unless tp_popup_enabled?(target)
    return if target.dead? || target.result.tp_damage == 0
    refresh
    @popup = target.result.tp_damage
    @battler = target
    deco = target.result.tp_damage > 0 ? :tp_minus : :tp_plus
    @deco = LNX11::DECORATION_NUMBER[deco]
    @type = LNX11::POPUP_TYPE[:tp_damage]
    @color = :tp_damage
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● HP 吸収回復
  #--------------------------------------------------------------------------
  def popup_hp_drain(target, hp_drain)
    return if hp_drain == 0
    refresh
    @popup = hp_drain
    @battler = target
    @type = LNX11::POPUP_TYPE[:hp_drainrecv]
    @color = :hp_recovery
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● MP 吸収回復
  #--------------------------------------------------------------------------
  def popup_mp_drain(target, mp_drain)
    return if mp_drain == 0
    refresh
    @popup = mp_drain
    @battler = target
    @deco = LNX11::DECORATION_NUMBER[:mp_damage]
    @type = LNX11::POPUP_TYPE[:mp_drainrecv]
    @color = :mp_recovery
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● ステート付加のポップアップ
  #--------------------------------------------------------------------------
  def popup_added_states(target)
    refresh
    @battler = target
    target.result.added_state_objects.each do |state|
      next if state.id == target.death_state_id
      next if state.icon_index == 0 && LNX11::INDEXZERO_NO_POPUP
      next if state.add_no_display?      
      if state.add_no_decoration?
        @popup = state.add_display_name
      else
        @popup = sprintf(LNX11::DECORATION_TEXT[:add_state],
                         state.add_display_name)
      end
      type = state.advantage? ? :add_state : :add_badstate
      if state.add_popup_type
        @type = state.add_popup_type
      else
        @type = LNX11::POPUP_TYPE[type]
      end
      @color = type
      # ポップアップ作成
      makeup
    end
  end
  #--------------------------------------------------------------------------
  # ● ステート解除のポップアップ
  #--------------------------------------------------------------------------
  def popup_removed_states(target)
    refresh
    @type = LNX11::POPUP_TYPE[:rem_badstate]
    @battler = target
    target.result.removed_state_objects.each do |state|
      next if state.id == target.death_state_id
      next if state.icon_index == 0 && LNX11::INDEXZERO_NO_POPUP
      next if state.remove_no_display?
      if state.remove_no_decoration?
        @popup = state.remove_display_name
      else
        @popup = sprintf(LNX11::DECORATION_TEXT[:rem_state],
                         state.remove_display_name)
      end
      type = state.advantage? ? :rem_state : :rem_badstate
      if state.remove_popup_type
        @type = state.remove_popup_type
      else
        @type = LNX11::POPUP_TYPE[type]
      end
      @color = type
      # ポップアップ作成
      makeup
    end
  end
  #--------------------------------------------------------------------------
  # ● 能力強化／弱体のポップアップ
  #--------------------------------------------------------------------------
  def popup_buffs(target, buffs, fmt)
    return if buffs.empty?
    refresh
    @battler = target
    case fmt 
    when Vocab::BuffAdd 
      buffdeco = LNX11::DECORATION_TEXT[:add_buff]
      @type = LNX11::POPUP_TYPE[:add_buff]
      @color = :add_buff
      @buff_data[1] = 0
    when Vocab::DebuffAdd
      buffdeco = LNX11::DECORATION_TEXT[:add_debuff]
      @type = LNX11::POPUP_TYPE[:add_debuff]
      @color = :add_debuff
      @buff_data[1] = 1
    when Vocab::BuffRemove
      buffdeco = LNX11::DECORATION_TEXT[:rem_buff]
      @type = LNX11::POPUP_TYPE[:rem_buff]
      @color = :rem_buff
      @buff_data[1] = 2
    end
    buffs.each do |param_id|
      @popup = sprintf(buffdeco, LNX11::POPUP_VOCAB_PARAMS[param_id])
      @buff_data[0] = param_id
      # ポップアップ作成
      makeup
      @popup_wait = false
    end
  end
  #--------------------------------------------------------------------------
  # ● HP 再生
  #--------------------------------------------------------------------------
  def popup_regenerate_hp(target, hp_damage, paycost = false)
    return if hp_damage == 0
    refresh
    @popup = hp_damage
    @battler = target
    if hp_damage > 0
      # ダメージ
      @type = LNX11::POPUP_TYPE[:hp_slipdamage]
      @color = :hp_damage
    elsif hp_damage < 0
      # 回復
      @type = LNX11::POPUP_TYPE[:hp_regenerate]
      @color = :hp_recovery
    end 
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● MP 再生
  #--------------------------------------------------------------------------
  def popup_regenerate_mp(target, mp_damage, paycost = false)
    return if mp_damage == 0
    refresh
    @popup = mp_damage
    @battler = target
    @deco = LNX11::DECORATION_NUMBER[mp_damage > 0 ? :mp_minus : :mp_plus]
    if mp_damage > 0
      # ダメージ
      @type = LNX11::POPUP_TYPE[paycost ? :mp_paycost : :mp_slipdamage]
      @color = :mp_damage
    elsif mp_damage < 0
      # 回復
      @type = LNX11::POPUP_TYPE[paycost ? :mp_paycost : :mp_regenerate]
      @color = :mp_recovery
    end
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● TP 再生
  #--------------------------------------------------------------------------
  def popup_regenerate_tp(target, tp_damage, paycost = false)
    return unless tp_popup_enabled?(target)
    return if tp_damage == 0
    refresh
    @popup = tp_damage
    @battler = target
    @deco = LNX11::DECORATION_NUMBER[tp_damage > 0 ? :tp_minus : :tp_plus]
    @type = LNX11::POPUP_TYPE[paycost ? :tp_paycost : :tp_regenerate]
    @color = :tp_damage
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● TP チャージ
  #--------------------------------------------------------------------------
  def popup_tp_charge(target, tp_damage)
    return unless tp_popup_enabled?(target)
    return if tp_damage == 0
    refresh
    @popup = tp_damage
    @battler = target
    @deco = LNX11::DECORATION_NUMBER[tp_damage > 0 ? :tp_minus : :tp_plus]
    @type = LNX11::POPUP_TYPE[:tp_charge]
    @color = :tp_damage
    # ポップアップ作成
    makeup
  end
  #--------------------------------------------------------------------------
  # ● TP 得
  #--------------------------------------------------------------------------
  def popup_tp_gain(target, tp_damage)
    return unless tp_popup_enabled?(target)
    return if tp_damage == 0
    refresh
    @popup = tp_damage
    @battler = target
    @deco = LNX11::DECORATION_NUMBER[tp_damage > 0 ? :tp_minus : :tp_plus]
    @type = LNX11::POPUP_TYPE[:tp_gain]
    @color = :tp_damage
    # ポップアップ作成
    makeup
  end
end

#==============================================================================
# ■ [追加]:Sprite_PopupBase
#------------------------------------------------------------------------------
# 　戦闘中のダメージ表示等をポップアップ表示するためのスプライトの
# スーパークラス。サブクラスで細かい動きを定義します。
#==============================================================================

class Sprite_PopupBase < Sprite
  #--------------------------------------------------------------------------
  # ● クラス変数
  #--------------------------------------------------------------------------
  @@cache_number = []
  @@cache_text   = {}
  @@w = []
  @@h = []
  @@priority = 0
  @@count    = 0
  @@buf_bitmap = nil
  #--------------------------------------------------------------------------
  # ● 定数
  #--------------------------------------------------------------------------
  NUMBER_COLOR_SIZE = 8
  NUMBERS    = [0,1,2,3,4,5,6,7,8,9]
  COLOR_KEYS = LNX11::POPUP_COLOR.keys 
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     data : ポップアップデータ
  #--------------------------------------------------------------------------
  def initialize(data = nil)
    if data == nil || !data.battler.battle_member?
      # 非表示のポップアップ
      super(nil)
      @remove = true
      return
    end
    # ポップアップデータを適用
    super(data.viewport)
    @battler = data.battler # ポップアップを表示するバトラー
    @delay   = data.delay   # ディレイ(遅延) ※サブクラスによって扱いが違います
    @popup_size = data.popup_size # ポップアップの大きさ 大/小
    # 基本設定
    @duration = 60  # 消え始める時間
    @fadeout  = 16  # 消える速さ
    @rx = ry  = 0   # XY座標
    # Z座標
    @rz = base_z * 128 + priority
    popup_add
    self.visible = false
    # ポップアップデータからビットマップを作成
    if data.popup.is_a?(Numeric)
      # ダメージ値
      self.bitmap = number(data.popup, data.color, data.popup_size, data.deco)
    elsif data.popup.is_a?(String)
      # テキスト
      self.bitmap = text(data.popup, data.color, 
                         data.popup_size, data.buff_data)
    end
    # 位置設定
    self.ox = self.width  / 2
    self.oy = self.height / 2
    set_position
    start
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  def dispose
    popup_remove
    terminate
    self.bitmap.dispose if self.bitmap
    super
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    return if removed? || delay?
    update_popup
    update_xy
    @duration -= 1
    self.opacity -= @fadeout if @duration <= 0
    dispose if self.opacity == 0
  end
  #--------------------------------------------------------------------------
  # ● 開始処理(サブクラスで定義)
  #--------------------------------------------------------------------------
  def start
  end
  #--------------------------------------------------------------------------
  # ● 終了処理(サブクラスで定義)
  #--------------------------------------------------------------------------
  def terminate
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新(サブクラスで定義)
  #--------------------------------------------------------------------------
  def update_popup
  end
  #--------------------------------------------------------------------------
  # ● ポップアップ Z 座標
  #--------------------------------------------------------------------------
  def base_z
    0
  end
  #--------------------------------------------------------------------------
  # ● ポップアップのプライオリティを返す
  # 　同一Z座標のポップアップで、後から生成されたものが手前に表示されるように
  # Z座標の修正値をクラス変数で管理しています。
  #--------------------------------------------------------------------------
  def priority
    @@priority * 2
  end
  #--------------------------------------------------------------------------
  # ● ポップアップ追加
  #--------------------------------------------------------------------------
  def popup_add
    @@priority += 1
    @@count += 1
  end
  #--------------------------------------------------------------------------
  # ● ポップアップ消去
  #--------------------------------------------------------------------------
  def popup_remove
    @remove = true
    @@count -= 1
    @@priority = 0 if @@count <= 0
  end
  #--------------------------------------------------------------------------
  # ● ディレイが残っている？
  # 　サブクラスの update メソッドで使用します。
  #--------------------------------------------------------------------------
  def delay?
    @delay -= 1
    self.visible = (@delay <= 0)
    !self.visible
  end
  #--------------------------------------------------------------------------
  # ● ポップアップ消去済み？
  #--------------------------------------------------------------------------
  def removed?
    @remove
  end  
  #--------------------------------------------------------------------------
  # ● 座標更新
  #--------------------------------------------------------------------------
  def update_xy
    self.x = @rx
    self.y = @ry
    self.z = @rz
  end
  #--------------------------------------------------------------------------
  # ● ポップアップ位置の設定
  #--------------------------------------------------------------------------
  def set_position
    @rx = @battler.screen_x
    if @battler.actor?
      pos = LNX11::ACTOR_POPUP_POSITION
    else
      pos = [LNX11::ENEMY_POPUP_POSITION, 2].min
    end
    case pos
    when 0 ; @ry = @battler.screen_y        # 足元
    when 1 ; @ry = @battler.screen_y_center # 中心
    when 2 ; @ry = @battler.screen_y_top    # 頭上
    when 3 ; @ry = Graphics.height + LNX11::ACTOR_POPUP_Y # Y座標統一(アクター)
    end
  end
  #--------------------------------------------------------------------------
  # ● 描画するテキストの矩形を取得
  #--------------------------------------------------------------------------
  def text_size(str, name, size, bold = false)
    @@buf_bitmap = Bitmap.new(4, 4) if !@@buf_bitmap || @@buf_bitmap.disposed?
    @@buf_bitmap.font.name = name
    @@buf_bitmap.font.size = size
    @@buf_bitmap.font.bold = bold
    return @@buf_bitmap.text_size(str)
  end
  #--------------------------------------------------------------------------
  # ● 数字ビットマップの取得
  #--------------------------------------------------------------------------
  def bitmap_number(size = :large)
    return @@cache_number[size == :large ? 0 : 1]
  end
  #--------------------------------------------------------------------------
  # ● 数字ビットマップキャッシュの作成
  #--------------------------------------------------------------------------
  def create_number
    return if @@cache_number[0] && !@@cache_number[0].disposed?
    n_index = NUMBER_COLOR_SIZE
    @@cache_number.clear
    colors = LNX11::POPUP_COLOR.values # 色
    name = LNX11::NUMBER_FONT
    # 大・小の 2 パターンを作成する(ループ)
    [LNX11::LARGE_NUMBER, LNX11::SMALL_NUMBER].each_with_index do |n_size, i|
      next if get_number(i)
      size = n_size[:fontsize]
      # 数字の幅・高さ
      w = NUMBERS.collect{|n| text_size(n.to_s, name, size).width}.max + 4
      nh = NUMBERS.collect{|n| text_size(n.to_s, name, size).height}.max
      h = n_size[:line_height]
      @@w[i] = w
      @@h[i] = h
      # ビットマップ作成
      bitmap = Bitmap.new(w * NUMBERS.size, h * [colors.size, n_index].min)
      bitmap.font.name = LNX11::NUMBER_FONT
      bitmap.font.size = n_size[:fontsize]
      y = ((h - nh) / 2) - 1
      # 色ごとに分けて描画する(ループ)
      n_index.times do |col|
        # 色を変更
        bitmap.font.color.set(colors[col][0])
        bitmap.font.out_color.set(colors[col][1])
        # 文字ごとに分けて描画(ループ)
        NUMBERS.size.times do |num|
          bitmap.draw_text(num * w, (col * h) + y, w, nh, NUMBERS[num], 2)
        end
      end
      @@cache_number.push(bitmap)
    end
    p "LNX11a:数字ビットマップのキャッシュを作成しました。"
    # 数字ビットマップを表示する(テスト用)
    # s = Sprite.new
    # s.z = 1000000
    # s.bitmap = @@cache_number[1] # 0 or 1
    # loop do Graphics.update end
  end
  #--------------------------------------------------------------------------
  # ● 数字ビットマップの取得
  #--------------------------------------------------------------------------
  def get_number(i)
    case i
    when 0 # 大
      return false if LNX11::LARGE_NUMBER_NAME.empty?
      bitmap = Cache.system(LNX11::LARGE_NUMBER_NAME)
    when 1 # 小
      return false if LNX11::SMALL_NUMBER_NAME.empty?
      bitmap = Cache.system(LNX11::SMALL_NUMBER_NAME)
    end
    @@cache_number.push(bitmap)
    @@w[i] = bitmap.width / NUMBERS.size
    @@h[i] = bitmap.height / NUMBER_COLOR_SIZE
    true
  end
  #--------------------------------------------------------------------------
  # ● ダメージ数を描画したビットマップの取得
  #--------------------------------------------------------------------------
  def number(num, color, size = :large, deco = nil)
    # 数値を文字列の配列にする
    numbers = (num.abs.to_s).split(//)
    # 色番号を取得
    color_index = COLOR_KEYS.index(color)
    # ポップアップサイズを設定
    n_bitmap = bitmap_number(size)
    if size == :large
      n_size = LNX11::LARGE_NUMBER
      i = 0
    else
      n_size = LNX11::SMALL_NUMBER
      i = 1
    end
    spacing = n_size[:spacing]
    w = @@w[i]
    h = @@h[i]
    # ダメージ値のビットマップサイズ
    @bw = w * numbers.size + spacing * (numbers.size - 1)
    @bh = h
    # 修飾文字の描画
    @offset_x = @offset_y = 0
    text_bitmap = deco_text(deco,color,n_size[:fontsize]) if deco[1] >= 0
    # ビットマップを作成
    bitmap = Bitmap.new(@bw, @bh) 
    # 塗りつぶし(テスト用)
    # bitmap.fill_rect(bitmap.rect, Color.new(0,0,0,128))
    # ダメージ値を描画
    rect = Rect.new(0, h * color_index, w, h)
    numbers.size.times do |n|
      rect.x = numbers[n].to_i * w
      bitmap.blt(w * n + spacing * n + @offset_x, @offset_y, n_bitmap, rect) 
    end
    # 修飾文字の描画をコールバック
    @decoblt.call(bitmap) if @decoblt
    @decoblt = nil
    # ビットマップを返す
    bitmap
  end
  #--------------------------------------------------------------------------
  # ● 修飾文字の描画
  #--------------------------------------------------------------------------
  def deco_text(deco, color, sizerate)
    # 元の幅・高さ
    ow = @bw
    oh = @bh
    case deco[1]    
    when 2 # ダメージ値の下
      # テキストのビットマップを取得
      size = decosize(deco[0], sizerate, :top_bottom)
      text_bitmap = text(deco[0], color, size)
      # テキストの幅・高さ
      tw = text_bitmap.width
      th = text_bitmap.height * 0.8
      # 最終的なビットマップのサイズ
      @bw = [@bw, tw].max
      @bh += th
      # ダメージ値の描画位置の修正
      @offset_x = (@bw - ow) / 2
      @offset_y = 0
      # 修飾文字の描画位置を設定
      x = (@bw - tw) / 2
      y = oh * 0.8
    when 4 # ダメージ値の左
      # テキストのビットマップを取得
      size = decosize(deco[0], sizerate, :left_right)
      text_bitmap = text(deco[0], color, size)
      # テキストの幅・高さ
      tw = text_bitmap.width
      th = text_bitmap.height
      # 最終的なビットマップのサイズ
      @bw += tw
      @bh = [@bh, th].max
      # ダメージ値の描画位置の修正
      @offset_x = tw
      @offset_y = (@bh - oh) / 2
      # 修飾文字の描画位置を設定
      x = 2
      y = (@bh - th) / 2
    when 6 # ダメージ値の右
      # テキストのビットマップを取得
      size = decosize(deco[0], sizerate, :left_right)
      text_bitmap = text(deco[0], color, size)
      # テキストの幅・高さ
      tw = text_bitmap.width
      th = text_bitmap.height
      # 最終的なビットマップのサイズ
      @bw += tw
      @bh = [@bh, th].max
      # ダメージ値の描画位置の修正
      @offset_x = 0
      @offset_y = (@bh - oh) / 2
      # 修飾文字の描画位置を設定
      x = ow
      y = (@bh - th) / 2
    when 8 # ダメージ値の上
      # テキストのビットマップを取得
      size = decosize(deco[0], sizerate, :top_bottom)
      text_bitmap = text(deco[0], color, size)
      # テキストの幅・高さ
      tw = text_bitmap.width
      th = text_bitmap.height * 0.8
      # 最終的なビットマップのサイズ
      @bw = [@bw, tw].max
      @bh += th
      # ダメージ値の描画位置の修正
      @offset_x = (@bw - ow) / 2
      @offset_y = @bh - oh
      # 修飾文字の描画位置を設定
      x = (@bw - tw) / 2
      y = 0
    end
    # 修飾文字の描画(コールバック)
    @decoblt = Proc.new {|bitmap|
    bitmap.blt(x, y, text_bitmap, text_bitmap.rect)
    text_bitmap.dispose}
    return text_bitmap
  end
  #--------------------------------------------------------------------------
  # ● 修飾文字のサイズ
  #--------------------------------------------------------------------------
  def decosize(text, size, pos)
    if text.length != text.bytesize
      return size * LNX11::TEXT_SIZERATE[pos] * LNX11::TEXT_SIZERATE_MCS
    else
      return size * LNX11::TEXT_SIZERATE[pos]
    end
  end
  #--------------------------------------------------------------------------
  # ● テキストを描画したビットマップの取得
  # 　ステートやダメージ値の修飾文字の描画に使用します。
  #--------------------------------------------------------------------------
  def text(text, color, size = :large, buff_data = [-1, -1])
    # キャッシュがあればそれを返す(無ければ作成)
    key = text + color.to_s + size.to_s
    if @@cache_text[key] && !@@cache_text[key].disposed?
      return @@cache_text[key].clone 
    end
    # 用語の置き換え
    text.gsub!("\hp") { Vocab::hp_a } if text.include?("\hp")
    text.gsub!("\mp") { Vocab::mp_a } if text.include?("\mp") 
    text.gsub!("\tp") { Vocab::tp_a } if text.include?("\tp")
    # <<ver1.10>> テキストの頭に _ があれば対応する画像ファイルを参照する
    if text[/^[\_]./]
      bitmap = get_text_bitmap(text, color, size)
      # キャッシュに保存
      @@cache_text[key] = bitmap
      # ビットマップを返す
      return bitmap.clone
    end
    # <<ver1.10>> 
    # 能力強化/弱体のポップアップで、ファイル名が指定されていればそれを返す
    if buff_data[0] >= 0 &&
      (size == :large && !LNX11::LARGE_BUFFS_NAME.empty?) ||
      (size == :small && !LNX11::SMALL_BUFFS_NAME.empty?)
      bitmap = get_buff_bitmap(buff_data, size)
      # キャッシュに保存
      @@cache_text[key] = bitmap
      # ビットマップを返す
      return bitmap.clone
    end
    # テキストにマルチバイト文字があれば日本語用フォントを使う
    if text.length != text.bytesize
      fontname = LNX11::TEXT_FONT_MCS
      sizerate = LNX11::TEXT_SIZERATE[:normal] * LNX11::TEXT_SIZERATE_MCS
    else
      fontname = LNX11::TEXT_FONT
      sizerate = LNX11::TEXT_SIZERATE[:normal]
    end
    # ポップアップサイズを設定
    case size
    when :large ; fontsize = LNX11::LARGE_NUMBER[:fontsize] * sizerate
    when :small ; fontsize = LNX11::SMALL_NUMBER[:fontsize] * sizerate
    else        ; fontsize = size
    end
    # テキストサイズ計算
    rect = text_size(text, fontname, fontsize)
    rect.width += 2
    # ビットマップを作成
    bitmap = Bitmap.new(rect.width, rect.height) 
    # 塗りつぶし(テスト用)
    # bitmap.fill_rect(bitmap.rect, Color.new(0,0,0,128)) 
    # フォント設定
    bitmap.font.name = fontname
    bitmap.font.size = fontsize
    bitmap.font.color.set(LNX11::POPUP_COLOR[color][0])
    bitmap.font.out_color.set(LNX11::POPUP_COLOR[color][1])
    # テキスト描画
    bitmap.draw_text(rect, text, 1)
    # キャッシュに保存
    @@cache_text[key] = bitmap
    # ビットマップを返す
    bitmap.clone
  end
  #--------------------------------------------------------------------------
  # ● 能力強化/弱体ビットマップの取得 <<ver1.10>>
  #--------------------------------------------------------------------------
  def get_buff_bitmap(buff_data, size)
    case size
    when :large ; src_bitmap = Cache.system(LNX11::LARGE_BUFFS_NAME)
    when :small ; src_bitmap = Cache.system(LNX11::SMALL_BUFFS_NAME)
    end
    src_rect = Rect.new
    src_rect.width  = src_bitmap.width  / 2
    src_rect.height = src_bitmap.height / 12
    src_rect.x = (buff_data[0] / 4) * src_rect.width
    src_rect.y = (buff_data[0] % 4) * src_rect.height * 3 +
                  buff_data[1] * src_rect.height
    bitmap = Bitmap.new(src_rect.width, src_rect.height)
    bitmap.blt(0, 0, src_bitmap, src_rect)
    bitmap
  end
  #--------------------------------------------------------------------------
  # ● テキストビットマップの取得 <<ver1.10>>
  #--------------------------------------------------------------------------
  def get_text_bitmap(text, color, size)
    # クリティカルカラーかつ、弱点/耐性なら参照するビットマップを変更
    if LNX11::POPUP_COLOR[color] == LNX11::POPUP_COLOR[:critical] &&
      (text == LNX11::DECORATION_NUMBER[:weakness][0] ||
       text == LNX11::DECORATION_NUMBER[:resist][0])
      # ファイル名に _critcolor を加える
      text += "_critcolor"
    end
    # MPダメージ/回復(符号なし)なら参照するビットマップを変更
    if text == LNX11::DECORATION_NUMBER[:mp_damage][0]
      # カラーに応じてファイル名を変更
      case LNX11::POPUP_COLOR[color]
      when LNX11::POPUP_COLOR[:mp_damage]   ; text += "_damage"
      when LNX11::POPUP_COLOR[:mp_recovery] ; text += "_recovery"
      end
    end
    # popup_xxxxxx_(large or small)
    Cache.system("popup" + text + (size == :large ? "_large" : "_small"))
  end
end

#==============================================================================
# ■ [追加]:Sprite_PopupSpring
#------------------------------------------------------------------------------
# 　通常の跳ねるポップアップ。
#==============================================================================

class Sprite_PopupSpring < Sprite_PopupBase
  #--------------------------------------------------------------------------
  # ● ポップアップ Z 座標
  #--------------------------------------------------------------------------
  def base_z
    14
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    # 動き設定
    set_movement
    # ディレイ設定 同じタイプのポップアップが重ならないようにする
    if @popup_size == :small
      self.oy -= @battler.popup_delay[1]
      @delay_clear = (@delay == 0)
      dy = self.bitmap.height * 0.8
      @battler.popup_delay[1] += dy
      @delay = 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------  
  def terminate
    # 一番上のポップアップなら、ディレイを初期化する
    @battler.popup_delay[1] = 0 if @delay_clear
  end
  #--------------------------------------------------------------------------
  # ● 投射運動の設定
  #--------------------------------------------------------------------------
  def set_movement
    if @popup_size == :large
      movement = LNX11::LARGE_MOVEMENT
    else
      movement = LNX11::SMALL_MOVEMENT
    end
    @fall       = -movement[:inirate]
    @gravity    =  movement[:gravity]
    @side       =  movement[:side_scatter] * rand(0) * (rand(2) == 0 ? -1 : 1)
    @ref_move   =  movement[:ref_height]
    @ref_factor =  movement[:ref_factor]
    @ref_count  =  movement[:ref_count]
    @duration   =  movement[:duration]
    @fadeout    =  movement[:fadeout]
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update_popup
    update_freefall
  end
  #--------------------------------------------------------------------------
  # ● 投射運動の更新
  #--------------------------------------------------------------------------
  def update_freefall
    if @ref_count >= 0
      # X:左右移動
      @rx += @side
      # Y:自由落下
      @ry += @fall
      @ref_move -= @fall
      @fall += @gravity
      # 跳ね返り
      if @ref_move <= 0 && @fall >= 0
        @ref_count -= 1
        @fall = -@fall * @ref_factor
      end      
    end
  end
end

#==============================================================================
# ■ [追加]:Sprite_PopupRising
#------------------------------------------------------------------------------
# 　少しずつ上昇するポップアップ。
#==============================================================================

class Sprite_PopupRising < Sprite_PopupBase
  #--------------------------------------------------------------------------
  # ● ポップアップ Z 座標
  #--------------------------------------------------------------------------
  def base_z
    6
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    # 動き設定
    set_movement
    self.opacity = 0
    d = self.bitmap.height * LNX11::RISE_MOVEMENT[:line_spacing]
    @delay_count = d / @rising_speed 
    @battler.popup_delay[2] += @delay_count
  end
  #--------------------------------------------------------------------------
  # ● 動きの設定
  #--------------------------------------------------------------------------
  def set_movement
    @rising_speed = LNX11::RISE_MOVEMENT[:rising_speed]
    @duration = LNX11::RISE_MOVEMENT[:duration]
    @fadeout  = LNX11::RISE_MOVEMENT[:fadeout]
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update_popup
    @delay_count -= 1
    @battler.popup_delay[2] -= 1 if @delay_count >= 0
    @ry -= @rising_speed # すこしずつ上昇
    self.opacity += 32 if @duration > 0
  end
end

#==============================================================================
# ■ [追加]:Sprite_PopupSliding
#------------------------------------------------------------------------------
# 　スライド表示するポップアップ。
#==============================================================================

class Sprite_PopupSliding < Sprite_PopupBase
  #--------------------------------------------------------------------------
  # ● ポップアップ Z 座標
  #--------------------------------------------------------------------------
  def base_z
    8
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    # 動き設定
    set_movement
    d = self.bitmap.height * LNX11::SLIDE_MOVEMENT[:line_spacing]
    self.oy += @delay + d / 2 if @delay > 0
    self.opacity = 0
    # ディレイ設定 同じタイプのポップアップが重ならないようにする
    @delay_clear = (@delay == 0)
    @battler.popup_delay[3] += (@delay <= 0 ? d / 2 : d)
    @delay = 0
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------  
  def terminate
    # 一番下のポップアップなら、ディレイを初期化する
    @battler.popup_delay[3] = 0 if @delay_clear
  end
  #--------------------------------------------------------------------------
  # ● 動きの設定
  #--------------------------------------------------------------------------
  def set_movement
    @x_speed  = LNX11::SLIDE_MOVEMENT[:x_speed]
    @duration = LNX11::SLIDE_MOVEMENT[:duration]
    @fadeout  = LNX11::SLIDE_MOVEMENT[:fadeout]
    # フェードインのスライド分だけ X を移動
    @rx -= @x_speed * 255.0 / @fadeout
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update_popup
    @rx += @x_speed if opacity != 255 # スライド
    self.opacity += @fadeout if @duration > 0
  end
end

#==============================================================================
# ■ [追加]:Sprite_PopupOverlay
#------------------------------------------------------------------------------
# 　オーバーレイポップアップ。自身の複製を加算合成で重ね合わせます。
#==============================================================================

class Sprite_PopupOverlay < Sprite_PopupBase
  #--------------------------------------------------------------------------
  # ● ポップアップ Z 座標
  #--------------------------------------------------------------------------
  def base_z
    10
  end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    @duration = LNX11::OVERLAY_MOVEMENT[:duration]
    @fadeout  = LNX11::OVERLAY_MOVEMENT[:fadeout]
    # オーバーレイの作成
    create_overlay
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    @overlay.dispose
    @overlay = nil
  end
  #--------------------------------------------------------------------------
  # ● オーバーレイ(複製)の作成
  #--------------------------------------------------------------------------
  def create_overlay
    @overlay = Sprite.new
    @overlay.bitmap   = self.bitmap
    @overlay.viewport = self.viewport
    @overlay.ox = self.ox
    @overlay.oy = self.oy
    @overlay.visible = false
    @overlay.blend_type = 1
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update_popup
    self.opacity += @fadeout * 2 if @duration > 0
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_overlay
  end
  #--------------------------------------------------------------------------
  # ● オーバーレイの更新
  #--------------------------------------------------------------------------
  def update_overlay
    return if self.disposed? || @overlay.opacity == 0
    @overlay.x = self.x
    @overlay.y = self.y
    @overlay.z = self.z
    # 拡大・消去
    @overlay.zoom_x += 0.16
    @overlay.zoom_y += 0.12
    @overlay.opacity -= 20
    @overlay.visible = (@overlay.opacity != 0)
  end
end

#==============================================================================
# ■ [追加]:Sprite_PopupLevelUp
#------------------------------------------------------------------------------
# 　レベルアップのポップアップ。スライドポップアップを継承しています。
#==============================================================================

class Sprite_PopupLevelUp < Sprite_PopupSliding
  #--------------------------------------------------------------------------
  # ● ポップアップ Z 座標
  #--------------------------------------------------------------------------
  def base_z
    32
  end
  #--------------------------------------------------------------------------
  # ● ポップアップ位置の設定
  #--------------------------------------------------------------------------
  def set_position
    @rx = @battler.screen_x - LNX11::ACTOR_OFFSET[:x]
    case LNX11::LEVELUP_POPUP_POSITION
    when 0 ; @ry = @battler.screen_y        # 足元
    when 1 ; @ry = @battler.screen_y_center # 中心
    when 2 ; @ry = @battler.screen_y_top    # 頭上
    when 3 ; @ry = Graphics.height + LNX11::LEVELUP_POPUP_Y # Y座標統一
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update_popup
    super
    # リザルト中なら自動的に消去しない
    @duration += 1 if $game_troop.all_dead? || $game_message.busy?
  end
end

#==============================================================================
# ■ Bitmap
#==============================================================================

class Bitmap
  #--------------------------------------------------------------------------
  # ● [追加]:カーソル用三角形の描画
  #--------------------------------------------------------------------------
  def lnx_cursor_triangle(size, color, oy = 0, grad = 1)
    color = color.clone
    x = (self.width - size) / 2
    y = (self.height - size) / 2 + oy
    rect = Rect.new(x, y, size, 1)
    count = size / 2
    minus = 128 / count / 2
    count.times do
      clear_rect(rect)
      fill_rect(rect, color)
      color.red   = [color.red   - minus * grad, 0].max
      color.green = [color.green - minus * grad, 0].max
      color.blue  = [color.blue  - minus * grad, 0].max
      rect.y += rect.height
      clear_rect(rect)
      fill_rect(rect, color) 
      color.red   = [color.red   - minus * grad, 0].max
      color.green = [color.green - minus * grad, 0].max
      color.blue  = [color.blue  - minus * grad, 0].max
      rect.x += 1
      rect.y += rect.height
      rect.width -= 2
    end
  end
end

#==============================================================================
# ■ [追加]:Sprite_TargetCursor
#------------------------------------------------------------------------------
# 　対象選択されているバトラーや行動選択中のアクターを示すアローカーソルです。
#==============================================================================
class Sprite_TargetCursor < Sprite
  #--------------------------------------------------------------------------
  # ● クラス変数
  #--------------------------------------------------------------------------
  @@cursor_cache = nil
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :battler     # バトラー
  attr_accessor :blink       # 点滅(対象の選択中)
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport = nil)
    super(viewport)
    @wait = LNX11::CURSOR_ANI_SPEED
    @speed = [LNX11::CURSOR_SPEED, 1].max
    @battler = nil
    @sub_cursor = []
    @blink = false
    self.bitmap = cursor_bitmap
    partition = self.bitmap.width / self.height
    self.src_rect.set(0, 0, self.width / partition, self.height)
    self.ox = self.width / 2
    self.oy = self.height / 2
    self.x = @rx = @tx = 0
    self.y = @ry = @ty = 0
    self.z = 98
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------  
  def dispose
    dispose_subcursor
    super
  end
  #--------------------------------------------------------------------------
  # ● サブカーソル作成
  # 　メンバー全体にカーソルを表示するために複数のカーソルを作成します。
  #--------------------------------------------------------------------------  
  def create_subcursor(members)
    return unless @sub_cursor.empty?
    members.each_with_index do |battler, i|
      @sub_cursor[i] = Sprite_TargetCursor.new(self.viewport)
      @sub_cursor[i].set(@rx, @ry)
      @sub_cursor[i].set(battler, true)
    end
  end
  #--------------------------------------------------------------------------
  # ● サブカーソル解放
  #--------------------------------------------------------------------------  
  def dispose_subcursor
    @sub_cursor.each {|sprite| sprite.dispose }
    @sub_cursor = []
  end
  #--------------------------------------------------------------------------
  # ● サブカーソル更新
  #--------------------------------------------------------------------------  
  def update_subcursor
    @sub_cursor.each {|sprite| sprite.update }
  end
  #--------------------------------------------------------------------------
  # ● ビットマップの設定
  #--------------------------------------------------------------------------
  def cursor_bitmap
    if !LNX11::CURSOR_NAME.empty?
      return Cache.system(LNX11::CURSOR_NAME)
    else
      # カーソルファイル名が指定されていなければRGSS側で生成
      return @@cursor_cache if @@cursor_cache && !@@cursor_cache.disposed?
      @@cursor_cache = Bitmap.new(32, 32)
      color = Color.new(0, 0, 0)
      @@cursor_cache.lnx_cursor_triangle(26, color, 2)
      2.times {@@cursor_cache.blur}
      color.set(255, 255, 255)
      @@cursor_cache.lnx_cursor_triangle(24, color, 1, 0.5)
      tone = LNX11::CURSOR_TONE ? LNX11::CURSOR_TONE : $game_system.window_tone
      r = 118 + tone.red
      g = 118 + tone.green
      b = 118 + tone.blue
      color.set(r, g, b, 232)
      @@cursor_cache.lnx_cursor_triangle(20, color,  0)
      @@cursor_cache.lnx_cursor_triangle(20, color,  1)
      p "LNX11a:カーソルビットマップを作成しました。"
      return @@cursor_cache
    end
  end
  #--------------------------------------------------------------------------
  # ● カーソルの表示
  #--------------------------------------------------------------------------
  def show
    self.x = @rx = @tx
    self.y = @ry = @ty
    self.visible = true
  end
  #--------------------------------------------------------------------------
  # ● カーソルの非表示
  #--------------------------------------------------------------------------
  def hide
    dispose_subcursor
    @battler = nil
    self.visible = false
  end
  #--------------------------------------------------------------------------
  # ● 移動平均
  #--------------------------------------------------------------------------
  def sma(a, b, p)
    # a = 目標位置 b = 現在地
    return a if a == b || (a - b).abs < 0.3 || p == 1
    result = ((a + b * (p.to_f - 1)) / p.to_f)
    return (a - result).abs <= 1.0 ? (b < a ? b + 0.3 : b - 0.3) : result
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    update_subcursor
    self.opacity = @sub_cursor.empty? ? 255 : 0
    return if !visible || !@sub_cursor.empty?
    super
    # 点滅
    if LNX11::CURSOR_BLINK
      self.blend_type = @blink && Graphics.frame_count / 3 % 2 == 0 ? 1 : 0
    end
    # アニメーションを進める
    @wait -= 1
    if @wait <= 0
      @wait += LNX11::CURSOR_ANI_SPEED
      self.src_rect.x += self.width
      self.src_rect.x = 0 if self.src_rect.x >= self.bitmap.width
    end
    # カーソルの座標を更新
    set_xy if @battler && @sub_cursor.empty?
    self.x = @rx = sma(@tx, @rx, @speed)
    self.y = @ry = sma(@ty, @ry, @speed)
  end
  #--------------------------------------------------------------------------
  # ● カーソル位置の設定
  #--------------------------------------------------------------------------
  def set(*args)
    if args[0].is_a?(Numeric)
      # 引数一つ目が数値なら、XY指定
      @battler = nil
      set_xy(args[0], args[1])
      @blink = args[2] ? args[2] : false
    else
      # バトラーorシンボル指定
      if @battler != args[0]
        @battler = args[0]
        dispose_subcursor
        case args[0]
        when :party        ; create_subcursor($game_party.members)
        when :troop        ; create_subcursor($game_troop.alive_members)
        when :troop_random ; create_subcursor($game_troop.alive_members)
        else ; args[0] ? set_xy : hide
        end
      end
      @blink = args[1] ? args[1] : false
    end
    # スピードが1かカーソルが非表示なら表示に変える
    show if @sub_cursor.empty? && (@speed == 1 || !visible)
  end
  #--------------------------------------------------------------------------
  # ● カーソル位置をバトラーの位置に設定
  #--------------------------------------------------------------------------
  def set_xy(x = nil, y = nil)
    if x 
      # 直接指定
      x += LNX11::CURSOR_OFFSET[:x]
      y += LNX11::CURSOR_OFFSET[:y]
    else
      # バトラーの座標
      x = @battler.screen_x + LNX11::CURSOR_OFFSET[:x]
      y = @battler.screen_y_top + LNX11::CURSOR_OFFSET[:y]
    end
    @tx = x
    minmax = LNX11::CURSOR_MINMAX
    @ty = [[y, minmax[:min] + self.oy].max, minmax[:max]].min
  end
end

#==============================================================================
# ■ [追加]:Sprite_OneLine_BattleLog
#------------------------------------------------------------------------------
# 　バトルログを動的に表示するスプライトです。単体では1行しか表示できませんが、
# 複数同時に扱うことで複数行の表示を実装しています。
#==============================================================================

class Sprite_OneLine_BattleLog < Sprite
  @@grad_cache = nil
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor   :position # 表示位置(行)
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(width, height, max_line_number)
    super(nil)
    @rx = @ry = 0
    @line_height = height
    @max_line_number = max_line_number
    @position = -1
    @visible = true
    self.ox = -LNX11::STORAGE_OFFSET[:x]
    self.oy = -LNX11::STORAGE_OFFSET[:y]
    self.opacity = 0
    self.z = 96
    self.bitmap = Bitmap.new(width * 0.75, height)
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------  
  def dispose
    self.bitmap.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● スプライトの表示
  #--------------------------------------------------------------------------  
  def show
    @visible = true
  end
  #--------------------------------------------------------------------------
  # ● スプライトの非表示
  #--------------------------------------------------------------------------  
  def hide
    @visible = false
    @position = -1
  end
  #--------------------------------------------------------------------------
  # ● 表示しているか？
  #--------------------------------------------------------------------------  
  def visible?
    @visible
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    return if self.opacity == 0
    self.opacity += @visible && @position >= 0 ? 24 : -24
    self.visible = self.opacity > 0
    return unless @visible # 不可視状態なら座標を更新しない
    @ry = (target_y + (@ry * 5)) / 6.0 if target_y < @ry
    @rx += 2 if @rx < 0
    self.x = @rx
    self.y = @ry
  end
  #--------------------------------------------------------------------------
  # ● テキストの描画
  # 　自身が持つ Bitmap で描画するのではなく、Window の contents から
  # コピーします(Sprite からでは Window_Base#draw_text_ex が扱えないため)。
  #--------------------------------------------------------------------------
  def set_text(window, position)
    self.bitmap.clear
    # 横グラデーション
    if @@grad_cache && !@@grad_cache.disposed?
      self.bitmap.blt(0, 0, @@grad_cache, self.bitmap.rect)
    else
      color = LNX11::STORAGE_GRADIENT_COLOR
      fillrect = self.bitmap.rect
      fillrect.width /= 2
      self.bitmap.gradient_fill_rect(fillrect, color[0], color[1])
      @@grad_cache = self.bitmap.clone
    end
    # contents からコピー
    self.bitmap.blt(4, 0, window.contents, self.bitmap.rect)
    self.opacity = 1
    @rx = -8
    @position = position
    @ry = target_y
  end
  #--------------------------------------------------------------------------
  # ● 位置の繰り上げ
  #--------------------------------------------------------------------------
  def up_position
    @position -= 1
  end
  #--------------------------------------------------------------------------
  # ● メッセージが空か？(表示待ち)
  #--------------------------------------------------------------------------
  def mes_empty?
    @position < 0
  end
  #--------------------------------------------------------------------------
  # ● 移動するべき Y 座標
  #--------------------------------------------------------------------------
  def target_y
    @position * @line_height
  end
end

#==============================================================================
# ■ Window_BattleLog
#------------------------------------------------------------------------------
# 　戦闘の進行を実況表示するウィンドウです。
#==============================================================================

class Window_BattleLog < Window_Selectable
  #--------------------------------------------------------------------------
  # ● [エイリアス]:オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :lnx11a_initialize :initialize
  def initialize
    lnx11a_initialize
    # バトルログタイプが 1 以上なら非表示にする
    @storage_number = 0
    hide if LNX11::BATTLELOG_TYPE >= 1
    BattleManager.log_window = self
  end
  #--------------------------------------------------------------------------
  # ● [追加]:文章の配列のクリア
  #--------------------------------------------------------------------------
  def lines_clear
    @lines.clear if LNX11::BATTLELOG_TYPE == 1
  end
  #--------------------------------------------------------------------------
  # ● [追加]:指定ウェイト
  #--------------------------------------------------------------------------
  def abs_wait(wait)
    @method_wait.call(wait) if @method_wait
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:メッセージ速度の取得
  #--------------------------------------------------------------------------
  def message_speed
    return 20
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:エフェクト実行が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_effect
    return if LNX11::BATTLELOG_TYPE > 0
    @method_wait_for_effect.call if @method_wait_for_effect
  end
  #--------------------------------------------------------------------------
  # ● [追加]:アニメーションのウェイト用メソッドの設定
  #--------------------------------------------------------------------------
  def method_wait_for_animation=(method)
    @method_wait_for_animation = method
  end
  #--------------------------------------------------------------------------
  # ● [追加]:アニメーション再生が終わるまでウェイト
  #--------------------------------------------------------------------------
  def wait_for_animation
    @method_wait_for_animation.call if @method_wait_for_animation
  end
  
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ウィンドウ高さの取得
  #--------------------------------------------------------------------------
  alias :lnx11a_window_height :window_height
  def window_height
    LNX11::BATTLELOG_TYPE == 1 ? fitting_height(1) : lnx11a_window_height
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:最大行数の取得
  #--------------------------------------------------------------------------
  alias :lnx11a_max_line_number :max_line_number
  def max_line_number
    num = LNX11::STORAGE_LINE_NUMBER
    LNX11::BATTLELOG_TYPE == 1 ? num : lnx11a_max_line_number
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:行の高さを取得
  #--------------------------------------------------------------------------
  def line_height
    LNX11::BATTLELOG_TYPE == 1 ? LNX11::STORAGE_LINE_HEIGHT : super
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:フォント設定のリセット
  #--------------------------------------------------------------------------
  def reset_font_settings
    super
    return unless LNX11::BATTLELOG_TYPE == 1
    contents.font.size = LNX11::STORAGE_FONT[:size]
    contents.font.out_color.set(LNX11::STORAGE_FONT[:out_color])
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:データ行数の取得
  #--------------------------------------------------------------------------
  alias :lnx11a_line_number :line_number
  def line_number
    return 0 if LNX11::BATTLELOG_TYPE == 2
    LNX11::BATTLELOG_TYPE == 1 ? @storage_number : lnx11a_line_number
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:背景スプライトの作成
  #--------------------------------------------------------------------------
  alias :lnx11a_create_back_sprite :create_back_sprite 
  def create_back_sprite
    if LNX11::BATTLELOG_TYPE == 1
      # 蓄積型
      create_message_sprite
    else
      # 背景
      lnx11a_create_back_sprite
    end
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:背景スプライトの解放
  #--------------------------------------------------------------------------
  alias :lnx11a_dispose_back_sprite :dispose_back_sprite
  def dispose_back_sprite
    if LNX11::BATTLELOG_TYPE == 1
      # 蓄積型
      dispose_message_sprite
    else
      # 背景
      lnx11a_dispose_back_sprite
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メッセージスプライトの作成
  #--------------------------------------------------------------------------
  def create_message_sprite
    # メッセージスプライト 行数分だけ作成する
    @mes_position = 0 # 次にメッセージを表示させる位置
    @mesup_count = LNX11::STORAGE_UP_MESSAGE_TIME # ログが進行するまでの時間
    @mes_sprites = Array.new(max_line_number + 1) {
    Sprite_OneLine_BattleLog.new(self.width, line_height, max_line_number)}
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メッセージスプライトの解放
  #--------------------------------------------------------------------------
  def dispose_message_sprite
    @mes_sprites.each {|sprite| sprite.dispose }
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メッセージスプライトを表示
  #--------------------------------------------------------------------------
  def show_message_sprite
    @mes_sprites.each {|sprite| sprite.show }
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メッセージスプライトを非表示
  #--------------------------------------------------------------------------
  def hide_message_sprite
    @mes_sprites.each {|sprite| sprite.hide }
    @mes_position = 0
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メッセージスプライトを一つ進める
  #--------------------------------------------------------------------------
  def up_message_sprite
    @mes_sprites.each {|sprite| sprite.up_position }
  end
  #--------------------------------------------------------------------------
  # ● [追加]:空のメッセージスプライトを返す
  #--------------------------------------------------------------------------
  def empty_message_sprite
    @mes_sprites.each {|sprite| return sprite if sprite.mes_empty? }
    @mes_sprites[0]
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メッセージスプライトの更新
  #--------------------------------------------------------------------------
  def update_message_sprite
    # バトルログ消去フラグが有効
    if $game_temp.battlelog_clear
      $game_temp.battlelog_clear = false
      # スプライトが表示されていれば非表示にする
      if @mes_sprites[0].visible?
        hide_message_sprite
        lines_clear
      end
    end
    # ログの自動進行
    @mesup_count -= 1
    if @mesup_count <= 0 && @mes_position > 0
      up_message_sprite
      @mes_position -= 1
      @mesup_count = LNX11::STORAGE_UP_MESSAGE_TIME
    end
    @mes_sprites.each {|sprite| sprite.update }
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メッセージスプライトのリフレッシュ
  #--------------------------------------------------------------------------
  def refresh_message_sprite
    # 文章が無ければ何もしない
    return if @lines.empty? 
    # スプライトを表示する
    show_message_sprite unless @mes_sprites[0].visible? 
    # 文章の描画
    contents.clear
    @lines[0] = last_text
    return if @lines[0].empty? 
    draw_line(0)
    @storage_number += 1
    # ウィンドウの内容をスプライトにコピー
    empty_message_sprite.set_text(self, @mes_position)
    # スプライト位置の変動    
    if @mes_position < max_line_number
      @mes_position += 1
    elsif @mesup_count > 0
      up_message_sprite
    end
    @mesup_count = (LNX11::STORAGE_UP_MESSAGE_TIME * 1.5).truncate
  end  
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_message_sprite if LNX11::BATTLELOG_TYPE == 1
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:リフレッシュ
  #--------------------------------------------------------------------------
  alias :lnx11a_refresh :refresh
  def refresh
    return if LNX11::BATTLELOG_TYPE == 2
    LNX11::BATTLELOG_TYPE == 1 ? refresh_message_sprite : lnx11a_refresh
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:クリア
  #--------------------------------------------------------------------------
  alias :lnx11a_clear :clear
  def clear
    return if LNX11::BATTLELOG_TYPE == 2
    LNX11::BATTLELOG_TYPE == 1 ? @storage_number = 0 : lnx11a_clear
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:一行戻る
  #--------------------------------------------------------------------------
  alias :lnx11a_back_one :back_one
  def back_one
    if LNX11::BATTLELOG_TYPE == 1
      # 蓄積型
      @storage_number = [@storage_number - 1, 0].max
    else
      # 通常
      lnx11a_back_one
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:指定した行に戻る
  #--------------------------------------------------------------------------
  alias :lnx11a_back_to :back_to
  def back_to(line_number)
    if LNX11::BATTLELOG_TYPE == 1
      # 蓄積型
      @storage_number -= 1 while @storage_number > line_number
    else
      # 通常
      lnx11a_back_to(line_number)
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ウェイト
  #--------------------------------------------------------------------------
  alias :lnx11a_wait :wait
  def wait
    return if LNX11::BATTLELOG_TYPE == 2
    # 元のメソッドを呼ぶ
    lnx11a_wait
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:スキル／アイテム使用の表示
  # 　使用時アニメーションの処理を追加します。
  #--------------------------------------------------------------------------
  alias :lnx11a_display_use_item :display_use_item
  def display_use_item(subject, item)
    if item.use_animation > 0
      # 使用時アニメーションが設定されていれば再生
      subject.animation_id = item.use_animation
      subject.animation_mirror = false
    end
    # 元のメソッドを呼ぶ
    lnx11a_display_use_item(subject, item)
    # アニメーションのウェイト
    wait_for_animation if item.use_animation > 0
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップデータの取得
  #--------------------------------------------------------------------------
  def popup_data
    $game_temp.popup_data
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:反撃の表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_counter :display_counter
  def display_counter(target, item)
    # ポップアップ
    popup_data.popup_text(target, :counter)
    # 元のメソッドを呼ぶ
    lnx11a_display_counter(target, item)
    # ポップアップウェイト
    popup_data.add_wait
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:反射の表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_reflection :display_reflection
  def display_reflection(target, item)
    # ポップアップ
    popup_data.popup_text(target, :reflection)
    # 元のメソッドを呼ぶ
    lnx11a_display_reflection(target, item)
    # ポップアップウェイト
    popup_data.add_wait
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:身代わりの表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_substitute :display_substitute
  def display_substitute(substitute, target)
    # ポップアップ
    popup_data.popup_text(substitute, :substitute)
    # 元のメソッドを呼ぶ
    lnx11a_display_substitute(substitute, target)
    # ポップアップウェイト
    popup_data.add_wait
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:失敗の表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_failure :display_failure
  def display_failure(target, item)
    if target.result.hit? && !target.result.success
      # ポップアップ (ミスと同じ扱いにする)
      popup_data.popup_miss(target, item)
    end
    # 元のメソッドを呼ぶ
    lnx11a_display_failure(target, item)
    # ポップアップウェイト
    popup_data.add_wait
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ミスの表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_miss :display_miss
  def display_miss(target, item)
    # ポップアップ
    popup_data.popup_miss(target, item)
    # 元のメソッドを呼ぶ    
    lnx11a_display_miss(target, item)
    # ポップアップウェイト
    popup_data.add_wait
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:回避の表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_evasion :display_evasion
  def display_evasion(target, item)
    # ポップアップ (ミスと同じ扱いにする)
    popup_data.popup_miss(target, item)
    # 元のメソッドを呼ぶ    
    lnx11a_display_evasion(target, item)
    # ポップアップウェイト
    popup_data.add_wait
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:HP ダメージ表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_hp_damage :display_hp_damage
  def display_hp_damage(target, item)
    # ポップアップ
    popup_data.popup_hp_damage(target, item)
    # 元のメソッドを呼ぶ
    lnx11a_display_hp_damage(target, item)
    # ポップアップウェイト
    popup_data.add_wait
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:MP ダメージ表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_mp_damage :display_mp_damage
  def display_mp_damage(target, item)
    # ポップアップ
    popup_data.popup_mp_damage(target, item)
    # 元のメソッドを呼ぶ
    lnx11a_display_mp_damage(target, item)
    # ポップアップウェイト
    popup_data.add_wait
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:TP ダメージ表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_tp_damage :display_tp_damage
  def display_tp_damage(target, item)
    # ポップアップ
    popup_data.popup_tp_damage(target, item)
    # 元のメソッドを呼ぶ
    lnx11a_display_tp_damage(target, item)
    # ポップアップウェイト
    popup_data.add_wait
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ステート付加の表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_added_states :display_added_states
  def display_added_states(target)
    # ポップアップ
    popup_data.popup_added_states(target)
    # 元のメソッドを呼ぶ
    lnx11a_display_added_states(target)
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ステート解除の表示
  #--------------------------------------------------------------------------
  alias :lnx11a_display_removed_states :display_removed_states
  def display_removed_states(target)
    # ポップアップ
    popup_data.popup_removed_states(target)
    # 元のメソッドを呼ぶ
    lnx11a_display_removed_states(target)
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:能力強化／弱体の表示（個別）
  #--------------------------------------------------------------------------
  alias :lnx11a_display_buffs :display_buffs
  def display_buffs(target, buffs, fmt)
    # ポップアップ
    popup_data.popup_buffs(target, buffs, fmt)
    # 元のメソッドを呼ぶ
    lnx11a_display_buffs(target, buffs, fmt)
  end
end

#==============================================================================
# ■ RPG::BaseItem
#------------------------------------------------------------------------------
# 　アクター、職業、スキル、アイテム、武器、防具、敵キャラ、およびステートの
# スーパークラス。
#==============================================================================

class RPG::BaseItem  
  #--------------------------------------------------------------------------
  # ● [追加]:バトラーグラフィックファイル名を取得
  #--------------------------------------------------------------------------
  def default_battler_graphic
    # キャッシュがある場合、それを返す
    return @default_battler_graphic if @default_battler_graphic
    # メモ取得
    re = LNX11::RE_BATTLER =~ note
    @default_battler_graphic = re ? $1 : ""
  end
  #--------------------------------------------------------------------------
  # ● [追加]:敵キャラの通常攻撃アニメの取得
  #--------------------------------------------------------------------------
  def atk_animation
    # キャッシュがある場合、それを返す
    return @atk_animation if @atk_animation
    # メモ取得
    re = LNX11::RE_ATK_ANIMATION =~ note
    @atk_animation = re ? $1.to_i : 1
  end
end

#==============================================================================
# ■ RPG::UsableItem
#------------------------------------------------------------------------------
# 　スキルとアイテムのスーパークラス。
#==============================================================================
class RPG::UsableItem < RPG::BaseItem
  #--------------------------------------------------------------------------
  # ● [エイリアス]:対象の選択操作が必要か否かを取得
  #--------------------------------------------------------------------------
  alias :lnx11a_need_selection? :need_selection?
  def need_selection?
    LNX11::FIX_TARGET_CHECKE && scope > 0 ? true : lnx11a_need_selection?
  end
  #--------------------------------------------------------------------------
  # ● [追加]:使用時アニメの取得
  #--------------------------------------------------------------------------
  def use_animation
    # キャッシュがある場合、それを返す
    return @use_animation if @use_animation
    # メモ取得
    re = LNX11::RE_USE_ANIMATION =~ note
    @use_animation = re ? $1.to_i : 0
  end
  #--------------------------------------------------------------------------
  # ● [追加]:簡易ヘルプ非表示の取得
  #--------------------------------------------------------------------------
  def no_display
    # キャッシュがある場合、それを返す
    return @no_display if @no_display
    # メモ取得
    re = LNX11::RE_USABLEITEM_NO_DISPLAY =~ note
    @no_display = re ? true : false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:使用時追加ウェイトの取得
  #--------------------------------------------------------------------------
  def display_wait
    # キャッシュがある場合、それを返す
    return @display_wait if @display_wait
    # メモ取得
    re = LNX11::RE_DISPLAY_WAIT =~ note
    @display_wait = re ? $1.to_i : LNX11::HELPDISPLAT_WAIT
  end
  #--------------------------------------------------------------------------
  # ● [追加]:終了時追加ウェイトの取得
  #--------------------------------------------------------------------------
  def end_wait
    # キャッシュがある場合、それを返す
    return @end_wait if @end_wait
    # メモ取得
    re = LNX11::RE_END_WAIT =~ note
    @end_wait = re ? $1.to_i : LNX11::HELPDISPLAT_END_WAIT
  end
  #--------------------------------------------------------------------------
  # ● [追加]:簡易ヘルプ説明を取得
  #--------------------------------------------------------------------------
  def short_description
    # キャッシュがある場合、それを返す
    return @short_description if @short_description
    # メモ取得
    re = LNX11::RE_SHORT_DESCRIPTION =~ note
    @short_description = re ? $1 : ""
  end
end

#==============================================================================
# ■ RPG::State
#------------------------------------------------------------------------------
# 　ステートのデータクラス。
#==============================================================================

class RPG::State < RPG::BaseItem
  #--------------------------------------------------------------------------
  # ● [追加]:ステートアニメの取得
  #--------------------------------------------------------------------------
  def state_animation
    # キャッシュがある場合、それを返す
    return @state_animation if @state_animation
    # メモ取得
    re = LNX11::RE_STATE_ANIMATION =~ note
    @state_animation = re ? $1.to_i : 0
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップ表示名の取得
  # <<ver1.10>>
  # 　このメソッドは付加/解除ポップアップ表示名が設定されていない場合のみ
  # 呼び出されるようになりました。
  #--------------------------------------------------------------------------
  def display_name
    # キャッシュがある場合、それを返す
    return @display_name if @display_name
    # メモ取得
    re = LNX11::RE_STATE_DISPLAY =~ note
    @display_name = re ? $1 : name
  end
  #--------------------------------------------------------------------------
  # ● [追加]:付加ポップアップ表示名の取得 <<ver1.10>>
  #--------------------------------------------------------------------------
  def add_display_name
    # キャッシュがある場合、それを返す
    return @add_display_name if @add_display_name
    # メモ取得
    re = LNX11::RE_STATE_ADD_DISPLAY =~ note
    @add_display_name = re ? $1 : display_name
  end
  #--------------------------------------------------------------------------
  # ● [追加]:解除ポップアップ表示名の取得 <<ver1.10>>
  #--------------------------------------------------------------------------
  def remove_display_name
    # キャッシュがある場合、それを返す
    return @remove_display_name if @remove_display_name
    # メモ取得
    re = LNX11::RE_STATE_REM_DISPLAY =~ note
    @remove_display_name = re ? $1 : display_name
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップ非表示の取得
  #--------------------------------------------------------------------------
  def no_display?
    # キャッシュがある場合、それを返す
    return @no_display if @no_display
    # 付加/解除のどちらかで設定されていれば無視する
    if LNX11::RE_STATE_ADD_NO_DISPLAY =~ note ||
       LNX11::RE_STATE_REM_NO_DISPLAY =~ note
      return @no_display = false
    end
    # メモ取得
    re = LNX11::RE_STATE_NO_DISPLAY =~ note
    @no_display = re ? true : false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:付加ポップアップ非表示の取得
  #--------------------------------------------------------------------------
  def add_no_display?
    return true if no_display?
    # キャッシュがある場合、それを返す
    return @add_no_display if @add_no_display
    # メモ取得
    re = LNX11::RE_STATE_ADD_NO_DISPLAY =~ note
    @add_no_display = re ? true : false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:解除ポップアップ非表示の取得
  #--------------------------------------------------------------------------
  def remove_no_display?
    return true if no_display?
    # キャッシュがある場合、それを返す
    return @remove_no_display if @remove_no_display
    # メモ取得
    re = LNX11::RE_STATE_REM_NO_DISPLAY =~ note
    @remove_no_display = re ? true : false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:有利なステートの取得
  #--------------------------------------------------------------------------
  def advantage?
    # キャッシュがある場合、それを返す
    return @advantage if @advantage
    # メモ取得
    re = LNX11::RE_STATE_ADVANTAGE =~ note
    @advantage = re ? true : false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップタイプの取得
  #--------------------------------------------------------------------------
  def popup_type
    # キャッシュがある場合、それを返す
    return @popup_type if @popup_type != nil
    # 付加/解除のどちらかで設定されていれば無視する
    if LNX11::RE_STATE_ADD_TYPE =~ note ||
       LNX11::RE_STATE_REM_TYPE =~ note
      return @popup_type = false
    end
    # メモ取得
    re = LNX11::RE_STATE_TYPE =~ note
    @popup_type = re ? $1.to_i : false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:付加ポップアップタイプの取得
  #--------------------------------------------------------------------------
  def add_popup_type
    return popup_type if popup_type
    # キャッシュがある場合、それを返す
    return @add_popup_type if @add_popup_type != nil
    # メモ取得
    re = LNX11::RE_STATE_ADD_TYPE =~ note
    @add_popup_type = re ? $1.to_i : false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:解除ポップアップタイプの取得
  #--------------------------------------------------------------------------
  def remove_popup_type
    return popup_type if popup_type
    # キャッシュがある場合、それを返す
    return @remove_popup_type if @remove_popup_type != nil
    # メモ取得
    re = LNX11::RE_STATE_REM_TYPE =~ note
    @remove_popup_type = re ? $1.to_i : false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:修飾文字非表示の取得
  #--------------------------------------------------------------------------
  def no_decoration?
    # キャッシュがある場合、それを返す
    return @no_decoration if @no_decoration
    # 付加/解除のどちらかで設定されていれば無視する
    if LNX11::RE_STATE_ADD_NO_DECORATION =~ note ||
       LNX11::RE_STATE_REM_NO_DECORATION =~ note
      return @no_decoration = false
    end
    # メモ取得
    re = LNX11::RE_STATE_NO_DECORATION =~ note
    @no_decoration = re ? true : false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:付加修飾文字非表示の取得
  #--------------------------------------------------------------------------
  def add_no_decoration?
    return true if no_decoration?
    # キャッシュがある場合、それを返す
    return @add_no_decoration if @add_no_decoration
    # メモ取得
    re = LNX11::RE_STATE_ADD_NO_DECORATION =~ note
    @add_no_decoration = re ? true : false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:解除修飾文字非表示の取得
  #--------------------------------------------------------------------------
  def remove_no_decoration?
    return true if no_decoration?
    # キャッシュがある場合、それを返す
    return @remove_no_decoration if @remove_no_decoration
    # メモ取得
    re = LNX11::RE_STATE_REM_NO_DECORATION =~ note
    @remove_no_decoration = re ? true : false
  end
end

#==============================================================================
# ■ BattleManager
#------------------------------------------------------------------------------
# 　戦闘の進行を管理するモジュールです。
#==============================================================================

class << BattleManager
  #--------------------------------------------------------------------------
  # ● [追加]:公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :preemptive             # 先制攻撃フラグ
  attr_reader   :surprise               # 不意打ちフラグ
  attr_accessor :log_window             # バトルログウィンドウ
  attr_accessor :update_for_wait_method # ウェイト中のフレーム更新
  attr_accessor :helpdisplay_set_method        # 簡易ヘルプ表示
  attr_accessor :helpdisplay_clear_method      # 簡易ヘルプ消去
  attr_accessor :helpdisplay_wait_short_method # 簡易ヘルプ・短時間ウェイト
  #--------------------------------------------------------------------------
  # ● [追加]:簡易ヘルプ表示
  #--------------------------------------------------------------------------
  def helpdisplay_set(*args)
    @helpdisplay_set_method.call(*args) if @helpdisplay_set_method
  end
  #--------------------------------------------------------------------------
  # ● [追加]:簡易ヘルプ消去
  #--------------------------------------------------------------------------
  def helpdisplay_clear(*args)
    @helpdisplay_clear_method.call(*args) if @helpdisplay_clear_method
  end
  #--------------------------------------------------------------------------
  # ● [追加]:簡易ヘルプ・短時間ウェイト
  #--------------------------------------------------------------------------
  def helpdisplay_wait_short
    @helpdisplay_wait_short_method.call if @helpdisplay_wait_short_method
  end 
  #--------------------------------------------------------------------------
  # ● [追加]:キー入力待ち
  #--------------------------------------------------------------------------
  def helpdisplay_wait_input
    return if $game_message.helpdisplay_texts.empty?
    return if LNX11::MESSAGE_TYPE == 0
    return if !@helpdisplay_wait_input || !@update_for_wait_method
    update_for_wait_method.call while !Input.press?(:B) && !Input.press?(:C)
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メッセージ進行の SE 再生
  #--------------------------------------------------------------------------
  def messagedisplay_se_play
    return if !@helpdisplay_se
    @helpdisplay_se.play  
    @helpdisplay_se = nil if @helpdisplay_se == LNX11::LEVELUP_SE
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メッセージ進行
  #--------------------------------------------------------------------------
  def process_messagedisplay(wait)
    return if $game_message.helpdisplay_texts.empty?
    return if LNX11::MESSAGE_TYPE == 0
    $game_temp.battlelog_clear = true
    BattleManager.log_window.update
    if LNX11::BATTLELOG_TYPE == 2 || LNX11::MESSAGE_TYPE == 2
      # 簡易ヘルプ
      $game_message.helpdisplay_texts.each do |text|
        helpdisplay_wait_short
        messagedisplay_se_play
        helpdisplay_set(text, wait)
        helpdisplay_wait_input
      end
      helpdisplay_clear
    elsif LNX11::BATTLELOG_TYPE == 0
      # VXAceデフォルト
      BattleManager.log_window.clear
      $game_message.helpdisplay_texts.each do |text|
        messagedisplay_se_play
        BattleManager.log_window.add_text(text)
        BattleManager.log_window.abs_wait(wait)
        helpdisplay_wait_input
        max = BattleManager.log_window.max_line_number
        # 表示がいっぱいになったら消去
        if BattleManager.log_window.line_number >= max
          BattleManager.log_window.clear
        end
      end
      BattleManager.log_window.clear
    elsif LNX11::BATTLELOG_TYPE == 1
      # 蓄積型
      $game_message.helpdisplay_texts.each do |text|
        messagedisplay_se_play
        BattleManager.log_window.add_text(text)
        BattleManager.log_window.abs_wait(wait)
        helpdisplay_wait_input
      end
      $game_temp.battlelog_clear = true
      BattleManager.log_window.update
    end
    $game_message.helpdisplay_texts.clear
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:メッセージ表示が終わるまでウェイト
  #--------------------------------------------------------------------------
  alias :lnx11a_wait_for_message :wait_for_message
  def wait_for_message
    # 簡易ヘルプ表示
    process_messagedisplay(@helpdisplay_wait ? @helpdisplay_wait : 60)
    return if $game_message.texts.empty?
    # 元のメソッドを呼ぶ
    lnx11a_wait_for_message
  end  
  #--------------------------------------------------------------------------
  # ● [エイリアス]:戦闘開始
  #--------------------------------------------------------------------------
  alias :lnx11a_battle_start :battle_start
  def battle_start    
    @helpdisplay_wait = LNX11::MESSAGE_WAIT[:battle_start][0]
    @helpdisplay_wait_input = LNX11::MESSAGE_WAIT[:battle_start][1]
    # メッセージウィンドウへのテキスト追加を禁止する
    $game_message.add_disabled
    # 元のメソッドを呼ぶ
    lnx11a_battle_start
    # メッセージウィンドウへのテキスト追加を許可する
    $game_message.add_enabled
    @helpdisplay_wait = nil
    @helpdisplay_wait_input = nil
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:勝利の処理
  #--------------------------------------------------------------------------
  alias :lnx11a_process_victory :process_victory
  def process_victory
    @helpdisplay_wait = LNX11::MESSAGE_WAIT[:victory][0]
    @helpdisplay_wait_input = LNX11::MESSAGE_WAIT[:victory][1]
    # メッセージウィンドウへのテキスト追加を禁止する
    $game_message.add_disabled
    # 元のメソッドを呼ぶ
    success = lnx11a_process_victory
    # メッセージウィンドウへのテキスト追加を許可する
    $game_message.add_enabled
    @helpdisplay_wait = nil
    @helpdisplay_wait_input = nil
    return success
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:逃走の処理
  #--------------------------------------------------------------------------
  alias :lnx11a_process_escape :process_escape
  def process_escape
    @helpdisplay_wait = LNX11::MESSAGE_WAIT[:escape][0]
    @helpdisplay_wait_input = LNX11::MESSAGE_WAIT[:escape][1]
    # メッセージウィンドウへのテキスト追加を禁止する
    $game_message.add_disabled
    # 元のメソッドを呼ぶ
    success = lnx11a_process_escape
    # メッセージウィンドウへのテキスト追加を許可する
    $game_message.add_enabled
    @helpdisplay_wait = nil
    @helpdisplay_wait_input = nil
    return success
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:敗北の処理
  #--------------------------------------------------------------------------
  alias :lnx11a_process_defeat :process_defeat
  def process_defeat
    @helpdisplay_wait = LNX11::MESSAGE_WAIT[:defeat][0]
    @helpdisplay_wait_input = LNX11::MESSAGE_WAIT[:defeat][1]
    # メッセージウィンドウへのテキスト追加を禁止する
    $game_message.add_disabled
    # 元のメソッドを呼ぶ
    success = lnx11a_process_defeat
    # メッセージウィンドウへのテキスト追加を許可する
    $game_message.add_enabled
    @helpdisplay_wait = nil
    @helpdisplay_wait_input = nil
    return success
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ドロップアイテムの獲得と表示
  #--------------------------------------------------------------------------
  alias :lnx11a_gain_drop_items :gain_drop_items
  def gain_drop_items
    helpdisplay_clear
    @helpdisplay_wait = LNX11::MESSAGE_WAIT[:drop_item][0]
    @helpdisplay_wait_input = LNX11::MESSAGE_WAIT[:drop_item][1]
    @helpdisplay_se = LNX11::DROPITEM_SE
    # 元のメソッドを呼ぶ
    lnx11a_gain_drop_items
    @helpdisplay_wait = nil
    @helpdisplay_wait_input = nil
    @helpdisplay_se = nil
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:経験値の獲得とレベルアップの表示
  #--------------------------------------------------------------------------
  def gain_exp
    @helpdisplay_wait = LNX11::MESSAGE_WAIT[:levelup][0]
    @helpdisplay_wait_input = LNX11::MESSAGE_WAIT[:levelup][1]
    $game_party.all_members.each do |actor|
      @helpdisplay_se = LNX11::LEVELUP_SE
      actor.gain_exp($game_troop.exp_total)
      # レベルアップ毎にメッセージ表示ウェイト
      wait_for_message
    end
    @helpdisplay_wait = nil
    @helpdisplay_wait_input = nil
    @helpdisplay_se = nil
  end
end

#==============================================================================
# ■ Game_Temp
#------------------------------------------------------------------------------
# 　セーブデータに含まれない、一時的なデータを扱うクラスです。このクラスのイン
# スタンスは $game_temp で参照されます。
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # ● [追加]:公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :popup_data            # ポップアップスプライト
  attr_accessor :actor_battler_graphic # アクターのバトラーグラフィック
  attr_accessor :battlelog_clear       # バトルログ消去フラグ
  attr_accessor :target_cursor_sprite  # ターゲットカーソルスプライト
  attr_accessor :last_target_cursor    # 対象選択のカーソル記憶
  #--------------------------------------------------------------------------
  # ● [エイリアス]:オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :lnx11a_initialize :initialize
  def initialize
    # 元のメソッドを呼ぶ
    lnx11a_initialize
    # 追加
    @popup_data = nil
    @actor_battler_graphic = []
    @battlelog_clear = false
    @battle_status_refresh = nil
    @target_cursor_sprite = nil
    clear_last_target_cursor
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトルステータス更新メソッドの設定
  #--------------------------------------------------------------------------
  def method_battle_status_refresh=(method)
    @battle_status_refresh = method
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトルステータス更新
  #--------------------------------------------------------------------------
  def battle_status_refresh
    return unless $game_party.in_battle
    @battle_status_refresh.call if @battle_status_refresh
  end
  #--------------------------------------------------------------------------
  # ● [追加]:対象選択のカーソル記憶をクリア
  #--------------------------------------------------------------------------
  def clear_last_target_cursor
    @last_target_cursor = {:actor => nil, :enemy => nil}
  end
end

#==============================================================================
# ■ Game_Action
#------------------------------------------------------------------------------
# 　戦闘行動を扱うクラスです。
#==============================================================================

class Game_Action
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ターゲットの配列作成
  #--------------------------------------------------------------------------
  alias :lnx11a_make_targets :make_targets
  def make_targets    
    if LNX11::TROOP_X_SORT
      # 元のメソッドを呼んでソート
      return lnx11a_make_targets.sort {|a,b| a.screen_x <=> b.screen_x}
    else
      return lnx11a_make_targets
    end
  end
end

#==============================================================================
# ■ Game_ActionResult
#------------------------------------------------------------------------------
# 　戦闘行動の結果を扱うクラスです。属性に関する結果を追加します。
#==============================================================================

class Game_ActionResult
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :element_rate               # 属性修正値
  #--------------------------------------------------------------------------
  # ● ダメージ値のクリア
  #--------------------------------------------------------------------------
  alias :lnx11a_clear_damage_values :clear_damage_values
  def clear_damage_values
    # 元のメソッドを呼ぶ
    lnx11a_clear_damage_values
    # 属性修正値をクリア
    @element_rate = 1.0
  end
  #--------------------------------------------------------------------------
  # ● [追加]:属性修正値の取得
  #--------------------------------------------------------------------------
  def element_rate
    return @element_rate if @element_rate
    @element_rate = 1.0
  end
end

#==============================================================================
# ■ Game_BattlerBase
#------------------------------------------------------------------------------
# 　バトラーを扱う基本のクラスです。
#==============================================================================

class Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップデータの取得
  #--------------------------------------------------------------------------
  def popup_data
    $game_temp.popup_data
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:スキル使用コストの支払い
  #--------------------------------------------------------------------------
  alias :lnx11a_pay_skill_cost :pay_skill_cost
  def pay_skill_cost(skill)
    rmp = self.mp
    rtp = self.tp
    # 元のメソッドを呼ぶ    
    lnx11a_pay_skill_cost(skill)
    return unless $game_party.in_battle
    # ポップアップ
    popup_data.popup_regenerate_mp(self, (rmp - self.mp).truncate, true)
    popup_data.popup_regenerate_tp(self, (rtp - self.tp).truncate, true)
  end
end

#==============================================================================
# ■ Game_Battler
#------------------------------------------------------------------------------
# 　スプライトに関するメソッドを追加したバトラーのクラスです。
#==============================================================================

class Game_Battler < Game_BattlerBase
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :loop_animation_id     # ループアニメーション ID
  attr_accessor :loop_animation_mirror # ループアニメーション 左右反転フラグ
  #--------------------------------------------------------------------------
  # ● [エイリアス]:スプライトのエフェクトをクリア
  #--------------------------------------------------------------------------
  alias :lnx11a_clear_sprite_effects :clear_sprite_effects
  def clear_sprite_effects
    # 元のメソッドを呼ぶ
    lnx11a_clear_sprite_effects
    @loop_animation_id = 0
    @loop_animation_mirror = false
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:アニメーション ID の設定
  #--------------------------------------------------------------------------  
  def animation_id=(id)
    return unless battle_member?
    @animation_id = id
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ステートのループアニメーションの設定
  #--------------------------------------------------------------------------
  def set_state_animation
    # 表示優先度が高いステートを優先
    sort_states
    anime = @states.collect {|id| $data_states[id].state_animation }
    anime.delete(0)
    @loop_animation_id = anime[0] ? anime[0] : 0
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ステート情報をクリア
  #--------------------------------------------------------------------------
  alias :lnx11a_clear_states :clear_states
  def clear_states
    # 元のメソッドを呼ぶ
    lnx11a_clear_states
    # ステートアニメ設定
    set_state_animation
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ステートの付加
  #--------------------------------------------------------------------------
  alias :lnx11a_add_state :add_state
  def add_state(state_id)
    # 元のメソッドを呼ぶ
    lnx11a_add_state(state_id)
    # ステートアニメ設定
    set_state_animation
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ステートの解除
  #--------------------------------------------------------------------------
  alias :lnx11a_remove_state :remove_state
  def remove_state(state_id)
    # 元のメソッドを呼ぶ
    lnx11a_remove_state(state_id)
    # ステートアニメ設定
    set_state_animation
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップディレイの取得
  #--------------------------------------------------------------------------
  def popup_delay
    return @popup_delay if @popup_delay
    popup_delay_clear
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップディレイの設定
  #--------------------------------------------------------------------------
  def popup_delay=(delay)
    @popup_delay = delay
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップディレイの設定
  #--------------------------------------------------------------------------
  def popup_delay_clear
    @popup_delay = Array.new(16) { 0 }
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:スキル／アイテムの属性修正値を取得
  # 　弱点/耐性の判定を追加します。
  #--------------------------------------------------------------------------
  alias :lnx11a_item_element_rate :item_element_rate
  def item_element_rate(user, item)
    # 元のメソッドを呼ぶ
    rate = lnx11a_item_element_rate(user, item)
    return rate unless $game_party.in_battle
    # レートを結果に保存する
    @result.element_rate = rate
    rate
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ダメージの処理
  # 　吸収による回復のポップアップを生成します。
  #--------------------------------------------------------------------------
  alias :lnx11a_execute_damage :execute_damage
  def execute_damage(user)
    # 元のメソッドを呼ぶ
    lnx11a_execute_damage(user)
    return unless $game_party.in_battle
    # ポップアップ
    popup_data.popup_hp_drain(user, @result.hp_drain)
    popup_data.popup_mp_drain(user, @result.mp_drain)
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:HP の再生
  #--------------------------------------------------------------------------
  alias :lnx11a_regenerate_hp :regenerate_hp
  def regenerate_hp
    # 元のメソッドを呼ぶ
    lnx11a_regenerate_hp
    return unless $game_party.in_battle
    # ポップアップ
    popup_data.popup_regenerate_hp(self, @result.hp_damage)
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:MP の再生
  #--------------------------------------------------------------------------
  alias :lnx11a_regenerate_mp :regenerate_mp
  def regenerate_mp
    # 元のメソッドを呼ぶ
    lnx11a_regenerate_mp
    return unless $game_party.in_battle
    # ポップアップ
    popup_data.popup_regenerate_mp(self, @result.mp_damage)
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:TP の再生
  #--------------------------------------------------------------------------
  alias :lnx11a_regenerate_tp :regenerate_tp
  def regenerate_tp
    rtp = self.tp.to_i
    # 元のメソッドを呼ぶ
    lnx11a_regenerate_tp
    return unless $game_party.in_battle
    # ポップアップ
    popup_data.popup_regenerate_tp(self, rtp - self.tp.to_i)
  end
  #--------------------------------------------------------------------------
  # ● 被ダメージによる TP チャージ
  #--------------------------------------------------------------------------
  alias :lnx11a_charge_tp_by_damage :charge_tp_by_damage
  def charge_tp_by_damage(damage_rate)
    rtp = self.tp.to_i
    # 元のメソッドを呼ぶ
    lnx11a_charge_tp_by_damage(damage_rate)
    return unless $game_party.in_battle
    # ポップアップ
    popup_data.popup_tp_charge(self, rtp - self.tp.to_i)
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:スキル／アイテムの使用者側への効果(TP 得)
  #--------------------------------------------------------------------------
  alias :lnx11a_item_user_effect :item_user_effect
  def item_user_effect(user, item)
    rtp = user.tp.to_i
    # 元のメソッドを呼ぶ
    lnx11a_item_user_effect(user, item)
    return unless $game_party.in_battle
    # ポップアップ
    popup_data.popup_tp_gain(user, rtp - user.tp.to_i)
  end
  #--------------------------------------------------------------------------
  # ● [追加]:高さの取得
  #--------------------------------------------------------------------------
  def bitmap_height
    return @bitmap_height if @bitmap_height
    @bitmap_height = 0
  end 
  #--------------------------------------------------------------------------
  # ● [追加]:高さの設定
  #--------------------------------------------------------------------------
  def bitmap_height=(y)
    @bitmap_height = y
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトル画面 Y 座標(頭上)の取得
  #--------------------------------------------------------------------------
  def screen_y_top
    screen_y - @bitmap_height
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトル画面 Y 座標(中心)の取得
  #--------------------------------------------------------------------------
  def screen_y_center
    screen_y - @bitmap_height / 2
  end
end

#==============================================================================
# ■ Game_Actor
#------------------------------------------------------------------------------
# 　アクターを扱うクラスです。このクラスは Game_Actors クラス（$game_actors）
# の内部で使用され、Game_Party クラス（$game_party）からも参照されます。
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # ● [追加]:公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :battler_graphic_name    # 後指定のバトラーグラフィック
  attr_accessor :refresh_battler_graphic # バトラーグラフィックの更新フラグ
  attr_accessor :screen_x                # バトル画面 X 座標
  attr_accessor :screen_y                # バトル画面 Y 座標
  attr_accessor :last_actor_command      # 最後に選択したコマンド
  #--------------------------------------------------------------------------
  # ● [再定義]:スプライトを使うか？
  #--------------------------------------------------------------------------
  def use_sprite?
    return true # 使う
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトル画面 Z 座標の取得
  #--------------------------------------------------------------------------
  def screen_z
    return $game_party.members_screen_z[0] if index == nil
    return $game_party.members_screen_z[index] # Game_EnemyのZ座標は100
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ダメージ効果の実行
  #--------------------------------------------------------------------------
  alias :lnx11a_perform_damage_effect :perform_damage_effect
  def perform_damage_effect
    # 元のメソッドを呼ぶ
    lnx11a_perform_damage_effect
    # シェイクを無効にしている場合、シェイクをクリア
    $game_troop.screen.clear_shake if LNX11::DISABLED_DAMAGE_SHAKE
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:コラプス効果の実行
  # 　アクターの[特徴>その他>消滅エフェクト]の設定を適用するようにします。
  # 　処理内容は Game_Enemy のものとほぼ同一です。
  #--------------------------------------------------------------------------
  def perform_collapse_effect
    if $game_party.in_battle
      case collapse_type
      when 0
        @sprite_effect_type = :collapse
        Sound.play_actor_collapse
      when 1
        @sprite_effect_type = :boss_collapse
        Sound.play_boss_collapse1
      when 2
        @sprite_effect_type = :instant_collapse
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:グラフィック設定の配列を返す
  #--------------------------------------------------------------------------
  def graphic_name_index
    case LNX11::DEFAULT_BATTLER_GRAPHIC
    when 0 ; [@face_name, @face_index]
    when 1 ; [@character_name, @character_index]
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:グラフィックの変更
  #--------------------------------------------------------------------------
  alias :lnx11a_set_graphic :set_graphic
  def set_graphic(*args)
    face = graphic_name_index
    # 元のメソッドを呼ぶ
    lnx11a_set_graphic(*args)
    @refresh_battler_graphic = (face != graphic_name_index)
  end
  #--------------------------------------------------------------------------
  # ● [追加]:デフォルトバトラーグラフィックの取得
  #--------------------------------------------------------------------------
  def facebattler
    $game_temp.actor_battler_graphic[id]
  end
  def facebattler=(bitmap)
    facebattler.dispose if facebattler && !facebattler.disposed?
    $game_temp.actor_battler_graphic[id] = bitmap
  end
  #--------------------------------------------------------------------------
  # ● [追加]:後指定のバトラーグラフィックファイル名の取得
  #--------------------------------------------------------------------------
  def battler_graphic_name
    return @battler_graphic_name if @battler_graphic_name != nil
    @battler_graphic_name = ""
  end 
  #--------------------------------------------------------------------------
  # ● [追加]:後指定のバトラーグラフィックファイル名の指定
  #--------------------------------------------------------------------------
  def battler_graphic_name=(filename)
    @battler_graphic_name = filename
    @refresh_battler_graphic = true
  end
  #--------------------------------------------------------------------------
  # ● [追加]:顔グラフィックを描画して返す
  # 　処理内容は Window_Base の draw_face に準じたものです。
  #--------------------------------------------------------------------------
  def draw_face(face_name, face_index, enabled = true)
    fw = 96
    fh = 96
    # ビットマップを作成して返す
    bitmap = Cache.face(face_name)
    rect = Rect.new(face_index % 4 * fw, face_index / 4 * fh, fw, fh)
    face = Bitmap.new(fw, fh)
    color = LNX11::DEFAULT_BG_COLOR
    face.gradient_fill_rect(face.rect, color[0], color[1], true) 
    face.blt(0, 0, bitmap, rect)
    bitmap.dispose
    face
  end
  #--------------------------------------------------------------------------
  # ● [追加]:歩行グラフィックを描画して返す
  # 　処理内容は Window_Base の draw_character に準じたものです。
  #--------------------------------------------------------------------------
  def draw_character(character_name, character_index)
    return unless character_name
    bitmap = Cache.character(character_name)
    sign = character_name[/^[\!\$]./]
    if sign && sign.include?('$')
      cw = bitmap.width / 3
      ch = bitmap.height / 4
    else
      cw = bitmap.width / 12
      ch = bitmap.height / 8
    end
    n = character_index
    src_rect = Rect.new((n%4*3+1)*cw, (n/4*4)*ch, cw, ch)
    character = Bitmap.new(cw, ch)
    color = LNX11::DEFAULT_BG_COLOR
    character.gradient_fill_rect(character.rect, color[0], color[1], true) 
    character.blt(0, 0, bitmap, src_rect)
    character
  end
  #--------------------------------------------------------------------------
  # ● [追加]:デフォルトバトラーグラフィック設定
  #--------------------------------------------------------------------------
  def default_battler_graphic
    case LNX11::DEFAULT_BATTLER_GRAPHIC
    when 0 # 顔グラフィック
      self.facebattler = draw_face(@face_name, @face_index)
    when 1 # 歩行グラフィック
      self.facebattler = draw_character(@character_name, @character_index)
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトラーグラフィックの更新
  # 　Sprite_Batter が利用するオブジェクトを更新します。
  #--------------------------------------------------------------------------
  def update_battler_graphic
    @battler_hue = 0
    if !battler_graphic_name.empty?
      # スクリプトで指定されている
      @battler_name = @battler_graphic_name
      dispose_facebattler
    elsif !actor.default_battler_graphic.empty?
      # メモで指定されている
      @battler_name = actor.default_battler_graphic
      dispose_facebattler
    else
      # 何も指定されていない
      @battler_name = ""
      default_battler_graphic
    end
    # 更新したので更新フラグを取り消す
    @refresh_battler_graphic = false
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトラー用顔グラフィックの解放
  #--------------------------------------------------------------------------
  def dispose_facebattler
    return if self.facebattler == nil
    self.facebattler.dispose
    self.facebattler = nil
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:レベルアップメッセージの表示
  #   レベルアップのポップアップを追加します。
  #--------------------------------------------------------------------------
  alias :lnx11a_display_level_up :display_level_up
  def display_level_up(new_skills)
    popup_data.popup_levelup(self) if $game_party.in_battle
    lnx11a_display_level_up(new_skills)
  end
end

#==============================================================================
# ■ Game_Enemy
#------------------------------------------------------------------------------
# 　敵キャラを扱うクラスです。
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● [追加]:バトルメンバー判定
  #--------------------------------------------------------------------------
  def battle_member?
    true
  end
  #--------------------------------------------------------------------------
  # ● [追加]:通常攻撃 アニメーション ID の取得
  #--------------------------------------------------------------------------
  def atk_animation
    # メモを参照
    enemy.atk_animation
  end
end

#==============================================================================
# ■ Game_Party
#------------------------------------------------------------------------------
# 　パーティを扱うクラスです。所持金やアイテムなどの情報が含まれます。このクラ
# スのインスタンスは $game_party で参照されます。
#==============================================================================

class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # ● [追加]:公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :actor_invisible     # アクター非表示
  attr_accessor :status_invisible    # バトルステータス非表示
  attr_accessor :actor_bg_invisible  # アクター背景非表示
  attr_accessor :last_party_command  # 最後に選択したパーティコマンド
  attr_accessor :members_screen_x          # バトルメンバー分のX座標配列
  attr_accessor :members_screen_x_nooffset # X:オフセットなし
  attr_accessor :members_screen_y          # バトルメンバー分のY座標配列
  attr_accessor :members_screen_z          # バトルメンバー分のZ座標配列
  #--------------------------------------------------------------------------
  # ● [追加]:バトルメンバーの座標設定
  #--------------------------------------------------------------------------
  def set_members_xyz
    return if members.size == 0
    # 座標をまとめて設定
    set_screen_x
    set_screen_y
    set_screen_z
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトルメンバーの座標設定
  #--------------------------------------------------------------------------
  def set_members_battle_graphic
    $game_party.battle_members.each {|actor| actor.update_battler_graphic}
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトル画面 X 座標の設定
  # 　ここで設定した座標は Game_Actor や ステータス表示等で利用されます。
  #--------------------------------------------------------------------------
  def set_screen_x
    @members_screen_x = []
    @members_screen_x_nooffset = []
    padding = LNX11::ACTOR_PADDING[:side]
    if LNX11::ACTOR_CENTERING
      # アクターのセンタリングが有効
      a_spacing = LNX11::ACTOR_SPACING_ADJUST
      padding += (max_battle_members - battle_members.size) * a_spacing
      width = (Graphics.width - padding * 2) / battle_members.size
    else
      # アクターのセンタリングが無効
      width = (Graphics.width - padding * 2) / max_battle_members
    end
    battle_members.each_with_index do |actor, i|
      offset = LNX11::ACTOR_OFFSET[:x]
      @members_screen_x_nooffset[i] = width * i + width / 2 + padding
      @members_screen_x[i] = @members_screen_x_nooffset[i] + offset
      actor.screen_x = @members_screen_x[i]
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトル画面 Y 座標の設定
  # 　ここで設定した座標は Game_Actor や ステータス表示等で利用されます。
  #--------------------------------------------------------------------------
  def set_screen_y
    offset = LNX11::ACTOR_OFFSET[:y]
    ay = Graphics.height - LNX11::ACTOR_PADDING[:bottom] + offset
    @members_screen_y = Array.new(max_battle_members) {ay}
    battle_members.each {|actor| actor.screen_y = ay}
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトル画面 Z 座標の設定
  #--------------------------------------------------------------------------
  def set_screen_z
    # 便宜上、XYと同じように配列を作成しておく
    az = LNX11::ACTOR_SCREEN_TONE ? 150 : -10
    @members_screen_z = Array.new(max_battle_members) {az}
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:戦闘開始処理
  #--------------------------------------------------------------------------
  def on_battle_start
    super
    # バトルステータスの更新
    $game_temp.battle_status_refresh
  end
end

#==============================================================================
# ■ Game_Troop
#------------------------------------------------------------------------------
# 　敵グループおよび戦闘に関するデータを扱うクラスです。
#==============================================================================

class Game_Troop < Game_Unit
  #--------------------------------------------------------------------------
  # ● [エイリアス]:セットアップ
  # 　敵グループの座標修正処理を追加します。
  #--------------------------------------------------------------------------
  alias :lnx11a_setup :setup
  def setup(*args)
    # 元のメソッドを呼ぶ
    lnx11a_setup(*args)
    # 敵グループの座標修正
    @enemies.each do |enemy|
      # X:解像度がデフォルトでない場合に位置を補正する
      if LNX11::TROOP_X_SCREEN_FIX
        enemy.screen_x *= Graphics.width.to_f / 544
        enemy.screen_x.truncate
      end
      enemy.screen_y += LNX11::TROOP_Y_OFFSET
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:敵キャラ名の配列取得
  #--------------------------------------------------------------------------
  alias :lnx11a_enemy_names :enemy_names
  def enemy_names
    LNX11::MESSAGE_WINDOW_ENEMY_NAMES ? lnx11a_enemy_names : []
  end
end

#==============================================================================
# ■ Game_Message
#------------------------------------------------------------------------------
# 　文章や選択肢などを表示するメッセージウィンドウの状態を扱うクラスです。
#==============================================================================

class Game_Message
  #--------------------------------------------------------------------------
  # ● [追加]:公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :helpdisplay_texts        # 簡易ヘルプ配列
  #--------------------------------------------------------------------------
  # ● [追加]:簡易ヘルプ配列の取得
  #--------------------------------------------------------------------------
  def helpdisplay_texts
    return @helpdisplay_texts if @helpdisplay_texts
    @helpdisplay_texts = []
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:クリア
  #--------------------------------------------------------------------------
  alias :lnx11a_clear :clear
  def clear
    # 元のメソッドを呼ぶ
    lnx11a_clear
    @helpdisplay_texts = []
    @add_disabled = false
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:テキストの追加
  #--------------------------------------------------------------------------
  alias :lnx11a_add :add
  def add(text)
    # テキストの追加が禁止されてる場合、簡易ヘルプ表示用の配列に追加する
    if @add_disabled
      @helpdisplay_texts = [] unless @helpdisplay_texts
      @helpdisplay_texts.push(text)
    else
      # 元のメソッドを呼ぶ
      lnx11a_add(text)
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:テキスト追加の禁止
  #--------------------------------------------------------------------------
  def add_disabled
    return if LNX11::MESSAGE_TYPE == 0
    @add_disabled = true
  end
  #--------------------------------------------------------------------------
  # ● [追加]:テキスト追加の禁止
  #--------------------------------------------------------------------------
  def add_enabled
    return if LNX11::MESSAGE_TYPE == 0
    @add_disabled = false
  end
end

#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# 　バトラー表示用のスプライトです。
#==============================================================================

class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● [追加]:ターゲットカーソルのバトラーの取得
  #--------------------------------------------------------------------------
  def cursor_battler
    $game_temp.target_cursor_sprite.battler
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ターゲットカーソルの点滅状態に対応したシンボルを返す
  #--------------------------------------------------------------------------
  def cursor_effect
    $game_temp.target_cursor_sprite.blink ? :target_whiten : :command_whiten
  end
  #--------------------------------------------------------------------------
  # ● [追加]:対象選択フラッシュの設定
  #--------------------------------------------------------------------------
  def setup_cursor_effect 
    if cursor_battler == @battler ||
       (cursor_battler == :party && @battler.actor?) ||
       ([:troop, :troop_random].include?(cursor_battler) && !@battler.actor?)
      if @effect_type == nil || @effect_type != cursor_effect
        start_effect(cursor_effect)
      end
    else
      # フラッシュエフェクト終了
      end_cursor_effect
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:対象選択フラッシュの終了
  #--------------------------------------------------------------------------
  def end_cursor_effect 
    if [:target_whiten, :command_whiten].include?(@effect_type)
      @effect_type = nil
      @effect_duration = 0
      revert_to_normal
    end
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:アニメーションスプライトの設定
  #--------------------------------------------------------------------------
  def animation_set_sprites(frame)
    o = self.opacity
    self.opacity = 255 if !@battler_visible || @effect_duration > 0
    # スーパークラスのメソッドを呼ぶ
    super(frame)
    self.opacity = o
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:アニメーションの原点設定
  #--------------------------------------------------------------------------
  def set_animation_origin
    # スーパークラスのメソッドを呼ぶ
    super
    # 画面アニメーションがアクターに再生されたら
    if @animation.position == 3 && @battler != nil && @battler.actor?
      # アニメーションのY座標を修正
      @ani_oy += LNX11::SCREEN_ANIMATION_OFFSET
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:転送元ビットマップの更新
  #--------------------------------------------------------------------------
  alias :lnx11a_update_bitmap :update_bitmap
  def update_bitmap
    if @battler.actor? && @battler.refresh_battler_graphic
      # バトラーグラフィックが変更されていれば更新する
      @battler.update_battler_graphic
    end
    if @battler.actor? && @battler.facebattler != nil
      # バトラー用顔グラフィックが作成されていれば、
      # それを Sprite の Bitmap とする
      new_bitmap = @battler.facebattler
      if bitmap != new_bitmap
        self.bitmap = new_bitmap
        init_visibility
      end
    else
      # 元のメソッドを呼ぶ
      lnx11a_update_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:新しいアニメーションの設定
  #--------------------------------------------------------------------------
  alias :lnx11a_setup_new_animation :setup_new_animation
  def setup_new_animation
    lnx11a_setup_new_animation
    # ループアニメーションの設定
    if @battler.loop_animation_id > 0 && (@loop_animation == nil ||
       @battler.loop_animation_id != @loop_animation.id)
      animation = $data_animations[@battler.loop_animation_id]
      mirror = @battler.loop_animation_mirror
      start_loop_animation(animation, mirror)
    elsif @battler.loop_animation_id == 0 && @loop_animation
      end_loop_animation
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:新しいエフェクトの設定
  #--------------------------------------------------------------------------
  alias :lnx11a_setup_new_effect :setup_new_effect
  def setup_new_effect
    # 元のメソッドを呼ぶ
    lnx11a_setup_new_effect
    # フラッシュエフェクト設定
    if @battler_visible && cursor_battler
      setup_cursor_effect
    else
      # フラッシュエフェクト終了
      end_cursor_effect
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:エフェクトの開始
  #--------------------------------------------------------------------------
  alias :lnx11a_start_effect :start_effect
  def start_effect(effect_type)
    # エフェクト開始の追加
    @effect_type = effect_type
    case @effect_type
    when :target_whiten
      @effect_duration = 40
      @battler_visible = true
    when :command_whiten
      @effect_duration = 80
      @battler_visible = true
    end
    # 元のメソッドを呼ぶ
    lnx11a_start_effect(effect_type)
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:エフェクトの更新
  #--------------------------------------------------------------------------
  alias :lnx11a_update_effect :update_effect
  def update_effect
    # エフェクト更新の追加
    if @effect_duration > 0
      @effect_duration -= 1
      case @effect_type
      when :target_whiten
        update_target_whiten
      when :command_whiten
        update_command_whiten
      end
      @effect_duration += 1
    end
    # 元のメソッドを呼ぶ
    lnx11a_update_effect
  end
  #--------------------------------------------------------------------------
  # ● [追加]:対象選択フラッシュエフェクトの更新
  #--------------------------------------------------------------------------
  def update_target_whiten
    alpha = @effect_duration < 20 ? @effect_duration : 40 - @effect_duration
    self.color.set(255, 255, 255, 0)
    self.color.alpha = (alpha + 1) * 2
  end
  #--------------------------------------------------------------------------
  # ● [追加]:コマンド選択フラッシュエフェクトの更新
  #--------------------------------------------------------------------------
  def update_command_whiten
    alpha = @effect_duration < 40 ? @effect_duration : 80 - @effect_duration
    self.color.set(255, 255, 255, 0)
    self.color.alpha = alpha * 2
  end
  #--------------------------------------------------------------------------
  # ● [追加]:高さの取得
  #--------------------------------------------------------------------------
  def bitmap_height
    self.bitmap.height
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:位置の更新
  #--------------------------------------------------------------------------
  alias :lnx11a_update_position :update_position
  def update_position
    # 元のメソッドを呼ぶ
    lnx11a_update_position
    # 高さを更新
    @battler.bitmap_height = bitmap_height
    # 可視状態を更新
    self.visible = !$game_party.actor_invisible if @battler.actor?
  end
  if LNX11::ENHANCED_WHITEN
    # 白フラッシュを強めにする
    #------------------------------------------------------------------------
    # ● [再定義]:白フラッシュエフェクトの更新
    #------------------------------------------------------------------------
    def update_whiten
      self.color.set(255, 255, 255, 0)
      self.color.alpha = 192 - (16 - @effect_duration) * 12
    end
  end
  #--------------------------------------------------------------------------
  # ● ループアニメーションの追加
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # ● [追加]:クラス変数
  #--------------------------------------------------------------------------
  @@loop_ani_checker = []
  @@loop_ani_spr_checker = []
  #--------------------------------------------------------------------------
  # ● [エイリアス]:オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :lnx11a_initialize :initialize
  def initialize(viewport, battler = nil)
    # 元のメソッドを呼ぶ
    lnx11a_initialize(viewport, battler)
    # ループアニメの残り時間
    @loop_ani_duration = 0
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:解放
  #--------------------------------------------------------------------------
  alias :lnx11a_dispose :dispose
  def dispose
    # 元のメソッドを呼ぶ
    lnx11a_dispose
    # ループアニメを解放
    dispose_loop_animation
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:フレーム更新
  #--------------------------------------------------------------------------
  alias :lnx11a_update :update
  def update
    # 元のメソッドを呼ぶ
    lnx11a_update
    update_loop_animation
    @@loop_ani_checker.clear
    @@loop_ani_spr_checker.clear
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ループアニメーション表示中判定
  #--------------------------------------------------------------------------
  def loop_animation?
    @loop_animation != nil
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ループアニメーションの開始
  #--------------------------------------------------------------------------
  def start_loop_animation(animation, mirror = false)
    dispose_loop_animation
    @loop_animation = animation
    if @loop_animation
      @loop_ani_mirror = mirror
      set_loop_animation_rate
      @loop_ani_duration = @loop_animation.frame_max * @loop_ani_rate + 1
      load_loop_animation_bitmap
      make_loop_animation_sprites
      set_loop_animation_origin
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ループアニメーションの速度を設定
  #--------------------------------------------------------------------------
  def set_loop_animation_rate
    if $lnx_include[:lnx09]
      # LNX09 を導入している
      default = LNX09::DEFAULT_BATTLE_SPEED_RATE
      if @loop_animation.speed_rate
        @loop_ani_rate = @loop_animation.speed_rate
      else
        @loop_ani_rate = default
      end
    else
      @loop_ani_rate = 4
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ループアニメーション グラフィックの読み込み
  #--------------------------------------------------------------------------
  def load_loop_animation_bitmap
    animation1_name = @loop_animation.animation1_name
    animation1_hue = @loop_animation.animation1_hue
    animation2_name = @loop_animation.animation2_name
    animation2_hue = @loop_animation.animation2_hue
    @loop_ani_bitmap1 = Cache.animation(animation1_name, animation1_hue)
    @loop_ani_bitmap2 = Cache.animation(animation2_name, animation2_hue)
    if @@_reference_count.include?(@loop_ani_bitmap1)
      @@_reference_count[@loop_ani_bitmap1] += 1
    else
      @@_reference_count[@loop_ani_bitmap1] = 1
    end
    if @@_reference_count.include?(@loop_ani_bitmap2)
      @@_reference_count[@loop_ani_bitmap2] += 1
    else
      @@_reference_count[@loop_ani_bitmap2] = 1
    end
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ループアニメーションスプライトの作成
  #--------------------------------------------------------------------------
  def make_loop_animation_sprites
    @loop_ani_sprites = []
    if @use_sprite && !@@loop_ani_spr_checker.include?(@loop_animation)
      16.times do
        sprite = ::Sprite.new(viewport)
        sprite.visible = false
        @loop_ani_sprites.push(sprite)
      end
      if @loop_animation.position == 3
        @@loop_ani_spr_checker.push(@loop_animation)
      end
    end
    @loop_ani_duplicated = @@loop_ani_checker.include?(@loop_animation)
    if !@loop_ani_duplicated && @loop_animation.position == 3
      @@loop_ani_checker.push(@loop_animation)
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ループアニメーションの原点設定
  #--------------------------------------------------------------------------
  def set_loop_animation_origin
    if @loop_animation.position == 3
      if viewport == nil
        @loop_ani_ox = Graphics.width / 2
        @loop_ani_oy = Graphics.height / 2
      else
        @loop_ani_ox = viewport.rect.width / 2
        @loop_ani_oy = viewport.rect.height / 2
      end
    else
      @loop_ani_ox = x - ox + width / 2
      @loop_ani_oy = y - oy + height / 2
      if @loop_animation.position == 0
        @loop_ani_oy -= height / 2
      elsif @loop_animation.position == 2
        @loop_ani_oy += height / 2
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ループアニメーションの解放
  #--------------------------------------------------------------------------
  def dispose_loop_animation
    if @loop_ani_bitmap1
      @@_reference_count[@loop_ani_bitmap1] -= 1
      if @@_reference_count[@loop_ani_bitmap1] == 0
        @loop_ani_bitmap1.dispose
      end
    end
    if @loop_ani_bitmap2
      @@_reference_count[@loop_ani_bitmap2] -= 1
      if @@_reference_count[@loop_ani_bitmap2] == 0
        @loop_ani_bitmap2.dispose
      end
    end
    if @loop_ani_sprites
      @loop_ani_sprites.each {|sprite| sprite.dispose }
      @loop_ani_sprites = nil
      @loop_animation = nil
    end
    @loop_ani_bitmap1 = nil
    @loop_ani_bitmap2 = nil
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ループアニメーションの更新
  #--------------------------------------------------------------------------
  def update_loop_animation
    return unless loop_animation?
    @loop_ani_duration -= 1
    if @loop_ani_duration % @loop_ani_rate == 0
      if @loop_ani_duration > 0
        frame_index = @loop_animation.frame_max
        speed = (@loop_ani_duration + @loop_ani_rate - 1) / @loop_ani_rate
        frame_index -= speed
        loop_animation_set_sprites(@loop_animation.frames[frame_index])
        @loop_animation.timings.each do |timing|
          loop_animation_process_timing(timing) if timing.frame == frame_index
        end
      else
        # 残り時間を再設定してループ
        @loop_ani_duration = @loop_animation.frame_max * @loop_ani_rate + 1
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ループアニメーションの終了
  #--------------------------------------------------------------------------
  def end_loop_animation
    dispose_loop_animation
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ループアニメーションスプライトの設定
  #     frame : フレームデータ（RPG::Animation::Frame）
  #--------------------------------------------------------------------------
  def loop_animation_set_sprites(frame)
    cell_data = frame.cell_data
    @loop_ani_sprites.each_with_index do |sprite, i|
      next unless sprite
      pattern = cell_data[i, 0]
      if !pattern || pattern < 0
        sprite.visible = false
        next
      end
      sprite.bitmap = pattern < 100 ? @loop_ani_bitmap1 : @loop_ani_bitmap2
      sprite.visible = true
      sprite.src_rect.set(pattern % 5 * 192,
        pattern % 100 / 5 * 192, 192, 192)
      if @loop_ani_mirror
        sprite.x = @loop_ani_ox - cell_data[i, 1]
        sprite.y = @loop_ani_oy + cell_data[i, 2]
        sprite.angle = (360 - cell_data[i, 4])
        sprite.mirror = (cell_data[i, 5] == 0)
      else
        sprite.x = @loop_ani_ox + cell_data[i, 1]
        sprite.y = @loop_ani_oy + cell_data[i, 2]
        sprite.angle = cell_data[i, 4]
        sprite.mirror = (cell_data[i, 5] == 1)
      end
      sprite.z = self.z + 316 + i 
      sprite.ox = 96
      sprite.oy = 96
      sprite.zoom_x = cell_data[i, 3] / 100.0
      sprite.zoom_y = cell_data[i, 3] / 100.0
      sprite.opacity = cell_data[i, 6] * self.opacity / 255.0
      sprite.blend_type = cell_data[i, 7]
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:SE とフラッシュのタイミング処理
  #     timing : タイミングデータ（RPG::Animation::Timing）
  #--------------------------------------------------------------------------
  def loop_animation_process_timing(timing)
    timing.se.play unless @loop_ani_duplicated
    case timing.flash_scope
    when 1
      self.flash(timing.flash_color, timing.flash_duration * @loop_ani_rate)
    when 2
      if viewport && !@loop_ani_duplicated
        duration = timing.flash_duration * @loop_ani_rate
        viewport.flash(timing.flash_color, duration)
      end
    when 3
      self.flash(nil, timing.flash_duration * @loop_ani_rate)
    end
  end
end

#==============================================================================
# ■ Spriteset_Battle
#------------------------------------------------------------------------------
# 　バトル画面のスプライトをまとめたクラスです。
#==============================================================================

class Spriteset_Battle
  #--------------------------------------------------------------------------
  # ● [エイリアス]:オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :lnx11a_initialize :initialize
  def initialize
    # 元のメソッドを呼ぶ
    lnx11a_initialize
    # アクターエリアの背景の作成
    create_actor_background
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:解放
  #--------------------------------------------------------------------------
  alias :lnx11a_dispose :dispose
  def dispose
    # 元のメソッドを呼ぶ
    lnx11a_dispose
    # アクターエリアの背景の解放
    dispose_actor_background
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:フレーム更新
  #--------------------------------------------------------------------------
  alias :lnx11a_update :update
  def update
    # 元のメソッドを呼ぶ
    lnx11a_update
    # アクターエリアの背景の更新
    update_actor_background
  end
  #--------------------------------------------------------------------------
  # ● [追加]:アクターのビューポート
  #--------------------------------------------------------------------------
  def actor_viewport
    LNX11::ACTOR_SCREEN_TONE ? @viewport1 : @viewport2
  end
  #--------------------------------------------------------------------------
  # ● [追加]:アクターエリアの背景の作成
  #--------------------------------------------------------------------------
  def create_actor_background
    return if LNX11::ACTOR_BACKGROUND == 0
    viewport = actor_viewport
    height = LNX11::ACTOR_BACKGROUND_HEIGHT
    case LNX11::ACTOR_BACKGROUND
    when 1
      # グラデーション
      @actor_background = Sprite.new
      back = Bitmap.new(Graphics.width, height)
      color = LNX11::ACTOR_BG_GRADIENT_COLOR
      back.gradient_fill_rect(back.rect, color[0], color[1], true) 
      @actor_background.bitmap = back
    when 2
      # ウィンドウ
      @actor_background = Window_Base.new(0, 0, Graphics.width, height)
    else
      if LNX11::ACTOR_BACKGROUND.is_a?(String)
        # ファイル指定
        @actor_background = Sprite.new
        @actor_background.bitmap = Cache.system(LNX11::ACTOR_BACKGROUND)
        @actor_background.x = Graphics.width / 2
        @actor_background.ox = @actor_background.bitmap.width / 2
        height = @actor_background.bitmap.height
      end
    end
    @actor_background.viewport = viewport
    @actor_background.y = Graphics.height - height
    @actor_background.z = viewport == @viewport1 ? 120 : -20
    update_actor_background
  end
  #--------------------------------------------------------------------------
  # ● [追加]:アクターエリアの背景の解放
  #--------------------------------------------------------------------------
  def dispose_actor_background
    return unless @actor_background
    @actor_background.bitmap.dispose if @actor_background.is_a?(Sprite)
    @actor_background.dispose
  end
  #--------------------------------------------------------------------------
  # ● [追加]:アクターエリアの背景の更新
  #--------------------------------------------------------------------------
  def update_actor_background
    return unless @actor_background
    @actor_background.visible = !$game_party.actor_bg_invisible
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:アクタースプライトの作成
  #--------------------------------------------------------------------------
  def create_actors
    # 座標とグラフィックの設定
    $game_party.set_members_xyz
    $game_party.set_members_battle_graphic
    # スプライトの作成
    viewport = actor_viewport
    @actor_sprites = $game_party.battle_members.collect do |actor|
      Sprite_Battler.new(viewport, actor)
    end
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:アクタースプライトの更新
  #--------------------------------------------------------------------------
  def update_actors
    @actor_sprites.each {|sprite| sprite.update }
  end
end

#==============================================================================
# ■ Scene_Battle
#------------------------------------------------------------------------------
# 　バトル画面の処理を行うクラスです。
#==============================================================================

class Scene_Battle < Scene_Base
  #--------------------------------------------------------------------------
  # ● [追加]:簡易ヘルプのメソッド設定
  #--------------------------------------------------------------------------
  def set_helpdisplay_methods
    BattleManager.update_for_wait_method = method(:update_for_wait)
    BattleManager.helpdisplay_set_method = method(:helpdisplay_set)
    BattleManager.helpdisplay_clear_method = method(:helpdisplay_clear)
    BattleManager.helpdisplay_wait_short_method=method(:helpdisplay_wait_short)
  end
  #--------------------------------------------------------------------------
  # ● [追加]:簡易ヘルプ表示
  #--------------------------------------------------------------------------
  def helpdisplay_set(item, duration = nil)
    @wait_short_disabled = false
    @targethelp_window.show.set_item(item)
    @targethelp_window.update
    wait(duration ? duration : 20)
  end
  #--------------------------------------------------------------------------
  # ● [追加]:簡易ヘルプ消去
  #--------------------------------------------------------------------------
  def helpdisplay_clear(duration = nil)
    return if !@targethelp_window.visible
    @wait_short_disabled = false
    @targethelp_window.clear
    @targethelp_window.hide
    wait(duration ? duration : 10)
  end
  #--------------------------------------------------------------------------
  # ● [追加]:簡易ヘルプ・短時間ウェイト
  #--------------------------------------------------------------------------
  def helpdisplay_wait_short
    return if !@targethelp_window.visible || @wait_short_disabled
    @wait_short_disabled = true # 連続で短時間ウェイトが実行されないように
    @targethelp_window.clear
    abs_wait_short
  end
  #--------------------------------------------------------------------------
  # ● [追加]:バトラーのエフェクト実行中？
  #--------------------------------------------------------------------------
  def battler_effect?
    @spriteset.effect?
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:コマンド［逃げる］
  #--------------------------------------------------------------------------
  alias :lnx11a_command_escape :command_escape
  def command_escape
    @party_command_window.close
    @party_command_window.openness = 0 if LNX11::MESSAGE_TYPE == 2
    @status_window.unselect
    # 元のメソッドを呼ぶ
    lnx11a_command_escape
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:スキル／アイテムの使用
  #--------------------------------------------------------------------------
  alias :lnx11a_use_item :use_item
  def use_item
    # 簡易ヘルプ表示
    item = @subject.current_action.item
    if LNX11::BATTLELOG_TYPE == 2 && !item.no_display
      helpdisplay_set(item, item.display_wait)
    end
    # 元のメソッドを呼ぶ
    lnx11a_use_item
    # 簡易ヘルプ消去・エフェクトが終わるまで待つ
    if LNX11::BATTLELOG_TYPE == 2
      wait(item.end_wait) 
      helpdisplay_clear
    end
    wait_for_effect
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:開始処理
  #--------------------------------------------------------------------------
  alias :lnx11a_start :start
  def start
    set_helpdisplay_methods
    @last_party_members = party_members
    $game_temp.method_battle_status_refresh = method(:refresh_status)
    $game_temp.clear_last_target_cursor
    $game_party.all_members.each {|actor| actor.last_actor_command = 0 }
    reset_sprite_effects
    standby_message_window_position
    create_targetcursor
    create_popup
    #元のメソッドを呼ぶ
    lnx11a_start
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:終了処理
  #--------------------------------------------------------------------------
  alias :lnx11a_terminate :terminate
  def terminate
    $game_message.clear
    dispose_targetcursor
    dispose_popup
    # 元のメソッドを呼ぶ
    lnx11a_terminate
  end
  #--------------------------------------------------------------------------
  # ● [追加]:アクターのスプライト情報の初期化
  #--------------------------------------------------------------------------
  def reset_sprite_effects
    $game_party.battle_members.each do |actor|
      actor.popup_delay_clear
      actor.set_state_animation
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:全ウィンドウの作成
  #--------------------------------------------------------------------------
  alias :lnx11a_create_all_windows :create_all_windows
  def create_all_windows
    # 元のメソッドを呼ぶ
    lnx11a_create_all_windows
    create_targethelp_window
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ステータスウィンドウの作成
  #--------------------------------------------------------------------------
  alias :lnx11a_create_status_window :create_status_window
  def create_status_window
    # 元のメソッドを呼ぶ
    lnx11a_create_status_window
    @status_window.set_xy
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:情報表示ビューポートの作成
  #--------------------------------------------------------------------------
  alias :lnx11a_create_info_viewport :create_info_viewport
  def create_info_viewport
    # 元のメソッドを呼ぶ
    lnx11a_create_info_viewport
    # ビューポートを修正
    @info_viewport.rect.y = Graphics.height - LNX11::ACTOR_BACKGROUND_HEIGHT
    @info_viewport.rect.height = LNX11::ACTOR_BACKGROUND_HEIGHT
    @status_window.viewport = nil
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:パーティコマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias :lnx11a_create_party_command_window :create_party_command_window
  def create_party_command_window
    # 元のメソッドを呼ぶ
    lnx11a_create_party_command_window
    @party_command_window.viewport = nil
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:アクターコマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias :lnx11a_create_actor_command_window :create_actor_command_window
  def create_actor_command_window
    # 元のメソッドを呼ぶ
    lnx11a_create_actor_command_window
    @actor_command_window.viewport = nil
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ログウィンドウの作成
  #--------------------------------------------------------------------------
  alias :lnx11a_create_log_window :create_log_window
  def create_log_window
    # 元のメソッドを呼ぶ
    lnx11a_create_log_window
    # ウェイトメソッド
    @log_window.method_wait_for_animation = method(:wait_for_animation)
  end  
  #--------------------------------------------------------------------------
  # ● [追加]:ターゲットカーソルの作成
  #--------------------------------------------------------------------------
  def create_targetcursor
    @targetcursor = Sprite_TargetCursor.new
    $game_temp.target_cursor_sprite = @targetcursor
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ターゲットカーソルの解放
  #--------------------------------------------------------------------------
  def dispose_targetcursor
    @targetcursor.dispose
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ターゲットヘルプウィンドウの作成
  #--------------------------------------------------------------------------
  def create_targethelp_window
    @targethelp_window = Window_TargetHelp.new
    @targethelp_window.visible = false
    # ターゲット選択ウィンドウに関連付ける
    @actor_window.help_window = @targethelp_window
    @enemy_window.help_window = @targethelp_window
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップの作成
  #--------------------------------------------------------------------------
  def create_popup
    $game_temp.popup_data = Popup_Data.new
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップの解放
  #--------------------------------------------------------------------------
  def dispose_popup
    $game_temp.popup_data.dispose
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップデータの取得
  #--------------------------------------------------------------------------
  def popup_data
    $game_temp.popup_data
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:フレーム更新（基本）
  #--------------------------------------------------------------------------
  alias :lnx11a_update_basic :update_basic
  def update_basic
    # 元のメソッドを呼ぶ
    lnx11a_update_basic
    # 追加したオブジェクトの更新
    update_targetcursor
    update_popup
    refresh_actors
  end
  #--------------------------------------------------------------------------
  # ● [追加]:パーティメンバーの ID 配列の取得
  #--------------------------------------------------------------------------
  def party_members
    $game_party.battle_members.collect {|actor| actor.id }
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メンバーが入れ替わったらオブジェクトを再作成する
  #--------------------------------------------------------------------------
  def refresh_actors
    a_party_members = party_members
    return if @last_party_members == a_party_members
    @last_party_members = a_party_members
    $game_party.battle_members.each {|actor| actor.sprite_effect_type=:appear }
    reset_sprite_effects
    @spriteset.dispose_actors
    @spriteset.create_actors
    status_clear
    refresh_status
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ステータスウィンドウの情報を更新(メンバー交代用)
  #--------------------------------------------------------------------------
  def status_clear
    @status_window.all_clear
  end
  #--------------------------------------------------------------------------
  # ● [追加]:メッセージウィンドウの位置の初期化
  # 　毎フレーム呼び出すことで、イベントコマンド以外のメッセージの位置を
  # 固定します。
  #--------------------------------------------------------------------------
  def standby_message_window_position
    $game_message.background = LNX11::MESSAGE_WINDOW_BACKGROUND
    $game_message.position = LNX11::MESSAGE_WINDOW_POSITION
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:メッセージウィンドウを開く処理の更新
  #    ステータスウィンドウなどが閉じ終わるまでオープン度を 0 にする。
  #--------------------------------------------------------------------------
  def update_message_open
    if $game_message.busy?
      @party_command_window.close
      @actor_command_window.close
      $game_temp.battlelog_clear = true
    else
      standby_message_window_position
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ターゲットカーソル更新
  #--------------------------------------------------------------------------
  def update_targetcursor
    # 選択中のバトラーの座標を設定する
    if @actor_window.active
      # アクター選択ウィンドウがアクティブ
      @targetcursor.set(@actor_window.targetcursor, true)
    elsif @enemy_window.active
      # 敵キャラ選択ウィンドウがアクティブ
      @targetcursor.set(@enemy_window.targetcursor, true)
    elsif @status_window.index >= 0
      # ステータスウィンドウがアクティブ
      @targetcursor.set(@status_window.actor)
    else
      # どれもアクティブでない場合は非表示
      @targetcursor.hide
    end
    @targetcursor.update
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ポップアップ更新
  #--------------------------------------------------------------------------
  def update_popup
    # ポップアップスプライトの更新
    popup_data.update
  end  
  #--------------------------------------------------------------------------
  # ● [エイリアス]:パーティコマンド選択の開始
  #--------------------------------------------------------------------------
  alias :lnx11a_start_party_command_selection :start_party_command_selection
  def start_party_command_selection
    # 元のメソッドを呼ぶ
    lnx11a_start_party_command_selection
    # バトルログ削除
    @log_window.lines_clear
    $game_temp.battlelog_clear = LNX11::STORAGE_TURNEND_CLEAR
    @actor_command = false
    # 2ターン目以降のパーテイコマンドスキップ
    return unless @party_command_skip
    @party_command_skip = false
    command_fight if !scene_changing? && @party_command_window.active
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:アクターコマンド選択の開始
  #--------------------------------------------------------------------------
  alias :lnx11a_start_actor_command_selection :start_actor_command_selection
  def start_actor_command_selection
    # 元のメソッドを呼ぶ
    lnx11a_start_actor_command_selection
    @actor_command = true
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ターン終了
  #--------------------------------------------------------------------------
  alias :lnx11a_turn_end :turn_end
  def turn_end
    @party_command_skip = (LNX11::PARTY_COMMAND_SKIP && @actor_command)
    @actor_command = false
    # 元のメソッドを呼ぶ
    lnx11a_turn_end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:アクターの選択したアイテム・スキルを返す
  #--------------------------------------------------------------------------
  def actor_selection_item
    case @actor_command_window.current_symbol
    when :attack ; $data_skills[BattleManager.actor.attack_skill_id]
    when :skill  ; @skill
    when :item   ; @item
    when :guard  ; $data_skills[BattleManager.actor.guard_skill_id]
    else ; nil
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:コマンド［防御］
  #--------------------------------------------------------------------------
  alias :lnx11a_command_guard :command_guard
  def command_guard
    if LNX11::GUARD_TARGET_CHECKE
      BattleManager.actor.input.set_guard
      # アクター選択
      select_actor_selection
    else
      # 元のメソッドを呼ぶ
      lnx11a_command_guard
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:アクター選択の開始
  #--------------------------------------------------------------------------
  alias :lnx11a_select_actor_selection :select_actor_selection
  def select_actor_selection
    # ターゲットチェック
    @actor_window.set_target(actor_selection_item)
    # 元のメソッドを呼ぶ
    lnx11a_select_actor_selection
    # ターゲットチェック
    @actor_window.set_target_refresh(actor_selection_item, BattleManager.actor)
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:敵キャラ選択の開始
  #--------------------------------------------------------------------------
  alias :lnx11a_select_enemy_selection :select_enemy_selection
  def select_enemy_selection
    # ターゲットチェック
    @enemy_window.set_target(actor_selection_item)
    # 元のメソッドを呼ぶ
    lnx11a_select_enemy_selection
    # ターゲットチェック
    @enemy_window.set_target_refresh(actor_selection_item, BattleManager.actor)
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]アクター［キャンセル］
  #--------------------------------------------------------------------------
  alias :lnx11a_on_actor_cancel :on_actor_cancel
  def on_actor_cancel
    # 元のメソッドを呼ぶ
    lnx11a_on_actor_cancel
    # 防御の場合
    case @actor_command_window.current_symbol
    when :guard
      @actor_command_window.activate
    end    
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:攻撃アニメーションの表示
  #--------------------------------------------------------------------------
  alias :lnx11a_show_attack_animation :show_attack_animation
  def show_attack_animation(targets)
    if @subject.actor?
      lnx11a_show_attack_animation(targets)
    else
      # 敵の通常攻撃アニメーション
      show_normal_animation(targets, @subject.atk_animation, false)
    end
  end
end

#==============================================================================
# ■ LNX11_Window_ActiveVisible
#------------------------------------------------------------------------------
# 　バトル画面でターゲット選択中にウィンドウを非表示にするための
# ウィンドウ用モジュールです。
# ウィンドウの active と visible を連動させる役割があります。
# Window_ActorCommand,Window_BattleSkill, Window_BattleItem で
# インクルードされます。
#==============================================================================

module LNX11_Window_ActiveVisible
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ウィンドウのアクティブ化
  #--------------------------------------------------------------------------
  def activate
    self.show
    super
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ウィンドウの非アクティブ化
  #--------------------------------------------------------------------------
  def deactivate
    @help_window != nil ? self.hide : self.visible = false
    super
  end
end

#==============================================================================
# ■ LNX11_Window_FittingList
#------------------------------------------------------------------------------
# 　バトル画面のスキルリスト・アイテムリストを項目数に合わせてリサイズする
# ウィンドウ用モジュールです。
# Window_BattleSkill, Window_BattleItem でインクルードされます。
#==============================================================================

module LNX11_Window_FittingList
  #--------------------------------------------------------------------------
  # ● [追加]:ウィンドウの高さ(最大)
  #--------------------------------------------------------------------------
  def max_height
    @info_viewport.rect.y - @help_window.height
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    make_item_list
    self.height = [fitting_height(row_max), max_height].min
    super
    self.oy = 0
  end
end
  
#==============================================================================
# ■ LNX11_Window_TargetHelp
#------------------------------------------------------------------------------
# 　バトル画面で、ターゲット選択中にヘルプウィンドウを表示するための
# ウィンドウ用モジュールです。
# Window_BattleActor, Window_BattleEnemy でインクルードされます。
#==============================================================================

module LNX11_Window_TargetHelp
  #--------------------------------------------------------------------------
  # ● [追加]:ターゲットチェック
  #--------------------------------------------------------------------------
  def set_target(actor_selection_item)
    @cursor_fix = @cursor_all = @cursor_random = false
    item = actor_selection_item
    if actor_selection_item && !item.lnx11a_need_selection?
      # カーソルを固定
      @cursor_fix = true
      # 全体
      @cursor_all = item.for_all? 
      # ランダム
      if item.for_random?
        @cursor_all = true
        @cursor_random = true
        @random_number = item.number_of_targets
      end
    end
    # 戦闘不能の味方が対象か？
    @dead_friend = item.for_dead_friend?
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ターゲットチェック(リフレッシュ後)
  #--------------------------------------------------------------------------
  def set_target_refresh(actor_selection_item, actor)
    item = actor_selection_item
    # 使用者が対象なら、使用者にカーソルを合わせる
    select($game_party.members.index(actor)) if @cursor_fix && item.for_user?
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ウィンドウの表示
  #--------------------------------------------------------------------------
  def show
    @help_window.show
    super
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ウィンドウの非表示
  #--------------------------------------------------------------------------
  def hide
    @help_window.hide
    super
  end
end

#==============================================================================
# ■ [追加]:Window_TargetHelp
#------------------------------------------------------------------------------
# 　ターゲットの名前情報やスキルやアイテムの名前を表示します。
#==============================================================================

class Window_TargetHelp < Window_Help
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :random_number  # 効果範囲ランダムの数
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(1) # 1行ヘルプ
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ウィンドウの非表示
  #--------------------------------------------------------------------------
  def hide
    super
    clear
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:アイテム名設定
  #     item : スキル、アイテム、バトラー等
  #--------------------------------------------------------------------------
  def set_item(item)
    set_text(item ? item : "") # itemの説明ではなく、item自体を渡すようにする
  end
  #--------------------------------------------------------------------------
  # ● ゲージ幅
  #--------------------------------------------------------------------------
  def gauge_width
    LNX11::HELP_PARAM_WIDTH
  end
  #--------------------------------------------------------------------------
  # ● ゲージ幅(余白を含む)
  #--------------------------------------------------------------------------  
  def gauge_width_spacing
    LNX11::HELP_PARAM_WIDTH + 4
  end
  #--------------------------------------------------------------------------
  # ● パラメータエリアの幅
  #--------------------------------------------------------------------------  
  def param_width(size)
    gauge_width_spacing * size
  end
  #--------------------------------------------------------------------------
  # ● 効果範囲ランダムの数の取得
  #--------------------------------------------------------------------------
  def random_number
    # 全角にして返す
    @random_number.to_s.tr('0-9','０-９')
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    if @text == :party
      draw_text(contents.rect, "味方全体", 1)
    elsif @text == :troop
      draw_text(contents.rect, "敵全体", 1)
    elsif @text == :troop_random
      case LNX11::RANDOMSCOPE_DISPLAY
      when 0 ; draw_text(contents.rect, "敵全体 ランダム", 1)
      when 1 ; draw_text(contents.rect, "敵#{random_number}体 ランダム", 1)
      end
    elsif @text.is_a?(Game_Battler)
      # 選択対象の情報を描画
      draw_target_info
    elsif @text.is_a?(RPG::UsableItem)
      # アイテムかスキルならアイテム名を描画
      draw_item_name_help(@text)
    else
      # 通常のテキスト
      super
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択対象の情報の描画
  #--------------------------------------------------------------------------
  def draw_target_info
    # バトラー情報の描画
    param = @text.actor? ? LNX11::HELP_ACTOR_PARAM : LNX11::HELP_ENEMY_PARAM
    # ゲージ付きステータス配列
    status = [param[:hp],param[:mp],param[:tp]&&$data_system.opt_display_tp]
    # 名前
    x = contents_width / 2 - contents.text_size(@text.name).width / 2
    name_width = contents.text_size(@text.name).width + 4
    if !status.include?(true)
      # ゲージ付きステータスを描画しない場合
      draw_targethelp_name(@text, x, name_width, param[:hp])
      x += name_width
      state_width = contents_width - x
    else
      # ゲージ付きステータスを描画する場合
      status.delete(false)
      x -= param_width(status.size) / 2
      draw_targethelp_name(@text, x, name_width, param[:hp])
      x += name_width
      state_width = contents_width - x - param_width(status.size)
    end
    # ステートアイコン
    if param[:state]
      draw_actor_icons(@text, x, 0, state_width) 
    end
    # パラメータの描画
    x = contents_width - param_width(status.size)
    # HP
    if param[:hp]
      draw_actor_hp(@text, x, 0, gauge_width)
      x += gauge_width_spacing
    end
    # MP
    if param[:mp]
      draw_actor_mp(@text, x, 0, gauge_width)
      x += gauge_width_spacing
    end
    # TP
    if param[:tp] && $data_system.opt_display_tp
      draw_actor_tp(@text, x, 0, gauge_width)
      x += gauge_width_spacing
    end
  end
  #--------------------------------------------------------------------------
  # ● ターゲットの名前描画
  #--------------------------------------------------------------------------
  def draw_targethelp_name(actor, x, name_width, hp)
    if hp
      # HPゲージを伴う場合(HPが少ない場合、名前の色が変化する)
      draw_actor_name(actor, x, 0, name_width)
    else
      text = actor.name
      draw_text(x, 0, text_size(text).width + 4, line_height, text)
    end
  end
  #--------------------------------------------------------------------------
  # ● アイテムの描画(中央揃え)
  #--------------------------------------------------------------------------
  def draw_item_name_help(item)
    case LNX11::HELPDISPLAY_TYPE
    when 0 # アイコン+名前
      w = contents.text_size(@text.name).width + 28
    when 1 # 名前のみ
      w = contents.text_size(@text.name).width + 4
    end
    # 簡易説明文の描画
    if !@text.short_description.empty?
      des = LNX11::HELPDISPLAY_DESCRIPTION
      contents.font.size = des[:size]
      text = des[:delimiter] + @text.short_description
      rect = contents.text_size(text)
      w += rect.width
      x = (contents_width - w) / 2
      y = (line_height - rect.height) / 2
      draw_text(x, y, w, line_height, text, 2)
      reset_font_settings
    end
    # 名前の描画
    x = (contents_width - w) / 2
    case LNX11::HELPDISPLAY_TYPE
    when 0 # アイコン+名前
      draw_item_name(@text, x, 0, true, w)
    when 1 # 名前のみ
      draw_text(x, 0, contents_width, line_height, @text.name)
    end
  end
end

#==============================================================================
# ■ Window_PartyCommand
#------------------------------------------------------------------------------
# 　バトル画面で、戦うか逃げるかを選択するウィンドウです。
#==============================================================================

class Window_PartyCommand < Window_Command
  #--------------------------------------------------------------------------
  # ● [エイリアス]:オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :lnx11a_initialize :initialize
  def initialize
    $game_party.last_party_command = nil
    # 元のメソッドを呼ぶ
    lnx11a_initialize
    # 座標を設定
    self.x = LNX11::PARTY_COMMAND_XY[:x]
    self.y = LNX11::PARTY_COMMAND_XY[:y]
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return LNX11::PARTY_COMMAND_WIDTH
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    return LNX11::PARTY_COMMAND_HORIZON ? 1 : @list.size
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    return LNX11::PARTY_COMMAND_HORIZON ? @list.size : 1
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:アライメントの取得
  #--------------------------------------------------------------------------
  def alignment
    return LNX11::PARTY_COMMAND_ALIGNMENT
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:横に項目が並ぶときの空白の幅を取得
  #--------------------------------------------------------------------------
  def spacing
    return 8
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ウィンドウを開く
  #--------------------------------------------------------------------------
  def open
    super
    # 最後に選択したコマンドを選択
    return self unless LNX11::LAST_PARTY_COMMAND
    last_command = $game_party.last_party_command
    if last_command && @list.include?(last_command)
      select(@list.index(last_command))
    end
    self
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ウィンドウを閉じる
  #--------------------------------------------------------------------------
  def close
    super
    # 選択したコマンドを記憶
    $game_party.last_party_command = @list[index] if index >= 0
    self
  end
end

#==============================================================================
# ■ Window_ActorCommand
#------------------------------------------------------------------------------
# 　バトル画面で、アクターの行動を選択するウィンドウです。
#==============================================================================

class Window_ActorCommand < Window_Command
  include LNX11_Window_ActiveVisible
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return LNX11::ACTOR_COMMAND_WIDTH
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    list_size = LNX11::ACTOR_COMMAND_NOSCROLL ? @list.size : 4
    return LNX11::ACTOR_COMMAND_HORIZON ? 1 : list_size
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    return LNX11::ACTOR_COMMAND_HORIZON ? [@list.size, 1].max :  1
  end 
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:アライメントの取得
  #--------------------------------------------------------------------------
  def alignment
    return LNX11::ACTOR_COMMAND_ALIGNMENT
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:横に項目が並ぶときの空白の幅を取得
  #--------------------------------------------------------------------------
  def spacing
    return 8
  end
  #--------------------------------------------------------------------------
  # ● [追加]:X 座標をアクターに合わせる
  #--------------------------------------------------------------------------
  def actor_x(actor)
    ax = $game_party.members_screen_x_nooffset[actor.index] - self.width / 2
    pad = LNX11::STATUS_SIDE_PADDING / 2
    # 画面内に収める
    self.x = [[ax, pad].max, Graphics.width - pad - self.width].min
    self.x += LNX11::ACTOR_COMMAND_OFFSET[:x]
  end
  #--------------------------------------------------------------------------
  # ● [追加]:Y 座標をアクターに合わせる
  #--------------------------------------------------------------------------
  def actor_y(actor)
    self.y = actor.screen_y_top - self.height
    self.y += LNX11::ACTOR_COMMAND_OFFSET[:y]
  end
  #--------------------------------------------------------------------------
  # ● [追加]:固定 Y 座標
  #--------------------------------------------------------------------------
  def screen_y
    if LNX11::ACTOR_COMMAND_Y_POSITION == 0
      self.y = Graphics.height - self.height + LNX11::ACTOR_COMMAND_OFFSET[:y]
    else
      self.y = LNX11::ACTOR_COMMAND_OFFSET[:y]
    end
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:セットアップ
  #--------------------------------------------------------------------------
  alias :lnx11a_setup :setup
  def setup(actor)
    # 前のアクターのコマンドを記憶
    @actor.last_actor_command = @list[index] if @actor
    # 元のメソッドを呼ぶ
    lnx11a_setup(actor)
    self.arrows_visible = !LNX11::ACTOR_COMMAND_NOSCROLL
    self.height = window_height
    self.oy = 0
    # アクターコマンドの表示位置で分岐
    case LNX11::ACTOR_COMMAND_POSITION
    when 0
      # アクターの頭上
      actor_x(actor)
      actor_y(actor)
    when 1
      # Y 座標固定
      actor_x(actor)
      screen_y
    when 2
      # XY固定
      self.x = LNX11::ACTOR_COMMAND_OFFSET[:x]
      screen_y
    end
    # 最後に選択したコマンドを選択
    return unless LNX11::LAST_ACTOR_COMMAND
    last_command = @actor.last_actor_command
    if last_command && @list.include?(last_command)
      select(@list.index(last_command))
    end
  end
end

#==============================================================================
# ■ Window_BattleStatus
#------------------------------------------------------------------------------
# 　バトル画面で、パーティメンバーのステータスを表示するウィンドウです。
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ● [追加]:公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader :min_offset   # ステータス描画 X 座標の位置修正
  #--------------------------------------------------------------------------
  # ● [エイリアス]:オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :lnx11a_initialize :initialize
  def initialize
    @actor_last_status = Array.new($game_party.max_battle_members) { nil }    
    # 元のメソッドを呼ぶ
    lnx11a_initialize
    # ウィンドウを最初から表示
    self.openness = 255
    self.opacity = 0
    update_invisible
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:行の高さを取得
  #--------------------------------------------------------------------------
  def line_height
    return LNX11::STATUS_LINE_HEIGHT
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:標準パディングサイズの取得
  #--------------------------------------------------------------------------
  def standard_padding
    return 0
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    return $data_system.opt_display_tp ? 4 : 3
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    return [item_max, 1].max
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:横に項目が並ぶときの空白の幅を取得
  #--------------------------------------------------------------------------
  def spacing
    return 0
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:項目の高さを取得
  #--------------------------------------------------------------------------
  def item_height
    self.height
  end  
  #--------------------------------------------------------------------------
  # ● [再定義]:ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    Graphics.width
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ウィンドウ高さの取得
  #--------------------------------------------------------------------------
  alias :lnx11a_window_height :window_height
  def window_height
    # 一行目(名前・ステート)の高さを確保する
    lnx11a_window_height - line_height + [24, line_height].max
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:カーソルの更新
  #--------------------------------------------------------------------------
  def update_cursor
    # カーソルを表示しない
    cursor_rect.empty
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:システム色の取得
  # 　ゲージ幅が短すぎる場合、HP,MP,TP の文字を非表示にします。
  #--------------------------------------------------------------------------
  def system_color
    gauge_area_width - @min_offset >= 52 ? super : Color.new
  end  
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ゲージ背景色の取得
  #   ゲージの透明度を適用します。  
  #--------------------------------------------------------------------------
  def gauge_back_color
    color = super
    color.alpha *= LNX11::STATUS_GAUGE_OPACITY / 255.0
    color
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ゲージの描画
  #   ゲージの透明度を適用します。
  #--------------------------------------------------------------------------
  def draw_gauge(x, y, width, rate, color1, color2)
    oparate = LNX11::STATUS_GAUGE_OPACITY / 255.0
    color1.alpha *= oparate
    color2.alpha *= oparate
    super
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_invisible
  end
  #--------------------------------------------------------------------------
  # ● [追加]:表示状態更新
  #--------------------------------------------------------------------------
  def update_invisible
    self.contents_opacity = $game_party.status_invisible ? 0 : 255
  end  
  #--------------------------------------------------------------------------
  # ● [追加]:アクターオブジェクト取得
  #--------------------------------------------------------------------------
  def actor
    $game_party.members[@index]
  end
  #--------------------------------------------------------------------------
  # ● [追加]:座標の設定
  #--------------------------------------------------------------------------
  def set_xy
    # ステータス位置の調整:画面からはみ出ないようにする
    pw = $game_party.members_screen_x.last + LNX11::STATUS_OFFSET[:x]
    pw += gauge_area_width / 2
    right_end = Graphics.width - LNX11::STATUS_SIDE_PADDING
    min_offset = pw > right_end ? pw - right_end : 0
    # ステータスのオフセットを適用
    self.x = LNX11::STATUS_OFFSET[:x] - min_offset
    self.y = LNX11::STATUS_OFFSET[:y] + Graphics.height - self.height
    # ステータス幅の自動調整:位置を調整した分だけ幅を縮める
    @min_offset = LNX11::STATUS_AUTOADJUST ? min_offset : 0
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:ゲージエリアの幅を取得
  #--------------------------------------------------------------------------
  def gauge_area_width
    return LNX11::STATUS_WIDTH
  end
  #--------------------------------------------------------------------------
  # ● [追加]:表示するステート数の取得
  #--------------------------------------------------------------------------
  def states(actor, width)
    icons = (actor.state_icons + actor.buff_icons)[0, width / 24]
    icons.size
  end
  #--------------------------------------------------------------------------
  # ● [追加]:名前とステートの描画(1行表示)
  # 　width の範囲で名前を左揃え、ステートアイコンを右揃えで描画します。
  # ステートを優先して表示するため、アイコンが多すぎて名前の表示領域が
  # 極端に狭くなる場合は名前を描画しません。
  #--------------------------------------------------------------------------
  def draw_actor_name_with_icons(actor, x, y, width = 128, draw_name = true)
    # アイコンのY座標補正
    iy = ([line_height, 24].max - 24) / 2
    # 名前のY座標補正
    ny = ([line_height, 24].max - LNX11::STATUS_NAME_SIZE) / 2
    # 表示するステート数を取得
    icon = states(actor, width)
    if icon > 0
      # 表示するべきステートがある場合
      name_width = width - icon * 24
      ix = x + width - icon * 24
      if name_width >= contents.font.size * 2 && draw_name
        # 名前の表示領域(width) が フォントサイズ * 2 以上なら両方を描画
        draw_actor_name(actor, x, y + ny,  name_width)
        iw = width - name_width
        draw_actor_icons(actor, ix, y + iy, iw)
      else
        # ステートのみ描画
        draw_actor_icons(actor, ix, y + iy, width)
      end
    elsif draw_name
      # ない場合、名前のみ描画
      draw_actor_name(actor, x, y + ny, width)
    end
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    set_xy
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:項目を描画する矩形の取得
  #--------------------------------------------------------------------------
  def item_rect(index)
    rect = super
    rect.x = $game_party.members_screen_x[index] - gauge_area_width / 2
    rect.width = gauge_area_width
    rect
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:基本エリアの矩形を取得
  #--------------------------------------------------------------------------
  def basic_area_rect(index)
    rect = item_rect(index)
    rect
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:ゲージエリアの矩形を取得
  #--------------------------------------------------------------------------
  def gauge_area_rect(index)
    rect = basic_area_rect(index)
    rect.y += [24, line_height].max
    rect.x += @min_offset
    rect
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:基本エリアの描画
  #--------------------------------------------------------------------------
  def draw_basic_area(rect, actor)
    # フォントサイズ変更
    contents.font.size = [LNX11::STATUS_NAME_SIZE, 8].max
    # 名前とステートを描画
    dn = LNX11::STATUS_NAME_SIZE > 0 # 名前を描画するか？
    width = gauge_area_width - @min_offset
    rest  = width % 24
    width += 24 - rest if rest > 0
    draw_actor_name_with_icons(actor, rect.x, rect.y, width, dn)
    # フォントサイズを元に戻す
    reset_font_settings
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ゲージエリアの描画
  #--------------------------------------------------------------------------
  alias :lnx11a_draw_gauge_area :draw_gauge_area
  def draw_gauge_area(*args)
    # フォントサイズ変更
    contents.font.size = LNX11::STATUS_PARAM_SIZE
    # 元のメソッドを呼ぶ
    lnx11a_draw_gauge_area(*args)
    # フォントサイズを元に戻す
    reset_font_settings
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:ゲージエリアの描画（TP あり）
  #--------------------------------------------------------------------------
  def draw_gauge_area_with_tp(rect, actor)
    width = gauge_area_width - @min_offset
    draw_actor_hp(actor, rect.x, rect.y,                   width)
    draw_actor_mp(actor, rect.x, rect.y + line_height,     width)
    draw_actor_tp(actor, rect.x, rect.y + line_height * 2, width)
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:ゲージエリアの描画（TP なし）
  #--------------------------------------------------------------------------
  def draw_gauge_area_without_tp(rect, actor)
    draw_actor_hp(actor, rect.x, rect.y,               gauge_area_width)
    draw_actor_mp(actor, rect.x, rect.y + line_height, gauge_area_width)
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    actor = $game_party.battle_members[index]
    a_status = status(actor)
    # ステータスが変化した場合のみ描画する
    return if @actor_last_status[index] == a_status
    @actor_last_status[index] = a_status
    contents.clear_rect(item_rect(index))
    draw_basic_area(basic_area_rect(index), actor)
    draw_gauge_area(gauge_area_rect(index), actor)
  end
  #--------------------------------------------------------------------------
  # ● [追加]:アクターのステータス配列を返す
  #--------------------------------------------------------------------------
  def status(actor)
    if $data_system.opt_display_tp
      return [actor.name, actor.state_icons + actor.buff_icons,
              actor.mhp, actor.hp, actor.mmp, actor.mp, actor.max_tp, actor.tp]
    else
      # TP を除くステータス配列
      return [actor.name, actor.state_icons + actor.buff_icons,
              actor.mhp, actor.hp, actor.mmp, actor.mp]
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:内容の消去
  #--------------------------------------------------------------------------
  def all_clear
    contents.clear
    @actor_last_status = Array.new($game_party.max_battle_members) { nil }    
  end
end

#==============================================================================
# ■ Window_BattleActor
#------------------------------------------------------------------------------
# 　バトル画面で、行動対象のアクターを選択するウィンドウです。
# XPスタイルバトルではバトルステータスを非表示にしないため、
# 選択機能だけを持つ不可視のウィンドウとして扱います。
#==============================================================================

class Window_BattleActor < Window_BattleStatus
  include LNX11_Window_TargetHelp
  #--------------------------------------------------------------------------
  # ● [エイリアス]:オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :lnx11a_wba_initialize :initialize
  def initialize(info_viewport)
    # 元のメソッドを呼ぶ
    lnx11a_wba_initialize(info_viewport)
    # ウィンドウを画面外に移動
    self.y = Graphics.height
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_item(targetcursor)
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ターゲットカーソルに渡すオブジェクト
  #--------------------------------------------------------------------------
  def targetcursor
    @cursor_all ? :party : actor
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    64
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:全項目の描画
  #--------------------------------------------------------------------------
  def draw_all_items
    # 何もしない    
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    # 何もしない
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    # 何もしない
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ウィンドウの表示
  #--------------------------------------------------------------------------
  alias :lnx11a_show :show
  def show
    # 元のメソッドを呼ぶ
    lnx11a_show
    # 最後に選択したアクターを選択
    last_target = $game_temp.last_target_cursor[:actor]
    if last_target && $game_party.members.include?(last_target) &&
       LNX11::LAST_TARGET
      select($game_party.members.index(last_target))
    end
    # スマートターゲットセレクト
    if LNX11::SMART_TARGET_SELECT && !@cursor_fix
      if @dead_friend && (!last_target || last_target && last_target.alive?)
        dead_actor = $game_party.dead_members[0]
        select($game_party.members.index(dead_actor)) if dead_actor
      elsif !@dead_friend && (!last_target || last_target && last_target.dead?)
        alive_actor = $game_party.alive_members[0]
        select($game_party.members.index(alive_actor)) if alive_actor
      end
    end
    self
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ウィンドウの非表示
  #--------------------------------------------------------------------------
  alias :lnx11a_hide :hide
  def hide
    # 元のメソッドを呼ぶ
    lnx11a_hide
    # 選択したアクターを記憶
    $game_temp.last_target_cursor[:actor] = actor
    self
  end
end

#==============================================================================
# ■ Window_BattleEnemy
#------------------------------------------------------------------------------
# 　バトル画面で、行動対象の敵キャラを選択するウィンドウです。
# 横並びの不可視のウィンドウとして扱います。
#==============================================================================

class Window_BattleEnemy < Window_Selectable
  include LNX11_Window_TargetHelp
  #--------------------------------------------------------------------------
  # ● [エイリアス]:オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :lnx11a_initialize :initialize
  def initialize(info_viewport)
    # 敵キャラオブジェクトの設定
    set_enemy
    # 元のメソッドを呼ぶ
    lnx11a_initialize(info_viewport)
    # ウィンドウを画面外に移動
    self.y = Graphics.height
  end
  #--------------------------------------------------------------------------
  # ● [追加]:敵キャラオブジェクトの設定
  #--------------------------------------------------------------------------
  def set_enemy
    if LNX11::TROOP_X_SORT
      @troop = $game_troop.alive_members.sort {|a,b| a.screen_x <=> b.screen_x}
    else
      @troop = $game_troop.alive_members
    end
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:敵キャラオブジェクト取得
  #--------------------------------------------------------------------------
  def enemy
    @troop[@index]
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    64
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:指定行数に適合するウィンドウの高さを計算
  #--------------------------------------------------------------------------
  def fitting_height(line_number)
    super(1)
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    return item_max
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.random_number = @random_number
    @help_window.set_item(targetcursor)
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ターゲットカーソルに渡すオブジェクト
  #--------------------------------------------------------------------------
  def targetcursor
    @cursor_all ? (@cursor_random ? :troop_random : :troop) : enemy
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ウィンドウの表示
  #--------------------------------------------------------------------------
  alias :lnx11a_show :show
  def show
    # 元のメソッドを呼ぶ
    lnx11a_show
    # 敵キャラオブジェクトの設定
    set_enemy
    return self unless LNX11::LAST_TARGET
    # 最後に選択した敵キャラを選択
    last_target = $game_temp.last_target_cursor[:enemy]
    if last_target && @troop.include?(last_target)
      select(@troop.index(last_target))
    end
    self
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:ウィンドウの非表示
  #--------------------------------------------------------------------------
  alias :lnx11a_hide :hide
  def hide
    # 元のメソッドを呼ぶ
    lnx11a_hide
    # 選択した敵キャラを記憶
    $game_temp.last_target_cursor[:enemy] = enemy
    self
  end
end

#==============================================================================
# ■ Window_BattleSkill
#------------------------------------------------------------------------------
# 　いくつかのモジュールをインクルードします。
#==============================================================================

class Window_BattleSkill < Window_SkillList
  include LNX11_Window_ActiveVisible
  include LNX11_Window_FittingList if LNX11::FITTING_LIST
end

#==============================================================================
# ■ Window_BattleItem
#------------------------------------------------------------------------------
# 　いくつかのモジュールをインクルードします。
#==============================================================================

class Window_BattleItem < Window_ItemList
  include LNX11_Window_ActiveVisible
  include LNX11_Window_FittingList if LNX11::FITTING_LIST
end
# l:5608