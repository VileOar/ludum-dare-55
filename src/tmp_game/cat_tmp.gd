extends Node2D

var velocity : Vector2
@onready var cat_body = $CatBody



func _ready():
	velocity[0] = -20000
	velocity[1] = 0
	move_cat()


func move_cat():
	cat_body.apply_force(velocity)
