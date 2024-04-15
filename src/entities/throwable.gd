## object responsible for populating the different throwable objects
extends RigidBody2D
class_name Throwable


func populate_item(item_id: String):
	mass = Constants.items_stats[item_id][0]
	$CollisionShape2D.shape.radius = Constants.items_stats[item_id][1]
	
