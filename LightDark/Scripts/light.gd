@tool
extends Node2D

@export var curve : Curve
@export var direction : Vector2 = Vector2.UP
@export var width : float

@onready var point_light = $PointLight2D

func _ready():
	update_light()

func _process(_delta):
	# update light if press accept
	if Input.is_action_just_pressed("ui_accept"):
		print("set light")
		update_light()

func update_light():
	point_light.texture = generate_light_texture()
	point_light.transform = Transform2D().rotated(direction.angle())
	# You may need to adjust the scale of the light depending on your needs
	point_light.scale = Vector2(width, width)

func generate_light_texture():
	# Assuming you have a shader that generates the light texture
	var shader = load("res://Shaders/lightsector.gdshader")
	var shader_material = ShaderMaterial.new()
	shader_material.shader = shader
	shader_material.set_shader_parameter("curve", curve)

	# Create a new Viewport
	var viewport = SubViewport.new()
	viewport.size = Vector2(32, 32)  # Set the size of the viewport
	add_child(viewport)

	# Create a new ColorRect 32*32 and add it to the viewport
	var sprite = ColorRect.new()
	sprite.size = Vector2(32, 32)
	sprite.material = shader_material
	viewport.add_child(sprite)
	
	# Now the sprite is rendered in the viewport, we can get the texture
	var texture = viewport.get_texture()

	return texture
