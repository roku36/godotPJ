extends Node2D

@onready var icon: Sprite2D = $SubViewportContainer/Icon
@onready var player : Node2D = $SubViewportContainer/SubViewport/SubNode/Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# icon.global_position = player.global_position/ 4
	# print(player.global_position)
	pass
