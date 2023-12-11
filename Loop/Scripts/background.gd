extends Node2D
@onready var bg: ColorRect = $bg

# array of color
@export var colors: Array[Array] = [[Color.RED, Color.ORANGE], [Color.YELLOW, Color.GREEN], [Color.BLUE, Color.PINK]]
@export var trans_spd: float = 0.2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# bg.material.set_shader_parameter("fg_color", colors[0][0])
	# bg.material.set_shader_parameter("bg_color", colors[0][1])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass # Replace with function body.

func test_transition() -> void:
	# tween from blue to red
	var tween: Tween = create_tween()
	tween.tween_property(bg, "material:shader_parameter/bg_color", Color.RED, 3.0)

func col_transition(stage: int) -> void:
	var tween: Tween = create_tween()
	tween.tween_property(bg, "material:shader_parameter/fg_color", colors[stage][0], trans_spd)
	tween.tween_property(bg, "material:shader_parameter/bg_color", colors[stage][1], trans_spd)
