extends Node3D

@export var player: CharacterBody3D

func _process(_delta):
	if player:
		position = lerp(position, player.position, 0.4)
