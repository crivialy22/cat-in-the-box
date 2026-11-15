
extends CharacterBody2D


@onready var animated_sprite = $AnimatedSprite2D
@export var ghost_scene: PackedScene
@export var spawn_point: Marker2D
@export var gravity: float = 980.0
@export var fall_multiplier: float = 1.5

const SPEED = 600.0
const JUMP_VELOCITY = -520.0
const MAX_RECORDS = 60
const RECORD_INTERVAL = 0.05

var active_ghosts: Array[Node2D] = []
var record_timer = 0.0
var position_history: Array[Vector2] = []


func _physics_process(delta):

	# Add gravity.
	if velocity.y < 0:
		velocity.y += gravity * delta
	else:
		velocity.y += gravity * fall_multiplier * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input direction.
	var direction := Input.get_axis("ui_left", "ui_right")

	# Flip sprite.
	if direction > 0:
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.flip_h = false

	# Movement.
	if direction != 0:
		velocity.x = direction * SPEED
		animated_sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("idle")

	move_and_slide()

	# Record player position.
	record_timer += delta

	if record_timer >= RECORD_INTERVAL:
		record_timer -= RECORD_INTERVAL

		position_history.append(global_position)

		if position_history.size() > MAX_RECORDS:
			position_history.pop_front()
			
	if Input.is_action_just_pressed("ui_accept"):
		print("Player: ", global_position)
		print("Camera: ", $Camera2D.global_position)

func die():
	var death_recording = position_history.duplicate()
	
	death_recording.append(global_position)
	print("Recorded player position: ", global_position)
	spawn_ghost(death_recording)
	
	global_position = spawn_point.global_position
	print("Player respawn position: ", global_position)
	print("Camera position: ", $Camera2D.global_position)
	velocity = Vector2.ZERO
	position_history.clear()


func _on_hazard_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.call_deferred("die")

func spawn_ghost(recorded_positions: Array[Vector2]):
	print("Ghost playback received: ", recorded_positions.size(), " positions")
	if ghost_scene == null or recorded_positions.is_empty():
		return
	
	print ("Player death position:", global_position)
	
	var ghost = ghost_scene.instantiate()
	get_tree().current_scene.add_child(ghost)
	
	ghost.call("start_playback", recorded_positions)
	
	print ("Level: ", get_tree().current_scene)
	print("First recorded position: ", recorded_positions[0])
	print ("Ghost position: ", ghost.global_position)
	
	
	
	active_ghosts.append(ghost)
	if active_ghosts.size() > 3:
		var oldest_ghost = active_ghosts.pop_front()
		oldest_ghost.queue_free()
	
func clear_ghosts() -> void:
	for ghost in active_ghosts:
		ghost.queue_free()
		
	active_ghosts.clear()
	
	
