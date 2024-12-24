extends Control

@export var item_scene : PackedScene # Префаб предмета
@export var item_count : int = 8 # Количество предметов
@export var radius : float = 100.0 # Радиус круга

func _ready():
	create_circular_inventory()

func create_circular_inventory():
	for i in range(item_count):
		var angle = i * (2* PI / item_count)
		var position = Vector2(cos(angle), sin(angle)) * radius
		
		var item_instance = item_scene.instantiate()
		item_instance.position = position + Vector2(50,50)
		
		add_child(item_instance)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("aim"):
		var tween = get_tree().create_tween()
		set_deferred("add_child",tween)
		tween.tween_property(self,"rotation_degrees",deg_to_rad(rotation + 90),1)
