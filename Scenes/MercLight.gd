extends PointLight2D
@export var noise : FastNoiseLite
@export var speed : float = 20
@export var str : float  = 0.2
var pos : float
@onready var origScale = scale

func _ready() -> void:
	pos = randf_range(0,1000)

func _process(delta: float) -> void:
	pos += delta*speed
	scale = origScale * (1-noise.get_noise_1d(pos)*str)
