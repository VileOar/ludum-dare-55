extends Trails


func _get_position() -> Vector2:
	return get_parent().position
