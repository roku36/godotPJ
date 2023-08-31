extends Node2D

var full_passthrough:= true



func _ready():
	# COMMENT OUT "set_game_window" to not use the entire monitor(s) area (NOTE 
	set_game_window()
	
	get_viewport().transparent_bg = true
	change_passthrough()


func _input(event):
	if event.is_action_pressed("test"):
		change_passthrough()



func change_passthrough() -> void:
	# Swaps back and forth between full monitor and a small section at top left being passthrough
	full_passthrough = !full_passthrough
	if full_passthrough:
		DisplayServer.window_set_mouse_passthrough( [Vector2(0,0), Vector2(100,0), Vector2(100,100), Vector2(0,100)] )
	else:
		DisplayServer.window_set_mouse_passthrough( [] )



func set_game_window() -> void:
	var rightest_right: float
	var leftest_left:   float
	var downiest_down:  float
	var uppiest_up:     float

	# Itterate over screens to get area of all screens
	for i in DisplayServer.get_screen_count():
		var ss = DisplayServer.screen_get_size( i )
		var screen_pos = DisplayServer.screen_get_position( i )

		# Set edge if screen extends the edge of the clickable area
		if (ss.x + screen_pos.x) > rightest_right: rightest_right = (ss.x + screen_pos.x)
		if (ss.y + screen_pos.y) > downiest_down:  downiest_down  = (ss.y + screen_pos.y)
		if screen_pos.x < leftest_left:            leftest_left   = screen_pos.x
		if screen_pos.y < uppiest_up:              uppiest_up     = screen_pos.y		

	# Minus Vector2.ONE window_set_size because full size will cause a black screen (possibly depricated in GD4?)
	var total_area = Vector2(abs(leftest_left - rightest_right), abs(uppiest_up - downiest_down))
	DisplayServer.window_set_size( total_area + Vector2.ONE )
	DisplayServer.window_set_position( Vector2(leftest_left, uppiest_up) )
