class_name MainMenu
extends Control

@onready var start_game_button : Button = $MarginContainer/HorizontalContainer/MarginContainer/VButtonsContainer/PlayButton
@onready var options_menu_button : Button = $MarginContainer/HorizontalContainer/MarginContainer/VButtonsContainer/OptionsButton
@onready var options_menu_node : OptionsMenu = $OptionsMenu
@onready var exit_button : Button = $MarginContainer/HorizontalContainer/MarginContainer/VButtonsContainer/ExitButton

#@onready var game_scene : PackedScene = preload("")


func _ready():
	options_menu_node.visible = false
# Connects buttons to functions
	#start_game_button.grab_focus()
	start_game_button.button_down.connect(_on_start_pressed)
	options_menu_button.button_down.connect(_on_options_pressed)
	exit_button.button_down.connect(_on_exit_pressed)


func _play_click_sfx() -> void:
	SoundManager.instance.play_click_sfx()


# Starts game
func _on_start_pressed() -> void:
	_play_click_sfx()
	SoundManager.instance.play_correct_sfx()
	#get_tree().change_scene_to_packed(game_scene)


func _on_options_pressed() -> void:
	_play_click_sfx()
	options_menu_node.visible = true
	
	
# Exists game
func _on_exit_pressed() -> void:
	_play_click_sfx()
	get_tree().quit()

