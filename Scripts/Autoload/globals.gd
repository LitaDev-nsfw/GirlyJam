extends Node

enum ItemTypes {
	PLUSHIE,
	TOY,
	STICKER,
}

enum TriggerTypes {
	MOVE_ITEM,
	DELETE_ITEM,
	CHANGE_ITEM_TYPE,
}

## How many numerals to put on cards, presently 1-9
const NUMERALS := 9
const LOWEST_NUMBER := 1
const HIGHEST_NUMBER := 9


var trigger_resources: Array[Trigger] = []

func generate_triggers() -> void:
	var used_numbers = []
	var min = LOWEST_NUMBER
	var max = HIGHEST_NUMBER
	for key in TriggerTypes:
		var trigger = Trigger.new()
		trigger.trigger_type = TriggerTypes[key]
		trigger_resources.append(trigger)
		if used_numbers.size() == NUMERALS:
			trigger.position = randi_range(LOWEST_NUMBER,HIGHEST_NUMBER)
		else:
			if min in used_numbers:
				min += 1
			if max in used_numbers:
				max -= 1
			while true:
				var possible_number = randi_range(min,max)
				if possible_number not in used_numbers:
					used_numbers.append(possible_number)
					trigger.position = possible_number
					break
		

func generate_random_item() -> Item:
	var item = Item.new()
	item.type = randi_range(0,ItemTypes.size()-1)
	item.number = randi_range(LOWEST_NUMBER,HIGHEST_NUMBER)
	item.trigger = randi_range(0,TriggerTypes.size()-1)
	return item

func generate_set_item(type: ItemTypes, numeral: int, trigger_type: TriggerTypes) -> Item:
	var item = Item.new()
	item.type = type
	item.number = numeral
	item.trigger = trigger_type
	return item

func get_trigger(trigger_type: TriggerTypes) -> Trigger:
	print(trigger_type)
	for trigger in trigger_resources:
		if trigger.trigger_type == trigger_resources[trigger_type].trigger_type:
			return trigger
	push_error("Trigger doesn't exist.")
	return
