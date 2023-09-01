extends Node2D
@onready var color_rect: ColorRect = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set window passthrough to true
	# DisplayServer.window_set_mouse_passthrough([])
	DisplayServer.window_set_mouse_passthrough( [Vector2(0,0), Vector2(100,0), Vector2(100,100), Vector2(0,100)] )
	# get_viewport().transparent_bg = true
	get_tree().get_root().set_transparent_background(true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# set color rect shader parameters to current time (Hours, Minutes, Seconds)
	var timeDict = Time.get_time_dict_from_system()
	# print(timeDict["second"])
	color_rect.material.set_shader_parameter("hours", timeDict["hour"])
	color_rect.material.set_shader_parameter("minutes", timeDict["minute"])
	color_rect.material.set_shader_parameter("seconds", timeDict["second"])
