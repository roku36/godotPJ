extends Camera2D

@onready var level_selector: Node = $"../LevelSelector"
@onready var player: CharacterBody2D = $"../Player"
# Called when the node enters the scene tree for the first time.

var target_point: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	target_point = (level_selector.road_path.curve.sample_baked(level_selector.path_follow_player.progress + 1000) + player.position) / 2

	# move camera
	if Global.state == Global.TITLE:
		self.position = self.position.lerp(Vector2.ZERO, 3.0 * delta)
		self.zoom = self.zoom.lerp(Vector2(0.2, 0.2), 3.0 * delta)
	elif Global.state == Global.READY:
		# lerp position to player
		self.position = self.position.lerp(player.position, 1.0 * delta)
		self.zoom = self.zoom.lerp(Vector2.ONE, 3.0 * delta)
	else:
		self.position = self.position.lerp(target_point, 2.0 * delta)
		self.zoom = self.zoom.lerp(Vector2.ONE, 3.0 * delta)

