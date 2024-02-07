#==============================================================================
# ★ RGSS3_バトラー表示拡張 Ver1.02
#==============================================================================
=begin

作者：tomoaky
webサイト：ひきも記 (http://hikimoki.sakura.ne.jp/)

戦闘シーンにおいてエネミーのスプライトに以下の効果を適用します。
  ・ランダムに左右反転
  ・Ｙ座標を元に拡大縮小をおこない遠近感を演出
  ・一定間隔で拡大縮小をおこない息遣いを演出
  
行動不可状態のエネミーは息遣いが自動的に一時停止します

2012.04.05  Ver1.02
　・アクターグラフィックに効果を適用しないように修正
    デフォルトの戦闘シーンでは特に意味はありません

2011.12.20  Ver1.01
  ・解像度に合わせて遠近効果の基準となるＹ座標を自動計算するように修正

2011.12.15  Ver1.0
  公開

=end

#==============================================================================
# □ 設定項目
#==============================================================================
module TMBSPREX
  # 左右反転を適用しないトループをIDで指定
  NO_MIRROR_TROOP = []
  
  # 左右反転を適用しないエネミーをIDで指定
  NO_MIRROR_ENEMY = []
  
  # 遠近効果を適用しないトループをIDで指定
  NO_ZOOM_TROOP = [1, 2, 3, 4, 5]
  
  # 遠近効果を適用しないエネミーをIDで指定
  NO_ZOOM_ENEMY = []
  
  # 息遣いを適用しないトループをIDで指定
  NO_BREATH_TROOP = []
  
  # 息遣いを適用しないエネミーをIDで指定
  NO_BREATH_ENEMY = []
end

#==============================================================================
# ■ Sprite_Battler
#==============================================================================
class Sprite_Battler < Sprite_Base
  #--------------------------------------------------------------------------
  # ● オブジェクト初期化
  #--------------------------------------------------------------------------
  alias tmbsprex_sprite_battler_initialize initialize
  def initialize(viewport, battler = nil)
    tmbsprex_sprite_battler_initialize(viewport, battler)
    if battler && !battler.actor?
      unless TMBSPREX::NO_MIRROR_TROOP.include?($game_troop.troop.id)
        unless TMBSPREX::NO_MIRROR_ENEMY.include?(battler.enemy.id)
          self.mirror = (rand(3) == 0)      # 1/3の確率で左右反転
        end
      end
      unless TMBSPREX::NO_ZOOM_TROOP.include?($game_troop.troop.id)
        unless TMBSPREX::NO_ZOOM_ENEMY.include?(battler.enemy.id)
          border_y = Graphics.height * 65 / 100
          self.zoom_x = (battler.screen_y - border_y) * 0.005 + 1.0
        end
      end
      unless TMBSPREX::NO_BREATH_TROOP.include?($game_troop.troop.id)
        unless TMBSPREX::NO_BREATH_ENEMY.include?(battler.enemy.id)
          @zoom_max = rand(30) + 150
          @zoom_count = rand(@zoom_max)
        end
      end
      @use_tmbsprex = true
    end
  end
  #--------------------------------------------------------------------------
  # ● フレーム更新
  #--------------------------------------------------------------------------
  alias tmbsprex_sprite_battler_update update
  def update
    tmbsprex_sprite_battler_update
    if @use_tmbsprex
      self.zoom_y = self.zoom_x
      self.z = 50 + self.y
      if @zoom_max && @battler.movable?
        @zoom_count += 1
        @zoom_count = 0 if @zoom_count == @zoom_max
        f = Math.sin(Math::PI * @zoom_count / (@zoom_max / 2))
        self.zoom_y += f * 0.015 + 0.015
      end
    end
  end
end

