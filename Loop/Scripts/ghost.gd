extends Node2D
@onready var test_label_2: Label = $"../CanvasLayer/TestLabel2"

var replay_data = {
	"time": [],
	"position": [],
	"rotation": [],
}

var current_time = 0.0
var current_index = 0
var playback_started = false

func _ready():
	pass

func set_replay_data(data):
	replay_data = data

func start_playback():
	playback_started = true

func _physics_process(delta):
	if not playback_started:
		return

	# show number of replay_data["position"] to label
	test_label_2.text = str(len(replay_data["position"]))
	
	current_time += delta

	# If we've reached the end of the replay data, stop
	if current_index >= len(replay_data["position"]) - 1:
		return

	# If the current time is greater than the next timestamp in the replay data,
	# move to the next index
	if current_time >= replay_data["time"][current_index]:
		current_index += 1

	# Calculate the ratio between the current time and the next timestamp
	var t = (current_time - replay_data["time"][current_index-1]) / (replay_data["time"][current_index] - replay_data["time"][current_index-1])

	# Use linear interpolation for the position and rotation
	# self.position = replay_data["position"][current_index-1].linear_interpolate(replay_data["position"][current_index], t)
	self.position = lerp(replay_data["position"][current_index-1], replay_data["position"][current_index], t)
	self.rotation = lerp(replay_data["rotation"][current_index-1], replay_data["rotation"][current_index], t)

func _input(event):
	if event.is_action_pressed("ghost"):
		start_playback()
