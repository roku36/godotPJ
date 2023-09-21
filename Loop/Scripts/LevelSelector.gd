@tool
extends Node


@export_range(0, 1) var stage_num: int = 0:
	set (value):
		stage_num = set_stage_num(value)
	get:
		return stage_num

var levels = []

signal change_stage(stage_num)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(2):
		levels.append(get_parent().get_node("Level" + str(i)))
	print(levels)
	set_stage_num(stage_num)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("previous_level"):
		stage_num -= 1
	if Input.is_action_just_pressed("next_level"):
		stage_num += 1

func set_stage_num(value: int) -> int:
	# range of stage_num, make invisible if value!=i of node Leveli
	for i in range(2):
		if i == value:
			levels[i].visible = true
		else:
			levels[i].visible = false 
	change_stage.emit(value)
	return value 
