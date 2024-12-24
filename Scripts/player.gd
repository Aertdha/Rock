extends CharacterBody2D
class_name Player


@export var stats : PlayerStats
@onready var animator = $AnimatedSprite2D
@onready var hpBar : TextureProgressBar = get_node("%HpBar")
@onready var airBar : TextureProgressBar = get_node("%AirBar")
@export var fallDamageMultyply : float = 1
var fall_height : int = 0
var danger_height : int = 8
var selected_slot = 0
@onready var maxHp : int = stats.maxhp
@onready var hp : int = maxHp
@onready var maxAir : int = stats.max_air
@onready var air : int = maxHp
@onready var crosshair : Sprite2D = $Crosshair
@onready var digRaycast : RayCast2D = $Raycasts/DigRaycast
@onready var groundTiles : TileMapLayer = %GroundTiles
@export var inventory : Inventory
var is_digging : bool = false
var can_animate : bool = true
var can_move : bool = true
var is_in_water : bool = false
var is_alive : bool = true
var is_falling : bool = false
var direction
@onready var ProjectileRock = preload("res://Scenes/projectile_rock.tscn")
var is_aiming = false
var throw_power = 0
var max_throw_power = 800
var min_throw_power = 200

func _ready() -> void:
	hpBar.max_value = maxHp 
	hpBar.value = hp
	
	airBar.max_value = maxAir
	airBar.value = air


func _physics_process(delta: float) -> void:
	if is_alive:
		if can_move:
			if Input.is_action_pressed("jump") and is_in_water:
				velocity.y = stats.swim_jump
			elif Input.is_action_just_released("jump") and is_in_water:
				velocity.y = stats.swim_gravity
			
			if not is_on_floor():
				if !is_in_water:
					velocity += get_gravity() * delta
				else:
					velocity.y += stats.swim_gravity * delta
			
			direction = Input.get_axis("left", "right")
			if direction:
				velocity.x = direction * (stats.speed if !is_in_water else stats.swim_speed) 
			else:
				velocity.x = move_toward(velocity.x, 0, (stats.speed if !is_in_water else stats.swim_speed))
			
			if direction > 0:
				animator.flip_h = true
			elif direction < 0:
				animator.flip_h = false
			
			move_and_slide()


func _process(delta: float) -> void:
	hpBar.value = hp
	airBar.value = air
	if is_alive:
		
		if Input.is_action_just_pressed("ui_cancel"):
			inventory.RemoveItem(selected_slot)
		if Input.is_action_just_pressed("ScrollUp"):
			selected_slot = selected_slot - 1
			if selected_slot < 0:
				selected_slot = 0
		if Input.is_action_just_pressed("ScrollDown"):
			selected_slot = selected_slot - 1
			if selected_slot > 3:
				selected_slot = 3
		if can_move:
			HandlerAnimation()
			check_tile()
			
			if !is_on_floor():
				if velocity.y > 0:
					fall_height += velocity.y * delta
			else:
				fall_height = (fall_height / 32) + 1
				if is_falling:
					ApplyFallDamage()
			is_falling = true if (fall_height / 32) + 1 >= danger_height else false
		
		if is_in_water  and !$Raycasts/RayCast2D.is_colliding():
			fall_height = 0
			air -= 10 * delta
		elif !is_in_water:
			air += 200 * delta
		if air > maxAir:
			air = maxAir
		elif air <= 0:
			air = 0
			if $Timers/Timer.is_stopped():
				TakeDamage(stats.airLossDamage)
				$Timers/Timer.start()
		else:
			$Timers/Timer.stop()

		if is_aiming:
			crosshair.position = (position - get_global_mouse_position()).normalized() * -40
			crosshair.visible = true
			# Увеличиваем силу броска пока зажата кнопка
			throw_power = min(throw_power + 400 * delta, max_throw_power)
		else:
			crosshair.visible = false
			throw_power = min_throw_power


func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("use"):
		animator.play("dig")
	if Input.is_action_just_pressed("jump") and is_on_floor() and !is_in_water:
		velocity.y = stats.jump_force

	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
		for i in range(inventory.slots.size()):
			inventory.slots[i] == null
		inventory.update.emit()
	if Input.is_action_just_pressed("lbm"):
		var cellPos = groundTiles.local_to_map(get_global_mouse_position())
		if cellPos != null and !is_digging:
			is_digging = true
			var point_a = Vector2i(groundTiles.local_to_map(position)) + Vector2i(-1,-1)
			var point_b = Vector2i(groundTiles.local_to_map(position)) + Vector2i(1,1)
			var cellData : TileData = groundTiles.get_cell_tile_data(cellPos)
			if (cellData != null) and (is_close_to_dig(point_a,point_b,cellPos)):
				if cellData.get_custom_data("durability") != null:
					var cellHp = cellData.get_custom_data("durability")
					print(cellHp,"->",cellHp-1)
					cellHp -= 1
					cellData.set_custom_data("durability",cellHp)
					if cellHp <= 0:
						var cells = [cellPos]
						groundTiles.set_cells_terrain_connect(cells,0,-1,0)

			await get_tree().create_timer(0.75).timeout
			is_digging = false


func is_close_to_dig(point_a: Vector2, point_b: Vector2, pos: Vector2):
	var min_x = min(point_a.x, point_b.x)
	var max_x = max(point_a.x, point_b.x)
	var min_y = min(point_a.y, point_b.y)
	var max_y = max(point_a.y, point_b.y)
	
	return pos.x >= min_x and pos.x <= max_x and pos.y >= min_y and pos.y <= max_y
	

func HandlerAnimation():
	if is_digging:
		animator.play("dig")
	else:
		if is_alive and can_animate and !is_digging:
			if is_in_water:
				animator.play("swim")
			else:
				if is_on_floor():
					if velocity.x != 0:
						animator.play("run")
					else:
						animator.play("idle")
				else:
					if !is_falling:
						animator.play("jump")
					else:
						animator.play("fall")


func check_tile():
	var FluidTilemap : TileMapLayer = get_node("%FluidTiles")  # Убедитесь, что путь к TileMap правильный
	if FluidTilemap:
		var tile_pos = FluidTilemap.local_to_map(position)
		var tile_id = FluidTilemap.get_cell_source_id(tile_pos)
		
		if tile_id != -1:
			var tile_data : TileData = FluidTilemap.get_cell_tile_data(tile_pos)
			if tile_data.get_custom_data("name") == "water" and !is_in_water:
				is_in_water = true
				var tween = get_tree().create_tween()
				tween.parallel().tween_property(self, "velocity:y", stats.swim_gravity, 0.001).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT_IN)
		else:
			is_in_water = false


func ApplyFallDamage():
	var dmg : int
	if fall_height < danger_height:
		dmg = 0
	elif fall_height == danger_height:
		dmg = 10
	else:
		dmg = 10 * (1.5 ** (fall_height - danger_height))
	fall_height = 0
	TakeDamage(dmg * fallDamageMultyply)


func TakeDamage(dmg : int):
	if is_alive:
		if dmg > 0:
			hp -= dmg
		if hp<=0 and is_alive:
			Die()
		DamagePopUp.display_number(dmg,position,false)
		$Camera2D.apply_shake()
		print("урон получен: ", dmg)


func KnockBack(knockBack_str : Vector2,dir: Vector2):
	var tween = get_tree().create_tween()
	tween.parallel().tween_property(self,"velocity",Vector2(knockBack_str.x * (1 if dir.x > 0 else -1),knockBack_str.y),0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await tween.finished
	#$Node2D/stunTimer.start()


func Die():
	is_alive = false
	animator.play("death")
	$Timers/RestartTimer.start()


func _on_restart_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_stun_timer_timeout() -> void:
	can_move = true


func _on_timer_timeout() -> void:
	TakeDamage(stats.airLossDamage)


func _on_collect_area_area_entered(area: Area2D) -> void:
	if area.has_method("Collect"):
		if inventory.slots:
			area.Collect(inventory)

func _unhandled_input(event):
	if event.is_action_pressed("aim"):
		prints("Aim pressed")
		is_aiming = true
	elif event.is_action_released("aim") and is_aiming:
		prints("Aim released, throwing rock")
		throw_rock()
		is_aiming = false
		throw_power = min_throw_power

func throw_rock():
	prints("Trying to throw rock...")
	if inventory.has_item("rock"):
		prints("Rock found in inventory")
		var rock = ProjectileRock.instantiate()
		get_parent().add_child(rock)
		
		var mouse_pos = get_global_mouse_position()
		prints("Mouse position:", mouse_pos)
		prints("Player position:", global_position)
		var direction = (mouse_pos - global_position).normalized()
		
		prints("Throwing rock with power: ", throw_power)
		rock.initial_velocity = throw_power
		rock.launch(direction, global_position)
		inventory.remove_item("rock")
	else:
		prints("No rock in inventory")
