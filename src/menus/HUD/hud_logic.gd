extends MarginContainer

signal time_progress(value : int, is_value_to_progress_added : bool)

var progress_value : int = 0
var seconds_for_next_value : int = 120

@onready var time_trial = $TimeTrial

@export var TOTAL_GAME_DURATION : int = 120


func _ready():
	# Connects signal from time script
	time_trial.time_tick.connect(_progress_time)
	
	
# Updates progress time
func _progress_time(total_seconds : int) -> void:
	# to calculate next texture update, it is applied the regra de 3 simples
	# max time * next_progress_value / 100 percentage
	# we want to find next progress value, if total seconds bigger than that progress
	# we update
	var seconds_for_next_value_float = float(TOTAL_GAME_DURATION * (progress_value + 1)) / 100
	seconds_for_next_value = int(seconds_for_next_value_float)
	if seconds_for_next_value <= total_seconds:
		progress_value += 1
		time_progress.emit(1, true)
		

