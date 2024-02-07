#******************************************************************************
#
#   ＊ メッセージ機能拡張 ＊
#
#                       for RGSS3
#
#        Ver 1.00   2012.09.16
#        Ver 1.01   2014.01.06  自動モードの不具合修正
#        Ver 1.02   2014.12.16  背景黒が非表示にならない不具合を修正
#        Ver 1.03   2014.12.27  ウィンドウ非表示モードの不具合を修正
#        Ver 1.04   2015.01.06  前回の制御タグがクリアされない不具合を修正
#
#   ◆注意事項
#     ※この素材は「共通セーブファイル」スクリプトが必要になります。
#
#
#   ◆機能説明
#
#     １．追加された制御文字で、立ち絵を左・中央・右に表示できます。
#
#     ２．追加された制御文字で、音声を再生できます。
#
#     ３．追加された制御文字で、ＳＥを再生できます。
#
#     ４．追加された制御文字でＣＧの表示ができます。
#
#     ５．上記機能をスクリプトからも実行できます。
#
#     ６．コンフィグ項目で指定したボタンで、メッセージ枠を一時消去できます。
#
#     ７．コンフィグ項目で指定したボタンで、自動改ページモードに移行できます。
#
#     ８．シーンスキップに設定したゲームスイッチをオンにすると、コンフィグ
#         項目で設定したボタンを押すことでスキップ先ラベルまでスキップできます。
#
#
#   ◆使い方
#     http://hime.be/rgss3/sozai/message_manual.txt をご覧ください。
#
#
#   提供者：睡工房　http://hime.be/
#
#******************************************************************************


#==============================================================================
# コンフィグ項目
#==============================================================================
module SUI
module MESSAGE
  # 左側・中央・右側に表示する立ち絵のX座標（絵の左上を基準とします）
  LEFT_X    = 0      # 左側
  CENTER_X  = 180    # 中央
  RIGHT_X   = 360    # 右側
  
  # 立ち絵の表示に使用するピクチャ番号
  LEFT_PIC    = 5    # 左側
  CENTER_PIC  = 6    # 中央
  RIGHT_PIC   = 7    # 右側
  
  # ＣＧの表示に使用するピクチャ番号
  CG_PIC      = 8
  
  # メッセージウィンドウの消去に割り当てるボタンを設定
  # Input::A　の形式で指定
  BTN_HIDE = :Z
  
  # シーンスキップのボタンを設定
  # Input::X　の形式で指定
  BTN_RETURN = :X
  
  # 自動改ページのボタンを設定
  # Input::Y　の形式で指定
  BTN_AUTO_MODE = :Y
  
  # 立ち絵の保存場所（"Graphics/Pictures/"からの相対パスを指定"）
  #SURFACE_DIR = "Surface/"
  SURFACE_DIR = ""
  
  # ＣＧファイルの保存場所（"Graphics/Pictures/"からの相対パスを指定"）
  #CG_DIR = "CG/"
  CG_DIR = ""
  
  # ボイスファイルの保存場所
  #VOICE_DIR = "Audio/SE/Voice/"
  VOICE_DIR = "Audio/SE/"
  
  # イベントスキップのフラグ（ゲームスイッチの番号指定）
  # このゲームスイッチがオンの時、直近のスキップ先ラベルまでスキップします。
  SW_SKIP_ON = 51
  
  # イベントスキップ先として認識するラベル名
  SKIP_LABEL = "イベントスキップ先"
  
  # 自動改ページの待ち時間（フレーム数を指定）
  # 左から「遅い」，「普通」，「速い」の順に設定します。
  # ※オプション画面スクリプトが未導入の場合、「普通」のみ有効になります。
  AUTO_WAIT = [180, 120, 60]
end
end
#==============================================================================
# 設定完了
#==============================================================================



class Window_Message < Window_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias sui_message_initialize initialize
  def initialize
    sui_message_initialize
    @hide_mode = false          # ウィンドウ消去モード
    @auto_mode = false          # 自動改ページモード
    @auto_count = 0
    create_auto_message
    SUI::MESSAGE::SKIP["skip"] = false
  end
  #--------------------------------------------------------------------------
  # ● 解放
  #--------------------------------------------------------------------------
  alias sui_message_dispose dispose
  def dispose
    sui_message_dispose
    @auto_message.bitmap.dispose
    @auto_message.dispose
  end
  #--------------------------------------------------------------------------
  # ● フラグのクリア
  #--------------------------------------------------------------------------
  alias sui_message_clear_flags clear_flags
  def clear_flags
    sui_message_clear_flags
    @hide_mode = false          # ウィンドウ消去モード
  end
  #--------------------------------------------------------------------------
  # ● オートモードの通知メッセージ作成
  #--------------------------------------------------------------------------
  def create_auto_message
    @auto_message = Sprite.new
    @auto_message.x = Graphics.width
    @auto_message.y = 3
    @auto_message.bitmap = Bitmap.new(140, 15)
    @auto_message.bitmap.font.size = 15
    @auto_message.bitmap.gradient_fill_rect(0, 6, 140, 9, Color.new(128, 128, 128, 0), Color.new(128, 128, 128, 180), true)
    @auto_message.bitmap.draw_text(0, 0, @auto_message.bitmap.width, 15, "自動改ページモード", 1)
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias sui_message_update update
  def update
    if @auto_mode and (Input::trigger?(SUI::MESSAGE::BTN_AUTO_MODE) || Input.trigger?(:B) || Input.trigger?(:C))
      @auto_mode = false
      Input.update
    end
    @auto_message.x += 10 if !@auto_mode and @auto_message.x < Graphics.width
    sui_message_update unless update_hide_auto
  end
  #--------------------------------------------------------------------------
  # ● 入力処理
  #--------------------------------------------------------------------------
  def update_hide_auto
    if $game_message.choice?
      return update_hide([self, @choice_window])
    elsif $game_message.num_input?
      return update_hide([self, @number_window])
    elsif $game_message.item_choice?
      return update_hide([self, @item_window])
    else
      return update_hide([self]) unless @pause_skip
    end
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ消去モードの更新
  #--------------------------------------------------------------------------
  def update_hide(windows)
    if @hide_mode
      if Input.trigger?(:C) or Input.trigger?(SUI::MESSAGE::BTN_HIDE)
        @hide_mode = false
        windows.each do |window|
          window.visible = true
        end
      end
      return true
    else
      if Input.trigger?(SUI::MESSAGE::BTN_HIDE) && $game_message.busy?
        @hide_mode =true
        @back_sprite.visible = false
        windows.each do |window|
          window.visible = false
        end
        return true
      end
    return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 入力待ち処理 ※再定義
  #--------------------------------------------------------------------------
  def input_pause
    self.pause = true
    wait(10)
    Fiber.yield until auto_mode || Input.trigger?(:B) || Input.trigger?(:C)
    Input.update
    self.pause = false
  end
  #--------------------------------------------------------------------------
  # ● メッセージ自動送り＆スキップ確認
  #--------------------------------------------------------------------------
  def auto_mode
    if @auto_mode
      @auto_count = SUI::MESSAGE::AUTO_WAIT[SUI::OPTION.auto_wait] if @auto_count == 0
      @auto_count -= 1
      @auto_message.x -= 10 if  @auto_message.x > Graphics.width - @auto_message.width
      return true if Input::trigger?(SUI::MESSAGE::BTN_AUTO_MODE)
      return true if @auto_count == 0
      return false
    else
      @auto_mode = true if Input::trigger?(SUI::MESSAGE::BTN_AUTO_MODE)
      if $game_switches[SUI::MESSAGE::SW_SKIP_ON] && Input.trigger?(SUI::MESSAGE::BTN_RETURN)
        SUI::MESSAGE::SKIP["skip"] = true
        return true
      end
      return false
    end
  end
  #--------------------------------------------------------------------------
  # ● 一文字出力後のウェイト
  #--------------------------------------------------------------------------
  alias sui_message_wait_for_one_character wait_for_one_character
  def wait_for_one_character
    case SUI::OPTION.message_speed
    when 0
      wait(1) unless @show_fast or @line_show_fast
      @spd = false
    when 1
      @spd = false
    when 2
      @spd = !@spd
    end
    return unless @show_fast or @line_show_fast or !@spd
    sui_message_wait_for_one_character
  end
  #--------------------------------------------------------------------------
  # ● 制御文字の処理
  #     code : 制御文字の本体部分（「\C[1]」なら「C」）
  #--------------------------------------------------------------------------
  alias sui_process_escape_character process_escape_character
  def process_escape_character(code, text, pos)
    sui_process_escape_character(code, text, pos)
    case code
    when 'l', 'c', 'r'
      text.sub!(/\[(.{1,8})\]/, "")
      if $1 == "off"
        Message.set_tone(code, Tone.new(-40, -40, -40, 0))
      elsif $1 == "on"
        Message.set_tone(code, Tone.new(0, 0, 0, 0))
        for i in Message.get_array(code)
          Message.set_tone(i, Tone.new(-40, -40, -40, 0))
        end
      elsif $1 =="del"
        Message.del_picture(code)
      else
        Message.set_picture(code, $1)
        Message.set_tone(code, Tone.new(0, 0, 0, 0))
        for i in Message.get_array(code)
          Message.set_tone(i, Tone.new(-40, -40, -40, 0))
        end
      end
      wait(16)
    when 's'
        text.sub!(/\[(\w+)(,(\d+))?(,(\d+))?\]/, "")
        Audio.se_play("Audio/SE/#{$1}", ($3 ? $3.to_i : 100), ($5 ? $5.to_i : 100))
    when 'v'
        text.sub!(/\[([0-9a-zA-Z_\/]+)\]/, "")
        Message.play_voice($1)
    when 'p'
      text.sub!(/\[(.+)\]/, "")
      if $1 == "del"
        Message.del_cg
      else
        Message.set_cg($1)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 指定の位置を除いた配列を取得
  #--------------------------------------------------------------------------
  def self.get_array(pos)
    tmp = ["l", "c", "r"]
    tmp.delete(pos)
    return tmp
  end
  #--------------------------------------------------------------------------
  # ● ＣＧの表示
  #--------------------------------------------------------------------------
  def self.set_cg(file)
    name = SUI::MESSAGE::CG_DIR + file
    zoom_x = 100.0
    zoom_y = 100.0
    opacity = 255.0
    blend_type = 0
    origin = 0
    x = 0
    y = 0
    $game_map.screen.pictures[SUI::MESSAGE::CG_PIC].show(name, origin, x, y, zoom_x, zoom_y, opacity, blend_type)
  end
  #--------------------------------------------------------------------------
  # ● ＣＧの消去
  #--------------------------------------------------------------------------
  def self.del_cg
    $game_map.screen.pictures[SUI::MESSAGE::CG_PIC].erase
  end
  #--------------------------------------------------------------------------
  # ● 立ち絵の表示
  #--------------------------------------------------------------------------
  def self.set_picture(pos, file, flg = true)
    name = SUI::MESSAGE::SURFACE_DIR + file
    zoom_x = 100.0
    zoom_y = 100.0
    opacity = 255.0
    blend_type = 0
    origin = 0
    y = 0
    if pos == "l"
      x = SUI::MESSAGE::LEFT_X
      p = SUI::MESSAGE::LEFT_PIC
    elsif pos == "c"
      x = SUI::MESSAGE::CENTER_X
      p = SUI::MESSAGE::CENTER_PIC
    elsif pos == "r"
      x = SUI::MESSAGE::RIGHT_X
      p = SUI::MESSAGE::RIGHT_PIC
    end
    $game_map.screen.pictures[p].show(name, origin, x, y, zoom_x, zoom_y, opacity, blend_type)
    set_tone(pos, Tone.new(-40, -40, -40, 0)) unless flg
  end
  #--------------------------------------------------------------------------
  # ● 立ち絵の消去
  #--------------------------------------------------------------------------
  def self.del_picture(pos)
    if pos == "l"
      p = SUI::MESSAGE::LEFT_PIC
    elsif pos == "c"
      p = SUI::MESSAGE::CENTER_PIC
    elsif pos == "r"
      p = SUI::MESSAGE::RIGHT_PIC
    end
    $game_map.screen.pictures[p].erase
  end
  #--------------------------------------------------------------------------
  # ● トーンの設定
  #--------------------------------------------------------------------------
  def self.set_tone(pos, tone)
    if pos == "l"
      p = SUI::MESSAGE::LEFT_PIC
    elsif pos == "c"
      p = SUI::MESSAGE::CENTER_PIC
    elsif pos == "r"
      p = SUI::MESSAGE::RIGHT_PIC
    end
    $game_map.screen.pictures[p].start_tone_change(tone, 0)
  end
  #--------------------------------------------------------------------------
  # ● ボイスの再生
  #--------------------------------------------------------------------------
  def self.play_voice(file)
    unless $savec.check("voice")
      Audio.se_stop
      vol = SUI::OPTION.voice_volume
      Audio.se_play("#{SUI::MESSAGE::VOICE_DIR}#{file}", 100 * vol, 100)
    end
  end
end
Message = Window_Message


module SuiScript
  #--------------------------------------------------------------------------
  # ● ＣＧの表示
  #--------------------------------------------------------------------------
  def self.set_cg(file)
    if file == "del"
      Message.del_cg
    else
      Message.set_cg(file)
    end
  end
  #--------------------------------------------------------------------------
  # ● 立ち絵の表示
  #--------------------------------------------------------------------------
  def self.set_picture(pos, file, flg = true)
    if file == "off"
      Message.set_tone(pos, Tone.new(-40, -40, -40, 0))
    elsif file == "on"
      Message.set_tone(pos, Tone.new(0, 0, 0, 0))
      for i in Message.get_array(pos)
        Message.set_tone(i, Tone.new(-40, -40, -40, 0))
      end
    elsif file =="del"
      Message.del_picture(pos)
    else
      Message.set_picture(pos, file, flg)
      return unless flg
      Message.set_tone(pos, Tone.new(0, 0, 0, 0))
      for i in Message.get_array(pos)
        Message.set_tone(i, Tone.new(-40, -40, -40, 0))
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● ＳＥの再生
  #--------------------------------------------------------------------------
  def self.play_se(file, vol = 100, pitch = 100)
    Audio.se_play("Audio/SE/#{file}", vol, pitch)
  end
  #--------------------------------------------------------------------------
  # ● ボイスの再生
  #--------------------------------------------------------------------------
  def self.play_voice(file)
    Message.play_voice(file)
  end
end


class Game_Interpreter
  #--------------------------------------------------------------------------
  # ● イベントコマンドの実行
  #--------------------------------------------------------------------------
  alias sui_interpreter_execute_command execute_command
  def execute_command
    if SUI::MESSAGE::SKIP["skip"]
      SUI::MESSAGE::SKIP["skip"] = false
      $game_switches[SUI::MESSAGE::SW_SKIP_ON] = false
      return if label_jump
    end
    sui_interpreter_execute_command
  end
  #--------------------------------------------------------------------------
  # ● ラベルジャンプ
  #--------------------------------------------------------------------------
  def label_jump
    label_name = SUI::MESSAGE::SKIP_LABEL
    @list.size.times do |i|
      if @list[i].code == 118 && @list[i].parameters[0] == label_name
        @index = i
        return true
      end
    end
    return false
  end
end


module SUI::MESSAGE
  SKIP = {}
end


module SUI::OPTION
  def self.bgm_volume
    vol = $savec.get_num("bgm_vol")
    vol = 70 if vol < 10
    vol /=  100.0
    return vol
  end
  def self.voice_volume
    vol = $savec.get_num("voice_vol")
    vol = 70 if vol < 10
    vol /= 100.0
    return vol
  end
  def self.message_speed
    spd = $savec.get_num("speed")
    spd = 1 if spd == -1
    return spd
  end
  def self.auto_wait
    spd = $savec.get_num("auto_wait")
    spd = 1 if spd == -1
    return spd
  end
end