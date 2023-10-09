@tool
extends Node2D

@onready var road_path: Path2D = $".."

var point_out_angle: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if road_path != null:
		# access segment_num th point position
		var point_position: Vector2 = road_path.curve.get_point_position(0)
		var point_out_vec: Vector2 = road_path.curve.get_point_out(0)
		# move to the point position
		self.position = point_position
		point_out_angle = point_out_vec.angle()
