extends Node2D

@onready var _hud: HUDLogic = %Hud
@onready var _player : Player = $Player


func _ready() -> void:
	_player.new_next_item.connect(_hud._on_new_next_item)
