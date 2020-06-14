require 'app/primitives.rb'

def tick args
  outputs, grid = args.outputs, args.grid

  outputs.solids << Solid.new(x: grid.center_x - 32, y: grid.h * 0.1, w: 64, h: 64)

  outputs.lines << Line.new(x: 0, y: grid.center_y, x2: grid.w, y2: grid.center_y)
  outputs.lines << Line.new(x: grid.center_x, y: 0, x2: grid.center_x, y2: grid.h)
end
