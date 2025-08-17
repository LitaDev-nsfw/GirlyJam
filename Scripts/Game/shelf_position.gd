extends Area2D
class_name ShelfPosition

@export var shelf_position : int
var selected: bool = false:
	set(value):
		selected = value
		if selected:
			$Sprite.frame = 1
		else:
			$Sprite.frame = 0

func take_item_node(item_node: ItemNode, previous_position: Vector2, do_trigger = true) -> void:
	print("Taking node")
	selected = false
	item_node.animation_lock = true
	add_child(item_node)
	print(item_node.get_parent())
	item_node.global_position = previous_position
	var tween = create_tween()
	tween.tween_property(item_node,"global_position",global_position,.1)
	get_parent().place_item_on_shelf(item_node, shelf_position, do_trigger)
	
