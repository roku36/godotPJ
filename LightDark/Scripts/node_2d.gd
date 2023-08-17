extends Node2D

@onready var icon: Sprite2D = $SubViewportContainer2/SubViewport/Icon
@onready var player: Node2D = $SubViewportContainer2/SubViewport/SubViewportContainer/SubViewport/SubNode/Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	icon.position = player.position
	# modulate icon to black if health = 0, red if else
	if player.health == 0:
		icon.modulate = Color(1, 0, 0)
	else:
		icon.modulate = Color(1, 1, 1)
	
	# print(player.global_position)
