extends Node2D

func _ready():
	randomize()
	Globals.generate_triggers()
	$Shelf.place_item_on_shelf(Globals.generate_random_item(), randi_range(1,9))
	print($Shelf.contents)
