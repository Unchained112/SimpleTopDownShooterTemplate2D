extends Node2D


@onready var bleeding_effect: GPUParticles2D = $BleedingEffect

func setup(trans: Transform2D):
	bleeding_effect.emitting = true
	transform = trans

func _on_bleeding_effect_finished():
	queue_free()
