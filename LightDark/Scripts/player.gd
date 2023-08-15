# @tool
extends CharacterBody2D

# @onready var subViewport = $"../SubViewportContainer/SubViewport"
@onready var subViewport = $"../.."
var image: Image
var spd: float = 50

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()

	# move toward cursor position on screen in constant spd with normalization if left click
	# use move_and_slide
	velocity = Vector2.ZERO
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var direction = (mouse_pos - self.position).normalized()
		velocity = direction * spd
		

	var texture :ViewportTexture = subViewport.get_texture()
	image = texture.get_image()
	var color = image.get_pixelv(self.position)
	
	# reset modulation
	self.modulate = Color(1, 1, 1)
	# print(color)
	
	if color.r > 0.7:
		self.modulate = Color(1, 0, 0)
	
	if color.r < 0.3:
		self.modulate = Color(0, 1, 0)

	move_and_slide()

