## object responsible for populating the different throwable objects
extends RigidBody2D
class_name Throwable

## the object's attraction value
@export var attract: int


func populate_item(item_id: String):
	var item_data = Constants.get_item_data(item_id)
	
	mass = item_data["mass"]
	$CollisionShape2D.shape.radius = item_data["radius"]
	$Sprite2D.texture = Constants.get_item_texture(item_id)
	attract = item_data["attract"]
