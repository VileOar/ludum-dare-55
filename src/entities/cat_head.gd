## the separate object for the cat's head
##
## this node turns independently and detects objects and sends signals to the main body to act on
extends Node2D
class_name CatHead

## head turn behaviours, these states do not necessarily correspond to states in the main body, just
## different behaviours for the head
enum TurnStates {
	STOP, ## cat will not turn its head and remain at 0 rotation
	IDLE, ## cat will turn head at random positions and smoother speeds
	MOVE, ## cat will turn head at much smaller deltas and not as often
	LOCK, ## cat will always look at position, if that does not exceed max turn angle
}

## chance to choose a random position to turn to in idle state
const IDLE_TURN_CHANCE = 0.01
## chance to choose a random position to turn to in move state
const MOVE_TURN_CHANCE = 0.002
## angle range to choose new direction to turn to in idle state
const IDLE_TURN_RANGE = deg_to_rad(60)
## angle range to choose new direction to turn to in idle state
const MOVE_TURN_RANGE = deg_to_rad(30)

## weight of rotation used in lerping
const TURN_WEIGHT = 0.08

## signal for when a body is detected
signal object_detected(position)

## the max distance of the field of vision
@export var _fov_range = 60
## the angle (in degrees) to either side that the fov extends to
@export var _fov_angle = 40

## max angle the cat can turn its head to either side
@export var _MAX_TURN_ANGLE = 80

## the reference to the polygons used to create the field of view
var _fov_polygon: PackedVector2Array

## state of turn behaviour
var _turn_state = TurnStates.STOP
## target rotation value
var _target_rotation = 0.0
## locked position in case of Lock state
var _locked_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# convert them here so that they show as degrees in editor
	_fov_angle = deg_to_rad(_fov_angle)
	_MAX_TURN_ANGLE = deg_to_rad(_MAX_TURN_ANGLE)
	
	_build_fov()
	%FOVPolygonShape.polygon = _fov_polygon


func _physics_process(delta: float) -> void:
	# TODO: remove the input, it is just for testing purposes
	if Input.is_key_pressed(KEY_W):
		position.y -= 2
	if Input.is_key_pressed(KEY_S):
		position.y += 2
	if Input.is_key_pressed(KEY_A):
		position.x -= 2
	if Input.is_key_pressed(KEY_D):
		position.x += 2
	
	if Input.is_key_pressed(KEY_Q):
		rotation -= deg_to_rad(2)
	if Input.is_key_pressed(KEY_E):
		rotation += deg_to_rad(2)
	
	# turn towards target rotation
	if !is_equal_approx(_target_rotation, rotation):
		# rotate by current speed
		rotation = lerp_angle(rotation, _target_rotation, TURN_WEIGHT)
	
	match _turn_state:
		TurnStates.STOP:
			if !is_equal_approx(rotation, 0.0):
				_turn_towards(0.0)
		TurnStates.IDLE, TurnStates.MOVE:
			# randomly choose new target rotation
			var chance = randf()
			if _turn_state == TurnStates.IDLE:
				if chance < IDLE_TURN_CHANCE:
					var new_rot = randf_range(-IDLE_TURN_RANGE, IDLE_TURN_RANGE)
					_turn_towards(new_rot)
			elif _turn_state == TurnStates.MOVE:
				if chance < MOVE_TURN_CHANCE:
					var new_rot = randf_range(-MOVE_TURN_RANGE, MOVE_TURN_RANGE)
					_turn_towards(new_rot)
		TurnStates.LOCK:
			# will always try to look at locked_position, if that does not exceed limits
			var new_rot = clamp(transform.x.angle_to(position.direction_to(_locked_position)), -_MAX_TURN_ANGLE, _MAX_TURN_ANGLE)
			_turn_towards(new_rot)


## TODO: remove this
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		var obj = load("res://src/entities/throwable.tscn").instantiate()
		obj.position = get_global_mouse_position()
		get_parent().add_child(obj)
	if event.is_pressed() and event is InputEventKey and event.keycode == KEY_V:
		set_turn_state((_turn_state + 1) % TurnStates.size())


## function to set the turn state[br]
## it must always be set externally by the main body and resets head turning
func set_turn_state(new_state: int = TurnStates.STOP, look_at:= Vector2.ZERO) -> void:
	_turn_state = new_state
	_locked_position = look_at
	_turn_towards(0.0)


## starts turning in a new direction
func _turn_towards(new_rotation):
	_target_rotation = new_rotation


func _draw() -> void:
	draw_colored_polygon(_fov_polygon, Color.RED)


## build FOV polygon
func _build_fov():
	_fov_polygon.clear()
	var ref_point = Vector2(_fov_range, 0)
	_fov_polygon.append(Vector2.ZERO) # the initial point is always the centre of the segment
	# the angle that will be incremented sequentially to add points to the polygon
	var angle = -_fov_angle
	var angle_increment = PI / 10
	while angle < _fov_angle: # sequentially increase angle and add point
		_fov_polygon.append(ref_point.rotated(angle))
		angle += angle_increment
	_fov_polygon.append(ref_point.rotated(_fov_angle)) # always add the final edge of the segment


func _on_area_2d_body_entered(body: Node2D) -> void:
	object_detected.emit(body.global_position)
	set_turn_state(TurnStates.LOCK, body.global_position)
