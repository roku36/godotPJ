extends Node

# const stage num

const STAGE_NUM = 4
const REC_CAPACITY = 10
var current_stage: int = 0

var best_replay_data: Array[Dictionary] = []
var best_rap_time: Array[Array] = []

func _ready() -> void:
	for i in range(STAGE_NUM):
		best_replay_data.append({
		  "time": [],
		  "position": [],
		  "rotation": [],
		})
			
		# best_rap_time[i].fill(-1)
		var top_scores: Array[float] = []
		# for j in range(REC_CAPACITY):
		# 	top_scores.append(-1)
		best_rap_time.append(top_scores)

# enum to set stage: title, ready, started
enum {TITLE, READY, LAUNCH, STARTED}
var state: int = TITLE
