extends Node2D

@onready var subViewport = $"../SubViewportContainer/SubViewport"

var image: Image

func _ready() -> void:
	var texture :ViewportTexture = subViewport.get_texture()
	print(texture)
	image = texture.get_image()
	print(image)

func _process(delta: float) -> void:
	# var color = image.get_pixelv(self.position)
	# print("color!!")
	# var color = image.get_pixelv(Vector2(100, 100))
	# print(color)
	print(image)
