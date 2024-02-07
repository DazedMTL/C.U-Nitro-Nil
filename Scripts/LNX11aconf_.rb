#==============================================================================
# ★ RGSS3-Extension
# LNX11aconf_XPスタイルバトル#コンフィグ
# 　このスクリプトは LNX11a_XPスタイルバトル の設定スクリプトです。
# 　単体では何の機能も持ちませんのでご注意ください。
#
# 　version   : 1.10 (12/11/18)
# 　author    : ももまる
# 　reference : http://peachround.blog.fc2.com/blog-entry-9.html
#
#==============================================================================

module LNX11
  #--------------------------------------------------------------------------
  # ■ Index
  #
  # line 026 : 基本設定              line 244 : パーティコマンド
  # line 048 : アクターエリアの背景  line 259 : ターゲットカーソル
  # line 065 : バトルログ            line 289 : ターゲットヘルプ
  # line 118 : バトルメッセージ      line 305 : ポップアップ
  # line 159 : バトラーグラフィック  line 507 : ユーザビリティ
  # line 182 : バトルステータス      line 535 : その他
  # line 212 : アクターコマンド      
  #
  #--------------------------------------------------------------------------
  # ● 基本設定
  #--------------------------------------------------------------------------
  # デフォルトで表示するアクターのバトラーグラフィック
  # 　0 = 顔グラフィック / 0 = 歩行グラフィック
  DEFAULT_BATTLER_GRAPHIC = 0  # 規定値:0
  
  # デフォルトバトラーグラフィックの背景グラデーション色([Color1, Color2]) 
  DEFAULT_BG_COLOR        = [Color.new(0, 0, 0, 0), Color.new(0, 0, 0, 0)]
                   # 規定値:[Color.new(0, 0, 0, 0), Color.new(0, 0, 0, 0)]
  
  # 画面の色調変更をアクターに適用する true = 有効 / false = 無効
  # * true にするとアクターエリアの背景にも適用されます
  ACTOR_SCREEN_TONE       = false  # 規定値:false
  
  # TP のポップアップ設定
  # 　0 = すべてポップアップする / 1 = アクターのみ / 2 = ポップアップしない
  TP_POPUP_TYPE           = 1      # 規定値:1
  
  # アイコン無しのステートをポップアップしない true = 有効 / false = 無効
  INDEXZERO_NO_POPUP      = true   # 規定値:true

  #--------------------------------------------------------------------------
  # ● 設定:アクターエリアの背景
  #--------------------------------------------------------------------------
  # アクターエリアの背景のタイプ
  # 　0 = 無し / 1 = グラデーション / 2 = ウィンドウ / "文字列" = 画像
  ACTOR_BACKGROUND        = 1   # 規定値:2
  
  # アクターエリア背景の高さ
  ACTOR_BACKGROUND_HEIGHT = 112 # 規定値:112
  
    #------------------------------------------------------------------------
    # ○ タイプ [1:グラデーション] の設定
    #------------------------------------------------------------------------
    # グラデーションの色([Color1, Color2])
    ACTOR_BG_GRADIENT_COLOR = [Color.new(0, 0, 0, 96), Color.new(0, 0, 0, 224)]
                     # 規定値:[Color.new(0, 0, 0, 96), Color.new(0, 0, 0, 224)]
  
  #--------------------------------------------------------------------------
  # ● 設定:バトルログ
  #--------------------------------------------------------------------------
  # バトルログ(戦闘進行の実況)のタイプ
  # 0 = VXAceデフォルト / 1 = 蓄積型 / 2 = ヘルプ表示
  BATTLELOG_TYPE  =  1  # 規定値:1
  
    #------------------------------------------------------------------------
    # ○ バトルログタイプ [1:蓄積型] の設定
    #------------------------------------------------------------------------
    # 一度に表示する行数
    STORAGE_LINE_NUMBER     = 6     # 規定値:6
    
    # 一行の高さ
    STORAGE_LINE_HEIGHT     = 20    # 規定値:20
    
    # 自動的にログが進行する時間(フレーム)
    STORAGE_UP_MESSAGE_TIME = 90    # 規定値:90
    
    # ターン終了時にバトルログを消去する true = 有効 / false = 無効
    STORAGE_TURNEND_CLEAR   = true  # 規定値:true
    
    # 座標の調整 :x = X座標 / :y = Y座標
    STORAGE_OFFSET = {:x => 0, :y => 6}  # 規定値:{:x => 0, :y => 6}
    
    # フォント :size = フォントサイズ / :out_color = テキストの縁取り色
    STORAGE_FONT   = {:size => 20, :out_color => Color.new(0, 0, 0, 192)}
            # 規定値:{:size => 20, :out_color => Color.new(0, 0, 0, 192)}
    
    # 背景のグラデーションの色([Color1, Color2])
    STORAGE_GRADIENT_COLOR = [Color.new(0, 0, 0, 128), Color.new(0, 0, 0, 0)]
                    # 規定値:[Color.new(0, 0, 0, 128), Color.new(0, 0, 0, 0)]
    
    #------------------------------------------------------------------------
    # ○ バトルログタイプ [2:ヘルプ表示] の設定
    #------------------------------------------------------------------------
    # ポップアップのウェイト
    POPUP_ADD_WAIT          = 6     # 規定値:6

    # 行動の表示形式 0 = アイコン+名前 / 1 = 名前のみ
    HELPDISPLAY_TYPE        = 1     # 規定値:1
    
    # 行動の表示始めの追加ウェイト
    HELPDISPLAT_WAIT        = 20    # 規定値:20
    
    # 行動の表示終了までの追加ウェイト
    HELPDISPLAT_END_WAIT    = 24    # 規定値:24
    
    # 行動の簡易説明文
    # :size = フォントサイズ　:delimiter = 名前と簡易説明文の区切り文字
    HELPDISPLAY_DESCRIPTION = {:size => 20, :delimiter => " "}
                     # 規定値:{:size => 20, :delimiter => " "}
  
  #--------------------------------------------------------------------------
  # ● 設定:バトルメッセージ
  #--------------------------------------------------------------------------
  # バトルメッセージ(戦闘開始・逃走・リザルト等)の表示先
  # 0 = メッセージウィンドウ / 1 = バトルログ / 2 = ヘルプ
  MESSAGE_TYPE  =  2   # 規定値:2

    #------------------------------------------------------------------------
    # ○ バトルメッセージタイプ [0:メッセージウィンドウ] の設定
    #------------------------------------------------------------------------
    # メッセージウィンドウの背景 0 = ウィンドウ / 1 = 背景を暗くする / 2 = 透明
    MESSAGE_WINDOW_BACKGROUND  = 0     # 規定値:1
  
    # メッセージウィンドウの位置 0 = 上 / 1 = 中 / 2 = 下
    MESSAGE_WINDOW_POSITION    = 0     # 規定値:0

    #------------------------------------------------------------------------
    # ○ バトルメッセージタイプ [2:ヘルプ] の設定
    #------------------------------------------------------------------------
    # ヘルプバトルメッセージのウェイト
    #   [ウェイト(フレーム), キー入力を待つ(true = 有効 / false = 無効)]
    # 　:battle_start = 戦闘開始      :victory = 勝利
    # 　:escape       = 逃走          :defeat  = 敗北
    # 　:drop_item    = アイテム獲得　:levelup = レベルアップ
    MESSAGE_WAIT = {:battle_start => [120, false], :victory   => [ 60, false], 
                    :defeat       => [120, false], :escape    => [120, false], 
                    :drop_item    => [ 60,  true], :levelup   => [ 60,  true]}
          # 規定値:{:battle_start => [120, false], :victory   => [ 60, false], 
          #         :defeat       => [120, false], :escape    => [120, false], 
          #         :drop_item    => [ 60,  true], :levelup   => [ 60,  true]}
  
  # 戦闘開始時の敵出現メッセージを表示する
  MESSAGE_WINDOW_ENEMY_NAMES = false # 規定値:false
  
  # レベルアップ SE  RPG::SE.new("ファイル名", 音量, ピッチ)
  LEVELUP_SE  = RPG::SE.new("Up4", 90, 100)   # 規定値:("Up4", 90, 100)
  
  # ドロップアイテム獲得 SE  RPG::SE.new("ファイル名", 音量, ピッチ)
  # * バトルメッセージタイプが 0 以外の場合のみ再生されます。
  DROPITEM_SE = RPG::SE.new("Item3", 80, 125) # 規定値:("Item3", 80, 125)
  
  #--------------------------------------------------------------------------
  # ● 設定:アクターのバトラーグラフィック
  #--------------------------------------------------------------------------
  # アクター表示を中央揃えにする true = 有効 / false = 左揃え
  ACTOR_CENTERING  =  true    # 規定値:true

    #------------------------------------------------------------------------
    # ○ アクター表示中央揃えの設定
    #------------------------------------------------------------------------
    # アクター間のスペースの大きさ補正
    ACTOR_SPACING_ADJUST = 32 # 規定値:32
    
  # 座標の調整 :x = X座標 / :y = Y座標
  # * アクターコマンドのX座標には影響しません。
  ACTOR_OFFSET  = {:x => -16, :y => 50}       # 規定値:{:x => -16, :y => 0}
  
  # アクターエリアと画面端との余白 :side = 左右の余白 / :bottom = 下の余白
  ACTOR_PADDING = {:side => 4, :bottom => 8} # 規定値:{:side => 4, :bottom => 8}
  
  # パーティに対する画面アニメーションのY座標修正
  # 　位置が[画面]のアニメーションをパーティの中心に表示されるようにします。
  SCREEN_ANIMATION_OFFSET = 128  # 規定値:128
  
  #--------------------------------------------------------------------------
  # ● 設定:バトルステータス
  #--------------------------------------------------------------------------
  # 座標の調整  :x = X座標 / :y = Y座標
  #　 X 座標はアクターの中心を基準とします。
  # * パーティメンバーの数やステータス幅によっては、X 座標が自動的に
  # 調整される場合があります。
  STATUS_OFFSET = {:x => 64, :y => -12} # 規定値:{:x => 64, :y => -12}
  
  # 画面左右端の余白
  STATUS_SIDE_PADDING   = 6     # 規定値:6
  
  # アクター1人あたりのステータス幅
  STATUS_WIDTH          = 72    # 規定値:72

  # ステータス幅の自動調整を行う
  STATUS_AUTOADJUST     = true  # 規定値:true
  
  # 行の高さ
  STATUS_LINE_HEIGHT    = 22    # 規定値:22
  
  # アクターの名前のフォントサイズ 値を 0 にすると非表示になる
  STATUS_NAME_SIZE      = 20    # 規定値:20
  
  # HP/MP/TPのフォントサイズ
  STATUS_PARAM_SIZE     = 23    # 規定値:23
  
  # HP/MP/TPゲージの不透明度 (0-255)
  STATUS_GAUGE_OPACITY  = 192   # 規定値:192

  #--------------------------------------------------------------------------
  # ● 設定:アクターコマンド
  #--------------------------------------------------------------------------
  # コマンドの項目数が 4 を超える場合、項目がすべて見えるように
  # コマンドウィンドウの高さを拡張する true = 有効 / false = 無効
  ACTOR_COMMAND_NOSCROLL   = true  # 規定値:true
  
  # コマンドを横並びにする true = 横並び / false = 縦並び
  ACTOR_COMMAND_HORIZON    = false # 規定値:false

  # 文字揃え 0 = 左揃え / 1 = 中央揃え / 2 = 右揃え
  ACTOR_COMMAND_ALIGNMENT  = 0     # 規定値:0
  
  # ウィンドウの横幅
  # 　コマンドを横並びにする場合、大きめの値を設定してください。
  ACTOR_COMMAND_WIDTH      = 128   # 規定値:128
  
  # ウィンドウの位置
  # 　0 = アクターの頭上 / 1 = Y座標を固定 / 2 = XY座標を固定
  ACTOR_COMMAND_POSITION   = 0     # 規定値:0

    #------------------------------------------------------------------------
    # ○ ウィンドウの位置 [1:Y座標固定 2:XY座標] の設定
    #------------------------------------------------------------------------
    # 固定Y座標の基準位置
    # 0 = 画面下端 - ウィンドウの高さ / 画面上端
    ACTOR_COMMAND_Y_POSITION = 0   # 規定値:0
  
    # ウィンドウのXY座標修正 :x = X座標 / :y = Y座標
    # * コマンド位置が 1 or 2 の場合、ここで設定した値で座標を固定します。
    ACTOR_COMMAND_OFFSET  = {:x => 0, :y => -16} # 規定値:{:x => 0, :y => -16}
  
  #--------------------------------------------------------------------------
  # ● 設定:パーティコマンド
  #--------------------------------------------------------------------------
  # コマンドを横並びにする true = 横並び / false = 縦並び
  PARTY_COMMAND_HORIZON   = true  # 規定値:true
  
  # 文字揃え 0 = 左揃え / 1 = 中央揃え / 2 = 右揃え
  PARTY_COMMAND_ALIGNMENT = 1     # 規定値:1
  
  # ウィンドウの幅
  PARTY_COMMAND_WIDTH     = Graphics.width     # 規定値:Graphics.width
  
  # ウィンドウの座標 :x = X座標 / :y = Y座標
  PARTY_COMMAND_XY        = {:x => 0, :y => 0} # 規定値:{:x => 0, :y => 0}
  
  #--------------------------------------------------------------------------
  # ● 設定:ターゲットカーソル
  #--------------------------------------------------------------------------
  # カーソルグラフィックのファイル名 (Graphics/System/*)
  # 　"" を設定した場合、Bitmap の機能でカーソルを自動生成します。
  CURSOR_NAME       = ""    # 規定値:""
  
    #------------------------------------------------------------------------
    # ○ 自動生成のカーソルグラフィックの設定
    #------------------------------------------------------------------------
    # カーソルの色調 (Red, Green, Blue)
    # 　nil を設定した場合、データベースのウィンドウカラーと同じになります。
    CURSOR_TONE     = Tone.new(-34, 0, 68)  # 規定値:Tone.new(-34, 0, 68)
  
  # アニメーションスピード
  CURSOR_ANI_SPEED  = 3     # 規定値:3
    
  # 移動スピード
  CURSOR_SPEED      = 3     # 規定値:3
  
  # 対象選択時にカーソルを点滅させる
  CURSOR_BLINK      = true  # 規定値:true
  
  # カーソルのY座標の制限 :min = 最小値 / :max = 最大値
  CURSOR_MINMAX     = {:min => 48, :max => Graphics.height}
             # 規定値:{:min => 48, :max => Graphics.height}
  
  # カーソル位置のXY座標修正 :x = X座標 / :y = Y座標
  CURSOR_OFFSET     = {:x => 0, :y => 0} # 規定値:{:x => 0, :y => 0}

  #--------------------------------------------------------------------------
  # ● 設定:ターゲットヘルプ
  #--------------------------------------------------------------------------
  # バトラーの各パラメータ表示 true = 表示 / false = 非表示
  HELP_ACTOR_PARAM = {:hp => true ,:mp => true ,:tp => true ,:state => true }
  HELP_ENEMY_PARAM = {:hp => false,:mp => false,:tp => false,:state => true }
    # アクター規定値:{:hp => true ,:mp => true ,:tp => true ,:state => true }
    # 敵キャラ規定値:{:hp => false,:mp => false,:tp => false,:state => true } 
  
  # HP/MP/TP ゲージの幅
  HELP_PARAM_WIDTH    = 72  # 規定値:72
  
  # 敵ランダムの表示形式
  # 0 = 敵全体 ランダム / 1 = 敵ｎ体 ランダム
  RANDOMSCOPE_DISPLAY = 1   # 規定値:1
  
  #--------------------------------------------------------------------------
  # ● 設定:ポップアップ
  #--------------------------------------------------------------------------
  # ポップアップ位置 0 = 足元 / 1 = 中心 / 2 = 頭上 / 3 = 一定(アクターのみ)
  ACTOR_POPUP_POSITION   = 3  # アクター     規定値:3
  ENEMY_POPUP_POSITION   = 1  # 敵キャラ     規定値:1
  LEVELUP_POPUP_POSITION = 3  # レベルアップ 規定値:3
  
    #------------------------------------------------------------------------
    # ○ ポップアップ位置 [3:一定(アクターのみ)] の設定
    #------------------------------------------------------------------------
    # アクターのポップアップの Y 座標
    # 　ゲーム画面の高さ(Graphics.height)を基準とします。
    ACTOR_POPUP_Y     =  -100  # 規定値:-100
    
    # レベルアップのポップアップの Y 座標
    # 　ゲーム画面の高さ(Graphics.height)を基準とします。
    LEVELUP_POPUP_Y   =  -112  # 規定値:-112
  
  # 数字のフォント
  NUMBER_FONT   =  ["Arial Black", "VL Gothic"] # ["Arial Black", "VL Gothic"] 
  
  # ステート等のテキストのフォント
  TEXT_FONT     =  ["Arial Black", "VL Gothic"] # ["Arial Black", "VL Gothic"] 
  TEXT_FONT_MCS =  ["VL Gothic"]       #日本語を含む場合。規定値:["VL Gothic"]
  
  # 画像フォントのファイル名 (Graphics/System/*) <<ver1.10>>
  # 　"" を設定した場合、通常のフォントを利用します。
  # 数字
  LARGE_NUMBER_NAME = "popup_number02_large"    # 規定値:""
  SMALL_NUMBER_NAME = "popup_number02_small"    # 規定値:""
  # 能力
  LARGE_BUFFS_NAME  = "popup_buffs_large"       # 規定値:""
  SMALL_BUFFS_NAME  = "popup_buffs_small"       # 規定値:""
  
  # 数字のサイズ・字間
  # 　:fontsize = フォントサイズ / :spacing = 字間
  # 　:width    = 一字あたりの幅 / :height = 一字あたりの高さ
  LARGE_NUMBER  =  {:fontsize => 38, :spacing => -4, :line_height => 26}
  SMALL_NUMBER  =  {:fontsize => 28, :spacing => -4, :line_height => 20}
  # 大サイズ規定値:{:fontsize => 38, :spacing => -4, :line_height => 26}
  # 小サイズ規定値:{:fontsize => 28, :spacing => -4, :line_height => 20}
  
  # テキストのフォントサイズ倍率
  #   :normal     = テキスト単体
  #   :left_right = ダメージ左右   :top_bottom = ダメージ上下
  # * 数字のフォントサイズからの割合で指定します。
  TEXT_SIZERATE     = {:normal => 0.8, :left_right => 0.7, :top_bottom => 0.6}
             # 規定値:{:normal => 0.8, :left_right => 0.7, :top_bottom => 0.6}
  
  # 日本語を含むテキストのフォントサイズ倍率 
  # * 通常のテキストフォントサイズからの倍率で指定します。
  TEXT_SIZERATE_MCS = 0.9   # 規定値:0.9
  
  # ポップアップの修飾文字
  # ["テキスト", 修飾文字の位置(2 = 下 / 4 = 左 / 6 = 右 / 8 = 上)]
  # * 文字列中の \mp \tp はデータベースで設定した用語(短)に置き換わります
  DECORATION_NUMBER = {            # 規定値
  :critical    => ["_critical", 8], # ["CRITICAL", 8] / クリティカル
  :weakness    => ["_weakness", 8], # ["WEAKNESS", 8] / 弱点ダメージ
  :resist      => ["_resist"  , 8], # ["RESIST"  , 8] / 耐性ダメージ
  :mp_damage   => ["_mp"      , 4], # ["\mp"     , 4] / MP ダメージ・回復
  :mp_plus     => ["_mp+"     , 4], # ["\mp+"    , 4] / MP 再生
  :mp_minus    => ["_mp-"     , 4], # ["\mp-"    , 4] / MP 消費
  :tp_plus     => ["_tp+"     , 4], # ["\tp+"    , 4] / TP 増加
  :tp_minus    => ["_tp-"     , 4], # ["\tp-"    , 4] / TP 減少
  }
  # ステートや能力強化/弱体のポップアップの修飾文字
  # 　%s にステート・能力名が入る
  DECORATION_TEXT = {               # 規定値
  :add_state   => "+%s",            # "+%s"           / ステート付加
  :rem_state   => "-%s",            # "-%s"           / ステート解除
  :add_buff    => "%s UP",          # "%s UP"         / 能力強化付加
  :add_debuff  => "%s DOWN",        # "%s DOWN"       / 能力弱体付加
  :rem_buff    => "-%s Buff",       # "-%s Buff"      / 能力強化/弱体解除
  }
  # ポップアップの表示用語
  POPUP_VOCAB = {                   # 規定値
  :miss        => "_miss",          # "MISS!"         / ミス
  :counter     => "_counter",       # "Counter"       / 反撃
  :reflection  => "_reflection",    # "Reflection"    / 反射
  :substitute  => "_substitute",    # "Substitute"    / 身代わり
  :levelup     => "_levelup",       # "LEVELUP!"      / レベルアップ
  }
  # 能力強化/弱体ポップアップのパラメータ表記
  # * 文字列中の \hp \mp はデータベースで設定した用語(短)に置き換わります
  POPUP_VOCAB_PARAMS = [ # 規定値
  "MAX\hp",              # "MAX\hp"  / 最大HP    MAXimum Hit Point
  "MAX\mp",              # "MAX\mp"  / 最大MP    MAXimum Magic Point
  "ATK",                 # "ATK"     / 攻撃力    ATtacK power
  "DEF",                 # "MATK"    / 防御力    DEFense power
  "MATK",                # "MDEF"    / 魔法力    Magic ATtacK power
  "MDEF",                # "MDEF"    / 魔法防御  Magic DEFense power
  "AGI",                 # "AGI"     / 敏捷性    AGIlity
  "LUCK",                # "LUCK"    / 運        LUCK
  ]
  # ポップアップの色([Color1, Color2])
  # * ハッシュの順序を変更しないこと
  POPUP_COLOR = {
  # HP ダメージ(ミス)
  :hp_damage     => [Color.new(255, 255, 255), Color.new(  0,   0,   0)],
  # クリティカルダメージ
  :critical      => [Color.new(255, 255,  80), Color.new(224,  32,   0)],
  # 弱点ダメージ
  :weakness      => [Color.new(255, 255, 255), Color.new(  0,  56, 144)],
  # 耐性ダメージ
  :resist        => [Color.new(232, 224, 216), Color.new( 56,  48,  40)],
  # HP 回復(再生,吸収)
  :hp_recovery   => [Color.new( 96, 255, 128), Color.new(  0,  64,  32)],
  # MP ダメージ
  :mp_damage     => [Color.new(248,  80, 172), Color.new( 48,   0,  32)],
  # MP 回復(再生,吸収)
  :mp_recovery   => [Color.new(160, 240, 255), Color.new( 32,  48, 144)],
  # TP 増減
  :tp_damage     => [Color.new(248, 240,  64), Color.new(  0,  80,  40)],
  # 有利なステートの付加
  :add_state     => [Color.new(255, 255, 255), Color.new(  0,  56, 144)],
  # 有利なステートの解除
  :rem_state     => [Color.new(224, 232, 240), Color.new( 32,  64, 128, 128)],
  # ステートの付加
  :add_badstate  => [Color.new(255, 255, 255), Color.new(  0,   0,   0)],
  # ステートの解除
  :rem_badstate  => [Color.new(224, 224, 224), Color.new( 32,  32,  32, 128)],
  # 能力強化の付加
  :add_buff      => [Color.new(255, 255, 192), Color.new( 96,  64,   0)],
  # 能力弱体の付加
  :add_debuff    => [Color.new(200, 224, 232), Color.new( 40,  48,  56)],
  # 能力強化/弱体の解除
  :rem_buff      => [Color.new(224, 224, 224), Color.new( 32,  32,  32, 128)],
  # 反撃
  :counter       => [Color.new(255, 255, 224), Color.new(128,  96,   0)],
  # 反射
  :reflection    => [Color.new(224, 255, 255), Color.new(  0,  96, 128)],
  # 身代わり
  :substitute    => [Color.new(224, 255, 224), Color.new(  0, 128,  64)],
  # レベルアップ
  :levelup       => [Color.new(255, 255, 255), Color.new(  0,   0,   0)],
  }
  # ポップアップのタイプ        -1 = ポップアップしない
  #  0 = 跳ねるポップアップ(大)  4 = スライド(大)
  #  1 = 跳ねるポップアップ(小)  5 = スライド(小)
  #  2 = ゆっくり上昇(大)        6 = オーバーレイ(大)
  #  3 = ゆっくり上昇(小)        7 = オーバーレイ(小)
  POPUP_TYPE = {          # 規定値
  :miss          =>   0,  #   0 / ミス
  :hp_damage     =>   0,  #   0 / HP ダメージ
  :hp_slipdamage =>   1,  #   1 / HP スリップダメージ
  :hp_recovery   =>   0,  #   0 / HP 回復
  :hp_regenerate =>   1,  #   1 / HP 再生
  :hp_drain      =>   0,  #   0 / HP 被吸収
  :hp_drainrecv  =>   0,  #   0 / HP 吸収回復
  :mp_damage     =>   0,  #   0 / MP ダメージ
  :mp_slipdamage =>   1,  #   1 / MP スリップダメージ
  :mp_recovery   =>   0,  #   0 / MP 回復
  :mp_regenerate =>   1,  #   1 / MP 再生
  :mp_drain      =>   0,  #   0 / MP 被吸収
  :mp_drainrecv  =>   0,  #   0 / MP 吸収回復
  :mp_paycost    =>  -1,  #  -1 / MP 消費
  :tp_damage     =>   1,  #   1 / TP 増加(ダメージ)
  :tp_charge     =>  -1,  #  -1 / TP チャージ(被ダメージ時の TP 増加)
  :tp_gain       =>   7,  #   7 / TP 得
  :tp_regenerate =>   1,  #   1 / TP 再生(スリップダメージ)
  :tp_paycost    =>  -1,  #  -1 / TP 消費
  # ステート/能力
  :add_state     =>   2,  #   2 / 有利なステートの付加
  :rem_state     =>   2,  #   2 / 有利なステートの解除
  :add_badstate  =>   2,  #   2 / 不利なステートの付加
  :rem_badstate  =>   2,  #   2 / 不利なステートの解除
  :add_buff      =>   3,  #   3 / 能力強化の付加
  :add_debuff    =>   3,  #   3 / 能力弱体の付加
  :rem_buff      =>   3,  #   3 / 能力強化/弱体の解除
  # 特殊
  :counter       =>   6,  #   6 / 反撃
  :reflection    =>   6,  #   6 / 反射
  :substitute    =>   4,  #   4 / 身代わり
  }
  # 0:跳ねるポップアップの動き(大)
  LARGE_MOVEMENT = {
  :inirate    => 6.4,  :gravity      => 0.68,  :side_scatter => 1.2,
  :ref_height =>  32,  :ref_factor   => 0.60,  :ref_count    =>   2,
                       :duration     =>   40,  :fadeout      =>  20 }
  # 1:跳ねるポップアップの動き(小)
  SMALL_MOVEMENT = {
  :inirate    => 4.4,  :gravity      => 0.60,  :side_scatter => 0.0,
  :ref_height =>  12,  :ref_factor   => 0.70,  :ref_count    =>   0,
                       :duration     =>   60,  :fadeout      =>  16 }
  # 2,3:上昇ポップアップの動き
  RISE_MOVEMENT     = {:rising_speed => 0.75,  :line_spacing => 0.9,
                       :duration     =>   40,  :fadeout      =>   8 }
  # 4,5:スライドポップアップの動き
  SLIDE_MOVEMENT    = {:x_speed      =>    2,  :line_spacing => 0.9,
                       :duration     =>   50,  :fadeout      =>  32 }
  # 6,7:オーバーレイポップアップの動き
  OVERLAY_MOVEMENT  = {:duration     =>   36,  :fadeout      =>  32 }

  # :inirate      = 初速度                :gravity    = 重力加速度
  # :side_scatter = 左右移動のばらつき    :ref_height = 跳ね返り位置
  # :ref_factor   = 反発係数              :ref_count  = 跳ね返り回数
  # :duration     = 消え始めるまでの時間  :fadeout    = 消える速度
  # :rising_speed = 上昇速度              :x_speed    = 横移動速度
  # :line_spacing = ポップアップの行間
  
  #--------------------------------------------------------------------------
  # ● 設定:ユーザビリティ
  #--------------------------------------------------------------------------  
  # 効果範囲が 使用者/全体/ランダム のスキル・アイテムの対象確認を行う
  # 　true = 有効 / false = 無効
  FIX_TARGET_CHECKE     = true   # 規定値:true
    
  # 防御コマンドの対象確認を行う     true = 有効 / false = 無効
  GUARD_TARGET_CHECKE   = true   # 規定値:true
  
  # アクターの対象選択を最適化する   true = 有効 / false = 無効
  SMART_TARGET_SELECT   = true   # 規定値:true
  
  # 対象選択のカーソル位置を記憶する true = 有効 / false = 無効
  LAST_TARGET           = true   # 規定値:true

  # パーティコマンドのカーソル位置を記憶する    true = 有効 / false = 無効
  LAST_PARTY_COMMAND    = true   # 規定値:true 
  
  # アクターコマンドのカーソル位置を記憶する    true = 有効 / false = 無効
  LAST_ACTOR_COMMAND    = true   # 規定値:true 
  
  # 敵キャラのインデックスを X 座標でソートする true = 有効 / false = 無効
  TROOP_X_SORT          = true   # 規定値:true
  
  # パーティコマンド入力回数を最適化する        true = 有効 / false = 無効
  PARTY_COMMAND_SKIP    = true   # 規定値:true
  
  #--------------------------------------------------------------------------
  # ● 設定:その他
  #--------------------------------------------------------------------------
  # スキルリストとアイテムリストを項目数に合わせてリサイズする
  # 　true = 有効 / false = 無効
  FITTING_LIST          = true   # 規定値:true
    
  # バトラーの行動時の白フラッシュを強める          true = 有効 / false = 無効
  ENHANCED_WHITEN       = true   # 規定値:true
  
  # ダメージを受けた時の画面のシェイクを行わない    true = 有効 / false = 無効
  DISABLED_DAMAGE_SHAKE = true   # 規定値:true
  
  # 敵キャラの X 座標を画面サイズに合わせて修正する true = 有効 / false = 無効
  TROOP_X_SCREEN_FIX    = true   # 規定値:true
  
  # 敵キャラの Y 座標の調整
  TROOP_Y_OFFSET        = 0      # 規定値:0
  
  #
  # 設定ここまで お疲れ様でした。
  #
end
#==============================================================================
# ■ LNXスクリプト導入情報
#==============================================================================
$lnx_include = {} if $lnx_include == nil
$lnx_include[:lnx11aconf] = 110 # version
p "OK:LNX11aconf_XPスタイルバトル#コンフィグ"