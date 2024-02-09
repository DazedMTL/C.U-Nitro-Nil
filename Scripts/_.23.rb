#==============================================================================
#    ☆VXAce RGSS3 「「注釈クエストシステム」☆
#　　　　　　EnDlEss DREamER
#     URL:http://mitsu-evo.6.ql.bz/
#     製作者 mitsu-evo
#     Last:2014/1/20
#　　 コモンイベントＩＤ指定型の条件分岐と注釈利用によるクエスト管理システム
#     ▼ 素材よりも下に。
#==============================================================================
$ed_rgss3 = {} if $ed_rgss3 == nil
$ed_rgss3["ed_quest_system"] = true
=begin


    　★　概要　★
    
    ・スクリプトコマンドでコモンイベントのＩＤ指定をすると
    　そのコモンイベントで管理しているクエストの内容を表示します。
    ・内容はイベントコマンド「注釈」を利用して表示を行ないます。
    　イベント条件分岐も取得するので制作中はコモンイベントの操作でＯＫです。
    ・「冒険メモ」的な使い方としても使用できます。
    　イベント「条件分岐」で現在進行中のイベント内容を表示して
    　そのクエスト終了スイッチがONになったら「クエスト達成」という手順です。
    ・クエスト内容が「コモンイベント管理」なので、作りやすく管理しやすいです。
    ・「報酬」は実装していません。あくまで「進行中のクエスト一覧表示」です。
    　管理が面倒なのと、クエスト終了スイッチを指定するので
    　いくらでも自由に簡単にイベントコマンドで作れます。
    
    
    　★　作り方　★
    
    ・作りたいクエスト(お使いイベント等任意のイベント)の終了スイッチを作る。
    ・コモンイベントに注釈で
    
    　「タイトル：表示タイトル文字」
    　「内容：クエストの内容説明文」(これに限り複数の注釈使用OK)
    　「終了スイッチ：x」※「x」は任意のゲームスイッチ番号
    
    　とそれぞれ「３つに分けて」注釈でタイトルと内容と終了スイッチ番号を作る。
    ・ゲーム進行でまだ表示させたくないクエストは、「普通に条件分岐」で
    　分岐してから上記注釈コマンド３つを作成。条件を満たすと表示されます。
    ・クエストの並びはコモンイベントの下に行くほど新しいクエストになります。
    　途中で追加した場合は挿入される形となります。
    ・クエスト報酬などは別途コモンイベントで作成して下さい。
    　ゲームスイッチでクエスト終了を管理しているのでイベントコマンドで
    　任意にお金なりアイテムなりを報酬として与えて下さい。
    ・「内容：」の注釈イベントコマンドは「終了スイッチ[x]」の前なら
    　複数入れてもかまいません。
    
    
    　★　内容の書き方　★
    
    ・注釈内にクエストの内容を書きますが、おおよそ「14文字以内で1行」を
    　もしくは「28文字以内で2行」使用すると思ってください。
    ・また、注釈イベントコマンドのウィンドウ端で下の行に改行されたときも
    　実際の画面で改行されているので注意してください。
    ・ウィンドウ幅の端に文字が来ると自動的に改行をします。
    ・内容は複数の注釈コマンドを使用して表示することが可能なので
    　安心して内容を書けます。
    ・使用するフォントによって文字の大きさが違うので注意してください。
    ・特殊文字はツクール純正の他に
    　「\It[x]：アイテム名」「\We[x]：武器名」
    　「\Ar[x]：防具名」「\En[x]敵キャラ名」
    　を入力すると対応した名前が表示されます。
    　これにより「\En[1]を\v[1]体倒せ！」と言ったクエストが可能です。
    
    
    
    　★　使い方　★
    
    ・イベントスクリプトに「start_ed_quest_menu(コモンイベントID)」と記入すると
    　上記「作り方」で作成したクエストの内容が専用画面で表示されます。
    ・コモンイベントのIDを変えればメインイベントのクエストとサブクエストなど
    　用途に分けてクエストを管理できます。
    ・ただし、現在進行しているクエストの内容を表示するだけなので
    　この画面で報酬を得ることは出来ません。
    　クエスト報酬を与えるイベントを作成するなどして対処してください。
    ・RGSS2版と違い、メニュー画面から指定番号のコモンイベントを呼び出し
    　することが出来ます。
    　選択肢の表示などを利用して複数のクエスト表示メニューを作成できます。
    

=end
module ED

  
  
  
  VOCAB_QUEST_END_OK = "Complete"    # 表示文字
  VOCAB_MENU_TEXT = "Tasks"   # メニュー画面の表示文字
  QUEST_FONT_SIZE = 19           # クエスト内容の文字サイズ
  MENU_QUEST_COMMAND_COMON_ID = 110 # メニュー画面から呼び出すコモンイベントID
  
  
#==============================================================================
# ■ Command
#------------------------------------------------------------------------------
# 　イベントコマンド「スクリプト」で呼び出されるコマンドです。
#==============================================================================
  module Command
    module_function
    #--------------------------------------------------------------------------
    # ● クエスト画面開始
    #--------------------------------------------------------------------------
    def start_ed_quest_menu(common_id)
      return if $game_party.in_battle
      $game_temp.temp_quest_common_id = common_id
      SceneManager.call(Scene_Quest)
    end
  end
end


#★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
#==============================================================================
# ■ Game_Temp
#------------------------------------------------------------------------------
# 　セーブデータに含まれない、一時的なデータを扱うクラスです。このクラスのイン
# スタンスは $game_temp で参照されます。
#==============================================================================

class Game_Temp
  #--------------------------------------------------------------------------
  # ● クエストシーン呼び出し用コモンID保持アクセサ
  #--------------------------------------------------------------------------
  def temp_quest_common_id
    @temp_quest_common_id = 1 if @temp_quest_common_id == nil
    return @temp_quest_common_id
  end
  #--------------------------------------------------------------------------
  # ● クエストシーン呼び出し用コモンID保持アクセサ
  #--------------------------------------------------------------------------
  def temp_quest_common_id=(value)
    @temp_quest_common_id = value
  end
  #--------------------------------------------------------------------------
  # ● クエストシーンでのカーソル位置記憶
  #--------------------------------------------------------------------------
  def temp_quest_cursor
    @temp_quest_cursor = 0 if @temp_quest_cursor == nil
    return @temp_quest_cursor
  end
  #--------------------------------------------------------------------------
  # ● クエストシーンでのカーソル位置記憶
  #--------------------------------------------------------------------------
  def temp_quest_cursor=(value)
    @temp_quest_cursor = value
  end
end

#==============================================================================
# ■ Game_Interpreter
#------------------------------------------------------------------------------
# 　イベントコマンドを実行するインタプリタです。このクラスは Game_Map クラス、
# Game_Troop クラス、Game_Event クラスの内部で使用されます。
#==============================================================================
class Game_Interpreter
  # イベントコマンド「スクリプト」にモジュール「Command」のメソッドを反映。
  include ED::Command
end


#==============================================================================
# ■ Game_Quest
#------------------------------------------------------------------------------
# 　コモンイベントを読み取り、イベント分岐を処理して注釈の内容を取得し
# クエストの一括管理を行なうクラスです。
#==============================================================================

class Game_Quest < Game_Interpreter
  # 注釈コマンド(いじる必要なし。)
  CMD_TITLE = "タイトル："
  CMD_CONTENT = "内容："
  CMD_QUEST_END = "終了スイッチ[:：](\d+)"
  #--------------------------------------------------------------------------
  # ● イベントのセットアップ
  #    event_id : コモンイベント ID
  #--------------------------------------------------------------------------
  def setup(event_id=0)
    @list = $data_common_events[event_id].list
    @index = 0
    @quest_number = 0  # クエストナンバー
    # クエストの内容[クエストindex][タイトル,内容,終了判定スイッチ番号,行数]
    @quest = []      
    while @list[@index] do
      execute_command
      @index += 1
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新(このクラスは内容取得だけが目的なので更新しない)
  #--------------------------------------------------------------------------
  def update
    
  end
  #--------------------------------------------------------------------------
  # ● クエスト内容を配列で取得(タイトル,内容,終了スイッチ番号)
  #--------------------------------------------------------------------------
  def quest
    @quest ||= []
    return @quest
  end
  #--------------------------------------------------------------------------
  # ● クエストを終了しているかどうか
  #--------------------------------------------------------------------------
  def finished_quest(value)
    # 指定クエストの終了スイッチ番号がＯＮならtrueを返す。
    return false if @quest[value] == nil
    return false if @quest[value][2] == -1
    return true if $game_switches[@quest[value][2]] == true
    return false
  end
  #--------------------------------------------------------------------------
  # ● 注釈の内容を全取得
  #--------------------------------------------------------------------------
  def annotation_all_string(parameter)
    str = parameter
    @line = 1
    loop do
      # 次の行に文字列がある場合
      if @list[@index + @line].code == 408
        str += "\x00" # 改行の文字コードを追加。
        str += @list[@index + @line].parameters[0]
        @line += 1
      else
        break
      end
    end
    return str
  end
  #--------------------------------------------------------------------------
  # ● コマンドから先の文字列を取得
  #--------------------------------------------------------------------------
  def annotation_string(event, cmd_words)
    return event.slice(cmd_words.size, event.size)
  end
  #--------------------------------------------------------------------------
  # ● 特殊文字の変換
  #--------------------------------------------------------------------------
  def convert_special_characters(text)
    text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    text.gsub!(/\\N\[([0-9]+)\]/i) { $game_actors[$1.to_i].name }    
    text.gsub!(/\\C\[([0-9]+)\]/i) { "\x01[#{$1}]" }
    text.gsub!(/\\G/)              { "\x02" }
    text.gsub!(/\\\./)             { "\x03" }
    text.gsub!(/\\\|/)             { "\x04" }
    text.gsub!(/\\!/)              { "\x05" }
    text.gsub!(/\\>/)              { "\x06" }
    text.gsub!(/\\</)              { "\x07" }
    text.gsub!(/\\\^/)             { "\x08" }
    text.gsub!(/\\\\/)             { "\\" }
    text.gsub!(/_/)                { " " }
    text.gsub!(/\\It\[(\d+)\]/i) do
      $data_items[$1.to_i].nil? ? "" : $data_items[$1.to_i].name
    end
    text.gsub!(/\\We\[(\d+)\]/i) do
      $data_weapons[$1.to_i].nil? ? "" : $data_weapons[$1.to_i].name
    end
    text.gsub!(/\\Ar\[(\d+)\]/i) do
      $data_armors[$1.to_i].nil? ? "" : $data_armors[$1.to_i].name
    end
    text.gsub!(/\\En\[(\d+)\]/i) do
      $data_enemies[$1.to_i].nil? ? "" : $data_enemies[$1.to_i].name
    end
    return text
  end
#=begin
  #--------------------------------------------------------------------------
  # ● イベントコマンドの実行
  #--------------------------------------------------------------------------
  def execute_command
    command = @list[@index]
    @params = command.parameters
    @indent = command.indent
    method_name = "command_#{command.code}"
    #super
    if respond_to?(method_name)
      annotation_command(@params[0]) if command.code == 108
      send(method_name) 
    end
  end
#=end
  #--------------------------------------------------------------------------
  # ● 注釈の内容取得
  #--------------------------------------------------------------------------
  def annotation_command(event)
    # 選択クエスト配列がnilなら作成
    # クエストの内容[タイトル,内容,終了判定スイッチ番号,行数]
    @quest[@quest_number] ||= ["","",-1,0] #if @quest[@quest_number] == nil
    #msgbox_p @quest[@quest_number]
    end_flag = event.scan(/終了スイッチ[:：](\d+)/) # 注釈に終了スイッチ番号があるか？
    if event.include?(CMD_TITLE)
      # 注釈：タイトル
      str1 = annotation_all_string(event)           # コマンド含みの注釈全容取得
      str2 = annotation_string(str1,CMD_TITLE)      # コマンドを除く注釈内容取得
      text = convert_special_characters(str2)       # 注釈中の特殊文字を変換
      @quest[@quest_number][0] = text               # インスタンスにタイトルを保持
      return false
    elsif event.include?(CMD_CONTENT)
      # 注釈：内容
      str1 = annotation_all_string(event)             # コマンド含みの注釈全容取得
      str2 = annotation_string(str1,CMD_CONTENT)      # コマンドを除く注釈内容取得
      unless @quest[@quest_number][1] == ""
        # 既に内容があり続きの「内容：」なら冒頭で改行処理。
        str2 = "\x00" + str2
        @line += 1
      end
      str3 = @quest[@quest_number][1]                 # 追加前の文字を取得
      text = convert_special_characters(str2)         # 注釈中の特殊文字を変換
      @quest[@quest_number][1] << text                # インスタンスに内容を保持
      @quest[@quest_number][3] = @quest[@quest_number][3] + @line
      return false
    elsif not end_flag.empty? or end_flag != []
      # 終了注釈があるかどうかの処理
      end_flag.flatten!
      end_flag = end_flag[0].to_i                  # 終了コマンドの番号取得
      @quest[@quest_number][2] = end_flag          # インスタンスに終了番号を保持
      @quest_number += 1                           # 終了コマンドあれば次のクエストへ
      return false
    end
    return true
  end
end

#==============================================================================
# ■ Window_MenuCommand
#------------------------------------------------------------------------------
# 　メニュー画面で表示するコマンドウィンドウです。
#==============================================================================

class Window_MenuCommand < Window_Command

  #--------------------------------------------------------------------------
  # ● 独自コマンドの追加用
  #--------------------------------------------------------------------------
  alias ed_quest_system_add_original_commands add_original_commands
  def add_original_commands
    ed_quest_system_add_original_commands
    add_quest_command
  end
  #--------------------------------------------------------------------------
  # ● セーブをコマンドリストに追加
  #--------------------------------------------------------------------------
  def add_quest_command
    add_command(ED::VOCAB_MENU_TEXT, :quest)
  end
end
#==============================================================================
# ■ Window_Quest_Menu
#------------------------------------------------------------------------------
# 　アイテム画面などで、所持アイテムの一覧を表示するウィンドウです。
#==============================================================================

class Window_Quest_Menu < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x      : ウィンドウの X 座標
  #     y      : ウィンドウの Y 座標
  #     width  : ウィンドウの幅
  #     height : ウィンドウの高さ
  #     quest  : クエストデータ
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, quest)
    @quest = quest
    @data = @quest.quest
    super(x, y, width, height)
    @item_max = @data.size == nil ? 1 : @data.size
    
    @column_max = 1
    select(0)
    refresh
  end

  #--------------------------------------------------------------------------
  # ● 項目数の取得
  #--------------------------------------------------------------------------
  def item_max
    return @data.size
  end
  #--------------------------------------------------------------------------
  # ● 表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    item_max
  end
  #--------------------------------------------------------------------------
  # ● 選択項目のクエストの取得
  #--------------------------------------------------------------------------
  def quest
    return @data[self.index]
  end
  #--------------------------------------------------------------------------
  # ● クエストを許可状態で表示するかどうか(未終了クエストを許可状態で)
  #     quest_no : クエストナンバー
  #--------------------------------------------------------------------------
  def enable?(quest_no)
    return true unless @quest.finished_quest(quest_no)
    return false
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    create_contents
    for i in 0...item_max
      draw_item(i)
    end
    activate
  end
  #--------------------------------------------------------------------------
  # ● クエスト名の描画
  #     str     : タイトルや内容などの文字描画
  #     x       : 描画先 X 座標
  #     y       : 描画先 Y 座標
  #     enabled : 有効フラグ。false のとき半透明で描画
  #--------------------------------------------------------------------------
  def draw_quest(str,x,y,enabled,index)
    if str != ""
      self.contents.font.color = normal_color
      self.contents.font.color.alpha = enabled ? 255 : 128
      self.contents.draw_text(x + 24, y, 172, line_height, str)
      unless enable?(index)
        # 既に終了したクエストはタイトルの上に文字を描画。
        self.contents.font.color = crisis_color
        self.contents.font.bold  = true
        self.contents.draw_text(x + 24, y, 172, line_height, ED::VOCAB_QUEST_END_OK,1)
        self.contents.font.bold  = false
        self.contents.font.color = normal_color
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #     index : 項目番号
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    item = @data[index]
    if item != nil
      enabled = enable?(index)
      rect.width -= 4
      draw_quest(item[0], rect.x, rect.y, enabled, index)
    end
  end
end
#==============================================================================
# ■ Window_Quest_Contents
#------------------------------------------------------------------------------
# 　クエストの内容を表示するウィンドウクラスです。
#==============================================================================

class Window_Quest_Contents < Window_Selectable
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     x      : ウィンドウの X 座標
  #     y      : ウィンドウの Y 座標
  #     width  : ウィンドウの幅
  #     height : ウィンドウの高さ
  #     quest  : クエストデータ
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, quest)
    super(x, y, width, height)
    self.active = false
    @quest = quest
    @data = @quest.quest # クエストデータ
    unselect           # クエストインデックス
    @line = 0            # カーソル選択行数
    @line_max = 0        # クエスト内容最大行数
    refresh
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ内容の作成
  #--------------------------------------------------------------------------
  def create_contents
    self.contents.dispose
    self.contents = Bitmap.new(contents_width, 
    [contents_height, line_max * line_height].max)
  end
  #--------------------------------------------------------------------------
  # ● 行数の設定
  #--------------------------------------------------------------------------
  def line=(value)
    @line = value
  end
  #--------------------------------------------------------------------------
  # ● 最大行数の取得
  #--------------------------------------------------------------------------
  def line_max
    unless @data == nil
      return @data[@index][3] unless @data[@index][3] == 0
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 1画面に表示可能な行数
  #--------------------------------------------------------------------------
  def cts_max_line
    return (height - spacing) / line_height
  end
  #--------------------------------------------------------------------------
  # ● シーンクラスでメニュー選択インデックスとリンクさせる。
  #--------------------------------------------------------------------------
  def index=(value)
    @index = value
  end
  #--------------------------------------------------------------------------
  # ● クエストを許可状態で表示するかどうか(未終了クエストを許可状態で)
  #     quest_no : クエストナンバー
  #--------------------------------------------------------------------------
  def enable?(quest_no)
    return true unless @quest.finished_quest(quest_no)
    return false
  end
  #--------------------------------------------------------------------------
  # ● クエスト内容の表示。(自動改行や特殊文字の文字色変更に対応)
  #    x        : x座標
  #    y        : y座標
  #    str      : 描画文字列
  #    enabled  : 有効・無効設定。無効なら暗く表示
  #--------------------------------------------------------------------------
  def draw_quest_contents(x,y,str,enabled)
    text = str.clone
    c_x = x
    # y - 選択行数×WLH(例：5 * 24) = -120
    c_y = y - (@line * line_height)
    c_w = self.width - spacing
    c_h = self.height - spacing
    line = 0 # 処理中の行数
    loop do
      c = text.slice!(/./m)            # 次の文字を取得
      self.contents.font.size = ED::QUEST_FONT_SIZE - 4
      self.contents.font.color.alpha = enabled ? 255 : 128
      case c
      when nil
        return
      when "\x00"                       # 改行
        line += 1
        # 処理中の行数が選択行数よりも少ない場合は表示しない
        next if line < @line
        # 選択行数より大きくて初めて c_y に1行につきWLH加算。
        c_y += line_height
        c_x = x        
      when "\x01"                       # \C[n]  (文字色変更)
        next if line < @line
        text.sub!(/\[([0-9]+)\]/, "")
        self.contents.font.color = text_color($1.to_i)
        next
      else
        if c_x >= c_w - self.contents.font.size
          # ウィンドウよりも大きいときは改行
          line += 1
          # 処理中の行数が選択行数よりも少ない場合は表示しない
          next if line < @line
          c_y += line_height
          c_x = x
        end
        # 選択行数以上ならc_yは0より大きくなる。
        unless c_y < 0  
          self.contents.draw_text(c_x, c_y, line_height, line_height, c)
          c_width = self.contents.text_size(c).width
          c_x += c_width
        end
      end
    end
    
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    enabled = enable?(@index)
    create_contents
    self.contents.font.color = normal_color
    self.contents.font.color.alpha = enabled ? 255 : 128
    # 内容の描画メソッド
    draw_quest_contents(0, 0, @data[@index][1], enabled) #unless @data[@index][1] == nil
  end
#=begin
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    update_cursor if self.active
  end

  #--------------------------------------------------------------------------
  # ● カーソルを下に移動(1行下へ)
  #--------------------------------------------------------------------------
  def cursor_down(wrap = false)
    return if line_max == 0
    return if line_max < cts_max_line
    return if line_max - @line == cts_max_line
    @line += 1 
  end
  #--------------------------------------------------------------------------
  # ● カーソルを上に移動(1行上へ)
  #--------------------------------------------------------------------------
  def cursor_up(wrap = false)
    return if line_max < cts_max_line
    @line -= 1 if @line > 0
  end
  #--------------------------------------------------------------------------
  # ● カーソルを右に移動(ページの一番下へ)
  #--------------------------------------------------------------------------
  def cursor_right(wrap = false)
    return if line_max < cts_max_line
    @line = line_max - cts_max_line
  end
  #--------------------------------------------------------------------------
  # ● カーソルを左に移動(ページの一番上へ)
  #--------------------------------------------------------------------------
  def cursor_left(wrap = false)
    return if line_max < cts_max_line
    @line = 0
  end  
  #--------------------------------------------------------------------------
  # ● カーソルの更新
  #--------------------------------------------------------------------------
  def update_cursor
    if cursor_movable?
      last_line = @line
      if Input.repeat?(Input::DOWN)
        cursor_down
      end
      if Input.repeat?(Input::UP)
        cursor_up
      end
      if Input.repeat?(Input::RIGHT)
        cursor_right
      end
      if Input.repeat?(Input::LEFT)
        cursor_left
      end
      if @line != last_line
        Sound.play_cursor
        refresh
      end
    end
  end
#=end
end
#==============================================================================
# ■ Scene_Quest
#------------------------------------------------------------------------------
# 　クエスト画面の処理を行うクラスです。
#==============================================================================

class Scene_Quest < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     menu_index : コマンドのカーソル初期位置
  #     event_id   : コモンイベントのＩＤ
  #--------------------------------------------------------------------------
#=begin
  def initialize(menu_index = 0)#, event_id = 1)
    @menu_index = menu_index
    @event_id = $game_temp.temp_quest_common_id #== nil ? 1 : 
    #$game_temp.temp_quest_common_id#event_id
    @quest = Game_Quest.new
    @quest.setup(@event_id)
    # カーソルインデックスが以前のクエスト数よりも大きい場合はクエスト数にする。
    size = @quest.quest.size - 1
    @menu_index = size if menu_index > size
  end
#=end
  #--------------------------------------------------------------------------
  # ● 開始処理
  #--------------------------------------------------------------------------
  def start
    super
    @event_id = $game_temp.temp_quest_common_id
    @quest.setup(@event_id)
    
    create_background
    create_command_window
    @command_window.activate
    @status_window = Window_Quest_Contents.new(244, 0, 300, 416, @quest)
    @status_window.index = @command_window.index
    @status_window.refresh
  end
  #--------------------------------------------------------------------------
  # ● 終了処理
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_background
    @command_window.dispose
    @status_window.dispose
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  def update
    super
    @status_window.index = @command_window.index
    if Input.repeat?(Input::DOWN) or Input.repeat?(Input::UP)
      @status_window.refresh
    end
    update_command_selection
  end
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  def create_command_window
    @command_window = Window_Quest_Menu.new(0, 0, 244, 416, @quest)
    @command_window.index = @menu_index
  end
  #--------------------------------------------------------------------------
  # ● コマンド選択の更新
  #--------------------------------------------------------------------------
  def update_command_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      if @command_window.active
        $game_temp.temp_quest_cursor = @command_window.index
        SceneManager.return
      else
        @status_window.deactivate
        @status_window.line = 0
        @command_window.activate
      end
    elsif Input.trigger?(Input::C)
      Sound.play_ok
      @status_window.activate
      @command_window.deactivate
    end
  end
end
#==============================================================================
# ■ Scene_Menu
#------------------------------------------------------------------------------
# 　メニュー画面の処理を行うクラスです。
#==============================================================================

class Scene_Menu < Scene_MenuBase
  #--------------------------------------------------------------------------
  # ● コマンドウィンドウの作成
  #--------------------------------------------------------------------------
  alias ed_quest_system_create_command_window create_command_window
  def create_command_window
    ed_quest_system_create_command_window
    @command_window.set_handler(:quest,    method(:command_quest))
  end
  #--------------------------------------------------------------------------
  # ● コマンド［クエスト］
  #--------------------------------------------------------------------------
  def command_quest
    SceneManager.return
    $game_temp.reserve_common_event(ED::MENU_QUEST_COMMAND_COMON_ID)
  end
end

