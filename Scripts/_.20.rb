=begin

 ▼ 戦闘切り替えエフェクト ver. 3.0
 
 RPGツクールVXAce用スクリプト
 
 制作 : 木星ペンギン
 URL  : http://woodpenguin.blog.fc2.com/

------------------------------------------------------------------------------
 概要

 □ 戦闘突入時のエフェクトをオリジナルのものにします。
  ・とにかく重いので、適当に調整してください。
 
 □ 【オリジナルサブメニュー】と併用する場合、こちらを下にしてください。

------------------------------------------------------------------------------
 使い方
 
 □ フェードアウトエフェクト
  マップ画面から暗転までのエフェクトです。
  -1 : 暗転なし。
  0  : 通常のトランジションを行います。
  1  : 新たに設定したトランジションを行います。
  2  : 回転しながらアップになる演出を行います。
  3  : 幻影を残しながら、画面を縮小していきます。
  4  : いったん画面を縮小してから、プレイヤーを拡大します。
  5  : 波形描写を行います。
  6  : 画面を回転させながらぼかし効果を適用します。
  7  : 画面の拡大します。
  8  : 画面が割れて飛び散っていく演出を行います。
  9  : 画面が設定した方向から砕けていく演出を行います。
 
 □ フェードインエフェクト
  暗転した状態から戦闘画面までのエフェクトです。
  0 : 通常のフェードインを行います。
  1 : 通常のトランジションを行います。
  2 : 新たに設定したトランジションを行います。
  3 : 波形描写を行います。
  4 : 画面が割れて飛び散っていく演出を行います。
  5 : 画面が設定した方向から砕けていく演出を行います。
  
=end
module WdTk
module PrBtEff
#//////////////////////////////////////////////////////////////////////////////
#
# 設定項目
#
#//////////////////////////////////////////////////////////////////////////////
=begin #---------------------------------------------------------------------

    ● エフェクト共通の設定項目の説明
      :rate     : エフェクトの更新レートです。
                  数値が大きいほどFPSは下がりますが、処理が軽くなります。
                  1 以上の数値を設定してください。
      :time     : エフェクトにかける時間を設定できます。
                  60 で 1 秒です。
      :fadeout  : 最後にフェードアウトをかける時間です。未設定の場合は30。
      :fadein   : 戦闘開始時にフェードインをかける時間です。未設定の場合は30。
      :color    : フェードアウト時の色です。未設定の場合は黒。
      
=end #-----------------------------------------------------------------------
  OUTEFF = Array.new(10) { {} }
  INEFF  = Array.new(6) { {} }
  #--------------------------------------------------------------------------
  # ● フェードアウト設定
  #     OUT_VARIABLE : 変数を使用するかどうか
  #     OUT_INDEX    :
  #       変数を使用する場合、この番号の変数の値がエフェクトの番号になる。
  #       変数を使用しない場合、この数値がそのままエフェクトの番号になる。
  #--------------------------------------------------------------------------
  OUT_VARIABLE = false
  OUT_INDEX = 4
  
  #--------------------------------------------------------------------------
  # ● フェードアウト : エフェクト 0 の設定
  #     通常のトランジションを行います。
  #--------------------------------------------------------------------------
  # 設定項目  [:time, :color]
  OUTEFF[0][:time] = 60
  
  #--------------------------------------------------------------------------
  # ● フェードアウト : エフェクト 1 の設定
  #     新たに設定したトランジションを行います。
  #     :name : トランジションのファイル名です。
  #--------------------------------------------------------------------------
  # 設定項目  [:time, :color, :name]
  OUTEFF[1][:time] = 30
  OUTEFF[1][:name] = "BattleStart"
  
  #--------------------------------------------------------------------------
  # ● フェードアウト : エフェクト 2 の設定
  #     回転しながらアップになる演出を行います。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadeout, :color]
  OUTEFF[2][:rate]    = 3
  OUTEFF[2][:time]    = 120
  
  #--------------------------------------------------------------------------
  # ● フェードアウト : エフェクト 3 の設定
  #     幻影を残しながら、画面を縮小していきます。
  #     :dir   : 縮小をする方向です。テンキーの位置で指定します。
  #     :blur  : ブレの強さです。
  #     :angle : 回転角度です。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadeout, :color, :dir, :blur, :angle]
  OUTEFF[3][:rate]    = 2
  OUTEFF[3][:time]    = 90
  OUTEFF[3][:dir]     = 7
  OUTEFF[3][:blur]    = 16
  OUTEFF[3][:angle]   = 30
  
  #--------------------------------------------------------------------------
  # ● フェードアウト : エフェクト 4 の設定
  #     いったん画面を縮小してから、プレイヤーを拡大します。
  #     :angle : 回転角度です。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadeout, :color, :angle]
  OUTEFF[4][:rate]    = 3
  OUTEFF[4][:time]    = 60
  OUTEFF[4][:angle]   = 30
  
  #--------------------------------------------------------------------------
  # ● フェードアウト : エフェクト 5 の設定
  #     波形描写を行います。
  #     :amp    : 波形の振幅です。
  #     :length : 波形の周期です。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadeout, :color, :amp, :length]
  OUTEFF[5][:rate]    = 1
  OUTEFF[5][:time]    = 120
  OUTEFF[5][:amp]     = 64
  OUTEFF[5][:length]  = 60
  
  #--------------------------------------------------------------------------
  # ● フェードアウト : エフェクト 6 の設定
  #     画面を回転させながらぼかし効果を適用します。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadeout, :color]
  OUTEFF[6][:rate]    = 4
  OUTEFF[6][:time]    = 100
  
  #--------------------------------------------------------------------------
  # ● フェードアウト : エフェクト 7 の設定
  #     画面の拡大します。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadeout, :color]
  OUTEFF[7][:rate]    = 1
  OUTEFF[7][:time]    = 12
  OUTEFF[7][:fadeout] = 10
  OUTEFF[7][:color]   = Color.new(255, 255, 255)
  
  #--------------------------------------------------------------------------
  # ● フェードアウト : エフェクト 8 の設定
  #     画面が割れて飛び散っていく演出を行います。
  #     :side   : 画面を横に分割する数です。縦も同じ長さに設定されます。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadeout, :color, :side]
  OUTEFF[8][:rate]    = 1
  OUTEFF[8][:time]    = 180
  OUTEFF[8][:side]    = 12
  
  #--------------------------------------------------------------------------
  # ● フェードアウト : エフェクト 9 の設定
  #     画面が設定した方向から砕けていく演出を行います。
  #     :side   : 画面を横に分割する数です。縦も同じ長さに設定されます。
  #     :dir    : 画面が砕けていく方向。テンキーの位置(2, 4, 6, 8)で指定します。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadeout, :color, :side, :dir]
  OUTEFF[9][:rate]    = 1
  OUTEFF[9][:time]    = 100
  OUTEFF[9][:side]    = 17
  OUTEFF[9][:dir]     = 4
  
  
  #--------------------------------------------------------------------------
  # ● フェードイン設定
  #     IN_VARIABLE : 変数を使用するかどうか
  #     IN_INDEX    :
  #       変数を使用する場合、この番号の変数の値がエフェクトの番号になる。
  #       変数を使用しない場合、この数値がそのままエフェクトの番号になる。
  #--------------------------------------------------------------------------
  IN_VARIABLE = true
  IN_INDEX = 3
  
  #--------------------------------------------------------------------------
  # ● フェードイン : エフェクト 0 の設定
  #     通常のフェードインを行います。
  #--------------------------------------------------------------------------
  # 設定項目  [:time]
  INEFF[0][:time] = 10
  
  #--------------------------------------------------------------------------
  # ● フェードイン : エフェクト 1 の設定
  #     通常のトランジションを行います。
  #--------------------------------------------------------------------------
  # 設定項目  [:time]
  INEFF[1][:time] = 15
  
  #--------------------------------------------------------------------------
  # ● フェードイン : エフェクト 2 の設定
  #     新たに設定したトランジションを行います。
  #     :name : トランジションのファイル名です。
  #--------------------------------------------------------------------------
  # 設定項目  [:time, :name]
  INEFF[2][:time] = 15
  INEFF[2][:name] = "BattleStart"
  
  #--------------------------------------------------------------------------
  # ● フェードイン : エフェクト 3 の設定
  #     波形描写を行います。
  #     :amp    : 波形の振幅です。
  #     :length : 波形の周期です。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadein, :color, :amp, :length]
  INEFF[3][:rate]   = 1
  INEFF[3][:time]   = 80
  INEFF[3][:amp]    = 64
  INEFF[3][:length] = 60
  
  #--------------------------------------------------------------------------
  # ● フェードイン : エフェクト 4 の設定
  #     画面が割れて飛び散っていく演出を行います。
  #     :side   : 画面を横に分割する数です。縦も同じ長さに設定されます。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadein, :color, :side]
  INEFF[4][:rate]   = 1
  INEFF[4][:time]   = 150
  INEFF[4][:fadein] = 150
  INEFF[4][:side]   = 12
  
  #--------------------------------------------------------------------------
  # ● フェードイン : エフェクト 5 の設定
  #     画面が設定した方向から砕けていく演出を行います。
  #     :side   : 画面を横に分割する数です。縦も同じ長さに設定されます。
  #     :dir    : 画面が砕けていく方向。テンキーの位置(2, 4, 6, 8)で指定します。
  #--------------------------------------------------------------------------
  # 設定項目  [:rate, :time, :fadein, :color, :side, :dir]
  INEFF[5][:rate]   = 1
  INEFF[5][:time]   = 100
  INEFF[5][:fadein] = 100
  INEFF[5][:side]   = 17
  INEFF[5][:dir]    = 4
  
  
#//////////////////////////////////////////////////////////////////////////////
#
# 以降、変更する必要なし
#
#//////////////////////////////////////////////////////////////////////////////

  def self.snapshot_for_effect
    @effect_bitmap = Graphics.snap_to_bitmap
  end
  def self.dispose_effect_bitmap
    @effect_bitmap.dispose if @effect_bitmap
    @effect_bitmap = nil
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの作成
  #--------------------------------------------------------------------------
  def self.create_main_viewport
    @viewport = Viewport.new
    @viewport.z = 500
  end
  #--------------------------------------------------------------------------
  # ● ビューポートの解放
  #--------------------------------------------------------------------------
  def self.dispose_main_viewport
    @viewport.dispose
    @viewport = nil
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新（フェードアウト用）
  #--------------------------------------------------------------------------
  def self.update_fadeout(i, d)
    Graphics.update
    @viewport.color.alpha = 255 - 255 * (180 - i) / d if d > 0
    @viewport.update
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新（フェードイン用）
  #--------------------------------------------------------------------------
  def self.update_fadein(i, d)
    @viewport2.color.alpha = 255 - 255 * i / d if d > 0
    Graphics.update
  end
  #--------------------------------------------------------------------------
  # ● フェードアウト実行
  #--------------------------------------------------------------------------
  def self.perform_fadeout
    index = OUT_VARIABLE ? $game_variables[OUT_INDEX] : OUT_INDEX
    params = OUTEFF[index]
    return fadeout_transition({}) unless params
    return if index < 0
    return fadeout_transition(params) if index == 0 || index == 1
    create_main_viewport
    @viewport.color.set(params[:color]) if params[:color]
    @viewport.color.alpha = 0
    effect_sprites = []
    Graphics.transition(0)
    Graphics.frame_rate = 60 / params[:rate]
    step = params[:rate] * 180.0 / params[:time]
    dur = 180 * (params[:fadeout] || 30) / params[:time]
    case index
    when 2
      0.step(180, step) do |i|
        sprite = make_effect_sprite1
        sprite.angle = 2 * i
        sprite.opacity = (i == 0 ? 255 : params[:rate] * 8 + 8)
        update_effect_size(sprite, 1.0 + 0.01 * i)
        effect_sprites << sprite
        update_fadeout(i, dur)
      end
    when 3
      type = params[:dir] - 1
      tx = Graphics.width  * (type % 3 == 0 ? 1 : type % 3 == 2 ? 5 : 3) / 6
      ty = Graphics.height * (type / 3 == 0 ? 5 : type / 3 == 2 ? 1 : 3) / 6
      opacity = params[:rate] * 8 + 16
      0.step(180, step) do |i|
        if effect_sprites.size > params[:blur]
          sprite = effect_sprites.shift
        else
          sprite = make_effect_sprite1
        end
        sprite.x = Graphics.width / 2 - (Graphics.width / 2 - tx) * i / 180
        sprite.y = Graphics.height / 2 - (Graphics.height / 2 - ty) * i / 180
        sprite.z = i
        sprite.angle = params[:angle] * i / 180
        d = (i > 90 ? (180 - i) : 90)
        sprite.opacity = (255 - i) * d / 90
        effect_sprites.last.opacity = opacity * d / 90 unless effect_sprites.empty?
        update_effect_size(sprite, 0.2 + 0.8 * (180 - i) ** 2 / 180 ** 2)
        effect_sprites << sprite
        update_fadeout(i, dur)
      end
    when 4
      tx = $game_player.screen_x
      ty = $game_player.screen_y - 20
      opacity = params[:rate] * 8 + 8
      0.step(180, step) do |i|
        sprite = make_effect_sprite1
        sprite.x = tx + (Graphics.width / 2 - tx) * i / 180
        sprite.y = ty + (Graphics.height / 2 - ty) * i / 180
        sprite.z = i
        sprite.ox = tx
        sprite.oy = ty
        sprite.angle = params[:angle] * i / 180
        sprite.opacity = (i == 0 ? 255 : opacity)
        m = 60 ** 2 - 30 ** 2 + (30 - i) ** 2
        update_effect_size(sprite, 1.0 * m / 60 ** 2, 1.2)
        effect_sprites << sprite
        update_fadeout(i, dur)
      end
    when 5
      effect_sprites << make_effect_sprite1 << make_effect_sprite1
      effect_sprites[1].opacity = 64
      effect_sprites[1].wave_length = params[:length]
      0.step(180, step) do |i|
        d = 180 ** 2 - (180 - i) ** 2
        effect_sprites[1].wave_amp = params[:amp] * d / 180 ** 2
        effect_sprites[1].wave_speed = i * 5
        effect_sprites[1].opacity += 1
        effect_sprites[1].update
        update_fadeout(i, dur)
      end
    when 6
      effect_sprites << make_effect_sprite1
      0.step(180, step) do |i|
        @effect_bitmap.radial_blur(i / 3, 1)
        update_fadeout(i, dur)
      end
    when 7
      effect_sprites << make_effect_sprite1
      0.step(180, step) do |i|
        sprite = make_effect_sprite1
        sprite.opacity = 32
        sprite.zoom_x = sprite.zoom_y = 1.0 + 2.0 * i / 180
        effect_sprites << sprite
        update_fadeout(i, dur)
      end
    when 8
      effect_data = {}
      max = 32 * params[:time] / 180
      make_break_sprites1(params[:side]).each do |sprite|
        effect_sprites << sprite
        effect_data[sprite] = make_effect_data1(sprite, max)
      end
      Graphics.wait(8)
      0.step(180, step) do |i|
        update_break_effect1(effect_data, params[:time], i)
        update_fadeout(i, dur)
      end
    when 9
      effect_data = {}
      max = 24 * params[:time] / 180
      make_break_sprites1(params[:side]).each do |sprite|
        effect_sprites << sprite
        effect_data[sprite] = make_effect_data2(sprite, max, params[:dir])
      end
      0.step(180, step) do |i|
        update_break_effect2(effect_data, i, params[:dir])
        update_fadeout(i, dur)
      end
    end
    snapshot_for_effect
    Graphics.freeze
    Graphics.frame_rate = 60
    dispose_main_viewport
    effect_sprites.each {|sprite| sprite.dispose }
  end
  #--------------------------------------------------------------------------
  # ● フェードイン実行
  #--------------------------------------------------------------------------
  def self.perform_fadein
    return unless @effect_bitmap
    index = IN_VARIABLE ? $game_variables[IN_INDEX] : IN_INDEX
    params = INEFF[index]
    return Graphics.transition(10) unless params
    return Graphics.transition(params[:time]) if index == 0
    if index == 1 || index == 2
      name = params[:name] || "BattleStart"
      Graphics.transition(params[:time], "Graphics/System/" << name, 100)
      return
    end
    create_main_viewport
    @viewport2 = Viewport.new
    @viewport2.z = 450
    @viewport2.color.set(params[:color]) if params[:color]
    @viewport2.color.alpha = 0
    Graphics.transition(0)
    Graphics.frame_rate = 60 / params[:rate]
    effect_sprites = []
    step = params[:rate] * 180.0 / params[:time]
    dur = 180 * (params[:fadein] || 30) / params[:time]
    case index
    when 3
      effect_sprites << make_back_sprite(@viewport2)
      effect_sprites[0].wave_length = params[:length]
      effect_sprites << make_effect_sprite1
      effect_sprites[1].z += 1
      0.step(180, step) do |i|
        m = 180 ** 2
        d = m - i ** 2
        effect_sprites[0].wave_amp = params[:amp] * d / m
        effect_sprites[0].wave_speed = (180 - i) * 5
        effect_sprites[0].opacity = (180 - i) * 3 / 2
        effect_sprites[0].update
        effect_sprites[1].opacity = 255 - 255 * i / 60
        update_fadein(i, dur)
      end
    when 4
      effect_data = {}
      max = 32 * params[:time] / 180
      make_break_sprites1(params[:side]).each do |sprite|
        effect_sprites << sprite
        effect_data[sprite] = make_effect_data1(sprite, max)
      end
      0.step(180, step) do |i|
        update_break_effect1(effect_data, params[:time], i)
        effect_data.each_key {|sprite| sprite.opacity = (180 - i) * 4 }
        update_fadein(i, dur)
      end
    when 5
      effect_data = {}
      max = 24 * params[:time] / 180
      make_break_sprites1(params[:side]).each do |sprite|
        effect_sprites << sprite
        effect_data[sprite] = make_effect_data2(sprite, max, params[:dir])
      end
      0.step(180, step) do |i|
        update_break_effect2(effect_data, i, params[:dir])
        effect_data.each_key {|sprite| sprite.opacity = (180 - i) * 8 }
        update_fadein(i, dur)
      end
    end
    dispose_main_viewport
    @viewport2.dispose
    dispose_effect_bitmap
    effect_sprites.each {|sprite| sprite.dispose }
    Graphics.frame_rate = 60
    Graphics.frame_reset
  end
  #--------------------------------------------------------------------------
  # ● エフェクトスプライトの作成 1
  #--------------------------------------------------------------------------
  def self.make_effect_sprite1
    sprite = Sprite.new(@viewport)
    sprite.bitmap = @effect_bitmap
    sprite.x = sprite.ox = Graphics.width / 2
    sprite.y = sprite.oy = Graphics.height / 2
    sprite
  end
  #--------------------------------------------------------------------------
  # ● エフェクトの大きさ設定
  #--------------------------------------------------------------------------
  def self.update_effect_size(sprite, zoom, rate = 1.0)
    sprite.zoom_x = sprite.zoom_y = zoom
    if zoom > 1
      w =  (@effect_bitmap.width / zoom * rate).to_i / 2
      h =  (@effect_bitmap.height / zoom * rate).to_i / 2
      cx = [sprite.ox - w, 0].max
      cy = [sprite.oy - h, 0].max
      cw = [sprite.ox + w, @effect_bitmap.width].min - cx
      ch = [sprite.oy + h, @effect_bitmap.height].min - cy
      sprite.ox += sprite.src_rect.x - cx
      sprite.oy += sprite.src_rect.y - cy
      sprite.src_rect.set(cx, cy, cw, ch)
      Graphics.frame_reset
    end
  end
  #--------------------------------------------------------------------------
  # ● 画面破壊用エフェクト準備 1
  #--------------------------------------------------------------------------
  def self.make_break_sprites1(side)
    sprites = []
    rect = Rect.new
    height = Graphics.width / side
    row = (Graphics.height + height / 2) / height
    side.times do |x| row.times do |y|
      rect.x = Graphics.width * x / side
      rect.y = Graphics.height * y / row
      rect.width = Graphics.width * (x + 1) / side - rect.x
      rect.height = Graphics.height * (y + 1) / row - rect.y
      sprites << make_effect_sprite2(rect, 0)
      sprites << make_effect_sprite2(rect, 2)
    end; end
    Graphics.frame_reset
    sprites
  end
  #--------------------------------------------------------------------------
  # ● エフェクトスプライトの作成 2
  #--------------------------------------------------------------------------
  def self.make_effect_sprite2(rect, pos)
    sprite = Sprite.new(@viewport)
    sprite.bitmap = Bitmap.new(rect.width, rect.height)
    sprite.bitmap.blt(0, 0, @effect_bitmap, rect)
    d = [rect.width, rect.height].max
    if pos == 0
      d.times {|i| sprite.bitmap.clear_rect(rect.width * (d - i) / d, i, i, 1) }
    else
      d.times {|i| sprite.bitmap.clear_rect(0, i, rect.width * (d - i) / d, 1) }
    end
    sprite.ox = rect.width * (pos + 1) / 4
    sprite.oy = rect.height * (pos + 1) / 4
    sprite.x = rect.x + sprite.ox
    sprite.y = rect.y + sprite.oy
    sprite
  end
  #--------------------------------------------------------------------------
  # ● 背景スプライトの作成
  #--------------------------------------------------------------------------
  def self.make_back_sprite(viewport)
    sprite = Sprite.new(viewport)
    sprite.bitmap = Graphics.snap_to_bitmap
    sprite
  end
  #--------------------------------------------------------------------------
  # ● エフェクトデータの作成 1
  #--------------------------------------------------------------------------
  def self.make_effect_data1(sprite, max)
    result = [rand(3)] # ウェイト
    sx = sprite.x - Graphics.width / 2
    sy = sprite.y - Graphics.height / 2
    result[1] = Math.asin(1 - Math.hypot(sx, sy) / 360) * rand(6) ** 2 / 10 + 1 # 拡大率
    rate = 3.5
    result[1] = rate = 20.0 if result[1] > 2.5 && rand(3) == 0
    result[2] = (sx - rand(17) + 8) * rate + Graphics.width / 2 # 移動先 X
    result[3] = sprite.x - result[2] # X 軸移動距離
    result[4] = (sy - rand(13) + 6) * rate + Graphics.height / 2 # 移動先 Y
    result[5] = sprite.y - result[4] # Y 軸移動距離
    result[6] = (rand(max) + 1) * (rand(2) == 0 ? 1 : -1) / 4.0 # 回転
    result[7] = (rand(max) + 1) * (rand(2) == 0 ? 1 : -1) / 4.0 # X 軸回転
    result[8] = rand(max + 1) * (rand(2) == 0 ? 1 : -1) / 4.0 # Y 軸回転
    result[9] = sprite.ox # X 軸原点記憶
    result
  end
  #--------------------------------------------------------------------------
  # ● 破壊エフェクトの更新 1
  #--------------------------------------------------------------------------
  def self.update_break_effect1(effect_data, time, i)
    if i < 90
      d = (45 ** 2 - (i - 45) ** 2) / 40
    else
      d = (90 - i) * 2
    end
    d *= time / 180.0
    effect_data.each do |sprite, data|
      m = i - data[0]
      next if m <= 0
      zoom = data[1] - (data[1] - 1) * (179 - m) ** 2 / 180 ** 2
      next sprite.visible = false if zoom > 6
      sprite.x = data[2] + data[3] * (179 - m) ** 2 / 180 ** 2
      sprite.y = data[4] + data[5] * (179 - m) ** 2 / 180 ** 2
      sprite.y -= d * zoom if data[1] < 16
      sprite.z = data[1] * 100
      spin_set_sprite(sprite, m, zoom, data)
    end
  end
  #--------------------------------------------------------------------------
  # ● スプライト回転
  #--------------------------------------------------------------------------
  def self.spin_set_sprite(sprite, i, zoom, data)
    zoom_x = zoom * Math.cos(i * data[7] * Math::PI / 180)
    zoom_y = zoom * Math.cos(i * data[8] * Math::PI / 180)
    sprite.mirror = (zoom_x < 0) != (zoom_y < 0)
    sprite.ox = sprite.mirror ? sprite.width - data[9] : data[9]
    sprite.zoom_x = zoom_x.abs
    sprite.zoom_y = zoom_y.abs
    sprite.angle = i * data[6] + (zoom_y < 0 ? 180 : 0)
  end
  #--------------------------------------------------------------------------
  # ● エフェクトデータの作成 2
  #--------------------------------------------------------------------------
  def self.make_effect_data2(sprite, max, dir)
    result = []
    case dir
    when 2; wait = 90 - 90 * sprite.y / Graphics.height
    when 4; wait = 90 * sprite.x / Graphics.width
    when 6; wait = 90 - 90 * sprite.x / Graphics.width
    when 8; wait = 90 * sprite.y / Graphics.height
    end
    result[0] = wait + rand(5) - 5 # ウェイト
    sx = sprite.x - Graphics.width / 2
    sy = sprite.y - Graphics.height / 2
    rate = 2.0 - result[0] / 90.0
    result[1] = 1.5 # 拡大率
    result[2] = sprite.x # 現在 X
    result[4] = sprite.y # 現在 Y
    case dir
    when 2
      result[3] = (sprite.x - Graphics.width / 2) / 2 # X 軸移動距離
      result[5] = Graphics.height * rate # Y 軸移動距離
    when 4
      result[3] = -Graphics.width * rate # X 軸移動距離
      result[5] = (sprite.y - Graphics.height / 2) / 2 # Y 軸移動距離
    when 6
      result[3] = Graphics.width * rate # X 軸移動距離
      result[5] = (sprite.y - Graphics.height / 2) / 2 # Y 軸移動距離
    when 8
      result[3] = (sprite.x - Graphics.width / 2) / 2 # X 軸移動距離
      result[5] = -Graphics.height * rate # Y 軸移動距離
    end
    result[6] = (rand(max) + 1) * (rand(2) == 0 ? 1 : -1) / 4.0 # 回転
    result[7] = (rand(max) + 1) * (rand(2) == 0 ? 1 : -1) / 4.0 # X 軸回転
    result[8] = rand(max + 1) * (rand(2) == 0 ? 1 : -1) / 4.0 # Y 軸回転
    result[9] = sprite.ox # X 軸原点記憶
    result
  end
  #--------------------------------------------------------------------------
  # ● 破壊エフェクトの更新 2
  #--------------------------------------------------------------------------
  def self.update_break_effect2(effect_data, i, dir)
    effect_data.each do |sprite, data|
      m = i - data[0]
      next if m <= 0
      next sprite.visible = false if m > 90
      zoom = data[1] - (data[1] - 1) * (90 - m) ** 2 / 90 ** 2
      next sprite.visible = false if zoom > 6
      case dir
      when 2, 8
        sprite.x = data[2] + data[3] * m / 90
        sprite.y = data[4] + data[5] * m ** 2 / 90 ** 2
      when 4, 6
        sprite.x = data[2] + data[3] * m ** 2 / 90 ** 2
        sprite.y = data[4] + data[5] * m / 90
      end
      spin_set_sprite(sprite, m, zoom, data)
    end
  end
  #--------------------------------------------------------------------------
  # ● 画面破壊用エフェクト準備 2
  #--------------------------------------------------------------------------
  def self.make_break_sprites2
    base = [$game_player.screen_x, $game_player.screen_y - 20]
    pos_data = []
    r = 2 * Math::PI / 8
    8.times do |i|
      radian = r * i
      pos = base
      begin
        d = rand(100) + 50
        r2 = radian + radian * (rand * 0.8 - 0.4)
        pos[0] -= d * Math.sin(r2)
        pos[1] -= d * Math.cos(r2)
        
        
      end while pos[0].between?(0, Graphics.width) &&
                pos[1].between?(0, Graphics.height)
    end
    
    sprites = []
    sprites
  end
  #--------------------------------------------------------------------------
  # ● トランジション実行 [フェードアウト]
  #--------------------------------------------------------------------------
  def self.fadeout_transition(params)
    d     = params[:time] || 60
    name  = params[:name] || "BattleStart"
    color = params[:color] || Color.new(0, 0, 0, 255)
    create_main_viewport
    @viewport.color.set(color)
    Graphics.transition(d, "Graphics/System/" << name, 100)
    Graphics.freeze
    snapshot_for_effect
    dispose_main_viewport
  end
end

  @material ||= []
  @material << :PrBtEff
  def self.include?(sym)
    @material.include?(sym)
  end

end

#==============================================================================
# ■ Scene_Map
#==============================================================================
class Scene_Map
  #--------------------------------------------------------------------------
  # ◯ 終了前処理
  #--------------------------------------------------------------------------
  alias _wooden_prebteff_pre_terminate pre_terminate
  def pre_terminate
    WdTk::PrBtEff.snapshot_for_effect if SceneManager.scene_is?(Scene_Battle)
    _wooden_prebteff_pre_terminate
  end
  #--------------------------------------------------------------------------
  # ☆ 戦闘前トランジション実行
  #--------------------------------------------------------------------------
  def perform_battle_transition
    WdTk::PrBtEff.perform_fadeout
  end
end

#==============================================================================
# ■ Scene_Battle
#==============================================================================
class Scene_Battle
  #--------------------------------------------------------------------------
  # ☆ トランジション実行
  #--------------------------------------------------------------------------
  def perform_transition
    return if $BTEST
    WdTk::PrBtEff.perform_fadein
    WdTk::PrBtEff.dispose_effect_bitmap
    GC.start
  end
end

if WdTk.include?(:SubMenu)
#==============================================================================
# ■ Scene_ExSubMenu
#==============================================================================
class Scene_ExSubMenu
  #--------------------------------------------------------------------------
  # ◯ 終了前処理
  #--------------------------------------------------------------------------
  alias _wooden_prebteff_pre_terminate pre_terminate
  def pre_terminate
    WdTk::PrBtEff.snapshot_for_effect if SceneManager.scene_is?(Scene_Battle)
    _wooden_prebteff_pre_terminate
  end
  #--------------------------------------------------------------------------
  # ☆ 戦闘前トランジション実行
  #--------------------------------------------------------------------------
  def perform_battle_transition
    WdTk::PrBtEff.perform_fadeout
  end
end
end