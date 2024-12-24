extends CharacterBody2D

func _physics_process(delta: float) -> void:
	velocity += get_gravity() * delta
	move_and_slide()
