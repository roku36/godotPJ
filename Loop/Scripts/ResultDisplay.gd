@tool
extends Control
@onready var digits: Array[Node] = $HBoxContainer.get_children()
@export var display_number: float = 12.34
@onready var se_record: AudioStreamPlayer = $SE_record
@onready var se_new_record: AudioStreamPlayer = $SE_new_record

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	# roll_result()


# Called every frame. 'delta' is the elapsed time since the previous frame.

# func roll_result() -> void:
# 	var tmp_display_number: int = int(display_number * 100)
# 	for digit in digits:
# 		digit.material.set_shader_parameter("Number", tmp_display_number % 10)
# 		tmp_display_number /= 10

func roll_result(is_new_record: bool, is_near: bool) -> void:
	var digit_number_array: Array[int] = float_to_array(display_number)
	var reveal_interval: int = 5 
	var reveal_length: int = 30

	if is_near:
		reveal_interval = 20
		reveal_length = 100

	# Start rolling all digits
	for i in range(reveal_length, 0, -1):
		await get_tree().create_timer(0.03).timeout
		for d_i in digits.size():
			if i-1 > reveal_interval * d_i:
			# if i - reveal_interval < digit_number_array.size():
				digits[d_i].material.set_shader_parameter("Number", randi() % 10)
			else:
				digits[d_i].material.set_shader_parameter("Number", digit_number_array[d_i])

	if is_new_record:
		se_new_record.play()
	else:
		se_record.play()

	var final_time: float = 0.3
	if is_new_record:
		final_time = 1.0
	await get_tree().create_timer(final_time).timeout


func float_to_array(float_number: float) -> Array[int]:
	var tmp_int_num: int = int(float_number * 100)
	var tmp_array: Array[int] = []
	for i in range(digits.size()):
		tmp_array.append(tmp_int_num % 10)
		tmp_int_num /= 10
	return tmp_array
