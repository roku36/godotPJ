@tool
extends Node2D

@onready var point_light_2d: PointLight2D = $PointLight2D

@export var lightScale : float = 1.0
@export var enerty : int = 10
@export var height : float = 20.0

func _ready() -> void:
	update_params()

# set export variables to child pointlight2d
func update_params() -> void:
	point_light_2d.scale = Vector2(lightScale, lightScale)
	point_light_2d.energy = enerty
	point_light_2d.height = height

# run update_params() when exported values change
func _process(_delta: float) -> void:
	update_params()
