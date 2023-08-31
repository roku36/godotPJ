extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set window passthrough to true
	Window.mouse_passthrough = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
