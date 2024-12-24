extends Area2D

@onready var text = preload("res://Scenes/interectrive_text_control.tscn")
var IntText
@onready var TextPos : Marker2D = $TextPos
@onready var player = get_node("%Player")
var item = preload("res://resources/items/rock.tres")
var is_active : bool = false

func _ready() -> void:
	IntText = text.instantiate()
	%UnModulated.add_child(IntText)
	IntText.get_child(0).global_position = TextPos.global_position
	
func _process(delta: float) -> void:
	if DayMoludate.hour >= 8 and DayMoludate.hour < 20:
		$lights.visible = false
		#day
	else:
		$lights.visible = true
		#night
	if is_active:
		IntText.get_child(0).global_position = TextPos.global_position - IntText.get_child(0).pivot_offset
		if Input.is_action_just_pressed("interactive"):
			player.inventory.Insert(item)
			IntText.get_child(0).visible = true
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		IntText.get_child(0).visible = true
		is_active = true



func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_active = false
		IntText.get_child(0).visible = false
