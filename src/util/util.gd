extends Node


# Returns a vector2 windows position in the middle of the main screen
func get_new_window_position(new_resolution: Vector2) -> Vector2i:
	#var base_size: Vector2 = Vector2(1920, 1080)
	var window_size: Vector2 = DisplayServer.screen_get_size()
	# TODO, esta logica não faz sentido, ver se é importante mais tarde aka nunca
	#var scale: float = min(new_resolution.x / base_size.x, window_size.y / base_size.y)
	#var scaled_size: Vector2 = (base_size * scale)
	var scaled_size: Vector2 = new_resolution

	var window_x: float = (window_size.x / 2) - (scaled_size.x / 2)
	var window_y:float = (window_size.y / 2) - (scaled_size.y / 2)

	#return Vector2(window_x, window_y)
	return Vector2i(int(window_x), int(window_y))

