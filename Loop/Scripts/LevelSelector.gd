@tool
extends Node

@export_range(0, 1) var stage_num: int = 0:
	set (value):
		stage_num = set_stage_num(value)
	get:
		return stage_num


signal change_stage(stage_num)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_stage_num(value: int) -> int:
	# range of stage_num, make invisible if value!=i of node Leveli
	for i in range(2):
		if i == value:
			get_parent().get_node("Level" + str(i)).visible = true
		else:
			get_parent().get_node("Level" + str(i)).visible = false
	change_stage.emit(value)
	return value 
