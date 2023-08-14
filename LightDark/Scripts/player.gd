# @tool
extends Node2D

@onready var subViewport = $"../SubViewportContainer/SubViewport"

var image: Image
var spd: float = 0.5

func _process(delta: float) -> void:
	# move left/right/up/down by keyboard input
	if Input.is_action_pressed("ui_left"):
		self.position.x -= spd
	if Input.is_action_pressed("ui_right"):
		self.position.x += spd
	if Input.is_action_pressed("ui_up"):
		self.position.y -= spd
	if Input.is_action_pressed("ui_down"):
		self.position.y += spd


	var texture :ViewportTexture = subViewport.get_texture()
	image = texture.get_image()
	var color = image.get_pixelv(self.position)
	
	# reset modulation
	self.modulate = Color(1, 1, 1)
	
	if color.r > 0.7:
		self.modulate = Color(1, 0, 0)
	
	if color.r < 0.4:
		self.modulate = Color(0, 1, 0)

