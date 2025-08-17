extends Node2D
class_name ItemNode
## Class for each item being placed on the shelves


const HOVER_MOVE_DISTANCE = 50
const HOVER_MOVE_SPEED = 0.25
const TRIGGER_UI_SCALE_SPEED = 0.15
const FALL_BACK_SPEED = .15
## Item Data Resource
var item: Item:
	set(value):
		item = value
		item.item_node = self
## Position on a shelf, -1 represents in hand.
var shelf_position: int
## Which shelf its on.
var shelf : Shelf
var held: bool = false
var animation_lock: bool = false
var mouse_offset: Vector2
var potential_shelf_position: ShelfPosition:
	set(value):
		if potential_shelf_position:
			potential_shelf_position.selected = false
		potential_shelf_position = value
		if potential_shelf_position:
			potential_shelf_position.selected = true


func _process(_delta):
	if held:
		global_position = get_viewport().get_mouse_position()#+mouse_offset
		var lowest_distance: float
		if !$Area2D.has_overlapping_areas():
			potential_shelf_position = null
		if potential_shelf_position not in $Area2D.get_overlapping_areas():
			potential_shelf_position = null
		for area in $Area2D.get_overlapping_areas():
			if area is ShelfPosition and area.get_parent().check_validity(item,area.shelf_position) : #and area.get_parent().player == get_parent().player
				var distance_to = area.global_position.distance_to(global_position)
				if !lowest_distance:
					lowest_distance = distance_to
					potential_shelf_position = area
				elif distance_to < lowest_distance:
					lowest_distance = distance_to
					potential_shelf_position = area
					


var _fall_back_position: Vector2
func update_sprite():
	match item.type:
		Globals.ItemTypes.PLUSHIE: 
			$Sprite.animation = "plushie"
			$Sprite.self_modulate = Color(1,.4,.4)
		Globals.ItemTypes.TOY: 
			$Sprite.animation = "toy"
			$Sprite.self_modulate = Color(.4,1,.4)
		Globals.ItemTypes.STICKER: 
			$Sprite.animation = "sticker"
			$Sprite.self_modulate = Color(.4,.4,1)
	$Sprite.animation = "debug"
	$Sprite.frame = item.number
	$Sprite/Number.text = str(item.number)
	$TriggerIcon.frame = item.trigger.trigger_type
	$TriggerIcon/Number.text = str(item.trigger.position)
	# Techncally not sprite related but w/e
	var text
	print(item.trigger.trigger_type)
	match item.trigger.trigger_type:
		Globals.TriggerTypes.MOVE_ITEM: text = "Move Item\nIf placed in the proper position, this trigger will move a random item to an adjacent position on an opponent's shelf."
		Globals.TriggerTypes.DELETE_ITEM: text = "Trash Item\nIf placed in the proper position, this trigger will remove a random item from an opponent's shelf."
		Globals.TriggerTypes.CHANGE_ITEM_TYPE: text = "Change Item Type\nIf placed in the proper position, this trigger will change a random item on an opponent's shelf to a different type (Plushie, Toy, Sticker)."
	$TriggerIcon/PanelContainer/Label.text = text
	

func _on_overall_mouse_entered():
	if animation_lock or shelf_position != -1:
		return
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(position.x,-HOVER_MOVE_DISTANCE),HOVER_MOVE_SPEED).set_trans(Tween.TRANS_CUBIC)

func _on_overall_mouse_exited():
	if animation_lock or shelf_position != -1:
		return
	var tween = create_tween()
	tween.tween_property(self,"position",Vector2(position.x,0), HOVER_MOVE_SPEED)


func _on_trigger_icon_mouse_entered():
	$TriggerIcon/PanelContainer.visible = true
	var tween = create_tween()
	tween.tween_property($TriggerIcon/PanelContainer, "scale", Vector2(.5,.5), TRIGGER_UI_SCALE_SPEED)


func _on_trigger_icon_mouse_exited():
	$TriggerIcon/PanelContainer.visible = false
	var tween = create_tween()
	tween.tween_property($TriggerIcon/PanelContainer, "scale", Vector2(0,0), TRIGGER_UI_SCALE_SPEED)


func _on_area_2d_input_event(_viewport, event: InputEvent, _shape_idx):
	if shelf_position != -1:
		return
	if event.is_action_pressed("left_click"):
		held = true
		animation_lock = true
		mouse_offset = global_position - get_viewport().get_mouse_position()
	elif event.is_action_released("left_click"):
		held = false
		release_self()

func release_self():
	if !$Area2D.has_overlapping_areas() or !potential_shelf_position:
		var tween = create_tween()
		tween.tween_property(self, "position", _fall_back_position, FALL_BACK_SPEED)
		tween.tween_property(self, "animation_lock", false, 0)
	else:
		animation_lock = true
		var previous_position = global_position
		get_parent().remove_item_node(self)
		potential_shelf_position.take_item_node(self, previous_position)
		
		
