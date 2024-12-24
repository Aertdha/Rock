extends Node2D

@onready var label = $Label

func _ready():
    prints("Инициализация FloatingText")
    if not has_node("Label"):
        prints("ОШИБКА: Узел Label не найден в сцене!")
        queue_free()
        return
    
    label = $Label
    if label.text != "":
        prints("Текст уже установлен:", label.text)
    
    # Анимируем текст
    var tween = create_tween()
    tween.tween_property(self, "position", position + Vector2(0, -50), 0.3)
    tween.parallel().tween_property(self, "modulate:a", 0.0, 0.3)
    tween.tween_callback(queue_free)

func set_text(value: String):
    # Ждем готовности узла
    await ready
    
    if label:
        label.text = value
        prints("Текст успешно установлен:", value)
    else:
        prints("ОШИБКА: Label все еще не найден!") 