extends RigidBody2D


func _on_timer_timeout() -> void:
	var force_sign = 1 if rotation > 0 else -1
	var force = Vector2.UP * force_sign * randf_range(20, 40)
	apply_central_impulse(force)
