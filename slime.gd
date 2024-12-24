extends RigidBody2D

var player : Player
var can_jump : bool = true
var is_hiden : bool = true
var is_following : bool = false
var can_hit : bool = true
var is_close : bool = false
var is_on_floor : bool = true
var is_in_jump = false
var direction : Vector2 = Vector2.ZERO

@export var buff : int = -200
@export var stats : EnemyStats
@onready var animator = $AnimatedSprite2D

func _ready() -> void:
	animator.play_backwards("apeer")
	animator.stop()
	is_hiden = true

func _process(delta: float) -> void:
	is_on_floor = $Raycasts/ground1.is_colliding() or $Raycasts/ground2.is_colliding() or $Raycasts/ground3.is_colliding()
	
	
	if player and !is_hiden:
		direction = (player.position - position).normalized()
		if $Raycasts/RayCast2D.is_colliding() and is_on_floor:
			Jump()
			can_hit = true
		if direction.x > 0:
			animator.flip_h = false
		elif direction.x < 0:
			animator.flip_h = true
		if can_jump and is_on_floor:
			if $Raycasts/RayCast2D2.is_colliding() and direction.x > 0:
				Dash()
			elif $Raycasts/RayCast2D3.is_colliding() and direction.x < 0:
				Dash()
			else:
				Jump()
	
	set_collision_layer_value(3,true if !is_hiden else false)
	set_collision_mask_value(2,true if !is_hiden else false)
	



func Jump():	
	is_in_jump = true
	linear_velocity = Vector2.ZERO
	if (position.y - player.position.y) > 32 and (position.x - player.position.x) < 128:
		apply_impulse(Vector2(stats.speed  * direction.x,stats.jump + buff))
		print('yes')
	else: 
		apply_impulse(Vector2(stats.speed  * direction.x,stats.jump))
		print('no')
	#apply_impulse(Vector2(stats.speed  * direction.x,stats.jump))
		
	can_jump = false
	$timers/JumpDelay.start()
	animator.play("run")


func Dash():
	is_in_jump = true
	if abs(position.distance_to(player.position)) > 64 and abs(player.position.x - position.x) < 128:
		apply_impulse(Vector2(0,-400+buff))
	else:
		apply_impulse(Vector2(0,-400))
	
	can_jump = false
	$timers/JumpDelay.start()
	$timers/dashDelay.start()


func DealDamage():
	player.TakeDamage(stats.damage)
	player.KnockBack(stats.knockBack_str, direction)
	can_hit = false
	$timers/TimeBetweenHit.start()

	
#region Новая область кода
func _on_hurt_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_hit and !is_hiden:
		is_close = true
		DealDamage()
		$timers/HitDelay.start()


func _on_hurt_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") :
		$timers/HitDelay.stop()
		can_hit = true
		$timers/TimeBetweenHit.start()
		is_close = false


func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and is_hiden:
		player = body
		animator.play("apeer")
		$timers/apeerTimer.start()
		


func _on_follow_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		$timers/rememberTimer.start()
		player = body
		is_following = false

func _on_follow_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_following = true
		$timers/rememberTimer.stop()
#endregion

#region Новая область кода
func _on_timer_timeout() -> void:
	can_jump = true


func _on_dash_delay_timeout() -> void:
	apply_impulse(Vector2(100 * direction.x,0))
	can_jump = true


func _on_remember_timer_timeout() -> void:
	player = null
	is_hiden = true
	animator.play("disapeer")

func _on_apeer_timer_timeout() -> void:
	is_hiden = false

func _on_hit_delay_timeout() -> void:
	DealDamage()
	$timers/TimeBetweenHit.start()

func _on_time_between_hit_timeout() -> void:
	can_hit = true
#endregion
