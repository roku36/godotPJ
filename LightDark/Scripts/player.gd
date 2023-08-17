# @tool
extends CharacterBody2D

@onready var filter: ColorRect = $"../Filter"
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


func generate_image() -> void:
	filter.visible = false
	await get_tree().process_frame
	var texture :ViewportTexture = subViewport.get_texture()
	filter.visible = true
	image = texture.get_image()
