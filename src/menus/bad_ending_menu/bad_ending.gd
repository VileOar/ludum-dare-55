extends Control

@onready var menu_button = %MenuButton

@onready var main_menu_scene : PackedScene = preload("res://src/menus/main_menu/MainMenu.tscn")


func _ready():
	menu_button.button_down.connect(_on_menu_pressed)


func _on_menu_pressed() -> void:
	#_play_click_sfx()
	get_tree().change_scene_to_packed(main_menu_scene)
