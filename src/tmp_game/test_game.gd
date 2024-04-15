extends Node2D


@onready var _game_logic: GameLogic = %Hud
@onready var _player: Player = %Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_player.new_next_item.connect(_game_logic._on_new_next_item)
	_player.game_was_won.connect(_game_logic._on_game_won)
