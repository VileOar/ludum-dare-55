extends Node2D

var target_position : Vector2 = Vector2(960, 1000)
var current_position : Vector2
var _is_in_target_position : bool = false
@export var speed : float = 100.0
@onready var explosion_fish_fireworks = $ExplosionFishFireworks
@onready var trail = $Trail


# TODO remove
func _ready():
	reset_spawn_position()


func reset_spawn_position() -> void:
	trail.visible = false
	position = Vector2(960, 1000)
	_is_in_target_position = false
	#trail.visible = true
	
	
func explode() -> void:
	explosion_fish_fireworks.one_shot = true
	explosion_fish_fireworks.emitting = true
	await get_tree().create_timer(1.1).timeout 
	explosion_fish_fireworks.one_shot = false
	explosion_fish_fireworks.emitting = false
	

func _process(_delta):
	if _is_in_target_position:
		return
	
	
	if position == target_position:
		_is_in_target_position = true
	
	
	if not _is_in_target_position:
		position = lerp(target_position, Vector2(position), speed * _delta)
		
	
