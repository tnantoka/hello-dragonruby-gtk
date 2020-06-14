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
        bullet.solid = { x: bullet.x, y: bullet.y, w: bullet.size, h: bullet.size, r: 255, g: 100, b: 100 }
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
      bullet.solid[:y] = bullet.y

      if bullet.y > grid.h
        bullet.dead = true
      end
      if bullet.solid.intersect_rect?(enemy_rect)
        bullet.dead = true
      end
    end
    state.bullets = state.bullets.reject(&:dead)
  end

  def output
    outputs.solids << Solid.new(player_rect)

    outputs.solids << Solid.new(enemy_rect.merge(r: 150, g: 150, b: 150))

    outputs.solids << state.bullets.map(&:solid)

    outputs.lines << Line.new(x: 0, y: grid.center_y, x2: grid.w, y2: grid.center_y)
    outputs.lines << Line.new(x: grid.center_x, y: 0, x2: grid.center_x, y2: grid.h)
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
