## this node contains player sprites and animations as well as controls throwing mechanics and
## object spawning
extends Node2D
class_name Player

## scene to instance
@export var ball_scene: PackedScene

## test object to manipulate in this test scene
@onready var _obj: RigidBody2D = null

## ref to the strength indicator
@onready var _strength: ThrowMeter = %StrengthIndicator


func _ready() -> void:
	_strength.release_throw.connect(_on_release_throw)
	
	_spawn_new_throwable()


## callback to user release throw; connected to the ThrowMeter
func _on_release_throw(impulse_vector):
	if is_instance_valid(_obj):
		_obj.apply_central_impulse(impulse_vector)
	
	_strength.can_throw = false
	await get_tree().create_timer(1.5).timeout
	_spawn_new_throwable()


## spawn a new object ready to be thrown
func _spawn_new_throwable():
	_obj = ball_scene.instantiate()
	_obj.position = _strength.position
	add_child(_obj)
	_strength.can_throw = true
