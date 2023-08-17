# @tool
extends CharacterBody2D

@onready var filter: ColorRect = $"../Filter"
@onready var subViewport = $"../.."
var image: Image
var spd: float = 10
var health: int = 100
var direction: Vector2
var holding_index: int

func _ready() -> void:
	generate_image()

func _process(delta: float) -> void:
	# generate image if input up
	if Input.is_action_just_pressed("ui_up"):
		generate_image()

	var mouse_pos = get_global_mouse_position()
	direction = (mouse_pos - self.position)
	direction = direction.limit_length(10.0)

	# clip health from 0 to 100
	health = clamp(health, 0, 100)

	# move toward cursor position on screen in constant spd with normalization if left click
	# use move_and_slide
	velocity = Vector2.ZERO
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# velocity = direction * spd
		# instead of constant speed, leap and clam
		velocity = direction * spd
		

	move_and_slide()

	health = 100
	# print(get_intensity())

	if get_intensity() < 0.3:
		health = 0
	
	# if pressing space
	if Input.is_action_pressed("ui_accept"):
		move_light()
	else:
		holding_index = -1

func get_intensity() -> float:
	var color = image.get_pixelv(self.position)
	return color.r


func generate_image() -> void:
	await get_tree().process_frame
	var texture :ViewportTexture = subViewport.get_texture()
	image = texture.get_image()

# detect "Light" instance and move it to self position if near to player
func move_light() -> void:
	var lights = get_tree().get_nodes_in_group("lights")
	# pick closest light from player
	var light = lights[0]
	# if holding_index is not -1
	if holding_index != -1:
		light = lights[holding_index]
	else:
		for l in lights:
			if l.global_position.distance_to(self.global_position) < light.global_position.distance_to(self.global_position):
				light = l
		holding_index = lights.find(light)
	
	if light.global_position.distance_to(self.global_position) < 20:
		light.global_position = lerp(light.global_position, self.global_position, 0.8)
		light.global_rotation = lerp_angle(light.global_rotation, direction.angle(), 0.2)
		
