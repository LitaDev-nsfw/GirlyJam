extends Node2D

var _incr = 0


func _ready():
	randomize()
	Globals.generate_triggers()
	for i in 3:
		$Hand.add_item(generate_random_item())


func _process(delta):
	_incr += delta
	if _incr > 5:
		$UI/Label.text = "Score: "+str(round(calculate_score(Globals.Players.MAIN_PLAYER)))

func activate_trigger(trigger_type: Globals.TriggerTypes, player: Globals.Players):
	print("Activating Trigger")
	var targetted_player : Globals.Players
	match player:
		Globals.Players.MAIN_PLAYER: targetted_player = Globals.Players.AI_PLAYER
		Globals.Players.AI_PLAYER: targetted_player = Globals.Players.MAIN_PLAYER
	
	match trigger_type:
		Globals.TriggerTypes.MOVE_ITEM:
			var items = get_items_of_player(targetted_player)
			if items.size() == 0:
				return
			while true:
				var item = items[randi_range(0,items.size()-1)]
				var direction_array = [-1, 1]
				if item.item_node.shelf_position == Globals.LOWEST_NUMBER:
					direction_array.erase(-1)
				elif item.item_node.shelf_position == Globals.HIGHEST_NUMBER:
					direction_array.erase(1)
				var direction = [-1, 1].pick_random()
				var item_placed = false
				if item.item_node.shelf.contents[item.item_node.shelf_position+1+direction] == null:
					for shelf_position in item.item_node.shelf.get_children():
						if not shelf_position is ShelfPosition:
							pass
						elif shelf_position.shelf_position == item.item_node.shelf_position-1+direction:
							print("Moving Node")
							var temp_position = item.item_node.global_position
							item.item_node.get_parent().get_parent().contents.erase(item)
							item.item_node.get_parent().remove_child(item.item_node)
							shelf_position.take_item_node(item.item_node, temp_position, false)
							item_placed = true
							break
				if item_placed:
					break
		Globals.TriggerTypes.DELETE_ITEM: 
			var items = get_items_of_player(targetted_player)
			if items.size() == 0:
				return
			var item = items[randi_range(0,items.size()-1)]
			for shelf_position in item.item_node.shelf.get_children():
				if not shelf_position is ShelfPosition:
					pass
				else:
					shelf_position.get_parent().remove_item(item)
					break
		Globals.TriggerTypes.CHANGE_ITEM_TYPE: 
			var items = get_items_of_player(targetted_player)
			var item = items[randi_range(0,items.size()-1)]
			while true:
				var new_type = randi_range(0,Globals.ItemTypes.size()-1)
				if new_type != item.type:
					item.type = new_type
					item.item_node.update_sprite()
					break

func get_items_of_player(player) -> Array[Item]:
	var items: Array[Item] = []
	for shelf in get_tree().get_nodes_in_group("Shelves"):
		if shelf.player == player:
			items.append_array(shelf.unindexed_contents)
	return items

## Generates an item at random.
func generate_random_item() -> Item:
	var item = Item.new()
	item.type = randi_range(0,Globals.ItemTypes.size()-1)
	item.number = randi_range(Globals.LOWEST_NUMBER,Globals.HIGHEST_NUMBER)
	item.trigger = Globals.trigger_resources[randi_range(0,Globals.trigger_resources.size()-1)]
	return item


func generate_set_item(type: Globals.ItemTypes, numeral: int, trigger_type: Globals.TriggerTypes) -> Item:
	var item = Item.new()
	item.type = type
	item.number = numeral
	item.trigger = trigger_type
	return item



func calculate_score(player: Globals.Players) -> float:
	var items: Array[Item] = []
	for shelf in get_tree().get_nodes_in_group("Shelves"):
		if shelf.player == player:
			for item in shelf.contents:
				if item: items.append(item);
	var plushieCount = 0
	var toyCount = 0
	var stickerCount = 0
	if items.size() == 0:
		return 0
	for item in items:
		match item.type:
			Globals.ItemTypes.PLUSHIE: plushieCount += 1
			Globals.ItemTypes.TOY: toyCount += 1
			Globals.ItemTypes.STICKER: stickerCount += 1
	var totalCount = plushieCount + toyCount + stickerCount
	var multiplier = max(plushieCount, toyCount, stickerCount)/totalCount + 1.0
	return float(totalCount) * multiplier

func draw_item(hand: Hand):
	hand.add_item(generate_random_item())
