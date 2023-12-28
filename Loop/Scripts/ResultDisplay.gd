@tool
extends Control
@onready var digits: Array[Node] = $HBoxContainer.get_children()
@export var display_number: int = 1234

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# apply display_number for each digits
	# to shaderparameter digit_num
	var tmp_display_number: int = display_number
	for digit in digits:
		digit.material.set_shader_parameter("Number", tmp_display_number % 10)
		tmp_display_number /= 10
	# digits[3].material.set_shader_parameter("Number", tmp_display_number % 10)
