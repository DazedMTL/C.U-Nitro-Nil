#==============================================================================
# ■ RGSS3 エネミーコラプスアニメ Ver1.00 by 星潟
#------------------------------------------------------------------------------
# 敵戦闘不能時のコラプス開始時にアニメーションを追加表示します。
# 機械系の敵を倒した際に爆発させながら戦闘不能にする等の表現が可能になります。
# 同時に、コラプス表現の時間を操作します。
#------------------------------------------------------------------------------
# 設定方法
# 敵の特徴を有する項目のメモ欄に
# <コラプスアニメ:50,100>
# ……等のように記入する事で効果を発揮します。
# この場合、アニメーションID50番を表示しつつ
# コラプス表現時間を100フレーム分に変更します。
# コラプス表現時間を0にすると、コラプス表現時間の変更が行われません。
# 
# なお、コラプス表現時間を変更しない（0と書き込む）場合、その部分を省略して
# <コラプスアニメ:50>
# という書き方をする事も可能です。
#==============================================================================
module S_COLLAPSE
  
  #コラプスアニメ用のキーワードを指定。
  WORD = "コラプスアニメ"
  
end
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● エフェクトの開始
  #--------------------------------------------------------------------------
  alias start_effect_s_c_effect start_effect
  def start_effect(effect_type)
    if !@battler.actor?
      #エフェクトタイプを取得。
      @effect_type = effect_type
      case @effect_type
      #通常コラプスの場合、本来の通常コラプスの時間を元に処理を続行。
      when :collapse
        return c_animation_execute(48) if @battler.c_animation[0] != 0
      #ボスコラプスの場合、本来のボスコラプスの時間を元に処理を続行。
      when :boss_collapse
        return c_animation_execute(bitmap.height) if @battler.c_animation[0] != 0
      end
      #本来の処理を実行。
    end
    start_effect_s_c_effect(effect_type)
  end
  #--------------------------------------------------------------------------
  # ● コラプスアニメの開始
  #--------------------------------------------------------------------------
  def c_animation_execute(time)
    #エフェクト時間持続時間を設定。
    #0の場合は本来の時間に設定。
    @effect_duration = @battler.c_animation[1] != 0 ? @battler.c_animation[1] : time
    #通常のアニメーション設定処理を実行。
    @battler_visible = false
    revert_to_normal
    animation = $data_animations[@battler.c_animation[0]]
    mirror = @battler.animation_mirror
    start_animation(animation, mirror)
    @battler.animation_id = 0
  end
end
class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● コラプスアニメ設定
  #--------------------------------------------------------------------------
  def c_animation
    #コラプスアニメ設定が存在する場合はその設定を返す。
    return @c_animation if @c_animation != nil
    #コラプスアニメの初期設定を行う。
    @c_animation = [0, 0]
    #特徴を有する項目のチェックを行う。
    self.feature_objects.each do |f|
    #キーワードからデータをチェックする。
      data = f.note.scan(/<#{S_COLLAPSE::WORD}[：:](\S+)>/).flatten
      #nilでなく配列が空でもない場合は処理を続行。
      #そうでない場合は次の特徴をチェックする。
      if data != nil && !data.empty?
        #データをカンマの位置で分割する。
        data = data[0].to_s.split(/\s*,\s*/)
        #データが1つの場合はコラプス時間を変更しない。
        #データが2つの場合はコラプス時間を変更する。
        case data.size
        when 1
          @c_animation[0] = data[0].to_i
          @c_animation[1] = 0
        when 2
          @c_animation[0] = data[0].to_i
          @c_animation[1] = data[1].to_i
        end
        #コラプス時間を返し、残りの特徴データをチェックしない。
        return @c_animation
      end
    end
    #コラプス時間を返す。
    return @c_animation
  end
  #--------------------------------------------------------------------------
  # ● 変身
  #--------------------------------------------------------------------------
  alias transform_s_c_effect transform
  def transform(enemy_id)
    #本来の処理を実行。
    transform_s_c_effect(enemy_id)
    #コラプスアニメ設定を消去する。
    @c_animation = nil
  end
end