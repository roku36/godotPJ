@tool
extends Node2D

@onready var road_path: Path2D = $Path2D
@onready var road_line: Line2D = $Line2D
@onready var player: CharacterBody2D = $Player

signal rap_goal(raptime)

var raptime:float = 0.0
var bestRaptime:float = 1000
var nearest_offset:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	update_road_line()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		update_road_line()
	else:
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().reload_current_scene()
			
	nearest_offset = road_path.curve.get_closest_offset(player.position)
	queue_redraw()


func _draw() -> void:
	var nearest_point = road_path.curve.sample_baked(nearest_offset)
	var forward_point = road_path.curve.sample_baked(nearest_offset+30)
	draw_circle(nearest_point, 20, Color.RED)
	draw_circle(forward_point, 30, Color.BLUE)

func update_road_line():
	road_line.clear_points()
	var points = road_path.curve.get_baked_points()
	
	for point in points:
		var global_point = road_path.to_global(Vector2(point.x, point.y))
		var local_point = road_line.to_local(global_point)
		road_line.add_point(local_point)
