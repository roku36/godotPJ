@tool
extends Area2D

@onready var road_path: Path2D = $"../Path2D"

@export var segment_num: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# access segment_num th point position
	var point_position: Vector2 = road_path.curve.get_point_position(segment_num)
	var point_out_angle: Vector2 = road_path.curve.get_point_out(segment_num)
	# move to the point position
	self.position = point_position
	self.rotation = point_out_angle.angle()

