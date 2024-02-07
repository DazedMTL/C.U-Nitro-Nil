#==============================================================================
# ★ RGSS3_アニメ付き明かり Ver1.02
#==============================================================================
=begin

作者：tomoaky
webサイト：ひきも記は閉鎖しました。 (http://hikimoki.sakura.ne.jp/)

キャラクタースプライトに拡大縮小アニメーション付きの明かりを追加表示します。

イベント実行内容の先頭に『注釈』コマンドで以下のタグを記述してください。
  <light ファイル名, 不透明度>
  例）<light red_light_s, 128>
  
　不透明度の後に座標の補正値を入力することで明かりの表示位置を
　ずらすことができます。
　例) <light red_light_s, 128, 0, -20>

動作に必要な画像
  Graphics/System/red_light_s.png
  Graphics/System/blue_light_s.png
  
2014.10.24  Ver1.02
  ・明かり設定のないイベントページに切り替えても明かりが消えない不具合を修正

2014.10.20  Ver1.01
  ・イベントページ切り替え時にエラー落ちする場合がある不具合を修正
  
2014.10.10  Ver1.0
  ・公開

=end

#==============================================================================
# □ 設定項目
#==============================================================================
module TMLIGHT
  # 明かり用サインテーブル（変更する必要はありません）
  SIN_30 = []
  30.times do |i|
    SIN_30[i] = Math.sin(Math::PI * i / 15) * 0.1 + 1.0
  end
end

#==============================================================================
# ■ Game_CharacterBase
#==============================================================================
class Game_CharacterBase
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :light_data               # 明かりデータ
  #--------------------------------------------------------------------------
  # ● 公開メンバ変数の初期化
  #--------------------------------------------------------------------------
  alias tmlight_game_characterbase_init_public_members init_public_members
  def init_public_members
    tmlight_game_characterbase_init_public_members
    @light_data = nil
  end
end

#==============================================================================
# ■ Game_Event
#==============================================================================
class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # ● イベントページのセットアップ
  #--------------------------------------------------------------------------
  alias tmlight_game_event_setup_page setup_page
  def setup_page(new_page)
    tmlight_game_event_setup_page(new_page)
    clear_light_settings
    setup_light_settings if @page
  end
  #--------------------------------------------------------------------------
  # ○ 明かりの設定をクリア
  #--------------------------------------------------------------------------
  def clear_light_settings
    @light_data = nil
  end
  #--------------------------------------------------------------------------
  # ○ 明かりの設定をセットアップ
  #--------------------------------------------------------------------------
  def setup_light_settings
    if @list
      @list.each do |list|
        if list.code == 108 || list.code == 408
          text = list.parameters[0]
          if /<light\s+(.+?)((?:\s*,\s*\-*\d+\s*)+)>/i =~ text
            @light_data = [$1]
            $2.scan(/\-*\d+/).each do |id|
              @light_data.push(id.to_i)
            end
          end
        else
          break
        end
      end
    end
  end
end

#==============================================================================
# ■ Sprite_Character
#==============================================================================
class Sprite_Character < Sprite_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     character : Game_Character
  #--------------------------------------------------------------------------
  alias tmlight_sprite_character_initialize initialize
  def initialize(viewport, character = nil)
    tmlight_sprite_character_initialize(viewport, character)
    @light_data = nil
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias tmlight_sprite_character_dispose dispose
  def dispose
    dispose_light
    tmlight_sprite_character_dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias tmlight_sprite_character_update update
  def update
    tmlight_sprite_character_update
    update_light
  end
  #--------------------------------------------------------------------------
  # ● 新しいエフェクトの設定
  #--------------------------------------------------------------------------
  alias tmlight_sprite_character_setup_new_effect setup_new_effect
  def setup_new_effect
    tmlight_sprite_character_setup_new_effect
    if @light_data != @character.light_data
      if @character.light_data
        @light_data = @character.light_data.clone
        start_light
      else
        @light_data = nil
        dispose_light
      end
    end
  end
  #--------------------------------------------------------------------------
  # ○ 明かり表示の開始
  #--------------------------------------------------------------------------
  def start_light
    dispose_light
    @light_sprite = Sprite_Light.new(viewport, *@light_data)
    update_light
  end
  #--------------------------------------------------------------------------
  # ○ 明かりの解放
  #--------------------------------------------------------------------------
  def dispose_light
    if @light_sprite
      @light_sprite.dispose
      @light_sprite = nil
    end
  end
  #--------------------------------------------------------------------------
  # ○ 明かりの更新
  #--------------------------------------------------------------------------
  def update_light
    if @light_sprite
      @light_sprite.update
      @light_sprite.x = x
      @light_sprite.x += @light_data[2] if @light_data[2]
      @light_sprite.y = y - 16
      @light_sprite.y += @light_data[3] if @light_data[3]
    end
  end
end

#==============================================================================
# □ Sprite_Light
#==============================================================================
class Sprite_Light < Sprite
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize(viewport, file_name, opacity, ox = 0, oy = 0)
    super(viewport)
    self.bitmap = Cache.system(file_name)
    self.opacity = opacity
    self.blend_type = 1
    self.z = 195
    self.ox = self.width / 2
    self.oy = self.height / 2
    @zoom_count = 0
    update
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @zoom_count += 1
    @zoom_count = 0 if @zoom_count == 30
    self.zoom_x = TMLIGHT::SIN_30[@zoom_count]
    self.zoom_y = self.zoom_x
  end
end

