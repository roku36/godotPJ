@tool
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var road_path: Path2D = $Path2D
@onready var road_line: Line2D = $Line2D
@onready var player: CharacterBody2D = $Player
@onready var time_label: Label = $TimeLabel
@onready var pause_menu: Control = $HUD/PauseMenu
var paused = false

var raptime:float = 0.0
var bestRaptime:float = 1000
var nearest_offset:float = 0.0

signal goal_reached
signal new_record

# Called when the node enters the scene tree for the first time.
func _ready():
	update_road_line()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Engine.is_editor_hint():
		update_road_line()
	else:
		if Input.is_action_just_pressed("animation"):
			animation_player.play("default")
		
		if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
		if Input.is_action_just_pressed("pause"):
			pop_pause_menu()
		
		# update time
		raptime += delta
		time_label.text = "%04.2f" % raptime
		if player.nearest_offset <= 200 and raptime > 1 :
			if raptime < bestRaptime:
				bestRaptime = raptime
				new_record.emit()
			raptime = 0
			goal_reached.emit()
			
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

func pop_pause_menu() -> void:
	if not paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Engine.time_scale = 0
		pause_menu.show()
		paused = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Engine.time_scale = 1
		pause_menu.hide()
		paused = false
