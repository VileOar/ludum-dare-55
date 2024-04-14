extends Node2D


const RIGHT_FIREWORK_X_POSITION : int = 1600
const LEFT_FIREWORK_X_POSITION : int = 400
const FIREWORK_Y_POSITION : int = 540

var firework_target_position : Vector2
var target_position_variation : Vector2
var is_firework_right : bool = true

@onready var animation_player = $AnimationPlayer
@onready var fireworks_timer = $FireworksTimer
@onready var fish_fireworks = $FishFireworks


func _ready():
	animation_player.play("win_logo_animated")
	animation_player.animation_finished.connect(_start_win_logo_loop)
	fish_fireworks.reset_spawn_position()
	fireworks_timer.start()


func _find_new_firework_target_position() -> void:
	var x_variation = randi_range(-100, 100)
	var y_variation = randi_range(-50, 50)
		
	if is_firework_right:
		firework_target_position = Vector2(RIGHT_FIREWORK_X_POSITION + x_variation, FIREWORK_Y_POSITION + y_variation)
		is_firework_right = false
	else:
		firework_target_position = Vector2(LEFT_FIREWORK_X_POSITION + x_variation, FIREWORK_Y_POSITION + y_variation)
		is_firework_right = true
	
	fish_fireworks.target_position = firework_target_position
	print("firework target = ", fish_fireworks.target_position)

func _start_win_logo_loop(_animation_name : String) -> void:
	animation_player.play("win_logo_loop")


func _on_timer_timeout():
	fish_fireworks.reset_spawn_position()
	_find_new_firework_target_position()
	await get_tree().create_timer(1).timeout
	fish_fireworks.explode()
