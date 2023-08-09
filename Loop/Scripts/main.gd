@tool
extends Node2D

@onready var road_path: Path2D = $Path2D
@onready var road_line: Line2D = $Line2D
@onready var player: CharacterBody2D = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		update_road_line()
	else:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
	
	queue_redraw()
		

func update_road_line():
	road_line.clear_points()
	var points = road_path.curve.get_baked_points()
	
	for point in points:
		var global_point = road_path.to_global(Vector2(point.x, point.y))
		var local_point = road_line.to_local(global_point)
		road_line.add_point(local_point)
