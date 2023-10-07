@tool
extends Node
@onready var road_path: Path2D
@onready var scores: RichTextLabel = $"../Titles/Scores"
@onready var background: Node2D = $"../Background"

@export_range(0, Global.STAGE_NUM -1) var stage_num: int:
	set (value):
		stage_num = set_stage_num(value)
	get:
		return stage_num

var levels = []

# signal change_stage(stage_num)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(4):
		levels.append(get_parent().get_node("Level" + str(i)))
	print(levels)
	set_stage_num(stage_num)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("previous_level"):
			stage_num -= 1
		if Input.is_action_just_pressed("next_level"):
			stage_num += 1

func set_stage_num(value: int) -> int:
	# range of stage_num, make invisible if value!=i of node Leveli
	for i in range(4):
		if i == value:
			levels[i].visible = true
		else:
			levels[i].visible = false 
	# change_stage.emit(value)
	Global.current_stage = value
	background.col_transition(value)
	road_path = levels[value]
	update_scoreboard()
	return value 

func update_scoreboard():
	scores.text = "%d st stage: %f" % [Global.current_stage, Global.best_rap_time[Global.current_stage]]
