#==============================================================================
# ★ RGSS3-Extension
# LNX09_アニメーション速度変更
# 　アニメーションの再生速度を変更します。個別に変更することも可能です。
#
# 　version   : 1.00 (12/02/27)
# 　author    : ももまる
# 　reference : http://peachround.blog.fc2.com/blog-entry-17.html
#
#==============================================================================

module LNX09
  #--------------------------------------------------------------------------
  # ● 設定
  #--------------------------------------------------------------------------
  # マップ画面のデフォルトのアニメーション速度 (1以上)
  DEFAULT_MAP_SPEED_RATE    = 4  # 規定値:4

  # バトル中のデフォルトのアニメーション速度 (1以上)
  DEFAULT_BATTLE_SPEED_RATE = 3  # 規定値:3
  
  #--------------------------------------------------------------------------
  # ● 正規表現
  #--------------------------------------------------------------------------
  RE_ANISPEED = /\[(\d+)\]/
end

#==============================================================================
# ■ LNXスクリプト導入情報
#==============================================================================

$lnx_include = {} if $lnx_include == nil
$lnx_include[:lnx09] = 100 # version
p "OK:LNX09_アニメーション速度変更"

#==============================================================================
# ■ RPG::Animation
#------------------------------------------------------------------------------
# 　アニメーションのデータクラス。
#==============================================================================

class RPG::Animation
  #------------------------------------------------------------------------
  # ● [追加]:名前からアニメーション再生速度を取得
  #------------------------------------------------------------------------
  def speed_rate
    return @speed_rate if @speed_rate != nil
    re = LNX09::RE_ANISPEED =~ name
    @speed_rate = re ? [$1.to_i, 1].max : false
  end
end

#==============================================================================
# ■ Sprite_Base
#------------------------------------------------------------------------------
# 　アニメーションの表示処理を追加したスプライトのクラスです。
#==============================================================================

class Sprite_Base < Sprite
  #--------------------------------------------------------------------------
  # ● [再定義]:アニメーションの速度を設定
  #--------------------------------------------------------------------------
  def set_animation_rate
    default = LNX09::DEFAULT_MAP_SPEED_RATE
    @ani_rate = @animation.speed_rate ? @animation.speed_rate : default
  end
end
#==============================================================================
# ■ Sprite_Battler
#------------------------------------------------------------------------------
# 　バトラー表示用のスプライトです。
#==============================================================================

class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● [オーバーライド]:アニメーションの速度を設定
  #--------------------------------------------------------------------------
  def set_animation_rate
    default = LNX09::DEFAULT_BATTLE_SPEED_RATE
    @ani_rate = @animation.speed_rate ? @animation.speed_rate : default
  end
end