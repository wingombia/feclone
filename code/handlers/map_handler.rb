require_relative '../modules/buttonable'
class MapHandler
  include Buttonable
  attr_accessor :map, :cursor, :buttons, :unit_activated, :current_unit
  def initialize(map: nil, cursor: nil)
    @map = map
    @cursor = cursor
    @buttons = {
      KB_DOWN:  true,
      KB_UP:    true,
      KB_RIGHT: true,
      KB_LEFT:  true,
      KB_Z: true,
      KB_X: true
    }
    change_cursor_state
  end
  
  def draw
    cursor.draw
    map.draw
  end
  private

  ######################
  #BUTTONABLE INTERFACE#
  ######################
  def pre_handling
    
    !cursor.debounced?
  end
  
  def pre_press(button)
    if movement_button?(button)
      change_cursor_state(move_out: true)
    end
  end

  def post_press(button)
    if movement_button?(button)
      change_cursor_state
    end
  end
  
  def kb_z
    if unit = unit_focused?
      activate_unit(unit)
    end
  end

  def kb_x
    if unit_activated
      rehover_cursor
      unactivate_unit
    end
  end

  def kb_down
    cursor.y_grid += 1
    change_move_state(move: :down) if unit_activated
  end

  def kb_up
    cursor.y_grid -= 1
    change_move_state(move: :up) if unit_activated
  end

  def kb_right
    cursor.x_grid += 1
    change_move_state(move: :right) if unit_activated
  end
  
  def kb_left
    cursor.x_grid -= 1
    change_move_state(move: :left) if unit_activated
  end
  
  def change_move_state(move:)
    current_unit.change_move_state(move: move, cursor_terrain: map.terrains[cursor.y_grid][cursor.x_grid]) 
  end

  def change_cursor_state(move_out: false)
    if !unit_activated
      unit = unit_focused?
      if unit && move_out
        unit.change_sprite_state(state: :idle)
        cursor.ani_state = :idle
      elsif unit && cursor.ani_state == :idle
        unit.add_moveable_tiles(moveable_tiles: PathFinder.perform(map.terrains, unit.dimensioner, unit.movement))
        cursor.ani_state = :hover
        unit.change_sprite_state(state: :hover)
      elsif !unit && cursor.ani_state == :hover
        cursor.ani_state = :idle
      end
    else
      cursor.ani_state = :idle
    end
  end

  def rehover_cursor
    cursor.x_grid = current_unit.x_grid
    cursor.y_grid = current_unit.y_grid
    cursor.ani_state = :hover
  end

  def unactivate_unit
    current_unit.change_sprite_state(state: :hover)
    current_unit.clear_arrow
    self.unit_activated = false
    self.current_unit = nil
  end

  def activate_unit(unit)
    self.unit_activated = true
    self.current_unit = unit
    unit.change_sprite_state(state: :active)
  end

  def unit_focused?
    map.unit_present?(cursor.x_grid, cursor.y_grid)
  end
end