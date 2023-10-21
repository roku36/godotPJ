extends Node2D

@onready var test_label_2: Label = $"HUD/TestLabel2"
@onready var hud: CanvasLayer = $"HUD"
@onready var player: CharacterBody2D = $Player
@onready var time_label: Label = $TimeLabel
@onready var titles: Node2D = $Titles
@onready var scores: RichTextLabel = $Titles/Scores
@onready var camera: Camera2D = $Camera2D
@onready var level_selector: Node = $LevelSelector

var paused = false
var raptime:float = 0.0
var nearest_offset:float = 0.0

signal goal_reached
signal new_record

# Called when the node enters the scene tree for the first time.
func _ready():
	# add level1.tscn scene as "road"
	pass

func _draw() -> void:
	# draw_circle(player.nearest_point, 50, Color.RED)
	draw_circle(camera.target_point, 50, Color.BLUE)
	draw_circle(level_selector.path_follow_player.position, 50, Color.GREEN)
	# pass
	# draw forward_point by circle


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
	# test_label_2.text = "\n" + str(Global.best_rap_time[0]) + "\n" + str(Global.best_rap_time[1]) + "\n" + str(Global.best_rap_time[2]) + "\n" + str(Global.best_rap_time[3])
	# show Global.state with text
	scores.text = str(Global.best_rap_time[Global.current_stage])
	if Input.is_action_just_pressed("restart"):
		pass
	if Input.is_action_just_pressed("pause"):
		hud.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.state = Global.TITLE
		titles.visible = true
	if Global.state == Global.READY and Input.is_action_just_pressed("start"):
		hud.visible = true
		player.mousex_delta = 0.0
		$"HUD/CircleBar".material.set_shader_parameter("fill_ratio", 0.0)
		Global.state = Global.STARTED
	if Global.state == Global.TITLE and Input.is_action_just_pressed("start"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Global.state = Global.READY
		# animation_player.play("titleToMain")
		titles.visible = false
		# unpause player
	
	# update time
	raptime += delta
	time_label.text = "%04.2f" % raptime
	# Goal detection
	if player.nearest_offset <= 200 and raptime > 1 :
		var bestRaptime = Global.best_rap_time[Global.current_stage]
		bestRaptime.append(raptime)
		bestRaptime.sort()
		while bestRaptime.size() > 5:
			bestRaptime.pop_back()
			new_record.emit()
		Global.best_rap_time[Global.current_stage] = bestRaptime
		raptime = 0
		goal_reached.emit()
