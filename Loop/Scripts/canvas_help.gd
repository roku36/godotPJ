extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# if clicked, make unvisible
	if Input.is_action_just_pressed("click"):
		visible = false
	
