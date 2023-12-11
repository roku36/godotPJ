@tool
extends Path2D
@onready var road_line : Line2D = $Line2D
const goal = preload("res://Scenes/goal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_road_line()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_road_line()

func update_road_line() -> void:
	road_line.clear_points()
	var points: PackedVector2Array = self.curve.get_baked_points()

	for point in points:
		var global_point: Vector2 = self.to_global(Vector2(point.x, point.y))
		var local_point: Vector2 = road_line.to_local(global_point)
		road_line.add_point(local_point)
