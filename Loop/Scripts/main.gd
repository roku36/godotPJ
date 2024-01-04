extends Node2D

@onready var test_label_2: Label = $"HUD/TestLabel2"
@onready var hud: CanvasLayer = $"HUD"
@onready var player: CharacterBody2D = %Player
@onready var titles: Node2D = $Titles
@onready var scores: RichTextLabel = %Scores
@onready var level_selector: Node = $LevelSelector
@onready var state_label: Label = %StateLabel
@onready var rap_time_label: Label = %RapTimeLabel
@onready var affine_camera: Camera2D = %AffineCamera
@onready var result_display: Control = %ResultDisplay


const GOAL_PARTICLE = preload("res://Entities/goal_particle.tscn")

var paused:bool = false
var raptime:float = 0.0
var nearest_offset:float = 0.0

signal goal_reached
signal new_record
signal rap_started

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# add level1.tscn scene as "road"
	pass

func _draw() -> void:
	pass
	# draw_circle(affine_camera.target_point, 50, Color.RED)
	# draw_circle(level_selector.path_follow_player.position, 50, Color.GREEN)
	# draw_line(player.position, player.position + player.velocity * 1.0, Color.RED, 10.0, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	state_label.text = str(Global.state)
	# if Input.is_action_just_pressed("restart"):
		# restart()
	if Global.state == Global.RESULT:
		pass
	if Input.is_action_just_pressed("pause"):
		hud.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.state = Global.TITLE
		titles.visible = true
	if Global.state == Global.READY and Input.is_action_just_pressed("start"):
		init_state()
		Global.state = Global.STARTED
		rap_started.emit()
	if Global.state == Global.TITLE and Input.is_action_just_pressed("start"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Global.state = Global.READY
		# animation_player.play("titleToMain")
		titles.visible = false
		# unpause player
	
	# update time
	if Global.state == Global.STARTED:
		raptime += delta
	rap_time_label.text = "%04.2f" % raptime
	# Goal detection
	if level_selector.path_follow_player.progress_ratio == 1.0:
		goal_reached.emit()

func init_state() -> void:
	hud.visible = true
	player.mousex_delta = 0.0
	player.velocity = Vector2.ZERO
	$"HUD/CircleBar".material.set_shader_parameter("fill_ratio", 0.0)
	level_selector.path_follow_player.progress = 0

func result_countdown() -> void:
	result_display.visible = true
	result_display.display_number = raptime
	init_state()
	Global.state = Global.RESULT
	# countdown 3 seconds and then start
	await get_tree().create_timer(3.0).timeout
	raptime = 0
	result_display.visible = false
	Global.state = Global.READY


func _on_goal_reached() -> void:
	var goal_fx: GPUParticles2D = GOAL_PARTICLE.instantiate()
	goal_fx.global_position = player.global_position
	add_child(goal_fx)

	# if raptime is better than target time, print the prize
	var prize: String = "none"
	for medal: String in ["gold", "silver", "bronze"]:
		if raptime < Global.target_times[Global.current_stage][medal]:
			prize = medal
			break

	print("Prize: " + str(prize))

	var bestRaptime: Array[float] = Global.best_rap_time[Global.current_stage]
	bestRaptime.append(raptime)
	bestRaptime.sort()
	if bestRaptime[0] == raptime:
		new_record.emit()
	while bestRaptime.size() > Global.REC_CAPACITY:
		bestRaptime.pop_back()
	level_selector.update_scoreboard()
	Global.best_rap_time[Global.current_stage] = bestRaptime
	result_countdown()

