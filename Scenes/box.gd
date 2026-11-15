extends Area2D
signal box_activated

@export var activated_texture: Texture2D
	
var activated = false

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not activated:
		activated = true
		$Sprite2D.texture = activated_texture
		box_activated.emit()
