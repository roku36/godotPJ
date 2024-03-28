extends Node

var save_path: String = "user://globals.save"
# const stage num

const STAGE_NUM = 3
const REC_CAPACITY = 10
var current_stage: int = 0

var target_times: Array[Dictionary] = [
{"gold": 9.0, "silver": 12.0, "bronze": 18.0},
{"gold": 22.0, "silver": 25.0, "bronze": 30.0},
{"gold": 25.0, "silver": 28.0, "bronze": 35.0},
{"gold": 13.0, "silver": 18.0, "bronze": 25.0},
]

var best_replay_data: Array
var best_lap_time: Array
var achievements: Array
var auto_start: bool = false

var nearest_offset: float = 0.01
var mouse_sensitivity: float = 1.0


func _ready() -> void:
	# initialize data
	best_replay_data = []
	best_lap_time = []
	achievements = ["none", "none", "none", "none"]
	for i in range(STAGE_NUM):
		best_replay_data.append({
				"time": [],
				"position": [],
				"rotation": [],
				})

		var top_scores: Array[float] = []
		best_lap_time.append(top_scores)

	load_data()

# state enum
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

func reset_data() -> void:
	# delete user save file
	var dir: DirAccess = DirAccess.open("user://")
	dir.remove(save_path)
	_ready()
