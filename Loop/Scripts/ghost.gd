extends Node2D
@onready var test_label_2: Label = $"../CanvasLayer/TestLabel2"
@onready var player: CharacterBody2D = $"../Player"

var replay_data = {
	"time": [],
	"position": [],
	"rotation": [],
}

var current_time = 0.0
var current_index = 0
var playback_started = false

const SAVE_INTERVAL = 0.1 # save every 0.1 seconds
var time_since_last_save = 0.0

func _ready():
	pass

func set_replay_data(data):
	replay_data = data

func _start_playback():
	current_time = 0
	playback_started = true

func _physics_process(delta):
	if not playback_started:
		# Add to the time since the last save
		current_time += delta
		time_since_last_save += delta
		# If it's been long enough since the last save, save the data
		if time_since_last_save >= SAVE_INTERVAL:
			time_since_last_save = 0.0
			record_data()

	else:
		# show number of replay_data["position"] to label
		# test_label_2.text = str(len(replay_data["position"]))
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
		self.position = lerp(replay_data["position"][current_index-1], replay_data["position"][current_index], t)
		self.rotation = lerp_angle(replay_data["rotation"][current_index-1], replay_data["rotation"][current_index], t)
		# show time, position, rotation of current_index to label
		test_label_2.text = str(current_index) + "\n" + str(replay_data["time"][current_index]) + "\n" + str(replay_data["position"][current_index])

func _input(event):
	if event.is_action_pressed("ghost"):
		_start_playback()

func record_data():
	replay_data["time"].append(current_time)
	replay_data["position"].append(player.position)
	replay_data["rotation"].append(player.rotation)
