extends Node2D
class_name Hand

const HAND_SIZE = 3
const SPRITE_OFFSET = 150
@export var player: Globals.Players = Globals.Players.MAIN_PLAYER
var contents: Array[Item] = []
@onready var item_scene = preload("res://Scenes/Instanced Objects/item.tscn")  

func _init():
	contents.resize(HAND_SIZE)

func sort_hand():
	var sort = func sort_item_numbers(a, b): return a.item.number < b.item.number
	var sorted_items = get_children()
	sorted_items.sort_custom(sort)
	for i in sorted_items:
		print("Sort: "+str(i.item.number))
		var tween = create_tween()
		tween.tween_property(i, "position", Vector2(SPRITE_OFFSET * sorted_items.find(i),0), .25).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(i, "_fall_back_position", Vector2(SPRITE_OFFSET * sorted_items.find(i), 0), 0)

func add_item(item: Item):
	print(contents)
	contents[contents.find(null)] = item
	var item_node: ItemNode = item_scene.instantiate()
	item_node.item = item
	item_node.shelf_position = -1
	item_node.update_sprite()
	print(contents.find(item))
	item_node.position.x = SPRITE_OFFSET * contents.find(item)
	item_node._fall_back_position = item_node.position
	add_child(item_node)
	sort_hand()

func remove_item_node(item_node: ItemNode):
	contents.erase(item_node.item)
	contents.resize(HAND_SIZE)
	remove_child(item_node)
	get_parent().draw_item(self)
