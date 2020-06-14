class Primitive
  def initialize(attributes)
    attr_keys.each { |key| send("#{key}=", attributes[key]) }
  end

  def primitive_marker
    self.class.name.downcase
  end

  def attr_keys
    self.class.class_variable_get(:@@attr_keys)
  end

  def serialize
    attr_keys.map { |key| [key, send(key)] }.to_h
  end

  def inspect
    serialize.to_s
  end

  def to_s
    serialize.to_s
  end
end

class Solid < Primitive
  @@attr_keys = %i[x y w h r g b a]
  attr_accessor(*@@attr_keys)
end
