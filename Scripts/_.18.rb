=begin
==============================================================================
天候拡張スクリプト Var1.00
Author：村人A
使用規約は下記URLを参照にしてください。
http://www.rpgmaker-script-wiki.xyz/kiyaku.php

不具合等ございましたらvillaa.contact@gmail.comまでお願いします。
==============================================================================
使用方法
イベントスクリプトで
chg_wtr(天候,強さ,変化時間,天候の色,x方向の速度,y方向の速度,回転,天候が透明になる時間,画面の色調)
と記述してください。
天候の色と画面の色調はそれぞれColorとToneを使用しています。
以下の例のように入力すると分かりやすく、スクリプトウィンドウからはみ出さずに済みます。

例１（赤い雨）
cl = Color.new(255, 0, 0, 255)
tn = [100,-100,-100]
chg_wtr(:rain,6,10,cl,-3,5,-20,10,tn)

例２（青い雪）
cl = Color.new(150, 150, 255, 255)
tn = [-20,-20,20]
chg_wtr(:snow,6,60,cl,0,1,1,10,tn)

例３（チラチラする光のような効果）
cl = Color.new(255, 255, 255, 255)
tn = [80,80,80]
chg_wtr(:storm,6,60,cl,0,0,25,3,tn)

・天候
この項目は:（コロン）の後に天候名を記述して下さい。
このスクリプトではデフォルトの雨「rain」、雪「snow」、嵐「storm」のみに対応して
います。

・強さ
天候スプライトを表示する頻度を指定します。
イベントで行う強さに対応しています。
スクリプトでは9を超えて設定することも出来ます。

・変化時間
指定した天候に変更するまでの時間（フレーム）を指定します。

・天候の色
雨や雪の粒の色を指定します。
Colorを使っているので「Color.new(赤, 緑, 青, 強さ)」で指定してください。

・x方向の速度
雨や雪の粒のx方向の速度を指定します。
小数点以下は無効です。

・y方向の速度
雨や雪の粒のy方向の速度を指定します。
小数点以下は無効です。

・回転
雨や雪の粒を回転させて表示させることが出来ます。
数値は角度を表します。
例えば30と記述すれば30度反時計回りに回転させた雨や雪の粒を表示させます。

・天候が透明になる時間
雨や雪の粒が発生してから透明になるまでのフレーム毎の速度を指定することが出来ます。
例）10と記述すればフレームごとに不透明度が10減ります


・画面の色調
天候を変化させたときの画面の色調を指定することが出来ます。
デフォルトの天候の変化では強さによって暗くなりましたが、このスクリプトでは配列で
指定することによって画面を任意の色にすることが出来ます。
[赤, 緑, 青]
で0～255の間で各要素を指定してください。

=end

#==============================================================================
# ■ Spriteset_Weather
#------------------------------------------------------------------------------
# 　天候エフェクト（雨、嵐、雪）のクラスです。このクラスは Spriteset_Map クラ
# スの内部で使用されます。
#==============================================================================
class Spriteset_Weather
  attr_accessor :is_change          # 天候が変わったか
  attr_accessor :set_power          # 天候の強さ
  attr_accessor :duration           # 画面色調変化時間
  attr_accessor :bit_color          # 天候の色
  attr_accessor :weather_x          # 天候のx方向の速度
  attr_accessor :weather_y          # 天候のy方向の速度
  attr_accessor :weather_rotation   # 天候の回転
  attr_accessor :weather_fade_speed # 天候の消える速さ
  attr_accessor :tone               # 画面の色調
  
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  #alias villa_initialize initialize
  alias villa_initialize initialize
  def initialize(viewport = nil)
    villa_initialize(viewport)
  end
  #--------------------------------------------------------------------------
  # ● パラメータが省略された場合の代入処理
  #--------------------------------------------------------------------------
  def param_nil_setting
    @bit_color = Color.new(255, 255, 255, 255) unless @bit_color
    @duration = 0           unless @duration
    @weather_x = 1          unless @weather_x
    @weather_y = 1          unless @weather_y
    @weather_fade_speed = 1 unless @weather_fade_speed
    @set_power = 0          unless @set_power
    @tone = [-6*@set_power,-6*@set_power,-6*@set_power]         unless @tone
    @now_tone = []
    @dimness = [0,0,0]
    @duration = 0           unless @duration
    @ct = 0
    @tone_changing = false
  end
  #--------------------------------------------------------------------------
  # ● 粒子の色 3
  #--------------------------------------------------------------------------
  def particle_color3
    Color.new(255, 255, 255, 255)
  end
  
  #--------------------------------------------------------------------------
  # ● 天候［雨］のビットマップを作成
  #--------------------------------------------------------------------------
  def create_rain_bitmap
    set_wheather_tone
    color = det_weather_color
    @rain_bitmap = Bitmap.new(7, 42)
    7.times {|i| @rain_bitmap.fill_rect(6-i, i*6, 1, 6, color) }
  end
  #--------------------------------------------------------------------------
  # ● 天候［嵐］のビットマップを作成
  #--------------------------------------------------------------------------
  def create_storm_bitmap
    set_wheather_tone
    color = det_weather_color
    @storm_bitmap = Bitmap.new(34, 64)
    32.times do |i|
      @storm_bitmap.fill_rect(33-i, i*2, 1, 2, color)
      @storm_bitmap.fill_rect(32-i, i*2, 1, 2, color)
      @storm_bitmap.fill_rect(31-i, i*2, 1, 2, color)
    end
  end
  #--------------------------------------------------------------------------
  # ● 天候［雪］のビットマップを作成
  #--------------------------------------------------------------------------
  def create_snow_bitmap
    set_wheather_tone
    color = det_weather_color
    @snow_bitmap = Bitmap.new(6, 6)
    @snow_bitmap.fill_rect(0, 1, 6, 4, color)
    @snow_bitmap.fill_rect(1, 0, 4, 6, color)
    @snow_bitmap.fill_rect(1, 2, 4, 2, color)
    @snow_bitmap.fill_rect(2, 1, 2, 4, color)
  end
  #--------------------------------------------------------------------------
  # ● メニュー時にも対応可能なようにトーンを設定
  #--------------------------------------------------------------------------
  def set_wheather_tone
    if $game_map.screen.weather_tone && !@tone
      tone = $game_map.screen.weather_tone
      @viewport.tone.set(tone[0], tone[1], tone[2])
    end
  end
  
  #--------------------------------------------------------------------------
  # ● パラメータが必要な天候を再描画
  #--------------------------------------------------------------------------
  def redraw_param_weather
    param_nil_setting
    @sprites.each {|sprite| sprite.angle = 0 }
    case @type
    when :rain
      create_rain_bitmap
    when :storm
      create_storm_bitmap
    when :snow
      create_snow_bitmap
    end
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias villa_dispose dispose
  def dispose
    villa_dispose
  end
  #--------------------------------------------------------------------------
  # ● 画面の更新
  #--------------------------------------------------------------------------
  def update_screen
    is_change_weather
    if @duration >= 0 && @tone_changing
      cul_arr =[]
      for i in 0..2
        cul_arr.push(@now_tone[i] + @dimness[i] * (@ct - @duration))
      end
      @viewport.tone.set(cul_arr[0], cul_arr[1], cul_arr[2])
      @tone_changing = false if @duration == 0
    end
  end
  #--------------------------------------------------------------------------
  # ● 色調移動の割合計算
  #--------------------------------------------------------------------------
  def set_dimness
    @dimness = []
    @ct = 0
    if @duration == 0
      @tone_changing = false
      @viewport.tone.set(@tone[0],@tone[1],@tone[2])
    else
      for i in 0..2
        @dimness.push((@tone[i] - @now_tone[i])/@duration)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 天候に変更があった時の処理
  #--------------------------------------------------------------------------
  def is_change_weather
    if @is_change
      redraw_param_weather
      $game_map.screen.weather_is_change = false
      convert_nowtone_array
      @tone_changing = true
      set_dimness
      @ct = @duration
      @is_change = false
      @wave_dir = nil
    end
  end
  #--------------------------------------------------------------------------
  # ● 現在のトーンの要素を配列に変換
  #--------------------------------------------------------------------------
  def convert_nowtone_array
    str = @viewport.tone.to_s
    str.slice!(0)
    str.slice!(str.size - 1)
    str_arr = str.split(", ")
    @now_tone = []
    str_arr.each{|ele| @now_tone.push(ele.to_f)}
  end
  #--------------------------------------------------------------------------
  # ● 天候の色を決定
  #--------------------------------------------------------------------------
  def det_weather_color
    #if @bit_color && @bit_color.class.to_s == "Color"
    if $game_map.screen.weather_bit_color
      return $game_map.screen.weather_bit_color
    else
      particle_color3
    end
  end
  #--------------------------------------------------------------------------
  # ● スプライトの更新
  #--------------------------------------------------------------------------
  def update_sprite(sprite)
    sprite.ox = @ox
    sprite.oy = @oy
    case @type
    when :rain
      update_spcial_sprite(sprite, @rain_bitmap)
    when :storm
      update_spcial_sprite(sprite, @storm_bitmap)
    when :snow
      update_spcial_sprite(sprite, @snow_bitmap)
    end
    create_new_particle(sprite) if sprite.opacity < 64
  end
  #--------------------------------------------------------------------------
  # ● スプライトの更新
  #--------------------------------------------------------------------------
  def update_spcial_sprite(sprite, bitmap)
    sprite.bitmap = bitmap
    sprite.x += @weather_x
    sprite.y += @weather_y
    sprite.angle = @weather_rotation
    rad = ( sprite.angle * Math::PI/ 180.0 )
    sprite.ox = @ox * Math.cos(rad) - @oy * Math.sin(rad)
    sprite.oy = @ox * Math.sin(rad) + @oy * Math.cos(rad)
    sprite.opacity -= @weather_fade_speed
  end
  #--------------------------------------------------------------------------
  # ● 新しい粒子の作成
  #--------------------------------------------------------------------------
  def create_new_particle(sprite)
    sprite.x = rand(Graphics.width + 100) - 100 + @ox
    sprite.y = rand(Graphics.height + 200) - 200 + @oy
    sprite.opacity = 160 + rand(96)
  end
end

#==============================================================================
# ■ Game_Screen
#------------------------------------------------------------------------------
# 　色調変更やフラッシュなど、画面全体に関係する処理のデータを保持するクラスで
# す。このクラスは Game_Map クラス、Game_Troop クラスの内部で使用されます。
#==============================================================================
class Game_Screen
  attr_accessor   :weather_is_change     # 天候 変更あったか
  attr_reader   :weather_set_power       # 天候 強さ
  attr_reader   :weather_duration        # 天候 変化時間
  attr_reader   :weather_bit_color       # 天候 色
  attr_reader   :weather_x               # 天候 x方向の速度
  attr_reader   :weather_y               # 天候 y方向の速度
  attr_reader   :weather_rotation        # 天候 回転
  attr_reader   :weather_fade_speed      # 天候 消える速度
  attr_reader   :weather_tone            # 天候 画面の色調
  #--------------------------------------------------------------------------
  # ● 天候の変更
  #--------------------------------------------------------------------------
  alias villa_change_weather change_weather
  def change_weather(weather, power, duration, color = Color.new(255, 255, 255, 255), x = 1, y = 1, rotation = 0, fade_speed = 10, tone = [0,0,0])
    villa_change_weather(weather, power, duration)
    @weather_set_power = power
    @weather_bit_color = color
    @weather_x = x
    @weather_y = y
    @weather_rotation = rotation
    @weather_fade_speed = fade_speed
    @weather_tone = tone
    @weather_is_change = true
  end
end

#==============================================================================
# ■ Spriteset_Map
#------------------------------------------------------------------------------
# 　マップ画面のスプライトやタイルマップなどをまとめたクラスです。このクラスは
# Scene_Map クラスの内部で使用されます。
#==============================================================================
class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● 天候の更新
  #--------------------------------------------------------------------------
  alias villa_update_weather update_weather
  def update_weather
    @weather.bit_color = $game_map.screen.weather_bit_color
    @weather.set_power = $game_map.screen.weather_set_power
    @weather.duration = $game_map.screen.weather_duration
    @weather.weather_x = $game_map.screen.weather_x
    @weather.weather_y = $game_map.screen.weather_y
    @weather.weather_rotation = $game_map.screen.weather_rotation
    @weather.weather_fade_speed = $game_map.screen.weather_fade_speed
    @weather.tone = $game_map.screen.weather_tone
    @weather.is_change = $game_map.screen.weather_is_change
    villa_update_weather
  end
end

class Game_Interpreter
  def chg_wtr(weather, power, duration, color = Color.new(255, 255, 255, 255), x = 1, y = 1, rotation = 0, fade_speed = 10, tone = [0,0,0])
    screen.change_weather(weather, power, duration, color, x, y, rotation, fade_speed, tone)
  end
end