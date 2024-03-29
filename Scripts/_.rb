=begin ************************************************************************
  ◆ セーブレイアウト (リーダー詳細版) Ver.1.01
  ---------------------------------------------------------------------------
    セーブ・ロード画面のレイアウトを変更します。
=end # ************************************************************************

#-information------------------------------------------------------------------
$ziifee ||= {}
$ziifee[:SaveLayout] = :TypeA
#------------------------------------------------------------------------------
#-memo-------------------------------------------------------------------------
#   各種データは一度セーブすることで表示されます。
#   セーブファイルのマップ名は「表示名」を表示します。
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   他のセーブ関係の素材と競合する可能性が高いので注意して使用してください。
#   ファイル番号 17番 以降にセーブした場合、ロードにはこのスクリプトが必要です。
#------------------------------------------------------------------------------

module ZiifSaveLayoutA
  # [ 設定箇所 1 ]
  # ▼ ファイルリスト設定 (ファイル数は 横×縦)
  File_column  = 3              # ファイル 横の数
  File_row     = 6              # ファイル 縦の数
  D_LineNumber = 6              # 表示行数
  File_Align   = 1              # 揃え (0:左揃え, 1:中央揃え, 2:右揃え)
  D_StoryList  = false          # リストにストーリー名を表示 ( true / false )
  V_None       = "No Data"      # 用語 : ファイルなし
  
  # ▼ 情報ウィンドウ設定
  WindowMargin       = 8        # ウィンドウ外周の余白   (px)
  WindowLineNumber   = 7        # ウィンドウの高さ       (行数)
  WindowTransparency = false    # 情報ウィンドウを透明化 ( true / false )
  
  # ▼ ヘルプウィンドウ設定
  HelpWTransparency  = false    # ヘルプウィンドウを透明化 ( true / false )
  
  # ▼ セーブ確認設定
  SaveConfirm          = true   # セーブ確認を行うかどうか ( true / false )
  SConfirmationDefault = 0      # 初期位置 ( 0:はい / 1:いいえ )
  V_SConfirmation      = "Are you sure you want to save?"   # 用語 : セーブ確認
  V_SConfirmationYes   = "Save"                     # 用語 : はい
  V_SConfirmationNo    = "Cancel"                         # 用語 : いいえ
  
  # ▼ ロード確認設定
  LoadConfirm          = true   # ロード確認を行うかどうか ( true / false )
  LConfirmationDefault = 0      # 初期位置 ( 0:はい / 1:いいえ )
  V_LConfirmation      = "Are you sure you want to load?"   # 用語 : ロード確認
  V_LConfirmationYes   = "Load"                     # 用語 : はい
  V_LConfirmationNo    = "Cancel"                         # 用語 : いいえ
  
  # ▼ ファイル画面背景画像名 ( "" : 未使用、画像は Graphics/Pictures に)
  SaveBackground = ""           # セーブ画面背景
  LoadBackground = ""           # ロード画面背景
  
  # ※ 背景画像未使用時は通常の背景表示になります。
  
  # ▼ ウィンドウ表示設定 ( true : 表示する / false : 表示しない )
  # ファイル情報
  D_File       = true      # ファイル番号
  D_Story      = true      # ストーリー名
  D_Playtime   = true      # プレイ時間
  
  # パーティ情報
  D_Area       = true      # エリア・マップ名
  D_Gold       = true      # 所持金
  D_AG_Line    = false     # マップ名と所持金を同じ行に表示 (マップ名は左揃え)
  
  # パーティ画像
  D_PartyFaces = false     # パーティの顔グラフィック
  D_Characters = true      # パーティの歩行グラフィック
  
  # リーダー情報
  D_LeaderInfo = true      # リーダー情報 ( true の時以下を表示する)
  
  D_Face       = true      # 顔グラフィック
  D_Name       = true      # 名前
  D_Level      = true      # レベル
  D_Class      = true      # 職業
  D_Nickname   = true      # 二つ名
  D_HPMP       = true      # HP・MP
  D_UnderName  = :level    # 名前下の表示タイプ ( :level / :class / nil )
  D_Param      = true      # 能力値 (攻撃・敏捷性など)
  D_Equip      = false     # 装備   (武器・防具)
  
  # ※ 全てを true にすると、ウィンドウ内に入りきらないので注意！
end

module ZiifManager
  # [ 設定箇所 2 ]
  # ▼ 文字色設定 (0～255) : Color.new(赤, 緑, 青)
  Story_Color    = Color.new(255, 255, 128)        # ストーリー名
  Area_Color     = Color.new(128, 255, 0)          # エリア・マップ名
  
  # ▼ ストーリー名の設定
  Story_VarID    = 0                               # ストーリー確認用 変数ID
  StorySet     ||= Hash.new("")
  StorySet[1]    = "序章 プロローグ"               # ストーリーID:01
  StorySet[2]    = "第一章 からくり時計の魔人"     # ストーリーID:02
  StorySet[3]    = "第二章 夢の中で呼ばれて"       # ストーリーID:03
  #-memo---------------------------------------------------------------------
  #  StorySet[変数の値] = "ストーリー名"           # ストーリー名の設定
  #--------------------------------------------------------------------------
  
  # ▼ エリア名の設定
  AreaSet      ||= Hash.new(Hash.new(nil))
  AreaSet[1]     = Hash.new(nil)                   # マップID:01 を登録
  AreaSet[1][1]  = "からくり館周辺"                # ⇒ リージョンID:01
  AreaSet[1][2]  = "小さな村周辺"                  # ⇒ リージョンID:02
  AreaSet[2]     = Hash.new(nil)                   # マップID:02 を登録
  AreaSet[2][1]  = "暗闇の大地"                    # ⇒ リージョンID:01
  #-memo---------------------------------------------------------------------
  #  AreaSet[マップID] = Hash.new(nil)             # フィールドマップIDの登録
  #  AreaSet[マップID][リージョンID] = "エリア名"  # リージョンエリア名の設定
  #  ※ 変数の値が設定されていない場合は、現在のマップ名を表示します。
  #--------------------------------------------------------------------------
end

#******************************************************************************
# ▼ モジュール部
#******************************************************************************

#==============================================================================
# ■ ZiifSaveLayoutA
#==============================================================================

module ZiifSaveLayoutA
  #--------------------------------------------------------------------------
  # ● セーブファイル数の取得
  #--------------------------------------------------------------------------
  def self.savefile_max
    File_column * File_row
  end
  #--------------------------------------------------------------------------
  # ● セーブ背景画像があるかどうか
  #--------------------------------------------------------------------------
  def self.save_background?
    SaveBackground != ""
  end
  #--------------------------------------------------------------------------
  # ● セーブ背景ビットマップの取得
  #--------------------------------------------------------------------------
  def self.save_background_bitmap
    Cache.picture(SaveBackground)
  end
  #--------------------------------------------------------------------------
  # ● ロード背景画像があるかどうか
  #--------------------------------------------------------------------------
  def self.load_background?
    LoadBackground != ""
  end
  #--------------------------------------------------------------------------
  # ● ロード背景ビットマップの取得
  #--------------------------------------------------------------------------
  def self.load_background_bitmap
    Cache.picture(LoadBackground)
  end
end

#==============================================================================
# ■ ZiifManager
#==============================================================================

module ZiifManager
  #--------------------------------------------------------------------------
  # ● ストーリー名の取得
  #--------------------------------------------------------------------------
  def self.story_name(story_id)
    StorySet[story_id]
  end
  #--------------------------------------------------------------------------
  # ● エリア名の取得
  #--------------------------------------------------------------------------
  def self.area_name(map_id, region_id = nil)
    AreaSet[map_id][region_id] || map_name(map_id)
  end
  #--------------------------------------------------------------------------
  # ● マップ名の取得
  #--------------------------------------------------------------------------
  def self.map_name(map_id)
    @map_name_cache ||= {}
    unless @map_name_cache[map_id]
      map = load_data(sprintf("Data/Map%03d.rvdata2", map_id)) rescue nil
      @map_name_cache[map_id] = (map ? map.display_name : "No MapData")
    end
    @map_name_cache[map_id]
  end
end

#==============================================================================
# ■ ZiifManager::DrawingModule
#==============================================================================

module ZiifManager::DrawingModule
  #--------------------------------------------------------------------------
  # ● ストーリー名文字色の取得
  #--------------------------------------------------------------------------
  def story_color
    ZiifManager::Story_Color
  end
  #--------------------------------------------------------------------------
  # ● エリア名文字色の取得
  #--------------------------------------------------------------------------
  def area_color
    ZiifManager::Area_Color
  end
  #--------------------------------------------------------------------------
  # ● ファイル番号の描画
  #--------------------------------------------------------------------------
  def draw_file_number(index, x, y, enabled = true, width = 120, align = 0)
    change_color(normal_color, enabled)
    draw_text(x, y, width, line_height, Vocab::File + " #{index + 1}", align)
  end
  #--------------------------------------------------------------------------
  # ● ストーリー名の描画
  #--------------------------------------------------------------------------
  def draw_story_name(story_id, x, y, width = 256, align = 0)
    change_color(story_color)
    text = ZiifManager.story_name(story_id)
    draw_text(x, y, width, line_height, text, align)
  end
  #--------------------------------------------------------------------------
  # ● エリア名の描画
  #--------------------------------------------------------------------------
  def draw_area_map(map_id, region_id, x, y, width = 256, align = 0)
    change_color(area_color)
    text = ZiifManager.area_name(map_id, region_id)
    draw_text(x, y, width, line_height, text, align)
  end
end

#==============================================================================
# ■ DataManager
#==============================================================================

class << DataManager
  #--------------------------------------------------------------------------
  # ☆ セーブファイルの最大数 (再定義)
  #--------------------------------------------------------------------------
  def savefile_max
    return ZiifSaveLayoutA.savefile_max
  end
  #--------------------------------------------------------------------------
  # ● セーブヘッダの作成
  #--------------------------------------------------------------------------
  alias :ziif_save_layout_01_make_save_header :make_save_header
  def make_save_header
    header = ziif_save_layout_01_make_save_header
    header[:story_id]  = $game_system.ziif_story_id
    header[:map_id]    = $game_map.map_id
    header[:region_id] = $game_player.region_id
    header[:gold]      = $game_party.gold
    header[:faces]     = $game_party.ziif_faces_for_savefile
    header[:leader]    = $game_party.ziif_leader_for_savefile
    header
  end
end

#******************************************************************************
# ▼ ゲームオブジェクト部
#******************************************************************************

#==============================================================================
# ■ Game_System
#==============================================================================

class Game_System
  #--------------------------------------------------------------------------
  # ● ストーリーIDの取得
  #--------------------------------------------------------------------------
  def ziif_story_id
    $game_variables[ZiifManager::Story_VarID]
  end
end

#==============================================================================
# ■ Game_Party
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # ● セーブファイル表示用の顔グラフィック画像情報
  #--------------------------------------------------------------------------
  def ziif_faces_for_savefile
    battle_members.collect do |actor|
      [actor.face_name, actor.face_index]
    end
  end
  #--------------------------------------------------------------------------
  # ● セーブファイル表示用のリーダー情報
  #--------------------------------------------------------------------------
  def ziif_leader_for_savefile
    return leader
  end
end

#******************************************************************************
# ▼ ウィンドウ部
#******************************************************************************

#==============================================================================
# ■ Window_ZiifFileList
#------------------------------------------------------------------------------
# 　ファイル画面で、セーブファイルの一覧を表示するウィンドウです。
#==============================================================================

class Window_ZiifFileList < Window_Selectable
  #--------------------------------------------------------------------------
  # ● Mix-In
  #--------------------------------------------------------------------------
  include ZiifManager::DrawingModule      # 描画機能追加モジュール
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    rect = window_rect
    super(rect.x, rect.y, rect.width, rect.height)
    self.opacity = 0
    refresh
    activate
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの表示範囲を取得
  #--------------------------------------------------------------------------
  def window_rect
    rect = Rect.new
    rect.x      = 4
    rect.y      = 48
    rect.width  = Graphics.width-8
    rect.height = fitting_height(ZiifSaveLayoutA::D_LineNumber)
    rect
  end
  #--------------------------------------------------------------------------
  # ● 桁数の取得
  #--------------------------------------------------------------------------
  def col_max
    ZiifSaveLayoutA::File_column
  end
  #--------------------------------------------------------------------------
  # ● 項目数の取得
  #--------------------------------------------------------------------------
  def item_max
    DataManager.savefile_max
  end
  #--------------------------------------------------------------------------
  # ● アライメントの取得
  #--------------------------------------------------------------------------
  def alignment
    return ZiifSaveLayoutA::File_Align
  end
  #--------------------------------------------------------------------------
  # ● ファイル名の描画判定
  #--------------------------------------------------------------------------
  def file_number_draw?
    !ZiifSaveLayoutA::D_StoryList
  end
  #--------------------------------------------------------------------------
  # ● ストーリー名の描画判定
  #--------------------------------------------------------------------------
  def story_name_draw?
    ZiifSaveLayoutA::D_StoryList
  end
  #--------------------------------------------------------------------------
  # ● セーブヘッダの取得
  #--------------------------------------------------------------------------
  def header(index)
    DataManager.load_header(index)
  end
  #--------------------------------------------------------------------------
  # ● セーブファイルが存在しているかどうか
  #--------------------------------------------------------------------------
  def enable?(index)
    header(index)
  end
  #--------------------------------------------------------------------------
  # ● 決定ボタンが押されたときの処理 (決定サウンドを鳴らさない)
  #--------------------------------------------------------------------------
  def process_ok
    if current_item_enabled?
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
  #--------------------------------------------------------------------------
  # ● 選択項目の有効状態を取得
  #--------------------------------------------------------------------------
  def current_item_enabled?
    !SceneManager.scene_is?(Scene_Load) || enable?(self.index)
  end
  #--------------------------------------------------------------------------
  # ● 項目の描画
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect  = item_rect(index)
    # ファイル番号を描画
    if file_number_draw?
      draw_file_number(index,rect.x,rect.y,enable?(index),rect.width,alignment)
    end
    # ストーリー名を描画
    if story_name_draw?
      header = header(index)
      if header && header[:story_id]
        draw_story_name(header[:story_id],rect.x,rect.y,rect.width,alignment)
      else
        change_color(normal_color, false)
        draw_text(rect, ZiifSaveLayoutA::V_None, alignment)
      end
    end
  end
end

#==============================================================================
# ■ Window_ZiifSaveFile
#------------------------------------------------------------------------------
# 　ファイル画面でファイル情報を表示するウィンドウです。
#==============================================================================

class Window_ZiifSaveFile < Window_Base
  #--------------------------------------------------------------------------
  # ● Mix-In
  #--------------------------------------------------------------------------
  include ZiifManager::DrawingModule      # 描画機能追加モジュール
  #--------------------------------------------------------------------------
  # ● 公開インスタンス変数
  #--------------------------------------------------------------------------
  attr_reader   :selected                 # 選択状態
  attr_reader   :header                   # セーブヘッダ
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #     index : セーブファイルのインデックス
  #--------------------------------------------------------------------------
  def initialize(dummy_height, index)
    rect = window_rect
    super(rect.x, rect.y, rect.width, rect.height)
    self.opacity = 0 if ZiifSaveLayoutA::WindowTransparency
    @file_index = index
    clear_header
    refresh
    self.visible = false
    @selected = false
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウの表示範囲を取得
  #--------------------------------------------------------------------------
  def window_rect
    rect = Rect.new
    rect.x      = ZiifSaveLayoutA::WindowMargin
    rect.y      = Graphics.height - ZiifSaveLayoutA::WindowMargin
    rect.width  = Graphics.width - ZiifSaveLayoutA::WindowMargin * 2
    rect.height = fitting_height(ZiifSaveLayoutA::WindowLineNumber)
    rect.y     -= rect.height
    rect
  end
  #--------------------------------------------------------------------------
  # ● 選択状態の設定
  #--------------------------------------------------------------------------
  def selected=(selected)
    @selected = selected
    update_select
  end
  #--------------------------------------------------------------------------
  # ● 選択状態の更新
  #--------------------------------------------------------------------------
  def update_select
    self.visible = self.selected
    update
  end
  #--------------------------------------------------------------------------
  # ● セーブヘッダのロード
  #--------------------------------------------------------------------------
  def load_header
    @header = DataManager.load_header(@file_index)
  end
  #--------------------------------------------------------------------------
  # ● セーブヘッダのクリア
  #--------------------------------------------------------------------------
  def clear_header
    @header = nil
  end
  #--------------------------------------------------------------------------
  # ● ファイル情報があるかどうか
  #--------------------------------------------------------------------------
  def header?(symbol)
    @header && @header[symbol]
  end
  #--------------------------------------------------------------------------
  # ● リフレッシュ
  #--------------------------------------------------------------------------
  def refresh
    contents.clear
    load_header
    draw_file_contents
    draw_no_file unless @header
    clear_header
  end
  #--------------------------------------------------------------------------
  # ○ ファイル内容の描画 (素材下部にて再定義)
  #--------------------------------------------------------------------------
  def draw_file_contents
  end
  #--------------------------------------------------------------------------
  # ● ファイルなしの描画
  #--------------------------------------------------------------------------
  def draw_no_file
    rect   = Rect.new(0, 0, contents.width, line_height)
    rect.y = (contents.height - rect.height) / 2
    change_color(normal_color, false)
    draw_text(rect, ZiifSaveLayoutA::V_None, 1)
  end
end

#==============================================================================
# ■ Window_ZiifFileConfirmation
#------------------------------------------------------------------------------
# 　ファイル画面でセーブ・ロード確認コマンドを表示するウィンドウです。
#==============================================================================

class Window_ZiifFileConfirmation < Window_Command
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    super(window_x, window_y)
    self.z        = 200
    self.openness = 0
    deactivate
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ X 座標 の取得
  #--------------------------------------------------------------------------
  def window_x
    return (Graphics.width-window_width) / 2
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ Y 座標 の取得
  #--------------------------------------------------------------------------
  def window_y
    return (Graphics.height-window_height) / 2
  end
  #--------------------------------------------------------------------------
  # ● ウィンドウ幅の取得
  #--------------------------------------------------------------------------
  def window_width
    return 128
  end
  #--------------------------------------------------------------------------
  # ● 表示行数の取得
  #--------------------------------------------------------------------------
  def visible_line_number
    return 2
  end
  #--------------------------------------------------------------------------
  # ● デフォルト位置を選択
  #--------------------------------------------------------------------------
  def select_default
  end
end

#==============================================================================
# ■ Window_ZiifSaveConfirmation
#------------------------------------------------------------------------------
# 　セーブ画面で確認コマンドを表示するウィンドウです。
#==============================================================================

class Window_ZiifSaveConfirmation < Window_ZiifFileConfirmation
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(ZiifSaveLayoutA::V_SConfirmationYes, :save)
    add_command(ZiifSaveLayoutA::V_SConfirmationNo, :cancel)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(ZiifSaveLayoutA::V_SConfirmation)
  end
  #--------------------------------------------------------------------------
  # ● デフォルト位置を選択
  #--------------------------------------------------------------------------
  def select_default
    select(ZiifSaveLayoutA::SConfirmationDefault)
  end
  #--------------------------------------------------------------------------
  # ● 決定ボタンが押されたときの処理 (セーブ時サウンドを鳴らさない)
  #--------------------------------------------------------------------------
  def process_ok
    return super if current_symbol != :save
    if current_item_enabled?
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
end

#==============================================================================
# ■ Window_ZiifLoadConfirmation
#------------------------------------------------------------------------------
# 　ロード画面で確認コマンドを表示するウィンドウです。
#==============================================================================

class Window_ZiifLoadConfirmation < Window_ZiifFileConfirmation
  #--------------------------------------------------------------------------
  # ● コマンドリストの作成
  #--------------------------------------------------------------------------
  def make_command_list
    add_command(ZiifSaveLayoutA::V_LConfirmationYes, :load)
    add_command(ZiifSaveLayoutA::V_LConfirmationNo, :cancel)
  end
  #--------------------------------------------------------------------------
  # ● ヘルプテキスト更新
  #--------------------------------------------------------------------------
  def update_help
    @help_window.set_text(ZiifSaveLayoutA::V_LConfirmation)
  end
  #--------------------------------------------------------------------------
  # ● デフォルト位置を選択
  #--------------------------------------------------------------------------
  def select_default
    select(ZiifSaveLayoutA::LConfirmationDefault)
  end
  #--------------------------------------------------------------------------
  # ● 決定ボタンが押されたときの処理 (ロード時サウンドを鳴らさない)
  #--------------------------------------------------------------------------
  def process_ok
    return super if current_symbol != :load
    if current_item_enabled?
      Input.update
      deactivate
      call_ok_handler
    else
      Sound.play_buzzer
    end
  end
end

#******************************************************************************
# ▼ シーン部
#******************************************************************************

#==============================================================================
# ■ Scene_File
#==============================================================================

class Scene_File
  #--------------------------------------------------------------------------
  # ● 背景画像があるかどうか
  #--------------------------------------------------------------------------
  def ziif_file_background?
    return false
  end
  #--------------------------------------------------------------------------
  # ● 背景ビットマップの取得
  #--------------------------------------------------------------------------
  def ziif_file_background_bitmap
    SceneManager.background_bitmap
  end
  #--------------------------------------------------------------------------
  # ● セーブ・ロードの確認をするかどうか
  #--------------------------------------------------------------------------
  def file_confirm?
    return false
  end
  #--------------------------------------------------------------------------
  # ● セーブ・ロード確認ウィンドウの取得
  #--------------------------------------------------------------------------
  def confirmation_window
    return Window_ZiifFileConfirmation
  end
  #--------------------------------------------------------------------------
  # ● 背景の作成
  #--------------------------------------------------------------------------
  alias :ziif_save_layout_01_create_background :create_background
  def create_background
    if ziif_file_background?
      create_ziif_file_background
    else
      ziif_save_layout_01_create_background
    end
  end
  #--------------------------------------------------------------------------
  # ● ファイル画面の背景の作成
  #--------------------------------------------------------------------------
  def create_ziif_file_background
    @background_sprite = Sprite.new
    @background_sprite.bitmap = ziif_file_background_bitmap
  end
  #--------------------------------------------------------------------------
  # ● ヘルプウィンドウの作成
  #--------------------------------------------------------------------------
  alias :ziif_save_layout_01_create_help_window :create_help_window
  def create_help_window
    ziif_save_layout_01_create_help_window
    @help_window.opacity = 0 if ZiifSaveLayoutA::HelpWTransparency
  end
  #--------------------------------------------------------------------------
  # ☆ セーブファイルウィンドウの作成 (再定義)
  #--------------------------------------------------------------------------
  def create_savefile_windows
    create_filelist_window
    create_savefile_windows_sub
    create_confirmation_window
  end
  #--------------------------------------------------------------------------
  # ● ファイルリストウィンドウの作成
  #--------------------------------------------------------------------------
  def create_filelist_window
    @filelist_window = Window_ZiifFileList.new
    @filelist_window.set_handler(:ok,     method(:on_filelist_ok))
    @filelist_window.set_handler(:cancel, method(:return_scene))
  end
  #--------------------------------------------------------------------------
  # ● セーブファイルウィンドウの作成 (サブ定義)
  #--------------------------------------------------------------------------
  def create_savefile_windows_sub
    @savefile_windows = Array.new(item_max) do |i|
      Window_ZiifSaveFile.new(0, i)
    end
  end
  #--------------------------------------------------------------------------
  # ● セーブ・ロード確認ウィンドウの作成
  #--------------------------------------------------------------------------
  def create_confirmation_window
    @confirmation_window = confirmation_window.new
    @confirmation_window.help_window = @help_window
    @confirmation_window.set_handler(:ok,     method(:on_confirmation_ok))
    @confirmation_window.set_handler(:cancel, method(:on_confirmation_cancel))
    @confirmation_window.select_default
  end
  #--------------------------------------------------------------------------
  # ☆ 選択状態の初期化 (再定義)
  #--------------------------------------------------------------------------
  def init_selection
    @filelist_window.select(first_savefile_index)
    @savefile_windows[index].selected = true
    @last_index = index
    set_file_index
  end
  #--------------------------------------------------------------------------
  # ☆ 現在のインデックスの取得 (再定義)
  #--------------------------------------------------------------------------
  def index
    @filelist_window.index
  end
  #--------------------------------------------------------------------------
  # ● インデックス設定
  #--------------------------------------------------------------------------
  def set_file_index
    @index = index
  end
  #--------------------------------------------------------------------------
  # ☆ セーブファイル選択の更新 (再定義)
  #--------------------------------------------------------------------------
  def update_savefile_selection
    if index != @last_index
      set_file_index
      @savefile_windows[@last_index].selected = false
      @savefile_windows[index].selected = true
      @last_index = index
    end
  end
  #--------------------------------------------------------------------------
  # ● ファイルリスト［決定］
  #--------------------------------------------------------------------------
  def on_filelist_ok
    set_file_index
    if file_confirm?
      Sound.play_ok
      activate_confirmation_window
    else
      on_savefile_ok
    end
  end
  #--------------------------------------------------------------------------
  # ● 確認ウィンドウをアクティブ化
  #--------------------------------------------------------------------------
  def activate_confirmation_window
    @confirmation_window.activate
    @confirmation_window.open
  end
  #--------------------------------------------------------------------------
  # ● セーブ・ロード確認［決定］
  #--------------------------------------------------------------------------
  def on_confirmation_ok
    on_savefile_ok
  end
  #--------------------------------------------------------------------------
  # ● セーブ・ロード確認［キャンセル］
  #--------------------------------------------------------------------------
  def on_confirmation_cancel
    @help_window.set_text(help_window_text)
    @confirmation_window.select_default
    @confirmation_window.close
    @filelist_window.activate
  end
end

#==============================================================================
# ■ Scene_Save
#==============================================================================

class Scene_Save
  #--------------------------------------------------------------------------
  # ● 背景画像があるかどうか
  #--------------------------------------------------------------------------
  def ziif_file_background?
    ZiifSaveLayoutA.save_background?
  end
  #--------------------------------------------------------------------------
  # ● 背景ビットマップの取得
  #--------------------------------------------------------------------------
  def ziif_file_background_bitmap
    ZiifSaveLayoutA.save_background_bitmap
  end
  #--------------------------------------------------------------------------
  # ● セーブ・ロードの確認をするかどうか
  #--------------------------------------------------------------------------
  def file_confirm?
    ZiifSaveLayoutA::SaveConfirm
  end
  #--------------------------------------------------------------------------
  # ● セーブ・ロード確認ウィンドウの取得
  #--------------------------------------------------------------------------
  def confirmation_window
    return Window_ZiifSaveConfirmation
  end
  #--------------------------------------------------------------------------
  # ● セーブファイルの決定
  #--------------------------------------------------------------------------
  alias :ziif_save_layout_01_save_on_savefile_ok :on_savefile_ok
  def on_savefile_ok
    ziif_save_layout_01_save_on_savefile_ok
    @confirmation_window.close
    @filelist_window.activate
  end
end

#==============================================================================
# ■ Scene_Load
#==============================================================================

class Scene_Load
  #--------------------------------------------------------------------------
  # ● 背景画像があるかどうか
  #--------------------------------------------------------------------------
  def ziif_file_background?
    ZiifSaveLayoutA.load_background?
  end
  #--------------------------------------------------------------------------
  # ● 背景ビットマップの取得
  #--------------------------------------------------------------------------
  def ziif_file_background_bitmap
    ZiifSaveLayoutA.load_background_bitmap
  end
  #--------------------------------------------------------------------------
  # ● セーブ・ロードの確認をするかどうか
  #--------------------------------------------------------------------------
  def file_confirm?
    ZiifSaveLayoutA::LoadConfirm
  end
  #--------------------------------------------------------------------------
  # ● セーブ・ロード確認ウィンドウの取得
  #--------------------------------------------------------------------------
  def confirmation_window
    return Window_ZiifLoadConfirmation
  end
  #--------------------------------------------------------------------------
  # ● セーブファイルの決定
  #--------------------------------------------------------------------------
  alias :ziif_save_layout_01_load_on_savefile_ok :on_savefile_ok
  def on_savefile_ok
    ziif_save_layout_01_load_on_savefile_ok
    @confirmation_window.close
    @filelist_window.activate
  end
end

#******************************************************************************
# ▼ ラインヘルプ機能部
#******************************************************************************
#-memo-------------------------------------------------------------------------
#   ラインヘルプウィンドウスクリプトを導入する場合に使用します。
#------------------------------------------------------------------------------

#==============================================================================
# ■ Window_ZiifFileList
#==============================================================================

class Window_ZiifFileList < Window_Selectable
  #--------------------------------------------------------------------------
  # ● ウィンドウの表示範囲を取得
  #--------------------------------------------------------------------------
  alias :ziif_line_help_file_window_rect :window_rect
  def window_rect
    rect    = ziif_line_help_file_window_rect
    rect.y -= 6 if $ziifee[:LineHelp]
    rect
  end
end

#==============================================================================
# ■ Scene_File
#==============================================================================

class Scene_File
  #--------------------------------------------------------------------------
  # ● ヘルプウィンドウの作成
  #--------------------------------------------------------------------------
  alias :ziif_line_help_file_create_help_window :create_help_window
  def create_help_window
    return ziif_line_help_file_create_help_window unless $ziifee[:LineHelp]
    @help_window = Window_ZiifLineHelp.new(1)
    @help_window.set_text(help_window_text)
  end
end

#******************************************************************************
# ▼ ファイル情報描画部
#******************************************************************************
#-memo-------------------------------------------------------------------------
#   ここから下を削除して、Window_ZiifSaveFile に直接記述する事もできます。
#------------------------------------------------------------------------------

#==============================================================================
# ■ Window_ZiifSaveFile
#==============================================================================

class Window_ZiifSaveFile
  #--------------------------------------------------------------------------
  # ● ファイル内容の描画
  #--------------------------------------------------------------------------
  def draw_file_contents
    draw_file_info
    draw_party_info
    draw_leader_info
    draw_party_faces
    draw_party_characters
  end
  #--------------------------------------------------------------------------
  # ● ファイル情報の描画
  #--------------------------------------------------------------------------
  def draw_file_info
    draw_x = 4
    # ファイル番号
    if ZiifSaveLayoutA::D_File
      draw_file_number(@file_index, draw_x, 0)
      draw_x += 128
    end
    # ストーリー名
    if ZiifSaveLayoutA::D_Story && header?(:story_id)
      draw_story_name(@header[:story_id], draw_x, 0)
    end
    # プレイタイム
    if ZiifSaveLayoutA::D_Playtime && header?(:playtime_s)
      change_color(normal_color)
      draw_text(4, 0, contents.width - 8, line_height, @header[:playtime_s], 2)
    end
  end
  #--------------------------------------------------------------------------
  # ● 通貨単位の取得
  #--------------------------------------------------------------------------
  def currency_unit
    Vocab::currency_unit
  end
  #--------------------------------------------------------------------------
  # ● 所持金・マップ情報の描画
  #--------------------------------------------------------------------------
  def draw_party_info
    draw_y = contents.height - line_height
    # エリア・マップ名
    if ZiifSaveLayoutA::D_Area && header?(:map_id)
      map_align = (ZiifSaveLayoutA::D_AG_Line ? 0 : 2)
      map_id    = @header[:map_id]
      region_id = @header[:region_id]
      draw_area_map(map_id, region_id, 4, draw_y, contents.width-8, map_align)
      draw_y -= line_height unless ZiifSaveLayoutA::D_AG_Line
    end
    # 所持金
    if ZiifSaveLayoutA::D_Gold && header?(:gold)
      gold = @header[:gold]
      draw_currency_value(gold, currency_unit, 4, draw_y, contents.width - 8)
    end
  end
  #--------------------------------------------------------------------------
  # ● ファイル情報を描画したかどうか
  #--------------------------------------------------------------------------
  def file_info_draw?
    ZiifSaveLayoutA::D_File || ZiifSaveLayoutA::D_Story ||
    ZiifSaveLayoutA::D_Playtime
  end
  #--------------------------------------------------------------------------
  # ● リーダー情報の描画
  #--------------------------------------------------------------------------
  def draw_leader_info
    return 0, 0 unless ZiifSaveLayoutA::D_LeaderInfo && header?(:leader)
    actor  = @header[:leader]
    draw_x = 4
    draw_y = (file_info_draw? ? line_height : 0)
    # 顔グラフィック
    if ZiifSaveLayoutA::D_Face
      draw_actor_face(actor, draw_x, draw_y)
      draw_x += 100
    end
    bw = draw_leader_base_info(actor, draw_x, draw_y + line_height)
    nw = draw_leader_name_info(actor, draw_x, draw_y) - draw_x
    # 詳細情報の描画位置調整
    if nw <= bw && bw > 0
      draw_x += bw + 8
    elsif nw > 0 && bw == 0
      draw_y += line_height
    elsif nw > bw && bw > 0
      draw_x += bw + 8
      draw_y += line_height
    end
    # 能力値
    param_width = contents.width - draw_x
    line = draw_leader_parameters(actor, draw_x, draw_y, param_width)
    draw_y += line * line_height
    # 装備
    line = draw_leader_equipments(actor, draw_x + 16, draw_y)
    draw_y += line * line_height
    return draw_x, draw_y
  end
  #--------------------------------------------------------------------------
  # ● リーダーの基本情報の描画 (最大描画幅を返す)
  #--------------------------------------------------------------------------
  def draw_leader_base_info(actor, x, y)
    draw_width = 0
    # レベル (名前の下に表示する場合)
    if ZiifSaveLayoutA::D_Level && ZiifSaveLayoutA::D_UnderName == :level
      draw_actor_level(actor, x, y)
      draw_width = [draw_width, 96].max
    end
    # 職業 (名前の下に表示する場合)
    if ZiifSaveLayoutA::D_Class && ZiifSaveLayoutA::D_UnderName == :class
      draw_actor_class(actor, x, y)
      draw_width = [draw_width, 112].max
    end
    # HP・MP
    if ZiifSaveLayoutA::D_HPMP
      draw_actor_hp(actor, x, y + line_height * 1)
      draw_actor_mp(actor, x, y + line_height * 2)
      draw_width = [draw_width, 124].max
    end
    return draw_width
  end
  #--------------------------------------------------------------------------
  # ● リーダーのネーム情報の描画 (描画位置を返す)
  #--------------------------------------------------------------------------
  def draw_leader_name_info(actor, x, y)
    draw_x = x
    # 名前
    if ZiifSaveLayoutA::D_Name
      draw_actor_name(actor, draw_x, y)
      draw_x += 126
    end
    # レベル (名前の下に表示しない場合)
    if ZiifSaveLayoutA::D_Level && ZiifSaveLayoutA::D_UnderName != :level
      draw_actor_level(actor, draw_x, y)
      draw_x += 80
    end
    # 職業 (名前の下に表示しない場合)
    if ZiifSaveLayoutA::D_Class && ZiifSaveLayoutA::D_UnderName != :class
      draw_actor_class(actor, draw_x, y)
      draw_x += 110
    end
    # 二つ名
    if ZiifSaveLayoutA::D_Nickname
      draw_actor_nickname(actor, draw_x, y)
      draw_x += 180
    end
    return draw_x
  end
  #--------------------------------------------------------------------------
  # ● リーダーの能力値の描画 (描画行数を返す)
  #--------------------------------------------------------------------------
  def draw_leader_parameters(actor, x, y, width = 120)
    return 0 unless ZiifSaveLayoutA::D_Param
    col_num    = [width / 128, 1].max
    draw_width = width / col_num
    6.times do |i|
      draw_x = x + draw_width  * (i % col_num) + 4
      draw_y = y + line_height * (i / col_num)
      draw_actor_param_with_width(actor, draw_x, draw_y, i + 2, draw_width - 8)
    end
    return (5 + col_num) / col_num
  end
  #--------------------------------------------------------------------------
  # ● 能力値の描画 (横幅付きで描画)
  #--------------------------------------------------------------------------
  def draw_actor_param_with_width(actor, x, y, param_id, width)
    change_color(system_color)
    draw_text(x, y, width - 36, line_height, Vocab::param(param_id))
    change_color(normal_color)
    draw_text(x + width - 36, y, 36, line_height, actor.param(param_id), 2)
  end
  #--------------------------------------------------------------------------
  # ● リーダーの装備品の描画 (描画行数を返す)
  #--------------------------------------------------------------------------
  def draw_leader_equipments(actor, x, y)
    return 0 unless ZiifSaveLayoutA::D_Equip
    actor.equips.each_with_index do |item, i|
      draw_item_name(item, x, y + line_height * i)
    end
    return actor.equips.size
  end
  #--------------------------------------------------------------------------
  # ● リーダー情報で顔グラフィック描画をしたかどうか (パーティ表示用)
  #--------------------------------------------------------------------------
  def leader_face_draw?
    header?(:leader) &&
    ZiifSaveLayoutA::D_LeaderInfo && ZiifSaveLayoutA::D_Face
  end
  #--------------------------------------------------------------------------
  # ● パーティの顔グラフィックの描画
  #--------------------------------------------------------------------------
  def draw_party_faces
    return unless ZiifSaveLayoutA::D_PartyFaces && header?(:faces)
    draw_y = (file_info_draw? ? line_height : 0)
    draw_y += [96, line_height * 4].max if ZiifSaveLayoutA::D_LeaderInfo
    draw_x = 4
    @header[:faces].each_with_index do |data, i|
      next if i == 0 && leader_face_draw?
      draw_face_height88(data[0], data[1], draw_x, draw_y)
      draw_x += 100
    end
  end
  #--------------------------------------------------------------------------
  # ● パーティの歩行グラフィックの描画
  #--------------------------------------------------------------------------
  def draw_party_characters
    return unless ZiifSaveLayoutA::D_Characters && header?(:characters)
    draw_y  = contents.height - 8
    draw_y -= line_height if ZiifSaveLayoutA::D_AG_Line
    draw_x  = 28
    @header[:characters].each_with_index do |data, i|
      draw_character(data[0], data[1], draw_x, draw_y)
      draw_x += 48
    end
  end
  #--------------------------------------------------------------------------
  # ● 顔グラフィックの描画 (高さを 88px で描画)
  #--------------------------------------------------------------------------
  def draw_face_height88(face_name, face_index, x, y, enabled = true)
    bitmap = Cache.face(face_name)
    rect = Rect.new(face_index % 4 * 96, face_index / 4 * 96 + 4, 96, 88)
    contents.blt(x, y + 4, bitmap, rect, enabled ? 255 : translucent_alpha)
  end
end