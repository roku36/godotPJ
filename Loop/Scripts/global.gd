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

var best_replay_data: Array = []
var best_lap_time: Array = []
var achievements: Array = ["none", "none", "none", "none"]


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

	load_data()

# enum to set stage: title, ready, started
enum {TITLE, READY, STARTED, RESULT}
var state: int = TITLE

func save_data() -> void:
	var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(best_replay_data, true)
	file.store_var(best_lap_time, true)
	file.store_var(achievements, true)

func load_data() -> void:
	var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	if FileAccess.file_exists(save_path):
		best_replay_data = file.get_var(true) as Array[Dictionary]
		best_lap_time = file.get_var(true) as Array[Array]
		achievements = file.get_var(true) as Array[String]
