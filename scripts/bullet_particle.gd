extends Node2D

@onready var bullet_effect: GPUParticles2D = $BulletEffect

func setup(trans: Transform2D):
	bullet_effect.emitting = true
	transform = trans
	scale.x = -1

func _on_bullet_effect_finished():
	queue_free()
