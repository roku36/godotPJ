extends Node2D
@onready var bg: ColorRect = $bg

# array of color
@export var colors: Array[Array] = [[Color.RED, Color.ORANGE], [Color.YELLOW, Color.GREEN], [Color.BLUE, Color.PINK]]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(3):
		col_transition(i)
		await get_tree().create_timer(3.0).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# bg.material.set_shader_parameter("fg_color", Color.RED)
	pass # Replace with function body.

func test_transition() -> void:
	# tween from blue to red
	var tween = create_tween()
	tween.tween_property(bg, "material:shader_parameter/bg_color", Color.RED, 3.0)

func col_transition(stage: int) -> void:
	var tween = create_tween()
	tween.tween_property(bg, "material:shader_parameter/fg_color", colors[stage][0], 1.0)
	tween.tween_property(bg, "material:shader_parameter/bg_color", colors[stage][1], 1.0)
