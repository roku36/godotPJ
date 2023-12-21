extends Node2D
@onready var player: CharacterBody2D = $"../Player"

var replay_data: Dictionary = {
	"time": [],
	"position": [],
	"rotation": [],
}

var current_time: float = 0.0
var current_index: int = 0
var playback_started: bool = false

const SAVE_INTERVAL = 0.1 # save every 0.1 seconds
var time_since_last_save: float = 0.0

func _ready() -> void:
	pass

func set_replay_data(data: Dictionary) -> void:
	replay_data = data

func _physics_process(delta: float) -> void:
	if playback_started:
		modulate = Color.RED
	else:
		modulate = Color.WHITE
	current_time += delta
	# Add to the time since the last save
	time_since_last_save += delta
	# If it's been long enough since the last save, save the data
	if time_since_last_save >= SAVE_INTERVAL:
		time_since_last_save = 0.0
		record_data()
	
	if playback_started:
		play_recorded_data()


func record_data() -> void:
	replay_data["time"].append(current_time)
	replay_data["position"].append(player.position)
	replay_data["rotation"].append(player.rotation)


func play_recorded_data() -> void:
	# If we've reached the end of the replay data, stop
	var best_replay_data: Dictionary = Global.best_replay_data[Global.current_stage]
	if current_index >= len(best_replay_data["position"]) - 1:
		return
		# If the current time is greater than the next timestamp in the replay data,
		# move to the next index
	if current_time >= best_replay_data["time"][current_index]:
		current_index += 1
	# Calculate the ratio between the current time and the next timestamp
	var t: float = (current_time - best_replay_data["time"][current_index-1]) / (best_replay_data["time"][current_index] - best_replay_data["time"][current_index-1])
	# Use linear interpolation for the position and rotation
	self.position = lerp(best_replay_data["position"][current_index-1], best_replay_data["position"][current_index], t)
	self.rotation = lerp_angle(best_replay_data["rotation"][current_index-1], best_replay_data["rotation"][current_index], t)
	# show time, position, rotation of current_index to label
	# test_label_2.text = str(current_index) + "\n" + str(best_replay_data["time"][current_index]) + "\n" + str(best_replay_data["position"][current_index])
	# show bestraptime of each stages in row: for loop 0~3, Global.best_rap_time[0..3]


func _on_goal_reached() -> void:
	playback_started = false

func reset_replay_data() -> void:
	replay_data = {
		"time": [],
		"position": [],
		"rotation": [],
	}
func _on_new_record() -> void:
	# show label the len of best_replay_data and \n replay_data
	Global.best_replay_data[Global.current_stage] = replay_data.duplicate()
	# test_label_2.text = str(len(best_replay_data["time"])) + "\n" + str(len(replay_data["time"]))


func _on_main_rap_started() -> void:
	current_time = 0
	current_index = 0
	if not Global.best_rap_time[Global.current_stage].is_empty():
		playback_started = true
	# initialize replay_data
	reset_replay_data()

