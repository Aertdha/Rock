extends Resource
class_name Inventory

@export var slots : Array[InventorySlot]

signal update

func Insert(item: InvItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty() and itemSlots[itemSlots.size() - 1].amount < item.maxStuck:
		itemSlots[itemSlots.size() - 1].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1
	update.emit()


func RemoveItem(slot_index):
	if slot_index >= 0 and slot_index < slots.size():
		slots[slot_index].amount -= 1
		if slots[slot_index].amount <= 0:
			slots.remove_at(slot_index)


func get_item(slot_index):
	return slots[slot_index] if slot_index >= 0 and slot_index < slot_index.size() else null

func has_item(item_name: String) -> bool:
	for slot in slots:
		if slot.item != null and slot.item.name == item_name and slot.amount > 0:
			return true
	return false

func remove_item(item_name: String, amount: int = 1) -> bool:
	for i in range(slots.size()):
		if slots[i].item != null and slots[i].item.name == item_name and slots[i].amount >= amount:
			slots[i].amount -= amount
			if slots[i].amount <= 0:
				slots[i].item = null
			update.emit()
			return true
	return false
