require 'app/primitives.rb'

class Game
  attr_accessor :state, :outputs, :grid

  def tick
    output
  end

  def output
    outputs.solids << Solid.new(x: grid.center_x - 32, y: grid.h * 0.1, w: 64, h: 64)

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
end
 
$game = Game.new

def tick args
  $game.state = args.state
  $game.outputs = args.outputs
  $game.grid = args.grid
  $game.tick
end
