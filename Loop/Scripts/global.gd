extends Node

var save_path: String = "user://globals.save"
# const stage num

const STAGE_NUM = 4
const REC_CAPACITY = 10
var current_stage: int = 0

var target_times: Array[Dictionary] = [
{"gold": 10.0, "silver": 15.0, "bronze": 20.0},
{"gold": 11.0, "silver": 16.0, "bronze": 21.0},
{"gold": 12.0, "silver": 17.0, "bronze": 22.0},
{"gold": 13.0, "silver": 18.0, "bronze": 23.0},
]

var best_replay_data: Array[Dictionary] = []
var best_lap_time: Array[Array] = []
var achievements: Array[String] = ["none", "none", "none", "none"]


func _ready() -> void:
	for i in range(STAGE_NUM):
		best_replay_data.append({
				"time": [],
				"position": [],
				"rotation": [],
				})

# best_lap_time[i].fill(-1)
	var top_scores: Array[float] = []
# for j in range(REC_CAPACITY):
# 	top_scores.append(-1)
	best_lap_time.append(top_scores)

	# load_data()

# enum to set stage: title, ready, started
enum {TITLE, READY, STARTED, RESULT}
var state: int = TITLE

# func save_data() -> void:
# 	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
# 	var data: Dictionary = {
# 		"best_replay_data": best_replay_data,
# 		"best_lap_time": best_lap_time,
# 		"achievements": achievements
# 	}
# 	var json_data: JSON = JSON.
# 	file.store_string(json_data)
# 	file.close()
#
# func load_data():
# 	var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
# 	if file.file_exists(save_path):
# 		if file.open(save_path, File.READ):
# 			var json_data = file.get_as_text()
# 			var data = parse_json(json_data)
# 			if typeof(data) == TYPE_DICTIONARY:
# 				best_replay_data = data["best_replay_data"]
# 				best_lap_time = data["best_lap_time"]
# 				achievements = data["achievements"]
# 				file.close()
# 			else:
# 				print("Could not read the save file.")
