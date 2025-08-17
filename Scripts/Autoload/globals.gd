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

enum Players {
	MAIN_PLAYER,
	AI_PLAYER,
}

## How many numerals to put on cards, presently 1-9
const NUMERALS := 9
const LOWEST_NUMBER := 1
const HIGHEST_NUMBER := 9


var trigger_resources: Array[Trigger] = []

func generate_triggers() -> void:
	var used_numbers = []
	var min_value = LOWEST_NUMBER
	var max_value = HIGHEST_NUMBER
	for key in TriggerTypes:
		var trigger = Trigger.new()
		trigger.trigger_type = TriggerTypes[key]
		trigger_resources.append(trigger)
		if used_numbers.size() == NUMERALS:
			trigger.position = randi_range(LOWEST_NUMBER,HIGHEST_NUMBER)
		else:
			if min_value in used_numbers:
				min_value += 1
			if max_value in used_numbers:
				max_value -= 1
			while true:
				var possible_number = randi_range(min_value,max_value)
				if possible_number not in used_numbers:
					used_numbers.append(possible_number)
					trigger.position = possible_number
					break
		

func get_trigger(trigger_type: TriggerTypes) -> Trigger:
	print(trigger_type)
	for trigger in trigger_resources:
		if trigger.trigger_type == trigger_resources[trigger_type].trigger_type:
			return trigger
	push_error("Trigger doesn't exist.")
	return
