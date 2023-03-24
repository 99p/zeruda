extends Node

@onready var player_instance: Resource = load("res://scenes/necro.tscn")
var player

func _ready():
	player_spawn()

func _process(_delta):
	if player:
		$CameraPivot.position = lerp($CameraPivot.position, player.position, 0.4)

func _on_player_dead():
	player.queue_free()
	player_spawn()
	
func player_spawn():
	player = player_instance.instantiate()
	player.dead.connect(_on_player_dead)
	player.position = $StartPos.position
	player.set_name("Player")
	add_child(player)
