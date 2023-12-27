extends Node2D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func play():
	audio_player.play()

func _on_audio_stream_player_finished():
	queue_free()
