extends CharacterBody2D

enum States {IDLING, ACTION, MOVING_TRUE, MOVING_TEMP_STOP, MOVING_WANDER}

@export var debug_target : Sprite2D

var current_state := States.IDLING

# Movement Vars
const BASE_MOV_SPEED := 50.0 # base value just to barely get things around
@export var move_speed_mltplr := 1.0 # can be used to more easily tweak the speed
@export var minimum_distance := 150.0 # average short distance to have as reference
var target_object : Throwable
var custom_target_pos := Vector2.ZERO # can be same as the actual waypoint but can also be subject to variations

# Rotation Vars
@export var rot_speed := 0.05 # controls general rotation speed
var rot_coef := 0.0 # adjust speed based on distance and angle to waypoint. Faster rotation if the cat has less time to reach destination
var target_angle_dif := 0.0 # constantly represents the angle that is left for the cat to rotate towards waypoint
@export var target_angle_tolerance := 0.05 # when target_angle_dif is smaller than this value, it is assumed that rotation is close enough

# Waypoint Management
@export var min_variate_waypoint_interval := 0.3 # in seconds. Min time between calculating new variations
@export var max_variate_waypoint_interval := 1.5 # in seconds Max time between calculating new variations
@onready var variate_waypoint_interval := randf_range(min_variate_waypoint_interval, max_variate_waypoint_interval)
var variate_waypoint_timer := 0.0
@export var min_wander_angle_variation := 10
@export var max_wander_angle_variation := 80
@export var wander_length := 800 # when in wander state, the variations are set at this distance of current position

# Temp Stop
@onready var temp_stop_timeout_ref : Timer = $TempStopTimer
@export var temp_stop_time := 3
@export var temp_stop_check_intervals := 3.0 # in seconds
var temp_stop_timer := 0.0
@export var temp_stop_odds := 0.2

# Wander Timer
@onready var wander_timer_ref : Timer = $WanderStopTimer
@export var wander_time := 3
@export var wander_end_angle_check := 45 # in degrees. At the end of wander behaviour, if waypoint is outside this angle, idle behaviour starts
@export var wander_check_intervals := 1.0 # in seconds
var wander_timer := 0.0
@export var wander_odds := 0.2

@onready var head_ref : CatHead = $CatHead

# Repel Vars
var is_repelled := false # a cleaner way should be found, i.e. proper state machine
@export var repel_vec_length := 300
@export var repel_angle := 70


func _ready():
	temp_stop_timeout_ref.wait_time = temp_stop_time
	wander_timer_ref.wait_time = wander_time
		

func _process(delta):
	if current_state == States.MOVING_TRUE:
		if !is_repelled:
			temp_stop_timer += delta

			if temp_stop_timer >= temp_stop_check_intervals:
				temp_stop_timer = 0.0

				if randf() < temp_stop_odds:
					print("StartTempStop")
					current_state = States.MOVING_TEMP_STOP
					temp_stop_timeout_ref.start()
					head_ref.set_turn_state(CatHead.TurnStates.IDLE)

			# Below is wander timer stuff
			wander_timer += delta

			if wander_timer >= wander_check_intervals:
				wander_timer = 0.0

				if randf() < wander_odds:
					print("startWander")
					current_state = States.MOVING_WANDER
					wander_timer_ref.start()
					head_ref.set_turn_state(CatHead.TurnStates.MOVE)


func _physics_process(delta):
	if current_state == States.MOVING_TRUE || current_state == States.MOVING_WANDER:

		var _v = move_and_collide(transform.x * delta * BASE_MOV_SPEED * move_speed_mltplr)

		if current_state == States.MOVING_TRUE:
			if !is_repelled:
				custom_target_pos = target_object.position
				variate_waypoint_timer = 0
				if !target_object.linear_velocity.is_zero_approx():
					var distance = (custom_target_pos-position).length()
					rot_coef = (minimum_distance / BASE_MOV_SPEED) / (distance / (BASE_MOV_SPEED * move_speed_mltplr) / (target_angle_dif / 2))
		else:
			variate_waypoint_timer += delta
			if variate_waypoint_timer >= variate_waypoint_interval:
				variate_waypoint_timer = 0
				variate_waypoint_interval = randf_range(min_variate_waypoint_interval, max_variate_waypoint_interval)
				set_new_waypoint(null, variate_waypoint(), true)

				#debug_target.set_pos(variate_waypoint())

		if abs(target_angle_dif) > target_angle_tolerance:
			target_angle_dif = transform.x.angle_to(custom_target_pos-position)
			#print(target_angle_dif)
			var modifier : int = sign(target_angle_dif)
			rotation = move_toward(rotation, rotation + modifier * target_angle_dif, rot_coef * rot_speed)

		if !is_repelled:
			if (target_object.position-position).length() <= minimum_distance:
				current_state = States.IDLING
				head_ref.set_turn_state(CatHead.TurnStates.IDLE)

		if is_repelled && (custom_target_pos-position).length() <= minimum_distance:
			current_state = States.IDLING
			head_ref.set_turn_state(CatHead.TurnStates.IDLE)

		


# || --- Waypoint Management --- ||


func set_new_waypoint(new_obj : Throwable, pos_ref : Vector2, variant : bool = false):
	if variant:
		custom_target_pos = pos_ref
	else:
		target_object = new_obj
	
	target_angle_dif = transform.x.angle_to(pos_ref-position)
	var distance = (pos_ref-position).length()

	# coeficient is used to alter rotation speed based on time it would take to rotate til destination as well as time it 
	# would take to reach target destination
	rot_coef = (minimum_distance / BASE_MOV_SPEED) / (distance / (BASE_MOV_SPEED * move_speed_mltplr) / (target_angle_dif / 2))


# Returns variations on the current waypoint position
func variate_waypoint() -> Vector2:
	var modifier = 1 if randf() < 0.5 else -1
	return Vector2(position + (target_object.position-position).normalized().rotated(deg_to_rad(randf_range(min_wander_angle_variation, 
		max_wander_angle_variation) * modifier)) * wander_length)


func new_condition_after_callback():
	wander_timer = 0
	temp_stop_timer = 0
	if abs(rad_to_deg(transform.x.angle_to(target_object.position-position))) > wander_end_angle_check:
		print("StartIdleFromCallback")
		current_state = States.IDLING
		head_ref.set_turn_state(CatHead.TurnStates.IDLE)
	else:
		print("StartMoveTrueFromCallback")
		current_state = States.MOVING_TRUE
		head_ref.set_turn_state(CatHead.TurnStates.LOOK_AT, target_object)
		set_new_waypoint(target_object, target_object.position,  true)


# || --- Callbacks --- ||


func _on_temp_stop_timer_timeout():
	print("StopTempEnd")
	new_condition_after_callback()


func _on_wander_stop_timer_timeout():
	print("StopWander")
	new_condition_after_callback()


func _on_cat_head_object_detected(throwable:Throwable):
	if throwable != target_object:
		print("Detect %s!" % [throwable])
		current_state = States.MOVING_TRUE
		is_repelled = false

		if throwable.attract > 0:
			head_ref.set_turn_state(CatHead.TurnStates.LOOK_AT, throwable)
			set_new_waypoint(throwable, throwable.position)
		else:
			head_ref.set_turn_state(CatHead.TurnStates.MOVE)
			is_repelled = true

			var modifier = 1 if randf() < 0.5 else -1
			var test = Vector2(position + (throwable.position-position).normalized().rotated(deg_to_rad(repel_angle * modifier)) * repel_vec_length)

			debug_target.set_pos(test)

			set_new_waypoint(null, test, true)
