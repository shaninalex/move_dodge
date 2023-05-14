extends Line2D

func _process(delta):
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)
