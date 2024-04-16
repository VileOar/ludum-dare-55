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
const items_sprites_folder = "res://assets/game_assets/Objetos/tamanho real/"
const items_icons_folder = "res://assets/game_assets/Objetos/tamanho maior/"

## data that holds stats for all items
var items_stats = {
	"tuna": {"mass":2, "radius":72, "texture":"tuna.png", "attract":1},
	"ball": {"mass":0.5, "radius":24, "texture":"ball.png", "attract":1},
	"balloon": {"mass":0.3, "radius":32, "texture":"balloon.png", "attract":-1},
	"banana": {"mass":1, "radius":48, "texture":"banana.png", "attract":-1},
	"novelo": {"mass":1, "radius":32, "texture":"novelo.png", "attract":1},
	"lemon": {"mass":0.8, "radius":32, "texture":"lemon.png", "attract":-1},
}
## return the dictionary data of items
func get_item_data(item_id: String) -> Dictionary:
	if items_stats.has(item_id):
		return items_stats[item_id]
	return {}
## return a random item id from the available pool
func get_random_item_id() -> String:
	var pool = items_stats.keys()
	return pool[randi() % pool.size()]
## return a texture resource from the given item_id
func get_item_texture(item_id) -> Texture:
	return load(items_sprites_folder.path_join(get_item_data(item_id)["texture"]))
## return a texture resource from the given item_id
func get_item_icon(item_id) -> Texture:
	return load(items_icons_folder.path_join(get_item_data(item_id)["texture"]))

func _ready() -> void:
	randomize()
