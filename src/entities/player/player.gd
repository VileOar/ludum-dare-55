## this node contains player sprites and animations as well as controls throwing mechanics and
## object spawning
extends Node2D
class_name Player

## signal sent when a new next item is generated
signal new_next_item(item_id)

## signal sent when the game finishes on a winning condition
signal game_was_won

## scene to instance
@export var ball_scene: PackedScene

## test object to manipulate in this test scene
@onready var _obj: RigidBody2D = null

## ref to the strength indicator
@onready var _strength: ThrowMeter = %StrengthIndicator

## id of the next item to be spawned
var _next_item = ""


func _ready() -> void:
	_strength.release_throw.connect(_on_release_throw)
	
	_set_next_item()
	_spawn_new_throwable()


## callback to user release throw; connected to the ThrowMeter
func _on_release_throw(impulse_vector):
	if is_instance_valid(_obj):
		_obj.apply_central_impulse(impulse_vector)
	
	_strength.can_throw = false
	await get_tree().create_timer(1.5).timeout # magic numbers are to be replaced
	_spawn_new_throwable()
	_set_next_item()


## spawn a new object ready to be thrown
func _spawn_new_throwable():
	_obj = ball_scene.instantiate()
	_obj.position = _strength.position
	_obj.position = position + Vector2(128, 0) # magic numbers are to be replaced
	_obj.populate_item(_next_item)
	get_parent().add_child.call_deferred(_obj)
	_strength.can_throw = true


## generate new next item
func _set_next_item():
	_next_item = Constants.get_random_item_id()
	new_next_item.emit(_next_item)


func _on_detection_area_body_entered(_body: Node2D) -> void:
	game_was_won.emit()
	print("Cat entered winning area!")
	print("Congralutions, you won!")
