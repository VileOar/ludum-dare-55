extends RigidBody2D


var force_strength = 1


func _on_timer_timeout() -> void:
	apply_central_impulse(Vector2.UP * force_strength * randf_range(10, 20))
	force_strength = -force_strength
