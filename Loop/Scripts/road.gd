@tool
extends Path2D
@onready var road_line : Line2D = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_road_line()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_road_line()

func update_road_line():
	road_line.clear_points()
	var points = self.curve.get_baked_points()

	for point in points:
		var global_point = self.to_global(Vector2(point.x, point.y))
		var local_point = road_line.to_local(global_point)
		road_line.add_point(local_point)
