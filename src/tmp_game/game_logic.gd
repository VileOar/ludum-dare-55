extends Node2D


func _ready():
	pass # Replace with function body.


func _on_end_game_area_body_entered(body):
# TODO temp até ter tipos ou something
	if body.name == "CatBody":
		print("Cat entered winning area!")
		print("Congralutions, you won!")
