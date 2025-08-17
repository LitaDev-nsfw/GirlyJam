extends Resource
class_name Item

## Type, Plushie, Toy, or Sticker.
var type : Globals.ItemTypes
				
## The number on the item.
var number: int
## Which trigger will occur if placed on the correct position.
var trigger: Trigger

var item_node: ItemNode
