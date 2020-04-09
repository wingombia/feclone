module Drawable
  def draw(x_scale: GC::SCALING_FACTOR, y_scale: GC::SCALING_FACTOR)
    return if !pre_draw

    image = get_frame
    return if !image 

    !custom_draw? ? image.draw(*dimensioner.get_3d, x_scale, y_scale) : custom_draw(image)

    post_draw
  end

  def get_frame
    cur_animator ? cur_animator.get_frame : sprite
  end

  def animatable?
    instance_variable_defined?(:@animator) || have_states?
  end

  def have_states?
    instance_variable_defined?(:@animators)
  end

  def cur_animator
    if have_states?
      animators[ani_state]
    elsif animatable?
      animator
    end
  end

  def pre_draw
    true
  end

  def post_draw
  end

  def custom_draw?
    false
  end
  
  def build_sprite(index: 0, frames_count: 1, delta: 0)
    result = []
    frames_count.times do
        result << sprite[index]
        index += 5
    end
    result
  end

  def build_animator(index: 0, frames_count: 1, times_per_frame: [0], delta: 0)
    Animator.new(
      sprite: build_sprite(index: index, frames_count: frames_count, delta: delta),
      times_per_frame: times_per_frame,
      reverse: true
    )
  end
end