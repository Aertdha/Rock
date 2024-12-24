extends TextureProgressBar

func _process(delta: float) -> void:
	if value > 75:
		$funny.visible = true
		$funny.play("funny")
		
		$bad.visible = false 
		$angry.visible = false
		$tilt.visible = false
	elif value > 50:
		$bad.visible = true
		$bad.play("bad")
		
		$funny.visible = false 
		$angry.visible = false
		$tilt.visible = false
	elif value > 25:
		$angry.visible = true
		$angry.play("angry")
		
		$funny.visible = false 
		$bad.visible = false
		$tilt.visible = false
	else:
		$tilt.visible = true
		$tilt.play("tilt")
		
		$funny.visible = false 
		$bad.visible = false
		$angry.visible = false
