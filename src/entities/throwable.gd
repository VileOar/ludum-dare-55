## object responsible for populating the different throwable objects
extends RigidBody2D
class_name Throwable


func populate_item(item_id: String):
	var item_data = Constants.items_stats[item_id]
	
	mass = item_data[0]
	$CollisionShape2D.shape.radius = item_data[1]
	$Sprite2D.texture = load(Constants.items_sprites_folder.path_join(item_data[2]))
