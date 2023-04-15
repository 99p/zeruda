extends Node3D

var left_button: Control
var right_button: Control
var jump_button: Control
var seaman: CharacterBody3D

func _ready():
	left_button = find_child("Left")
	right_button = find_child("Right")
	jump_button = find_child("Jump")
	seaman = find_child("seaman")
	print(jump_button)
