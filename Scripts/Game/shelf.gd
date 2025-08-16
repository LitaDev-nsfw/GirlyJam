extends Node2D
class_name Shelf

@export var shelf_spaces: int = 9
var contents: Array[Item] = []


func _ready():
	var item = Item.new()
	contents.resize(shelf_spaces)
	contents.fill(null)

## Places an item on the shelf, returns true if the item's trigger should occur.
func place_item_on_shelf(item: Item, itemPosition: int) -> bool:
	if contents[itemPosition]:
		push_error("Item already in position: "+ str(itemPosition))
		return false
	# Checks the contents for a placed object that would invalidate the current placement. 
	for i in range(0,itemPosition):
		if contents[i] and contents[i].number > item.number:
			return false
	for i in range(itemPosition,Globals.HIGHEST_NUMBER):
		if contents[i] and contents[i].number < item.number:
			return false
	#Assuming no early returns, assigns the object and determines if the trigger should occur.
	contents[itemPosition] = item
	item.shelf_position = itemPosition
	item.shelf = self
	if Globals.get_trigger(item.trigger).position == itemPosition:
		return true
	else:
		return false
