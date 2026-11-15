extends AnimatableBody2D

const RECORD_INTERVAL = 0.05

var playback_positions: Array[Vector2] = []
var playback_index = 0
var playback_timer = 0.0

func start_playback(positions: Array[Vector2]):
	playback_positions = positions.duplicate()
	playback_positions.reverse()
	if playback_positions.is_empty():
		return
	global_position = playback_positions[0]
	playback_index = 1
func _physics_process(delta):

	if playback_index >= playback_positions.size():
		return

	playback_timer += delta

	if playback_timer >= RECORD_INTERVAL:
		playback_timer -= RECORD_INTERVAL

		global_position = playback_positions[playback_index]
		print("ghost starting at ", global_position)
		print("Ghost sprite: ", global_position)
	
		playback_index += 1
	if playback_index >= playback_positions.size():
		print("Ghost final position: ", global_position)
