# @tool
extends CharacterBody2D

# @onready var subViewport = $"../SubViewportContainer/SubViewport"
@onready var subViewport = $"../.."
var image: Image
var spd: float = 100
var health: int = 100

func _ready() -> void:
	generate_image()

func _process(delta: float) -> void:

	# generate image if input up
	if Input.is_action_just_pressed("ui_up"):
		generate_image()

	var mouse_pos = get_global_mouse_position()
	# clip health from 0 to 100
	health = clamp(health, 0, 100)

	# move toward cursor position on screen in constant spd with normalization if left click
	# use move_and_slide
	velocity = Vector2.ZERO
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var direction = (mouse_pos - self.position).normalized()
		velocity = direction * spd

	move_and_slide()

	health = 100

	print(get_intensity())

	if get_intensity() < 0.3:
		health = 0

func get_intensity() -> float:
	var color = image.get_pixelv(self.position)
	return color.r

	# # reset modulation
	# self.modulate = Color(1, 1, 1)
	# # print(color)
	#
	# if color.r > 0.7:
	# 	self.modulate = Color(1, 0, 0)
	#
	# if color.r < 0.3:
	# 	self.modulate = Color(0, 1, 0)
	

func generate_image() -> void:
	var texture :ViewportTexture = subViewport.get_texture()
	image = texture.get_image()
