extends Camera2D

@export var player_path: NodePath
@export var ghost_path: NodePath
@onready var level_selector: Node = $"../LevelSelector"

var player: Node
var ghost: Node
var target_point: Vector2

var margin: float = 400 

func _ready() -> void:
	player = get_node(player_path)
	ghost = get_node(ghost_path)

func _process(delta: float) -> void:
	if Global.state == Global.TITLE:
		self.position = self.position.lerp(Vector2.ZERO, 3.0 * delta)
		self.zoom = self.zoom.lerp(Vector2(0.2, 0.2), 3.0 * delta)
		self.rotation = lerp_angle(self.rotation, 0, 0.1)
	else:
		if level_selector.path_follow_player.progress_ratio > 0.9:
			target_point = level_selector.road_path.curve.sample_baked(500)
		else:
			target_point = level_selector.road_path.curve.sample_baked(level_selector.path_follow_player.progress + 500)
		var position1: Vector2 = global_transform.affine_inverse() * player.global_transform.origin
		var position2: Vector2 = global_transform.affine_inverse() * target_point

		var distance: Vector2 = abs(position1 - position2) + Vector2(margin, margin)

		var screen_size: Vector2 = get_viewport_rect().size
		var target_zoom_level: float = min(screen_size.x/ distance.x, screen_size.y/ distance.y)

		var target_global_position: Vector2 = (player.global_position + target_point) / 2
		var target_zoom: Vector2 = Vector2(target_zoom_level, target_zoom_level)
		var target_angle: float = (target_point - player.global_position).angle() + deg_to_rad(90)

		self.global_position = self.global_position.lerp(target_global_position, 0.1)
		self.zoom = self.zoom.lerp(target_zoom, 0.05)
		self.rotation = lerp_angle(self.rotation, target_angle, 0.1)
