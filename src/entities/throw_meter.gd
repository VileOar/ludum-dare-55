## object which shows and controls throw strength and direction
##
## used both as controller and indicator
extends Sprite2D
class_name ThrowMeter

## max throw power
const MAX_POWER = 720

## emitted when user releases button
signal release_throw(impulse_vector)

## counter for current strength, based on click duration
var _strength_percent = 0.0:
	set(value):
		_strength_percent = value
		material.set("shader_parameter/percent", _strength_percent)

## strength increment speed while pressing
var _strength_inc_speed = 0.6

## whether user is still clicking
var _clicking = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	
	var dir = mouse_pos - position
	
	# point strength throw indicator towards mouse
	rotation = dir.angle()
	
	if _clicking: # if user is clicking, increment strength
		_strength_percent += delta * _strength_inc_speed
		if _strength_percent >= 1.2: # reached full percent and over a little (invisible to user)
			_throw()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index:
		if event.pressed: # start pressing
			_clicking = true
		elif _clicking: # if it is during a click
			_throw()


## called when object is to be thrown, can happen by user release button or pressing for too long
func _throw():
	release_throw.emit(Vector2.RIGHT.rotated(rotation) * min(1.0, _strength_percent) * MAX_POWER)
	# cleanup
	_clicking = false
	_strength_percent = 0.0
