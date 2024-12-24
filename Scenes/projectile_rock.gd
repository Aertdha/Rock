extends RigidBody2D

var damage = 10
var initial_velocity = 400

func _ready():
	# Настройка физики
	gravity_scale = 1.0
	contact_monitor = true
	max_contacts_reported = 4
	
func launch(direction: Vector2, start_pos: Vector2):
	position = start_pos
	prints("Rock spawned at:", position)
	prints("Direction:", direction)
	prints("Velocity:", direction * initial_velocity)
	linear_velocity = direction * initial_velocity
	damage = int(10 * (initial_velocity / 400.0))	

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()  # Уничтожаем камень после попадания 
