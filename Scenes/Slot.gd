extends Panel

@onready var itemSprite : Sprite2D = $CenterContainer/ItemTexture
@onready var amountText : Label = $Label

func update(slot : InventorySlot):
	
	if !slot.item:
		itemSprite.visible = false
		amountText.visible = false
	else:
		itemSprite.visible = true
		itemSprite.texture = slot.item.texture
		amountText.visible = slot.amount > 1
		amountText.text = str(slot.amount)
