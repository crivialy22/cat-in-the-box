extends Node2D


@onready var player =  $Player
@onready var spawn_point = $SpawnPoint
@onready var background = $StaticBody2D/background
@export var new_background = Texture2D



func _ready():
		player.global_position = spawn_point.global_position
func _process(delta:float) -> void:
	if Input.is_action_just_pressed("reset_level"):
		get_tree().reload_current_scene()


func _on_box_box_activated() -> void:
	print("BOX SIGNAL RECEIVED")
	background.texture = new_background
	$Player.clear_ghosts()
