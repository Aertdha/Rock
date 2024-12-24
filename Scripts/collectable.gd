extends Node

@export var itemRes : InvItem
#var inventory : Inventory = preload("res://resources/PlayerInventory.tres")

func Collect(inventory : Inventory):
	inventory.Insert(itemRes)
	get_parent().queue_free()
	
