extends Control

var main_menu_scene : PackedScene
@onready var win_ending = $"."


func _ready():
	main_menu_scene = load("res://src/menus/main_menu/MainMenu.tscn")


func _on_menu_button_pressed() -> void:
	#_play_click_sfx()
	get_tree().change_scene_to_packed(main_menu_scene)
