extends Node2D
class_name Shelf

## The player that owns the shelf.
@export var player: Globals.Players = Globals.Players.MAIN_PLAYER
## The number of spaces on the shelf
@export var shelf_spaces: int = 9
var contents: Array[Item] = []
var unindexed_contents: Array[Item] = []

func _ready():
	contents.resize(shelf_spaces)
	contents.fill(null)
	

func check_validity(item: Item, itemPosition: int) -> bool:
	if contents[itemPosition-1]:
		return false
	# Checks the contents for a placed object that would invalidate the current placement. 
	for i in range(0,itemPosition-1):
		if contents[i] and contents[i].number > item.number:
			return false
	for i in range(itemPosition-1,Globals.HIGHEST_NUMBER):
		if contents[i] and contents[i].number < item.number:
			return false
	return true

## Places an item on the shelf
func place_item_on_shelf(item_node: ItemNode, itemPosition: int, _trigger = true) -> void:
	# Assigns the object and determines if the trigger should occur.
	contents[itemPosition-1] = item_node.item
	unindexed_contents.append(item_node.item)
	item_node.shelf_position = itemPosition-1
	item_node.shelf = self
	if _trigger and Globals.get_trigger(item_node.item.trigger.trigger_type).position == itemPosition:
		get_parent().activate_trigger(item_node.item.trigger.trigger_type,player)


func remove_item(item: Item):
	print("Removing Item")
	push_error("test")
	contents[contents.find(item)] = null
	unindexed_contents.erase(item)
	item.item_node.queue_free()
