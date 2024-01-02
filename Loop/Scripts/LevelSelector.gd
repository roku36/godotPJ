# @tool
extends Node
@onready var road_path: Path2D
@onready var path_follow_player: PathFollow2D
@onready var scores: RichTextLabel = %Scores
@onready var background: Node2D = $"../Background"
@onready var arrow_left: ColorRect = $"../Titles/HBoxContainer/arrowLeft"
@onready var arrow_right: ColorRect = $"../Titles/HBoxContainer/arrowRight"
@onready var ghost: Node2D = %Ghost
@onready var world_env: WorldEnvironment = $"../WorldEnvironment"
@onready var target_time_label: RichTextLabel = %TargetTimeLabel

var level_width: float = 0.0
var level_width_curve: Curve
#
@export_range(0, Global.STAGE_NUM -1) var stage_num: int:
	set (value):
		stage_num = set_stage_num(value)
	get:
		return stage_num

var levels: Array[Node2D] = []

# signal change_stage(stage_num)

func _ready() -> void:
	for i in range(4):
		levels.append(get_parent().get_node("levels/Level" + str(i)))
	set_stage_num(stage_num)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		if Input.is_action_just_pressed("previous_level"):
			stage_num -= 1
		if Input.is_action_just_pressed("next_level"):
			stage_num += 1

func set_stage_num(value: int) -> int:
	# range of stage_num, make invisible if value!=i of node Level
	if value < 0 or value >= Global.STAGE_NUM:
		return stage_num
	for i in range(4):
		if i == value:
			levels[i].visible = true
		else:
			levels[i].visible = false 

	# show/hide arrows
	if value == 0:
		arrow_left.modulate = Color.TRANSPARENT
	else:
		arrow_left.modulate = Color.WHITE
	if value == Global.STAGE_NUM - 1:
		arrow_right.modulate = Color.TRANSPARENT
	else:
		arrow_right.modulate = Color.WHITE

	self.level_width = levels[value].get_node("Line2D").width
	self.level_width_curve = levels[value].get_node("Line2D").width_curve

	# change_stage.emit(value)
	Global.current_stage = value
	ghost.reset_replay_data()
	if Global.state == Global.STARTED:
		Global.state = Global.READY
	# background.col_transition(value)
	world_env.change_env_gradient(value)
	road_path = levels[value]
	# add pathfollow2d 
	path_follow_player = PathFollow2D.new()
	path_follow_player.loop = false
	path_follow_player.name = "PathFollowPlayer"
	road_path.add_child(path_follow_player)
	update_scoreboard()
	return value 

func update_scoreboard() -> void:
	scores.clear()
	# append top 5 scores
	# e.g. "1st score: 30.00"
	scores.append_text("[b]Stage: %d[/b]\n" % Global.current_stage)
	for i in range(Global.best_rap_time[Global.current_stage].size()):
		scores.append_text("%d st score: %f\n" % [i, Global.best_rap_time[Global.current_stage][i]])
	
	# show target times
	# in Global.target_times
	# var target_times: Array[Dictionary] = [
	# 	{"gold": 10.0, "silver": 15.0, "bronze": 20.0},
	# 	{"gold": 11.0, "silver": 16.0, "bronze": 21.0},
	# 	{"gold": 12.0, "silver": 17.0, "bronze": 22.0},
	# 	{"gold": 13.0, "silver": 18.0, "bronze": 23.0},
	# ]

	target_time_label.text = ""
	for key: String in Global.target_times[Global.current_stage].keys():
		target_time_label.text += "[img=16]res://Textures/%s.svg[/img] %f\n" % [key, Global.target_times[Global.current_stage][key]]
