extends Node

# const stage num

const STAGE_NUM = 4
var current_stage: int = 0

var best_replay_data = []
var best_rap_time = []

func _ready():
  for i in range(STAGE_NUM):
    best_replay_data.append({
      "time": [],
      "position": [],
      "rotation": [],
    })

    best_rap_time.append(-1.0)

# enum to set stage: title, ready, started
enum {TITLE, READY, STARTED}
var state = TITLE
