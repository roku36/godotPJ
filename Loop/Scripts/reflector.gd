@tool
extends Node2D

@onready var road_path: Path2D = $".."

@export_range(0, 100) var segment_num: int = 5:
	set (value):
		segment_num = set_segment_num(value)
	get:
		return segment_num

var point_out_angle: float = 0.0

func _ready() -> void:
	pass


func set_segment_num(value: int) -> int:
	# if road_path is invalid (returns null), return 0 
	if road_path == null:
		return 0
	
	# if value larger than points
	if value >= road_path.curve.get_point_count():
		value = 0
		print("out of range")
	
	# access segment_num th point position
	var point_position: Vector2 = road_path.curve.get_point_position(value)
	var point_out_vec: Vector2 = road_path.curve.get_point_out(value)
	# move to the point position
	self.position = point_position
	point_out_angle = point_out_vec.angle()
	self.rotation = point_out_angle
	
	return value
