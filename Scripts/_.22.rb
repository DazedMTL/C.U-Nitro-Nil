#==============================================================================
# ■ RGSS3 アイテム所持数制限 Ver1.03 by 星潟
#------------------------------------------------------------------------------
# 特定アイテムの所持数に制限を付与します。
# アイテムのメモ欄に特定の書式を記入する事で機能するようになります。
#------------------------------------------------------------------------------
# 設定例
#------------------------------------------------------------------------------
# アイテム・武器・防具の所持数を制限する場合
#
# <所持制限:20>
# このアイテムは20個までしか持つ事が出来なくなります。
#------------------------------------------------------------------------------
# 武器・防具の所持制限に現在装備中の物を含める場合
#
# <所持装備制限タイプ:1>
# このアイテムは現在のパーティメンバーの装備品も所持制限に含めます。
#
# <所持装備制限タイプ:2>
# このアイテムは全てのアクターの装備品も所持制限に含めます。
#------------------------------------------------------------------------------
# アイテム（武器・防具は除外）の所持数に預かり所の物も含める場合
# （当方の預かり所スクリプト利用の場合のみ使用可）
#
# <預かり所込所持制限>
# このアイテムの所持制限は預かり所の物も含みます。
#------------------------------------------------------------------------------
# Ver1.01 キャッシュ化により動作を若干軽量化しました。
# Ver1.02 現在装備中の装備品に対する所持制限と
#         預かり所スクリプトに対応した特殊な制限を追加しました。
# Ver1.03 預かり所持ちこみ制限機能が
#         装備品にも効果があった不具合を修正しました。
#==============================================================================
module M_I_N_CHANGE
  
  #アイテム所持制限に用いるキーワードを設定します。
  
  WORD1  = "所持制限"
  
  #装備品の所持制限において、現在装備中の装備品も所持制限の数に加えるか否かの
  #キーワードを設定します。
  
  WORD2  = "所持装備制限タイプ"
  
  #当方の預かり所スクリプトと併用時
  #アイテム所持制限数に預かり所内のアイテムを含ませる場合のキーワードを設定します。
  
  WORD3  = "預かり所込所持制限"
  
  #全てのアクターの装備品を所持制限に含める際
  #全てのアクターではなく特定のアクターに限定化するか否かを設定します。
  #（アクターIDが多い状態で限定化しない場合、処理に莫大な時間を要する場合があります）
  #trueで限定化し、falseで限定しません。
  
  LIMIT = true
  
  #LIMITをtrueにした際の特定のアクターというのを誰にするかを指定します。
  #アクターIDで指定します。
  
  ACTOR = [1,2,3,4,5,6,7,8,9,10]
  
end
class Game_Temp
  attr_accessor :ec_i_n_flag
  attr_accessor :item_keeper_include
  #--------------------------------------------------------------------------
  # オブジェクト初期化
  #--------------------------------------------------------------------------
  alias initialize_max_change initialize
  def initialize
    initialize_max_change
    @ec_i_n_flag = false
  end
end
class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # 装備の変更
  #--------------------------------------------------------------------------
  alias change_equip_max_change change_equip
  def change_equip(slot_id, item)
    $game_temp.ec_i_n_flag = true
    change_equip_max_change(slot_id, item)
    $game_temp.ec_i_n_flag = false
  end
  #--------------------------------------------------------------------------
  # 装備の強制変更
  #--------------------------------------------------------------------------
  alias force_change_equip_max_change force_change_equip
  def force_change_equip(slot_id, item)
    $game_temp.ec_i_n_flag = true
    force_change_equip_max_change(slot_id, item)
    $game_temp.ec_i_n_flag = false
  end
end
class Game_Party < Game_Unit
  #--------------------------------------------------------------------------
  # アイテムの最大所持数取得
  #--------------------------------------------------------------------------
  alias max_item_number_max_change max_item_number
  def max_item_number(item)
    
    #アイテムが存在しない時は0を返す。
    
    return 0 if item == nil
    
    #アイテムの最大数を取得する。
    
    data = item.max_item_number
    
    #データfalseの場合は本来の処理を実行する。
    
    data = max_item_number_max_change(item) unless data
    
    if !$game_temp.ec_i_n_flag && !item.is_a?(RPG::Item)
    
      case item.item_number_equip_type
      when 1
        data -= party_equip_number(item)
      when 2
        data -= all_actor_equip_number(item)
      end
    end
    
    #当方の預かり所スクリプト導入時、設定に応じて預かり所のアイテム数を引く。
    
    data -= keep_number_max_change(item) 
    
    #データを返す。
    
    [data,0].max
    
  end
  def keep_number_max_change(item)
    if $game_temp.item_keeper_include == nil
      begin
        item.max_item_keep_number
        $game_temp.item_keeper_include = true
      rescue
        $game_temp.item_keeper_include = false
      end
    end
    return 0 if !$game_temp.item_keeper_include or SceneManager.scene_is?(Scene_Item_Keep) or !item.keep_max_change
    $game_party.item_keep_number(item)
  end
  #--------------------------------------------------------------------------
  # パーティメンバーの装備中の装備品数の取得
  #--------------------------------------------------------------------------
  def party_equip_number(item)
    data = 0
    all_members.each {|actor|
    actor.equips.each{|equip|
    data += 1 if equip == item
    }
    }
    data
  end
  #--------------------------------------------------------------------------
  # 全アクターの装備中の装備品数の取得
  #--------------------------------------------------------------------------
  def all_actor_equip_number(item)
    data = 0
    if M_I_N_CHANGE::LIMIT
      M_I_N_CHANGE::ACTOR.each {|i|
      actor = $game_actors[i]
      actor.equips.each{|equip|
      data += 1 if equip == item
      }
      }
    else
      number = $data_actors.size
      number.times {|i|
      next if i == 0
      actor = $game_actors[i]
      actor.equips.each{|equip|
      data += 1 if equip == item
      }
      }
    end
    data
  end
end
class RPG::BaseItem
  #--------------------------------------------------------------------------
  # アイテムの最大所持数取得
  #--------------------------------------------------------------------------
  def max_item_number
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    @max_item_number  ||= /<#{M_I_N_CHANGE::WORD1}[：:](\S+)>/ =~ @note ? $1.to_i : false
    
  end
  #--------------------------------------------------------------------------
  # 装備品を所持数に含むか否かの判定を行う。
  #--------------------------------------------------------------------------
  def item_number_equip_type
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    @item_number_equip_type ||= /<#{M_I_N_CHANGE::WORD2}[：:](\S+)>/ =~ @note ? $1.to_i : 0
    
  end
  #--------------------------------------------------------------------------
  # 預かり所のアイテムも所持数に含むか否かの判定を行う。
  #--------------------------------------------------------------------------
  def keep_max_change
    
    #装備品には無効。
    
    false
    
  end
end
class RPG::Item < RPG::UsableItem
  #--------------------------------------------------------------------------
  # 預かり所のアイテムも所持数に含むか否かの判定を行う。
  #--------------------------------------------------------------------------
  def keep_max_change
    
    #キャッシュが存在する場合はキャッシュを返す。
    
    @keep_max_change ||= self.note.include?("<" + M_I_N_CHANGE::WORD3 + ">")
    
  end
end