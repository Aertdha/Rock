extends CanvasLayer

var is_open : bool = true
var openPos : int = 0
var closePos : int = -128
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("tab"):
		switch()
		if is_open:
			is_open = false
		else:
			is_open = true


func switch():
	var tween = get_tree().create_tween()
	if !is_open:
		tween.tween_property($Panel,"position:x",openPos,0.5)
	else:
		tween.tween_property($Panel,"position:x",closePos,0.5)
	
