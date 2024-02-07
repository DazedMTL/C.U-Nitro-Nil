 
#==============================================================================
#                   「近景スクリプト」(ACE) ver2.2
#
#   製作者：奈々（なな）
#   へぷたなすくろーる http://heptanas.mamagoto.com/
#
#   ◇使用規約
#   使用される場合はスクリプト作成者として「奈々」を明記して下さい。
#   このスクリプトを改変したり、改変したものを配布するなどは自由ですが
#   その場合も元のスクリプトの作成者として名前は載せて下さい。
#
#------------------------------------------------------------------------------
#
#   マップの遠景とは逆に、マップ手前に表示される「近景」を設定できます。
#   設定によってフォグや二重遠景なども表現可能です。
#   近景用の画像ファイルは遠景と同じくParallaxesフォルダに入れます。
#   
# ・マップのメモ欄に設定
#   <近景画像 ファイル名>
#   ：近景として表示する画像ファイルの指定
#   <近景ループ横 数値>
#   <近景ループ縦 数値>
#   ：ループと、自動スクロール速度の指定
#   ：遠景と同じなのでそちらを参考に（0でスクロールなしループ）
#   <近景不透明度 数値>
#   ：不透明度を0～255で指定、デフォルトは255
#   <近景合成方法 加算/減算>
#   ：合成方法を加算タイプや減算タイプに変更する
#   <近景表示位置 数値>
#   ：0    遠景の上、マップチップの下
#   ：1    マップチップの上、キャラチップの下
#   ：2    キャラチップの上、ピクチャの下（デフォルト値）
#   ：3    ピクチャの上、メッセージの下
#   
# ・イベントコマンドのスクリプトから変更
#   change_lid
#   ：近景を削除する
#
#   change_lid("ファイル名")
#   ：指定したファイルを近景として表示する
#
#   change_lid("ファイル名", ループ横, ループ縦)
#   ループの設定をしたい場合はスクロール速度を指定する。
#
#   change_lid("ファイル名", ループ横, ループ縦, 不透明度, 合成方法)
#   更に不透明度を0～255で、合成方法を「通常」「加算」「減算」で指定可能。
#   
#==============================================================================


module Cache
  #--------------------------------------------------------------------------
  # ● 近景グラフィックの取得
  #--------------------------------------------------------------------------
  def self.lid(filename)
    load_bitmap("Graphics/Parallaxes/", filename)
  end
end

class RPG::Map
  #--------------------------------------------------------------------------
  # ● 近景情報の取得
  #--------------------------------------------------------------------------
  def lid_name
    @note[/<近景画像\s?(\w+)>/] ? $1.to_s : ""
  end
  
  def lid_loop_x
    @note.include?("<近景ループ横")
  end
  def lid_loop_y
    @note.include?("<近景ループ縦")
  end

  def lid_sx
    @note[/<近景ループ横\s?([-]?\d+)>/] ? $1.to_i : 0
  end
  def lid_sy
    @note[/<近景ループ縦\s?([-]?\d+)>/] ? $1.to_i : 0
  end
  
  def lid_opacity
    @note[/<近景不透明度\s?(\d+)>/] ? $1.to_i : 255
  end
  def lid_blend_type
    if @note[/<近景合成方法\s?(加算|減算)>/]
      if $1.to_s == "加算"
        return 1
      else
        return 2
      end
    else
      return 0
    end
  end

  def lid_height_level
    @note[/<近景表示位置\s?(\d)>/] ? $1.to_i : 2
  end

end

class Game_Map
  attr_reader   :lid_name            # 近景 ファイル名
  attr_reader   :lid_opacity         # 近景 不透明度
  attr_reader   :lid_blend_type      # 近景 合成方法
  attr_reader   :lid_height_level    # 近景 表示位置
  #--------------------------------------------------------------------------
  # ● 遠景のセットアップ
  #--------------------------------------------------------------------------
  alias lid_setup_parallax setup_parallax
  def setup_parallax
    lid_setup_parallax
    setup_lid
  end
  #--------------------------------------------------------------------------
  # ● 近景のセットアップ
  #--------------------------------------------------------------------------
  def setup_lid
    @lid_name = @map.lid_name
    @lid_opacity = @map.lid_opacity
    @lid_blend_type = @map.lid_blend_type
    @lid_height_level = @map.lid_height_level
    @lid_loop_x = @map.lid_loop_x
    @lid_loop_y = @map.lid_loop_y
    @lid_sx = @map.lid_sx
    @lid_sy = @map.lid_sy
    @lid_x = 0
    @lid_y = 0
  end
  #--------------------------------------------------------------------------
  # ● 表示位置の設定
  #--------------------------------------------------------------------------
  alias lid_set_display_pos set_display_pos
  def set_display_pos(x, y)
    x = [0, [x, width - screen_tile_x].min].max unless loop_horizontal?
    y = [0, [y, height - screen_tile_y].min].max unless loop_vertical?
    lid_set_display_pos(x, y)
    @lid_x = x
    @lid_y = y
  end
  #--------------------------------------------------------------------------
  # ● 遠景表示の原点 X 座標の計算
  #--------------------------------------------------------------------------
  def lid_ox(bitmap)
    if @lid_loop_x
      @lid_x * 16
    else
      w1 = [bitmap.width - Graphics.width, 0].max
      w2 = [width * 32 - Graphics.width, 1].max
      @lid_x * 16 * w1 / w2
    end
  end
  #--------------------------------------------------------------------------
  # ● 遠景表示の原点 Y 座標の計算
  #--------------------------------------------------------------------------
  def lid_oy(bitmap)
    if @lid_loop_y
      @lid_y * 16
    else
      h1 = [bitmap.height - Graphics.height, 0].max
      h2 = [height * 32 - Graphics.height, 1].max
      @lid_y * 16 * h1 / h2
    end
  end
  #--------------------------------------------------------------------------
  # ● 下にスクロール
  #--------------------------------------------------------------------------
  def scroll_down(distance)
    if loop_vertical?
      @display_y += distance
      @display_y %= @map.height
      @parallax_y += distance if @parallax_loop_y
      @lid_y += distance if @lid_loop_y
    else
      last_y = @display_y
      @display_y = [@display_y + distance, height - screen_tile_y].min
      @parallax_y += @display_y - last_y
      @lid_y += @display_y - last_y
    end
  end
  #--------------------------------------------------------------------------
  # ● 左にスクロール
  #--------------------------------------------------------------------------
  def scroll_left(distance)
    if loop_horizontal?
      @display_x += @map.width - distance
      @display_x %= @map.width 
      @parallax_x -= distance if @parallax_loop_x
      @lid_x -= distance if @lid_loop_x
    else
      last_x = @display_x
      @display_x = [@display_x - distance, 0].max
      @parallax_x += @display_x - last_x
      @lid_x += @display_x - last_x
    end
  end
  #--------------------------------------------------------------------------
  # ● 右にスクロール
  #--------------------------------------------------------------------------
  def scroll_right(distance)
    if loop_horizontal?
      @display_x += distance
      @display_x %= @map.width
      @parallax_x += distance if @parallax_loop_x
      @lid_x += distance if @lid_loop_x
    else
      last_x = @display_x
      @display_x = [@display_x + distance, (width - screen_tile_x)].min
      @parallax_x += @display_x - last_x
      @lid_x += @display_x - last_x
    end
  end
  #--------------------------------------------------------------------------
  # ● 上にスクロール
  #--------------------------------------------------------------------------
  def scroll_up(distance)
    if loop_vertical?
      @display_y += @map.height - distance
      @display_y %= @map.height
      @parallax_y -= distance if @parallax_loop_y
      @lid_y -= distance if @lid_loop_y
    else
      last_y = @display_y
      @display_y = [@display_y - distance, 0].max
      @parallax_y += @display_y - last_y
      @lid_y += @display_y - last_y
    end
  end
  #--------------------------------------------------------------------------
  # ● 遠景の更新
  #--------------------------------------------------------------------------
  alias lid_update_parallax update_parallax
  def update_parallax
    lid_update_parallax
    update_lid
  end
  #--------------------------------------------------------------------------
  # ● 近景の更新
  #--------------------------------------------------------------------------
  def update_lid
    @lid_x += @lid_sx / 64.0 if @lid_loop_x
    @lid_y += @lid_sy / 64.0 if @lid_loop_y
  end
  #--------------------------------------------------------------------------
  # ● 近景の変更
  #--------------------------------------------------------------------------
  def change_lid(name, loop_x, loop_y, sx, sy, opacity, blend_type)
    @lid_name = name
    @lid_x = 0 if @lid_loop_x && !loop_x
    @lid_y = 0 if @lid_loop_y && !loop_y
    @lid_loop_x = loop_x
    @lid_loop_y = loop_y
    @lid_sx = sx
    @lid_sy = sy
    @lid_opacity = opacity
    @lid_blend_type = blend_type
  end
end

class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● 近景の変更
  #--------------------------------------------------------------------------
  def change_lid(name = "", loop_sx = false, loop_sy = false, opacity = 255, blend_type = "通常")
    if loop_sx
      loop_x = true
      sx = loop_sx
    else
      loop_x = false
      sx = 0
    end
    if loop_sy
      loop_y = true
      sy = loop_sy
    else
      loop_y = false
      sy = 0
    end
    if blend_type == "加算"
      blend_type = 1
    elsif blend_type == "減算"
      blend_type = 2
    else
      blend_type = 0
    end
    $game_map.change_lid(name, loop_x, loop_y, sx, sy, opacity, blend_type)
  end
end


class Spriteset_Map
  #--------------------------------------------------------------------------
  # ● 遠景の作成
  #--------------------------------------------------------------------------
  alias lid_create_parallax create_parallax
  def create_parallax
    lid_create_parallax
    create_lid
  end
  #--------------------------------------------------------------------------
  # ● 近景の作成
  #--------------------------------------------------------------------------
  def create_lid
    case $game_map.lid_height_level
    when 0
      @lid = Plane.new(@viewport1)
      @lid.z = -90
    when 1
      @lid = Plane.new(@viewport1)
      @lid.z = 10
    when 2
      @lid = Plane.new(@viewport1)
      @lid.z = 250
    when 3
      @lid = Plane.new(@viewport2)
      @lid.z = 120
    end
  end
  #--------------------------------------------------------------------------
  # ● 遠景の解放
  #--------------------------------------------------------------------------
  alias lid_dispose_parallax dispose_parallax
  def dispose_parallax
    lid_dispose_parallax
    dispose_lid
  end
  #--------------------------------------------------------------------------
  # ● 近景の解放
  #--------------------------------------------------------------------------
  def dispose_lid
    @lid.bitmap.dispose if @lid.bitmap
    @lid.dispose
  end
  #--------------------------------------------------------------------------
  # ● 遠景の更新
  #--------------------------------------------------------------------------
  alias lid_update_parallax update_parallax
  def update_parallax
    lid_update_parallax
    update_lid
  end
  #--------------------------------------------------------------------------
  # ● 近景の更新
  #--------------------------------------------------------------------------
  def update_lid
    if @lid_name != $game_map.lid_name
      @lid_name = $game_map.lid_name
      @lid.bitmap.dispose if @lid.bitmap
      @lid.bitmap = Cache.lid(@lid_name)
      Graphics.frame_reset
    end
    @lid.ox = $game_map.lid_ox(@lid.bitmap)
    @lid.oy = $game_map.lid_oy(@lid.bitmap)
    @lid.opacity = $game_map.lid_opacity
    @lid.blend_type = $game_map.lid_blend_type
  end
end
