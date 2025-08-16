extends Node2D
class_name Item
## Class for each item being placed on the shelves

## Type, Plushie, Toy, or Sticker.
var type : Globals.ItemTypes
## The number on the item.
var number: int
## Which trigger will occur if placed on the correct position.
var trigger: Globals.TriggerTypes

## Position on a shelf, -1 represents in hand.
var shelf_position: int
##Which shelf its on.
var shelf : Shelf
