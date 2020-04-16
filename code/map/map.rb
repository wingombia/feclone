class Map
  attr_accessor :terrains, :sprite, :tiles

  def initialize(
      image_path: nil,
      tiles: nil
  )
    @terrains = TerrainDrawer.perform(Tiler.perform(get_terrain_image_path(image_path), true))
    @sprite = Gosu::Image.new(image_path, retro: true)
    @tiles = set_up_tiles
    test_tiles
    PathFinder.perform(terrains, Dimensioner.new(x_grid: 5, y_grid: 5), Movement.new)
  end

  def draw
    sprite.draw(0, 0, 0, GC::SCALING_FACTOR, GC::SCALING_FACTOR)
    tiles.each do |row|
        row.each do |tile|
            tile.draw
        end
    end
  end
  
  def add_unit(x, y, unit)
    tiles[y][x].unit = unit
  end

  def unit_present?(x, y)
    tiles[y][x].unit
  end
  
  def get_unit(x,y)
    tile[y][x].unit
  end
  
  def toogle_highlight(x_src: 0, y_src: 0, movement: nil)
    
  end
  private

  def set_up_tiles
    tiles = []
    sprite.height_grid.to_i.times do |i|
        row = []
        sprite.width_grid.to_i.times do |j|
            row << Tile.new(dimensioner: Dimensioner.new(x_grid: j, y_grid: i), terrain: terrains[i][j])
        end
        tiles << row
    end
    tiles
  end

  def test_tiles
    4.times do |i|
        4.times do |j|
            unit = Unit.new(image_path: GC::CHARS_PATH.join("map_sprites","eirika.png").to_s)
            add_unit(4 * j, 2 * i, unit)
        end
    end
  end

  def get_terrain_image_path(image_path)
    parts = image_path.split('.')
    parts[0] + "_terrain." + parts[1]
  end
end