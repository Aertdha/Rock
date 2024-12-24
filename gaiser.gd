extends StaticBody2D

@export var force : int = -200
@export var revers : bool = false
var is_active : bool = false
var player

func _process(delta: float) -> void:
	if player:
		if !revers:
			player.velocity.y = force
			player.fall_height = 0
			$CPUParticles2D.lifetime = abs($Area2D/CollisionShape2D.position.y / 100)*2
			$CPUParticles2D2.lifetime = abs($Area2D/CollisionShape2D.position.y / 100)*2
		else:
			player.velocity.y += force * -1
			player.danger_height = 5
			player.fallDamageMultyply = 1.2


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player.can_animate = false
		player.animator.stop()
		player.animator.play("fall")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player.can_animate = true
		player.danger_height = 8
		player.fallDamageMultyply = 1
		player = null
		
