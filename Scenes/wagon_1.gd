extends Area2D

@onready var texture_man : Sprite2D = $man
@onready var texture_no_man : Sprite2D = $noMan
@onready var animator : AnimatedSprite2D = $AnimatedSprite2D
var is_open : bool

func _ready() -> void:
	if DayMoludate.hour >= 8 and DayMoludate.hour < 20:
		animator.play("open")
		is_open = true
	else:
		animator.play("close")
		is_open = false
func _process(delta: float) -> void:
	if DayMoludate.hour >= 8 and DayMoludate.hour < 20:
		if !is_open:
			animator.play("open")
		is_open = true
		#texture_man.visible = true
		#texture_no_man.visible = false
		$lights.visible = false
		#day
	else:
		if is_open:
			animator.play("close")
		is_open = false
		#texture_man.visible = false
		#texture_no_man.visible = true
		$lights.visible = true
		#night
