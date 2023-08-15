extends Camera2D

var spd: float = 1.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# move 4 direction by keyboard input
	if Input.is_action_pressed("ui_right"):
		position.x += spd
	if Input.is_action_pressed("ui_left"):
		position.x -= spd
	if Input.is_action_pressed("ui_down"):
		position.y += spd
	if Input.is_action_pressed("ui_up"):
		position.y -= spd


