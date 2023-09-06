@tool
extends Area2D

@onready var road_path: Path2D = $"../Path2D"

# bigger than 0
@export_range(0, 100, 1) var segment_num: int = 5:
	set (value):
		segment_num = set_segment_num(value)
	get:
		return segment_num

var point_out_angle: float = 0.0
signal out_dir(angle, pos)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func set_segment_num(value: int) -> int:
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

func _on_body_entered(body: Node2D) -> void:
	out_dir.emit(self.rotation, self.position)
