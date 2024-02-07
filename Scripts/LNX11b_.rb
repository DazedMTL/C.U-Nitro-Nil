#==============================================================================
# ★ RGSS3-Extension
# LNX11b_リフォーム・バトルステータス
# 　Spriteでパラメータやゲージを実装した動的なバトルステータスです。
# 　画像や設定を変更することでデザインをアレンジすることが可能です。
#   
# 　* このスクリプトは LNX11a_XPスタイルバトル の機能拡張スクリプトです。
# 　LNX11a_XPスタイルバトル より下のセクションに導入してください。
#
# 　また、ステータスの各要素の配置設定を行う
# 　LNX11bskin_リフォーム・バトルステータス#スキン設定 も必ず導入してください。
#
# 　version   : 1.01 (12/03/13)
# 　author    : ももまる
# 　reference : http://peachround.blog.fc2.com/blog-entry-12.html
#
#==============================================================================

#==============================================================================
# ■ LNXスクリプト導入情報
#==============================================================================
$lnx_include = {} if $lnx_include == nil
$lnx_include[:lnx11b] = 101 # version
module LNX11b ; end
unless $lnx_include[:lnx11a]
  p "NG:LNX11b_リフォーム・バトルステータス"
  text = "LNX11b: Error! LNX11a より下位のセクションに配置してください。"
  p text
  msgbox text
  exit
end
p "OK:LNX11b_リフォーム・バトルステータス"

#==============================================================================
# ■ Window_BattleStatus
#------------------------------------------------------------------------------
# 　バトル画面で、パーティメンバーのステータスを表示するウィンドウです。
#==============================================================================

class Window_BattleStatus < Window_Selectable
  #--------------------------------------------------------------------------
  # ● [エイリアス]:オブジェクト初期化
  #--------------------------------------------------------------------------
  alias :lnx11b_initialize :initialize
  def initialize
    unless $lnx_include[:lnx11bskin]
      text = "LNX11b:Error! LNX11bskin が導入されていません。"
      p text
      msgbox text
      exit
    end
    @sprite_viewport = Viewport.new
    # 元のメソッドを呼ぶ
    lnx11b_initialize
    @sprite_viewport.z = self.z
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]解放
  #--------------------------------------------------------------------------
  def dispose
    @sprite_viewport.dispose
    dispose_status_sprites
    super
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    return 4
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:行の高さを取得
  #--------------------------------------------------------------------------
  def line_height
    return 24 # ステートアイコン描画領域を確保
  end
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_invisible
    update_status_sprites
  end  
  #--------------------------------------------------------------------------
  # ● [再定義]:表示状態更新
  #--------------------------------------------------------------------------
  def update_invisible
    @sprite_viewport.visible = !$game_party.status_invisible
  end  
  #--------------------------------------------------------------------------
  # ● [再定義]:リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    set_xy
    # ステータススプライトの作成
    create_status_sprites
    draw_all_items
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ステータススプライトの作成
  #--------------------------------------------------------------------------
  def create_status_sprites
    return if @sprite != nil
    @sprite = []
    $game_party.battle_members.each_with_index do |actor, i|
      @sprite[i] = Spriteset_BattleStatus.new(actor, self, @sprite_viewport)
    end
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ステータススプライトの解放
  #--------------------------------------------------------------------------
  def dispose_status_sprites
    return unless @sprite
    @sprite.each do |sprite|
      sprite.dispose
    end
    @sprite = nil
  end
  #--------------------------------------------------------------------------
  # ● [追加]:ステータススプライトの更新
  #--------------------------------------------------------------------------
  def update_status_sprites
    return unless @sprite
    @sprite.each {|sprite| sprite.update}
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:基本エリアの描画
  #--------------------------------------------------------------------------
  def draw_basic_area(rect, actor)
    # スプライトの更新
    @sprite[actor.index].refresh
  end
  #--------------------------------------------------------------------------
  # ● [再定義]:ゲージエリアの描画
  #--------------------------------------------------------------------------
  def draw_gauge_area(*args)
    # 何もしない
  end
  #--------------------------------------------------------------------------
  # ● [エイリアス]:内容の消去
  #--------------------------------------------------------------------------
  alias :lnx11b_all_clear :all_clear
  def all_clear
    # 元のメソッドを呼ぶ
    lnx11b_all_clear
    # ステータススプライトの解放
    dispose_status_sprites
  end
end

#==============================================================================
# ■ [追加]:Spriteset_BattleStatus
#------------------------------------------------------------------------------
# 　スプライトによるバトルステータス。
#==============================================================================

class Spriteset_BattleStatus
  include LNX11
  include LNX11b
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------  
  def initialize(battler, status_window, viewport = nil)
    @battler = battler
    @viewport = viewport
    @status_window = status_window
    # 基準座標
    @x = $game_party.members_screen_x[battler.index] + STATUS_OFFSET[:x]
    @x -= STATUS_WIDTH / 2
    @y = @status_window.y + STATUS_OFFSET[:y]
    # メインスキン
    @main_skin_sprite = create_skin(MAIN_SKIN)
    # ステート
    @state_skin_sprite = create_skin(STATE_SKIN)
    @state_icon = create_state_icon(STATE_ICON)
    # 名前
    @name_sprite = create_name(NAME)
    # 数字
    num = @battler.hp ; max = @battler.mhp
    @hp_number_sprite = create_number(num, max, HP_NUMBER_FORMAT)
    num = @battler.mp ; max = @battler.mmp
    @mp_number_sprite = create_number(num, max, MP_NUMBER_FORMAT)
    if $data_system.opt_display_tp
      num = @battler.tp ; max = @battler.max_tp
      @tp_number_sprite = create_number(num, max, TP_NUMBER_FORMAT)
    end
    # 数字(最大値)
    num = @battler.mhp
    @mhp_number_sprite = create_number(num, num, MAXHP_NUMBER_FORMAT)
    num = @battler.mmp
    @mmp_number_sprite = create_number(num, num, MAXMP_NUMBER_FORMAT)
    if $data_system.opt_display_tp
      num = @battler.max_tp
      @mtp_number_sprite = create_number(num, num, MAXTP_NUMBER_FORMAT)
    end
    # ゲージ
    @hp_gauge_sprite = create_gauge(@battler.hp_rate, HP_GAUGE_FORMAT)
    @mp_gauge_sprite = create_gauge(@battler.mp_rate, MP_GAUGE_FORMAT)
    if $data_system.opt_display_tp
      @tp_gauge_sprite = create_gauge(@battler.tp_rate, TP_GAUGE_FORMAT)
    end
    # ゲージと数字スプライトの同期
    if HP_GAUGE_FORMAT[:number_link] && @hp_number_sprite
      @hp_gauge_sprite.number = @hp_number_sprite if @hp_gauge_sprite
    end
    if MP_GAUGE_FORMAT[:number_link] && @mp_number_sprite
      @mp_gauge_sprite.number = @mp_number_sprite if @mp_gauge_sprite
    end
    if TP_GAUGE_FORMAT[:number_link] && @tp_number_sprite
      @tp_gauge_sprite.number = @tp_number_sprite if @tp_gauge_sprite
    end
    # 更新するスプライトの配列
    @sprites = [@main_skin_sprite, @state_skin_sprite, @state_icon,
      @name_sprite, @hp_number_sprite, @mp_number_sprite, @tp_number_sprite, 
      @mhp_number_sprite, @mmp_number_sprite, @mtp_number_sprite,
      @hp_gauge_sprite, @mp_gauge_sprite, @tp_gauge_sprite]
    @sprites.delete(nil)
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------  
  def dispose
    @sprites.each {|sprite| sprite.dispose }
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    @sprites.each {|sprite| sprite.update }
  end
  #--------------------------------------------------------------------------
  # ● スプライトの位置設定
  #--------------------------------------------------------------------------  
  def move(sprite, format)
    # 表示基準 X 座標
    x = format[:x_fixed] ? @x : @x - @status_window.min_offset     
    sprite.move(x + format[:x], @y + format[:y], format[:z])
  end
  #--------------------------------------------------------------------------
  # ● スキンの作成
  #--------------------------------------------------------------------------  
  def create_skin(format)
    return nil unless format[:enabled]
    sprite = Sprite_Skin.new(format, @viewport)
    move(sprite, format)
    return sprite
  end
  #--------------------------------------------------------------------------
  # ● 名前の作成
  #--------------------------------------------------------------------------  
  def create_name(format)
    return nil unless format[:enabled]
    sprite = Sprite_BattlerName.new(@battler, format, @viewport)
    move(sprite, format)
    return sprite
  end
  #--------------------------------------------------------------------------
  # ● 数字の作成
  #--------------------------------------------------------------------------  
  def create_number(num, max, format)
    return nil unless format[:enabled]
    sprite = Sprite_Number.new(num, max, format, @viewport)
    move(sprite, format)
    return sprite
  end
  #--------------------------------------------------------------------------
  # ● ゲージの作成
  #--------------------------------------------------------------------------  
  def create_gauge(rate, format)
    return nil unless format[:enabled]
    case format[:type]
    when 0 # 横ゲージ
      sprite = Sprite_HorzGauge.new(rate, format, @viewport)
    when 1 # セルゲージ
      sprite = Sprite_CellGauge.new(rate, format, @viewport)
    end
    move(sprite, format)
    return sprite
  end
  #--------------------------------------------------------------------------
  # ● ステートアイコンの作成
  #--------------------------------------------------------------------------  
  def create_state_icon(format)
    return nil unless format[:enabled]
    sprite = Sprite_StateIcon.new(@battler, @status_window, format, @viewport)
    move(sprite, format)
    return sprite
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    # ゲージ
    @hp_gauge_sprite.set(@battler.hp_rate) if @hp_gauge_sprite
    @mp_gauge_sprite.set(@battler.mp_rate) if @mp_gauge_sprite
    @tp_gauge_sprite.set(@battler.tp_rate) if @tp_gauge_sprite
    # 数字
    @hp_number_sprite.set(@battler.hp, @battler.mhp) if @hp_number_sprite
    @mp_number_sprite.set(@battler.mp, @battler.mmp) if @mp_number_sprite
    @tp_number_sprite.set(@battler.tp, @battler.max_tp) if @tp_number_sprite
    # 数字(最大値)
    @mhp_number_sprite.set(@battler.mhp, @battler.mhp) if @mhp_number_sprite
    @mmp_number_sprite.set(@battler.mmp, @battler.mmp) if @mmp_number_sprite
    mtp = @battler.max_tp
    @mtp_number_sprite.set(mtp, mtp) if @mtp_number_sprite
    # ステート
    @state_icon.refresh if @state_icon
    @state_skin_sprite.visible = @state_icon.visible if @state_skin_sprite
    # 名前
    if @name_sprite
      @name_sprite.refresh
      if @state_icon && NAME[:auto_hide]
        @name_sprite.visible = !@state_icon.visible
      end
    end
  end
end

module LNX11
  # X 座標の自動調整を行う
  STATUS_AUTOADJUST = true 
end

#==============================================================================
# ■ [追加]:Sprite_BattleStatus
#------------------------------------------------------------------------------
# 　バトルステータスのスプライト群のスーパークラス。
#==============================================================================

class Sprite_BattleStatus < Sprite
  #--------------------------------------------------------------------------
  # ● 移動
  #--------------------------------------------------------------------------
  def move(x, y, z)
    self.x = x
    self.y = y
    self.z = z
  end
end

#==============================================================================
# ■ [追加]:Sprite_Skin
#------------------------------------------------------------------------------
# 　バトルステータス：スキンのスプライト。
#==============================================================================

class Sprite_Skin < Sprite_BattleStatus
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------  
  def initialize(format, viewport = nil)
    super(viewport)
    self.bitmap = Cache.system(format[:bitmap])
  end
end

#==============================================================================
# ■ [追加]:Sprite_BattlerName
#------------------------------------------------------------------------------
# 　バトルステータス：名前を表示するスプライト。
#==============================================================================

class Sprite_BattlerName < Sprite_BattleStatus
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------  
  def initialize(battler, format, viewport = nil)
    super(viewport)
    @battler = battler
    @format = format
    @name = ""
    refresh
  end
  #--------------------------------------------------------------------------
  # ● ビットマップの解放
  #--------------------------------------------------------------------------  
  def bitmap_dispose
    self.bitmap.dispose if self.bitmap && !self.bitmap.disposed?
    self.bitmap = nil
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------  
  def refresh
    return if @name == @battler.name
    @name = @battler.name
    bitmap_dispose
    if @format[:bitmap_name]
      self.bitmap = Cache.system("name_#{@name}")
    else
      self.bitmap = Bitmap.new(@format[:width], @format[:height])
      self.bitmap.font.name = @format[:name]
      self.bitmap.font.size = @format[:size]
      self.bitmap.font.bold = @format[:bold]
      self.bitmap.font.italic = @format[:italic]
      self.bitmap.font.color = @format[:color][0]
      self.bitmap.font.out_color = @format[:color][1]  
      self.bitmap.draw_text(self.bitmap.rect, @name, @format[:align])
    end
  end
end

#==============================================================================
# ■ [追加]:Sprite_HorzGauge
#------------------------------------------------------------------------------
# 　バトルステータス：横方向のゲージ。
#==============================================================================

class Sprite_HorzGauge < Sprite_BattleStatus
  NUMBERS    = [0,1,2,3,4,5,6,7,8,9]
  COLOR_SIZE = 4
  # 0:通常 1:ピンチ 2:最大 3:サブゲージ
  #--------------------------------------------------------------------------
  # ● [追加]:公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :number   # 同期する数字スプライト
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------  
  def initialize(rate, format, viewport)
    super(viewport)
    self.bitmap = Cache.system(format[:bitmap])
    @speed = format[:speed]
    @s_speed = format[:s_speed]
    @crisis = format[:crisis]    
    @sub_gauge = Sprite.new(viewport)
    @sub_gauge.bitmap = self.bitmap
    @number = nil
    color_set_rect(3, @sub_gauge)
    set(rate, true)
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------  
  def dispose
    @sub_gauge.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● 移動
  #--------------------------------------------------------------------------
  def move(x, y, z)
    super(x, y, z)
    @sub_gauge.x = x
    @sub_gauge.y = y
    @sub_gauge.z = z - 1
  end
  #--------------------------------------------------------------------------
  # ● ゲージ最大か？
  #--------------------------------------------------------------------------
  def max?
    @gauge_width / max_gauge_widht >= 1.0
  end
  #--------------------------------------------------------------------------
  # ● ゲージが少ない？
  #--------------------------------------------------------------------------  
  def crisis?
    @gauge_width / max_gauge_widht < @crisis
  end
  #--------------------------------------------------------------------------
  # ● 最大ゲージ幅の取得
  #--------------------------------------------------------------------------
  def max_gauge_widht
    self.bitmap.width.to_f
  end
  #--------------------------------------------------------------------------
  # ● ゲージ色変更(Rect)
  #--------------------------------------------------------------------------
  def color_set_rect(color, sprite)
    sprite.src_rect.height = self.bitmap.height / COLOR_SIZE
    sprite.src_rect.y = color * self.bitmap.height / COLOR_SIZE
  end
  #--------------------------------------------------------------------------
  # ● ゲージ色変更
  #--------------------------------------------------------------------------
  def gauge_color_set
    color_set_rect(max? ? 2 : crisis? ? 1 : 0, self)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    # メインゲージ幅の更新
    if @real_gauge_width != @gauge_width
      if @number
        # 数字スプライトと同期
        rate = @number.real_rate
        width = ([max_gauge_widht * rate, rate != 0 ? 1 : 0].max).to_i
        @real_gauge_width = width
      else
        @real_gauge_width = sma(@gauge_width, @real_gauge_width, @speed)
      end
      # ゲージ色変更
      gauge_color_set
    end
    # サブゲージ幅の更新
    if @sub_gauge_width > @gauge_width
      @sub_gauge_width = [@sub_gauge_width - @s_speed, @gauge_width].max
    elsif @sub_gauge_width != @gauge_width
      @sub_gauge_width = @real_gauge_width
    end
    # スプライトの更新
    update_sprite
  end
  #--------------------------------------------------------------------------
  # ● スプライトの更新
  #--------------------------------------------------------------------------
  def update_sprite
    self.src_rect.width = @real_gauge_width
    @sub_gauge.x = self.x + @real_gauge_width
    @sub_gauge.src_rect.x = @real_gauge_width
    @sub_gauge.src_rect.width = @sub_gauge_width - @real_gauge_width
  end
  #--------------------------------------------------------------------------
  # ● ゲージレートの設定
  #--------------------------------------------------------------------------  
  def set(rate, apply = false)
    @gauge_rate = rate
    @gauge_width = ([max_gauge_widht * rate, rate != 0 ? 1 : 0].max).to_i
    # すぐに適用
    if apply
      @real_gauge_width = @gauge_width
      @sub_gauge_width = @gauge_width
      # ゲージ色変更
      gauge_color_set
      # スプライトの更新
      update_sprite
    end
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
end

#==============================================================================
# ■ [追加]:Sprite_CellGauge
#------------------------------------------------------------------------------
# 　バトルステータス：値に応じたセルを参照して表示する擬似ゲージ。
#==============================================================================

class Sprite_CellGauge < Sprite_BattleStatus
  #--------------------------------------------------------------------------
  # ● [追加]:公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_accessor :number   # 同期する数字スプライト  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------  
  def initialize(rate, format, viewport)
    super(viewport)
    self.bitmap = Cache.system(format[:bitmap])
    @speed = format[:speed]
    @pattern = format[:pattern]
    @pattern_direction = format[:direction]
    @cell_width = format[:width]
    @cell_height = format[:height]
    # パターン
    @horz_size = self.bitmap.width / @cell_width
    @vtcl_size = self.bitmap.height / @cell_height
    @number = nil
    set(rate, true)
  end
  #--------------------------------------------------------------------------
  # ● パターン数の取得
  #--------------------------------------------------------------------------
  def pattern
    @pattern == :auto ? @horz_size * @vtcl_size - 1 : @pattern - 1
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    # メインゲージ幅の更新
    if @real_rate.truncate != @rate.truncate
      if number
        # 数字スプライトと同期
        @real_rate = @number.real_rate * 100
      else
        @real_rate = sma(@rate, @real_rate, @speed)
      end
      # スプライトの更新
      update_sprite
    end
  end
  #--------------------------------------------------------------------------
  # ● スプライトの更新
  #--------------------------------------------------------------------------
  def update_sprite
    pt = (pattern * @real_rate / 100).truncate
    if @pattern_direction == 0
      # 横方向にパターンが並んでいる
      cx = pt % @horz_size * @cell_width
      cy = pt / @horz_size * @cell_height
    else
      # 縦方向にパターンが並んでいる
      cx = pt / @vtcl_size * @cell_width
      cy = pt % @vtcl_size * @cell_height
    end
    self.src_rect.set(cx, cy, @cell_width, @cell_height)
  end
  #--------------------------------------------------------------------------
  # ● ゲージレートの設定
  #--------------------------------------------------------------------------  
  def set(rate, apply = false)
    @rate = rate * 100
    # すぐに適用
    if apply
      @real_rate = @rate
      # スプライトの更新
      update_sprite
    end
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
end

#==============================================================================
# ■ [追加]:Sprite_Number
#------------------------------------------------------------------------------
# 　バトルステータス：数字を表示するスプライト。
#==============================================================================

class Sprite_Number < Sprite_BattleStatus
  COLOR_SIZE = 3
  # 0:通常
  # 1:1/4(ピンチ)
  # 2:死亡
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------  
  def initialize(num, max, format, viewport = nil)
    super(viewport)
    @src_bitmap = Cache.system(format[:bitmap])
    @speed = format[:speed]
    @align  = format[:align]
    @spacing = format[:spacing]
    @crisis = format[:crisis]
    @dead = format[:dead]
    digit = format[:digit]
    # 数字幅
    @num_width = @src_bitmap.width / 10
    # 数字高さ
    @num_height = @src_bitmap.height / COLOR_SIZE
    bw = @num_width * digit + @spacing * (digit - 1)    
    self.bitmap = Bitmap.new(bw, @num_height)
    # 文字揃えによる基準座標の変更
    case @align
    when 0 ; self.ox = 0
    when 1 ; self.ox = self.width / 2
    when 2 ; self.ox = self.width
    end
    # 初期値適用
    set(num, max, true)
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------  
  def dispose
    self.bitmap.dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● レートの取得
  #--------------------------------------------------------------------------
  def rate
    @num / @max.to_f
  end
  #--------------------------------------------------------------------------
  # ● 表示レートの取得
  #--------------------------------------------------------------------------
  def real_rate
    @real_num / @max.to_f
  end
  #--------------------------------------------------------------------------
  # ● 数値が少ない？
  #--------------------------------------------------------------------------  
  def crisis?
    rate < @crisis
  end
  #--------------------------------------------------------------------------
  # ● 数値が 0 か？
  #--------------------------------------------------------------------------  
  def dead?
    rate <= @dead
  end
  #--------------------------------------------------------------------------
  # ● 数字色取得
  #--------------------------------------------------------------------------
  def number_color
    dead? ? 2 : crisis? ? 1 : 0
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    # 数値の更新
    if @real_num != @num 
      ac = [1, ((@real_num - @num).abs / @speed).truncate].max
      if @real_num > @num
        @real_num = [@real_num - ac, @num].max
      else
        @real_num = [@real_num + ac, @num].min
      end
      # ビットマップの更新
      update_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # ● 数値の設定
  #--------------------------------------------------------------------------  
  def set(num, max, apply = false)
    @num = num
    @max = max
    # すぐに適用
    if apply
      @real_num = @num
      # ビットマップの更新
      update_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # ● ビットマップの更新
  #--------------------------------------------------------------------------
  def update_bitmap
    self.bitmap.clear
    # 数値を文字列の配列にする
    numbers = (@real_num.to_i.abs.to_s).split(//)
    # 数字の色
    sy = @num_height * number_color
    # ダメージ値の幅
    nw = @num_width * numbers.size + @spacing * (numbers.size - 1)
    # 描画 X 座標
    case @align
    when 0 ; bx = 0                            # 左揃え
    when 1 ; bx = (self.bitmap.width - nw) / 2 # 中央揃え
    when 2 ; bx = self.bitmap.width - nw       # 右揃え
    end
    # 数字を描画
    rect = Rect.new(0, sy, @num_width, @num_height)
    numbers.size.times do |n|
      rect.x = numbers[n].to_i * @num_width
      self.bitmap.blt(bx + @num_width * n + @spacing * n, 0, @src_bitmap, rect) 
    end
  end
end

#==============================================================================
# ■ [追加]:Sprite_StateIcon
#------------------------------------------------------------------------------
# 　バトルステータス：ステートアイコンをスクロール表示するスプライト。
#==============================================================================

class Sprite_StateIcon < Sprite_BattleStatus
  #--------------------------------------------------------------------------
  # ● [追加]:公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader :min_offset   # ステータス描画 X 座標の位置修正
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------  
  def initialize(battler, bufwindow, format, viewport = nil)
    super(viewport)
    @battler = battler
    @bufwindow = bufwindow
    @size = format[:size]
    @background_color = format[:background_color]
    @scroll_interval = format[:scroll_interval]
    @icons = [-128]
    self.visible = false
    # リフレッシュ
    refresh
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------  
  def dispose
    bitmap_dispose
    super
  end
  #--------------------------------------------------------------------------
  # ● ビットマップの解放
  #--------------------------------------------------------------------------  
  def bitmap_dispose
    self.visible = false
    self.bitmap.dispose if self.bitmap && !self.bitmap.disposed?
    self.bitmap = nil
  end
  #--------------------------------------------------------------------------
  # ● ステートアイコン配列の取得
  #--------------------------------------------------------------------------
  def icons
    @battler.state_icons + @battler.buff_icons
  end
  #--------------------------------------------------------------------------
  # ● ステートアイコン数の取得
  #--------------------------------------------------------------------------
  def icons_size
    @bufwindow.states(@battler, @bufwindow.contents_width)
  end
  #--------------------------------------------------------------------------
  # ● スクロールのリセット
  #--------------------------------------------------------------------------
  def reset_scroll
    self.src_rect.x = 0
  end
  #--------------------------------------------------------------------------
  # ● スクロールを進める
  #--------------------------------------------------------------------------
  def update_scroll
    self.src_rect.x += self.src_rect.width
    reset_scroll if self.src_rect.x >= self.bitmap.width
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    update_scroll if self.bitmap && Graphics.frame_count % @scroll_interval == 0
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------  
  def refresh
    i = icons
    return if @icons == i
    @icons = i
    i_size = icons_size
    # ビットマップの作成
    bitmap_dispose if self.bitmap && !self.bitmap.disposed?
    return if i_size == 0
    self.visible = true
    self.bitmap = Bitmap.new(i_size * 24, 24)
    self.src_rect.set(0, 0, @size * 24, 24)
    # バッファウィンドウにアイコンの描画
    @bufwindow.contents.clear
    @bufwindow.draw_actor_icons(@battler, 0, 0, @bufwindow.contents_width)
    # 描画したアイコンをビットマップに転送
    self.bitmap.fill_rect(self.bitmap.rect, @background_color) 
    self.bitmap.blt(0, 0, @bufwindow.contents, self.bitmap.rect) 
    @bufwindow.contents.clear
    reset_scroll
  end
end