extends CharacterBody2D


enum States {IDLING, ACTION, MOVING}

@export var waypoint : Sprite2D

var current_state := States.IDLING

# Movement Vars
const BASE_MOV_SPEED := 50.0 # base value just to barely get things around
@export var move_speed_mltplr := 1.0 # can be used to more easily tweak the speed
@export var minimum_distance := 150.0 # average short distance to have as reference
var target_position := Vector2.ZERO

# Rotation Vars
@export var rot_speed := 2.0 # controls general rotation speed
var rot_coef := 0.0 # adjust speed based on distance and angle to waypoint. Faster rotation if the cat has less time to reach destination
var target_angle_dif := 0.0 # constantly represents the angle that is left for the cat to rotate towards waypoint
@export var target_angle_tolerance := 0.05 # when target_angle_dif is smaller than this value, it is assumed that rotation is close enough

# Waypoint Management
var can_deviate := false
@export var retry_waypoint_interval := 0.3 # in seconds
var refresh_waypoint_timer := 0.0
@export var waypoint_variation := 100


func _ready():
	current_state = States.MOVING
	set_new_waypoint(waypoint.position)


func set_new_waypoint(new_pos : Vector2, variate:bool = false):
	if variate:
		var alt_waypoint := Vector2(new_pos.x + randi_range(-waypoint_variation, waypoint_variation), 
			new_pos.y + randi_range(-waypoint_variation, waypoint_variation))
		target_position = alt_waypoint
	else:
		target_position = new_pos

	target_angle_dif = transform.x.angle_to(target_position-position)
	var distance = (target_position-position).length()

	# coeficient is used to alter rotation speed based on time it would take to rotate til destination as well as time it 
	# would take to reach target destination
	rot_coef = (minimum_distance / BASE_MOV_SPEED) / (distance / (BASE_MOV_SPEED * move_speed_mltplr) / (target_angle_dif / 2))


func _process(delta):
	if current_state == States.MOVING && can_deviate:
		refresh_waypoint_timer += delta
		if refresh_waypoint_timer >= retry_waypoint_interval:
			refresh_waypoint_timer = 0.0
			set_new_waypoint(target_position, true)


func _physics_process(delta):
	if current_state == States.MOVING:
		var _v = move_and_collide(transform.x * delta * BASE_MOV_SPEED * move_speed_mltplr)

		if abs(target_angle_dif) > target_angle_tolerance:
			can_deviate = false
			target_angle_dif = transform.x.angle_to(target_position-position)
			var modifier : int = sign(target_angle_dif)
			rotation = move_toward(rotation, rotation + modifier * target_angle_dif, rot_coef * rot_speed)
		else:
			can_deviate = true
