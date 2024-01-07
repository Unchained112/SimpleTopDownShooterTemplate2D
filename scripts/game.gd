extends Node2D

@export var noise_shake_speed: float = 15.0
@export var noise_shake_strength: float = 16.0
@export var shake_decay_rate: float = 20.0
@export var enable_camera_slow_motion: bool = true

var start_pos: Vector2
var enemy_list: Array = []
var noise_i: float = 0.0
var shake_strength: float = 0.0

@onready var camera: Camera2D = $Camera2D
@onready var enemy_class = preload("res://scenes/enemy.tscn")
@onready var player: CharacterBody2D = $Player
@onready var noise = FastNoiseLite.new()
@onready var rand = RandomNumberGenerator.new()
@onready var slow_mo_timer: Timer = $CameraSlowMoTimer

func _ready():
	var screen_size = get_viewport_rect().size
	start_pos = Vector2(screen_size.x/2, screen_size.y/2)
	player.setup(start_pos)
	# Camera shake related
	rand.randomize()
	noise.seed = rand.randi()
	noise.frequency = 0.1

func _process(delta: float):
	if enemy_list.size() == 0:
		var n = randi_range(1, 3)
		for i in range(0, n):
			var enemy = enemy_class.instantiate()
			enemy.connect("enemy_destroyed", _on_enemy_destroyed)
			var pos = Vector2(randf_range(100, 1000), randf_range(150, 500))
			enemy.setup(pos, player)
			get_tree().root.add_child(enemy)
			enemy_list.append(enemy)
	shake_camera(delta)

func shake_camera(delta: float):
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0.0, shake_decay_rate * delta)
	var shake_offset: Vector2
	shake_offset = get_noise_offset(delta, noise_shake_speed, shake_strength)
	# Shake by adjusting camera.offset, move the camera via it's position
	camera.offset = shake_offset

func get_noise_offset(delta: float, speed: float, strength: float) -> Vector2:
	noise_i += delta * speed
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * strength,
		noise.get_noise_2d(100, noise_i) * strength
	)

func get_random_offset() -> Vector2:
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	)

func start_slow_motion(scale: float = 0.5):
	if enable_camera_slow_motion:
		Engine.time_scale = scale
		slow_mo_timer.start()
		AudioServer.playback_speed_scale = scale

func stop_slow_motion():
	Engine.time_scale = 1.0
	AudioServer.playback_speed_scale = 1.0

func _on_enemy_destroyed(enemy):
	start_slow_motion(0.6)
	shake_strength = noise_shake_strength
	enemy_list.erase(enemy)

func _on_camera_slow_mo_timer_timeout():
	stop_slow_motion()
