extends Node2D

@onready var test_label_2: Label = $"HUD/TestLabel2"
@onready var player: CharacterBody2D = $Player
@onready var time_label: Label = $TimeLabel
@onready var pause_menu: Control = $HUD/PauseMenu
@onready var titles: Node2D = $Titles

var paused = false
var raptime:float = 0.0
var nearest_offset:float = 0.0

signal goal_reached
signal new_record

# Called when the node enters the scene tree for the first time.
func _ready():
	# add level1.tscn scene as "road"
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# test_label_2.text = "\n" + str(Global.best_rap_time[0]) + "\n" + str(Global.best_rap_time[1]) + "\n" + str(Global.best_rap_time[2]) + "\n" + str(Global.best_rap_time[3])
	# show Global.state with text
	test_label_2.text = str(Global.state)
	if Input.is_action_just_pressed("restart"):
		Global.state = Global.TITLE
	if Input.is_action_just_pressed("pause"):
		Global.state = Global.TITLE
	if Global.state == Global.READY and Input.is_action_just_pressed("start"):
		Global.state = Global.STARTED
	if Global.state == Global.TITLE and Input.is_action_just_pressed("start"):
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
		if bestRaptime == -1 or raptime < bestRaptime:
			Global.best_rap_time[Global.current_stage] = raptime
			new_record.emit()
		raptime = 0
		goal_reached.emit()


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
