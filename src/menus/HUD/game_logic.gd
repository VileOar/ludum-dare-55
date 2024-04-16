extends MarginContainer
class_name GameLogic

signal time_progress(value : int, is_value_to_progress_added : bool)

const TOTAL_PERCENTAGE : int = 100

var progress_value : int = 0
var seconds_for_next_value : int = 120

@onready var time_trial = $TimeTrial
@onready var bad_ending_scene : PackedScene = preload("res://src/menus/bad_ending_menu/bad_ending.tscn")
@onready var good_ending_scene : PackedScene = preload("res://src/menus/win_ending_menu/WinEnding.tscn")

@export var TOTAL_GAME_DURATION : int = 120
#@export var TOTAL_GAME_DURATION : int = 40
@export var TIME_IS_ALMOST_OVER_PERCENTAGE_WARNING : int = 75


func _ready():
	# Connects signal from time script
	time_trial.time_tick.connect(_progress_time)
	
	
 ## Updates progress time
	# to calculate next texture update, it is applied the regra de 3 simples
	# max time * next_progress_value / 100 percentage
	# we want to find next progress value, if total seconds bigger than that progress
	# we update
func _progress_time(total_seconds : int) -> void:
# TODO fix < 100 seconds
	#var seconds_for_next_value_float = float(TOTAL_GAME_DURATION * (progress_value + 1)) / 100
	var seconds_for_next_value_float = float((progress_value + 1) * 100) / TOTAL_GAME_DURATION
	seconds_for_next_value = int(seconds_for_next_value_float)
	#print("seconds_for_next_value_float = ", seconds_for_next_value_float)
	#print("total_seconds = ", total_seconds)
	
	#var progress_to_add = total_seconds - seconds_for_next_value
	#print("progress_to_add = ", progress_to_add)
	
	
	if seconds_for_next_value <= total_seconds:
		progress_value += 1
		time_progress.emit(1, true)
		
	if progress_value == TIME_IS_ALMOST_OVER_PERCENTAGE_WARNING:
# TODO change time loop music
		pass
	
	if progress_value >= TOTAL_PERCENTAGE:
		print("Time is over")
# TODO play sfx
		get_tree().change_scene_to_packed(bad_ending_scene)
		


## callback for when a new next item is spawned by the player
func _on_new_next_item(item_id):
	%NextObject.texture = Constants.get_item_icon(item_id)


## callback for when the game finishes on a winning condition
func _on_game_won():
	# TODO animation
	await get_tree().create_timer(0.5).timeout 
	get_tree().change_scene_to_packed(good_ending_scene)
