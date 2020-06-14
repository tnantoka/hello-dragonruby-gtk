require 'app/primitives.rb'

def tick args
  # args.outputs.solids << [args.grid.center_x - 32, args.grid.h * 0.1, 64, 64]
  # args.outputs.solids << { x: args.grid.center_x - 32, y: args.grid.h * 0.1, w: 64, h: 64 }
  args.outputs.solids << Solid.new(x: args.grid.center_x - 32, y: args.grid.h * 0.1, w: 64, h: 64)
end
