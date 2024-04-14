class_name PauseMenu
extends Control

@onready var continue_button : Button = %ContinueButton
@onready var options_button : Button = %OptionsButton
@onready var options_menu_node : OptionsMenu = $OptionsMenu
@onready var menu_button : Button = %MenuButton
@onready var exit_button : Button = %ExitButton

@onready var main_menu_scene : PackedScene = preload("res://src/main_menu/MainMenu.tscn")


func _ready():
	options_menu_node.visible = false
# Connects buttons to functions
	continue_button.button_down.connect(_on_continue_pressed)
	options_button.button_down.connect(_on_options_pressed)
	menu_button.button_down.connect(_on_menu_pressed)
	exit_button.button_down.connect(_on_exit_pressed)

func _play_click_sfx() -> void:
	SoundManager.instance.play_click_sfx()

# Starts game
func _on_continue_pressed() -> void:
	_play_click_sfx()
	$".".visible = false


func _on_options_pressed() -> void:
	_play_click_sfx()
	options_menu_node.visible = true
	
	
func _on_menu_pressed() -> void:
	_play_click_sfx()
	get_tree().change_scene_to_packed(main_menu_scene)
	
	
# Exists game
func _on_exit_pressed() -> void:
	_play_click_sfx()
	get_tree().quit()
