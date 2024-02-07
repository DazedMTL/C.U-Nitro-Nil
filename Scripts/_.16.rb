#==============================================================================
# ■ RGSS3 スイッチ依存タイトルグラフィック Ver1.00 by 星潟
#------------------------------------------------------------------------------
# 現在ゲームフォルダ内に保存されているセーブデータのスイッチの状態に応じて
# タイトルグラフィックを変更できるようになります。
# （本来の場所にセーブデータがない場合は正常に動作しません）
#==============================================================================
module TITLE_SWITCH
  
  #スイッチに応じたタイトルグラフィックを指定します。
  #[スイッチID,1つ目の画像ファイル名,2つ目の画像ファイル名]の
  #3項目で1セットとなっています。
  #複数該当する場合は、より下に設定された物が優先されます。
  #グラフィック指定をなしにする場合は
  #ファイル名を""とし、中に何も入れないで下さい
  
 T_GRAPHIC   = [
  [998,"title2",""],
  [998,"title",""],
  ]
  
end
class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # 背景の作成
  #--------------------------------------------------------------------------
  alias create_background_title_switch create_background
  def create_background
    
    #スイッチの情報を取得します。
    
    extract_savedata_switches
    
    #本来のタイトルグラフィック名を保存します。
    
    title1_name = $data_system.title1_name
    title2_name = $data_system.title2_name
    
    #タイトルグラフィックをスイッチに応じて変更します。
    
    title_graphic_switch
    
    #本来の処理を実行します。
    
    create_background_title_switch
    
    #タイトルグラフィックの指定を元に戻します。
    
    $data_system.title1_name = title1_name
    $data_system.title2_name = title2_name
  end
  #--------------------------------------------------------------------------
  # スイッチ情報の取得
  #--------------------------------------------------------------------------
  def extract_savedata_switches
    
    #専用のスイッチ配列を生成します。
    #他スクリプトとの競合を回避する為に、専用のデータを用意します。
    
    @switches_data = Game_Switches.new
    
    #データマネージャーで設定されたセーブファイル最大値の回数分だけ処理します。
    
    DataManager.savefile_max.times {|i|
    begin
      
      #順番にセーブファイルを開きます。
      
      File.open(DataManager.make_filename(i), "rb") do |file|
        
        #とりあえずヘッダーをロードします。
        
        Marshal.load(file)
        
        #ファイルデータをロードします。
        
        contents = Marshal.load(file)
        
        #スイッチデータをデータ部分のみ抜き出します。
        
        switches        = contents[:switches].switch_data_get
        
        #各スイッチがtrueの場合のみ取得します。
        
        switches.each_with_index {|s, s_id|
        @switches_data[s_id] = s if s
      }
      end
    rescue
    end
    }
  end
  #--------------------------------------------------------------------------
  # スイッチの状態に応じてタイトル画像を変更
  #--------------------------------------------------------------------------
  def title_graphic_switch
    
    #設定データの上から順に処理を行います。
    
    TITLE_SWITCH::T_GRAPHIC.each {|data|
    next if !@switches_data[data[0]]
    $data_system.title1_name = data[1]
    $data_system.title2_name = data[2]
    }
  end
end
class Game_Switches
  #--------------------------------------------------------------------------
  # スイッチデータをデータ部分のみ抜き出す
  #--------------------------------------------------------------------------
  def switch_data_get
    @data
  end
end