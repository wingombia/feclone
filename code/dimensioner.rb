class Dimensioner
  attr_accessor :x, :y, :z
  attr_reader :x_grid, :y_grid, :x_offset, :y_offset
  def initialize(x: nil, y: nil, x_grid: 0, y_grid: 0, z: 0, x_offset: 0, y_offset: 0)
    @x_grid = x_grid
    @y_grid = y_grid
    @x = x || real(x_grid) || 0
    @y = y || real(y_grid) || 0
    @z = z
    @x_offset = x_offset
    @y_offset = y_offset
  end

  def x_grid=(value)
    self.x = real(value)
    @x_grid = value
  end
  
  def y_grid=(value)
    self.y = real(value)
    @y_grid = value
  end

  def get_3d
    [x + x_offset, y + y_offset, z]
  end

  private

  def real(dimension)
    dimension * GC::GRID_SIZE
  end 
end