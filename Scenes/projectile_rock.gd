# Класс метательного камня, управляющий физикой и уроном
extends RigidBody2D

# Базовые параметры снаряда
var damage = 10          # Базовый урон камня
var initial_velocity = 400  # Начальная скорость полета

# Инициализация физических параметров
func _ready():
	gravity_scale = 1.0
	contact_monitor = true
	max_contacts_reported = 4
	
# Запуск камня в указанном направлении
func launch(direction: Vector2, start_pos: Vector2):
	position = start_pos
	prints("Rock spawned at:", position)
	prints("Direction:", direction)
	prints("Velocity:", direction * initial_velocity)
	linear_velocity = direction * initial_velocity
	damage = int(10 * (initial_velocity / 400.0))	

# Обработка столкновений
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
	queue_free()  # Уничтожаем камень после попадания 
