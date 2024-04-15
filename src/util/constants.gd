extends Node

# dictionary with possible resolutions
var resolutions: Dictionary = {"1920x1080[16:9]" : Vector2(1920, 1080),
								"1600x900[16:9]" : Vector2(1600, 900),
								"1366x768[16:9]" : Vector2(1366, 768),
								"1280x720[16:9]" : Vector2(1280, 720),
								"1280x1024[5:4]" : Vector2(1280, 1024),
								"1280x960[4:3]"  : Vector2(1280, 960),
								"1024x768[4:3]"  : Vector2(1024, 768),}

## path to the items sprites folder
const items_sprites_folder = "res://assets/game_assets/"

## CSV like data that holds stats for all items
var items_stats = {
	# id: [mass, radius, sprite_file, attract_value]
	"tuna": [5, 128, "tuna.png", 1]
}
