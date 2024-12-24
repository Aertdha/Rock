extends Label


func _process(delta: float) -> void:
	text = (str($"..".value)+"/"+str($"..".max_value))
