require 'app/primitives.rb'

class Game
  attr_accessor :state, :outputs, :grid, :inputs

  def tick
    set_defaults
    handle_inputs
    update_state
    output
  end

  def set_defaults
    state.player_x ||= grid.center_x - 32
    state.player_dx ||= 0

    state.enemy_x ||= grid.center_x - 32
    state.enemy_dx ||= 5

    state.bullets ||= []

    state.score ||= 0
  end

  def handle_inputs
    if inputs.keyboard.right
      state.player_dx = 5
    elsif inputs.keyboard.left
      state.player_dx = -5
    else
      state.player_dx = 0
    end

    if inputs.keyboard.key_up.space
      state.bullets << state.new_entity(:bullet) do |bullet|
        bullet.y = player_rect[:y]
        bullet.x = player_rect[:x] + 16
        bullet.size = 32
        bullet.dy = 10
        bullet.sprite = { x: bullet.x, y: bullet.y, w: bullet.size, h: bullet.size, r: 255, g: 100, b: 100, path: 'sprites/bullet.png' }
      end
    end
  end

  def update_state
    state.player_x += state.player_dx

    state.enemy_x += state.enemy_dx
    if state.enemy_x < 0 || state.enemy_x > grid.w - 64
      state.enemy_dx *= -1
    end

    state.bullets.each do |bullet|
      bullet.y += bullet.dy
      bullet.sprite[:y] = bullet.y

      if bullet.y > grid.h
        bullet.dead = true
        state.score -= 1
      end
      if bullet.sprite.intersect_rect?(enemy_rect)
        bullet.dead = true
        state.score += 2
      end
    end
    state.bullets = state.bullets.reject(&:dead)
  end

  def output
    outputs.sprites << Sprite.new(player_rect.merge(path: 'sprites/player.png'))

    outputs.sprites << Sprite.new(enemy_rect.merge(r: 150, g: 150, b: 150, path: 'sprites/enemy.png'))

    outputs.sprites << state.bullets.map(&:sprite)

    outputs.labels << Label.new(
      x: grid.w * 0.99,
      y: grid.h * 0.98,
      text: state.score,
      alignment_enum: 2,
      font: 'fonts/Press_Start_2P/PressStart2P-Regular.ttf'
    )
  end

  def serialize
    {}
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end

  private

  def player_rect
    { x: state.player_x, y: grid.h * 0.1, w: 64, h: 64 }
  end

  def enemy_rect
    { x: state.enemy_x, y: grid.h * 0.7, w: 64, h: 64 }
  end
end

$game = Game.new

def tick args
  $game.state = args.state
  $game.outputs = args.outputs
  $game.grid = args.grid
  $game.inputs = args.inputs
  $game.tick
end
