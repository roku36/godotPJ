extends CharacterBody2D

@onready var test_label: Label = $"%HUD/TestLabel"
@onready var circle_bar: ColorRect = $"%HUD/CircleBar"
@onready var spin_disk: ColorRect = $"%HUD/SpinDisk"
@onready var ghost: Node2D = %Ghost
@onready var level_selector: Node = %LevelSelector

@export var acceleration: float = 30.0
@export var max_speed: float = 1000.0
@export var turn_speed: float = 0.1
@export var spd_on_dist: Curve
@export var limit_on_dist: Curve
@export var limit_on_dist_bounce: Curve
@export var limit_width: float = 100.0
@onready var se_boost: AudioStreamPlayer = $SE_Boost
@onready var se_goal: AudioStreamPlayer = $SE_Goal

var impact: PackedScene = preload("res://Scenes/impact.tscn")
# get first effect of bus "se"
var se_panner: AudioEffectPanner = AudioServer.get_bus_effect(AudioServer.get_bus_index("se_boost"), 0)
# var velocity: Vector2 = Vector2.ZERO

var mousex_delta:float = 0.0

var closest_reflector: Node2D = null
var closest_reflector_distance: float = INF

func _ready() -> void:
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if Global.state == Global.STARTED:
		if Input.is_action_pressed("start"):
			self.mousex_delta *= 0.95

	
	mousex_delta = lerp(mousex_delta, 0.0, 0.01)
	circle_bar.material.set_shader_parameter("fill_ratio", -mousex_delta/1000)
	spin_disk.rotation_spd = mousex_delta / 50
	# if Global.state == Global.READY or Global.state == Global.TITLE or Global.state == Global.RESULT:
		# set position to start of the curve
	if Global.state == Global.STARTED:
		check_closest_reflector()
		velocity = velocity.limit_length(max_speed)
		# damp
		velocity *= 0.95
		update_rotation(mousex_delta, delta)
		# update_pathfollow()
		move_to_follower()
		move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mousex_delta += event.relative.x * Global.mouse_sensitivity
		# update test_label text to mousex_delta
		test_label.text = str(mousex_delta)
		# circle_bar.material.set_shader_parameter("fill_ratio", -mousex_delta/1000)
	if event.is_action_pressed("ui_accept"):
		# if distance is < 100
		if closest_reflector != null and closest_reflector_distance < 100:
			print("Closest enemy distance: " + str(closest_reflector_distance))
			print("Closest enemy rotation: " + str(closest_reflector.rotation))
			reflection_to(closest_reflector.rotation, closest_reflector.global_position)
			# add impact instance to the position
			var impact_instance: Node2D = impact.instantiate()
			impact_instance.global_position = closest_reflector.global_position
			get_tree().root.add_child(impact_instance)


func update_rotation(turn_input: float, delta: float) -> void:
	rotation += turn_input * turn_speed * delta


func reflection_to(angle: float, _pos: Vector2) -> void:
	# self.rotation = lerp_angle(self.rotation, angle + Vector2.DOWN.angle(), 1)
	self.rotation = angle
	# self.position = pos
	velocity = Vector2.RIGHT.rotated(angle) * velocity.length()


func check_closest_reflector() -> void:
	closest_reflector= null
	closest_reflector_distance = INF
	for reflector in get_tree().get_nodes_in_group("Reflector"):
		var distance: float = reflector.global_position.distance_to(global_position)
		if distance < closest_reflector_distance:
			closest_reflector_distance = distance
			closest_reflector=reflector 

# move toward pathfollower2d.
func move_to_follower() -> void:
	var followerDirXVec: Vector2 = Vector2.from_angle(level_selector.path_follow_player.rotation)
	var followerDirYVec: Vector2 = Vector2.from_angle(level_selector.path_follow_player.rotation).rotated(PI/2)
	var followerDist: Vector2 = level_selector.path_follow_player.position - self.position

	var XVec_dist: float = -followerDist.dot(followerDirXVec.normalized())
	var YVec_dist: float = followerDist.dot(followerDirYVec.normalized())
	level_selector.path_follow_player.progress += XVec_dist * 0.5
	level_selector.path_follow_player.progress_ratio = clamp(level_selector.path_follow_player.progress_ratio, 0.0, 1.0)

	limit_width = level_selector.level_width * level_selector.level_width_curve.sample(level_selector.path_follow_player.progress_ratio)
	var dist_0_1: float = abs(YVec_dist) / limit_width
	var limit_ratio: float = limit_on_dist.sample(dist_0_1)

	var spd: float = spd_on_dist.sample(dist_0_1) * acceleration
	se_boost.pitch_scale = remap(spd_on_dist.sample(dist_0_1), 0.0, 1.0, 0.0, 1.0)
	se_panner.pan = YVec_dist / limit_width
	self.velocity += Vector2.from_angle(self.rotation) * spd

	if self.velocity.dot(followerDirYVec) * YVec_dist < 0:
		self.velocity -= followerDirYVec * (self.velocity.dot(followerDirYVec.normalized()) * limit_ratio)


func _on_main_lap_started() -> void:
	reset_position()
	se_boost.play()
	self.modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_main_goal_reached() -> void:
	reset_position()
	se_boost.stop()
	self.modulate = Color(1.0, 1.0, 1.0, 0.2)
	se_goal.play()


func _on_main_escape_game() -> void:
	reset_position()
	se_boost.stop()

func reset_position() -> void:
	self.position = level_selector.road_path.curve.sample_baked(0)
	self.rotation = level_selector.road_path.curve.get_point_out(0).angle()


func _on_level_selector_stage_changed() -> void:
	reset_position()
	se_boost.stop()
