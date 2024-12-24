extends Resource
class_name EnemyStats

@export var speed : int = 150  # Было 200-300, уменьшаем
@export var jump : int = 300   # Можно тоже уменьшить если нужно
@export var maxHp : int
var hp = maxHp
@export var damage : int 
@export var knockBack_str : Vector2
@export var max_health : int = 30  # Максимальное здоровье слизи
