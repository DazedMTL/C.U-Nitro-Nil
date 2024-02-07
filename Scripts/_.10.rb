#******************************************************************************
#
#   ＊ 共通セーブファイル ＊
#
#                       for RGSS3
#
#        Ver 1.01   2013.08.24
#
#   ◆使い方
#     数字でも文字でも、お好きな名前（ID）への値の保存/読込が出来ます。
#     １．True/Falseの値の場合
#         例）保存：$savec.set("id", True)
#             読込：$savec.check("id")
#                   ※idが存在しない場合、Falseが返されます。
#
#     ２．数字の場合
#         例）保存：$savec.set_num("id", 100)
#             読込：$savec.get_num("id") 
#                   ※idが存在しない場合、-1が返されます。
#
#   提供者：睡工房　http://hime.be/
#
#******************************************************************************

#==============================================================================
# コンフィグ項目
#==============================================================================
module SUI
module COMMON_SAVE
  # 共通セーブファイル名
  COMMON_FILE = "savec.rvdata"
end
end
#==============================================================================
# 設定完了
#==============================================================================



class Common_Save
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  def initialize
    @data = {}
    load if FileTest.exist?(SUI::COMMON_SAVE::COMMON_FILE)
  end
  #--------------------------------------------------------------------------
  # ● フラグチェック
  #--------------------------------------------------------------------------
  def check(id)
    @data.include?(id)? @data[id] : false
  end
  #--------------------------------------------------------------------------
  # ● フラグセット
  #--------------------------------------------------------------------------
  def set(id, flg = false)
    unless check(id) == flg
      @data[id] = flg
      save
    end
  end
  #--------------------------------------------------------------------------
  # ● 数値取得
  #--------------------------------------------------------------------------
  def get_num(id)
    @data.include?(id)? @data[id] : -1
  end
  #--------------------------------------------------------------------------
  # ● 数値セット
  #--------------------------------------------------------------------------
  def set_num(id, num = -1)
    unless get_num(id) == num
      @data[id] = num
      save
    end
  end
  #--------------------------------------------------------------------------
  # ● ファイルセーブ
  #--------------------------------------------------------------------------
  def save
    save_data(@data, SUI::COMMON_SAVE::COMMON_FILE)
  end
  #--------------------------------------------------------------------------
  # ● ファイルロード
  #--------------------------------------------------------------------------
  def load
    @data = load_data(SUI::COMMON_SAVE::COMMON_FILE)
  end
end


class << DataManager
  #--------------------------------------------------------------------------
  # ● モジュール初期化
  #--------------------------------------------------------------------------
  alias sui_init init
  def init
    $savec = Common_Save.new
    sui_init
  end
end