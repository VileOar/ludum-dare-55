extends Node

const SECONDS_PER_MINUTE = 60
const MINUTES_PER_HOUR = 60
const INGAME_TO_REALTIME_DURATION = (2 * PI) 
const START_TIME = 0.0

# Use of signals to decouple ui from script
#signal time_tick(day : int, hour : int, minute : int)

@export var INGAME_SPEED = 1.0

var ingame_speed : float = floor(INGAME_SPEED)
var time : float = 0.0
# Prevent from updating every frame
var past_second : float = -1.0


func _ready():
	time = START_TIME * INGAME_TO_REALTIME_DURATION


func _process(delta: float):
	time += delta * INGAME_TO_REALTIME_DURATION * ingame_speed
	_recalculate_time()


func _recalculate_time() -> void:
	var total_seconds = int(time / INGAME_TO_REALTIME_DURATION)
	var second = total_seconds % SECONDS_PER_MINUTE
	var minute = int(total_seconds / SECONDS_PER_MINUTE)
	var hour = int(minute / MINUTES_PER_HOUR)

	if past_second != second:
		past_second = second
		print(hour, "h:", minute, "m:", second, "s" )
		#time_tick.emit(day, hour, minute)
		
