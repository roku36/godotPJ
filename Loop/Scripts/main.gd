extends Node2D

@onready var test_label_2: Label = $"HUD/TestLabel2"
@onready var hud: CanvasLayer = $"HUD"
@onready var player: CharacterBody2D = %Player
@onready var titles: Node2D = $Titles
@onready var canvas_labels: CanvasLayer = %CanvasLabels
@onready var scores: RichTextLabel = %"CanvasLabels".get_node("%Scores")
@onready var level_selector: Node = $LevelSelector
@onready var state_label: Label = %"CanvasLabels".get_node("%StateLabel")
@onready var lap_time_label: Label = %"CanvasLabels".get_node("%LapTimeLabel")
@onready var affine_camera: Camera2D = %AffineCamera
@onready var result_display: Control = %ResultDisplay
@onready var se_reset: AudioStreamPlayer = $SE_reset


const GOAL_PARTICLE = preload("res://Entities/goal_particle.tscn")

var paused:bool = false
var laptime:float = 0.0
var nearest_offset:float = 0.0

signal goal_reached
signal new_record
signal lap_started
signal escape_game
signal restart_game
signal enter_exit_title(is_enter: bool)

func _ready() -> void:
	pass

func _draw() -> void:
	pass
	# draw_circle(affine_camera.target_point, 50, Color.RED)
	# draw_circle(level_selector.path_follow_player.position, 50, Color.GREEN)
	# draw_line(player.position, player.position + player.velocity * 1.0, Color.RED, 10.0, false)

func _process(delta: float) -> void:
	queue_redraw()
	state_label.text = str(Global.state)
	if Global.state == Global.RESULT:
		pass
	if Input.is_action_just_pressed("pause"):
		escape_game.emit()
	if Input.is_action_just_pressed("start"):
		match Global.state:
			Global.READY:
				init_state()
				Global.state = Global.STARTED
				lap_started.emit()
			Global.STARTED:
				restart_game.emit()
			Global.TITLE:
				enter_exit_title.emit(false)
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				Global.state = Global.READY
	
	# update laptime
	if Global.state == Global.STARTED:
		laptime += delta
	lap_time_label.text = "%04.2f" % laptime
	# Goal detection
	if level_selector.path_follow_player.progress_ratio == 1.0:
		goal_reached.emit()

func init_state() -> void:
	laptime = 0
	hud.visible = true
	player.mousex_delta = 0.0
	player.velocity = Vector2.ZERO
	$"HUD/CircleBar".material.set_shader_parameter("fill_ratio", 0.0)
	level_selector.path_follow_player.progress = 0

func result_countdown(is_new_record: bool, is_near: bool) -> void:
	# result_display.position = player.global_position
	result_display.visible = true
	result_display.display_number = laptime
	init_state()
	hud.visible = false
	Global.state = Global.RESULT
	# countdown 3 seconds and then start
	await result_display.roll_result(is_new_record, is_near)
	laptime = 0
	if Global.auto_start:
		init_state()
		Global.state = Global.STARTED
		lap_started.emit()
	else:
		Global.state = Global.READY


func _on_goal_reached() -> void:
	hud.visible = false
	var goal_fx: GPUParticles2D = GOAL_PARTICLE.instantiate()
	goal_fx.global_position = player.global_position
	add_child(goal_fx)

	# if laptime is better than target time, print the prize
	var prize: String = "none"
	for medal: String in ["gold", "silver", "bronze"]:
		if laptime < Global.target_times[Global.current_stage][medal]:
			prize = medal
			break

	var got_medal: bool = false
	# if prize is better than Global.achievements_unlocked[Global.current_stage]
	var tmp_prize: Array[String] = ["none", "bronze", "silver", "gold"]
	if tmp_prize.find(prize) > tmp_prize.find(Global.achievements[Global.current_stage]):
		Global.achievements[Global.current_stage] = prize
		got_medal = true

	var bestlaptime: Array = Global.best_lap_time[Global.current_stage]
	# print(laptime)
	bestlaptime.append(laptime)
	bestlaptime.sort()
	if bestlaptime[0] == laptime:
		new_record.emit()
	while bestlaptime.size() > Global.REC_CAPACITY:
		bestlaptime.pop_back()
	canvas_labels.update_scoreboard()
	Global.best_lap_time[Global.current_stage] = bestlaptime
	Global.save_data()
	await result_countdown(bestlaptime[0] == laptime, laptime - bestlaptime[0] < Global.nearest_offset)

	if got_medal:
		canvas_labels.anim_medal(prize)


func _on_reset_button_long_pressed() -> void:
	se_reset.play()
	Global.reset_data()
	canvas_labels.update_labels()


func _on_escape_game() -> void:
	result_display.visible = false
	hud.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.state = Global.TITLE
	enter_exit_title.emit(true)
	level_selector.path_follow_player.progress = 0


func _on_level_selector_stage_changed() -> void:
	if not is_node_ready():
		await ready
	match Global.state:
		Global.STARTED:
			init_state()


func _on_lap_started() -> void:
	result_display.visible = false


func _on_enter_exit_title(is_enter: bool) -> void:
	if is_enter:
		titles.visible = true
	else:
		titles.visible = false
