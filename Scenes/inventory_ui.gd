extends Control

signal opened
signal closed

var is_open : bool = false
var can_zoom_one : bool = true
var can_zoom_two : bool = true
var can_zoom_tree : bool = true
var can_zoom_four : bool = true
var can_zoom_five : bool = true
@onready var inventory : Inventory = preload("res://resources/PlayerInventory.tres")
@onready var slots1 : Array = $HBoxContainer.get_children()
@onready var slots2 : Array = $HBoxContainer2.get_children()
@onready var slotsAll : Array = slots1 + slots2

func _ready() -> void:
	inventory.update.connect(update)
	#inventory.zoom.connect(Zoom)
	update()

func _process(delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("one") and can_zoom_one:
		#var originalPos = slotsAll[0].position.y
		#var tween = get_tree().create_tween()
		#can_zoom_one = false
		#tween.tween_property(slotsAll[0],"position:y",originalPos-50,0.2)
		#await get_tree().create_timer(0.4).timeout
		#var tween2 = get_tree().create_tween()
		#tween2.tween_property(slotsAll[0],"position:y",originalPos,0.2)
		#await get_tree().create_timer(0.4).timeout
		#can_zoom_one = true
	#elif Input.is_action_just_pressed("two") and can_zoom_two:
		#var originalPos = slotsAll[1].position.y
		#var tween = get_tree().create_tween()
		#can_zoom_two = false
		#tween.tween_property(slotsAll[1],"position:y",originalPos-50,0.2)
		#await get_tree().create_timer(0.4).timeout
		#var tween2 = get_tree().create_tween()
		#tween2.tween_property(slotsAll[1],"position:y",originalPos,0.2)
		#await get_tree().create_timer(0.4).timeout
		#can_zoom_two = true
	#elif Input.is_action_just_pressed("tree") and can_zoom_tree:
		#var originalPos = slotsAll[2].position.y
		#var tween = get_tree().create_tween()
		#can_zoom_tree = false
		#tween.tween_property(slotsAll[2],"position:y",originalPos-50,0.2)
		#await get_tree().create_timer(0.4).timeout
		#var tween2 = get_tree().create_tween()
		#tween2.tween_property(slotsAll[2],"position:y",originalPos,0.2)
		#await get_tree().create_timer(0.4).timeout
		#can_zoom_tree = true
	#elif Input.is_action_just_pressed("foure") and can_zoom_four:
		#var originalPos = slotsAll[3].position.y
		#var tween = get_tree().create_tween()
		#can_zoom_four = false
		#tween.tween_property(slotsAll[3],"position:y",originalPos-50,0.2)
		#await get_tree().create_timer(0.4).timeout
		#var tween2 = get_tree().create_tween()
		#tween2.tween_property(slotsAll[3],"position:y",originalPos,0.2)
		#await get_tree().create_timer(0.4).timeout
		#can_zoom_four = true
	#elif Input.is_action_just_pressed("five") and can_zoom_five:
		#var originalPos = slotsAll[4].position.y
		#var tween = get_tree().create_tween()
		#can_zoom_five = false
		#tween.tween_property(slotsAll[4],"position:y",originalPos-50,0.2)
		#await get_tree().create_timer(0.4).timeout
		#var tween2 = get_tree().create_tween()
		#tween2.tween_property(slotsAll[4],"position:y",originalPos,0.2)
		#await get_tree().create_timer(0.4).timeout
		#can_zoom_five = true

func update():
	for i in range(min(inventory.slots.size(),slotsAll.size())):
		slotsAll[i].update(inventory.slots[i])

#func Zoom(index : int):
	##if can_zoom:
		##print(index)
		##var originalPos = position.y
		##var tween = get_tree().create_tween()
		##can_zoom = false
		##tween.tween_property(slots[0],"position:y",originalPos-50,0.5)
		##await get_tree().create_timer(1).timeout
		##var tween2 = get_tree().create_tween()
		##tween2.tween_property(slots[0],"position:y",originalPos,0.5)
		##await get_tree().create_timer(1).timeout
		##can_zoom = true
		#pass

func Open():
	visible = true
	is_open = true
	opened.emit()

func Closed():
	visible = false
	is_open = true
	closed.emit(false)
