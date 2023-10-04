extends Camera2D

@onready var player: CharacterBody2D = $"../Player"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Global.state == Global.TITLE:
		self.position = self.position.lerp(Vector2.ZERO, 3.0 * delta)
		self.zoom = self.zoom.lerp(Vector2(0.2, 0.2), 3.0 * delta)
	else:
		# lerp position to player
		self.position = self.position.lerp(player.position, 3.0 * delta)
		self.zoom = self.zoom.lerp(Vector2.ONE, 3.0 * delta)
