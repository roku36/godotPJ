extends CanvasLayer

@onready var target_time_container: VBoxContainer = $VBox
@onready var medal_textures: Dictionary = {
	"gold": $VBox/HBoxGold/TextureRect,
	"silver": $VBox/HBoxSilver/TextureRect,
	"bronze": $VBox/HBoxBronze/TextureRect,
}
@onready var medal_labels: Dictionary = {
	"gold": $VBox/HBoxGold/Label,
	"silver": $VBox/HBoxSilver/Label,
	"bronze": $VBox/HBoxBronze/Label,
}
@onready var se_medal: AudioStreamPlayer = $SE_medal
@onready var scores: RichTextLabel = %Scores

var achieved_color: Color = Color.ORANGE

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass
	# when pressed enter key, anim medal
	# if Input.is_action_just_pressed("ui_accept"):
	# 	# anim_medal("gold")
	# 	anim_medal("silver")
	# 	# anim_medal("bronze")

func anim_medal(medal: String) -> void:
	# emphasis effect using scale
	var medal_node: TextureRect = medal_textures[medal]
	# Global.achievements[Global.current_stage] = "silver"
	update_target_times()
	
	# write your code here.


	var tween: Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(target_time_container, "scale", Vector2(1.0, 1.0), 0.3)
	tween.parallel().tween_property(target_time_container, "position", Vector2(850, 230), 0.3)
	tween.tween_interval(0.3)
	tween.tween_property(se_medal, "playing", true, 0.0)
	tween.tween_property(medal_node, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(medal_node, "material:shader_parameter/spin_rate", TAU, 0.3)
	tween.tween_property(medal_node, "material:shader_parameter/spin_rate", 0, 0.0)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(medal_node, "scale", Vector2(1, 1), 0.1)
	tween.tween_interval(1.0)
	tween.tween_property(target_time_container, "scale", Vector2(0.4, 0.4), 0.3)
	tween.parallel().tween_property(target_time_container, "position", Vector2(1000, 30), 0.3)

func update_labels() -> void:
	if not is_node_ready():
		await ready
	update_target_times()
	update_scoreboard()

func update_target_times() -> void:
	var achievement: String = Global.achievements[Global.current_stage]
	for medal: String in ["gold", "silver", "bronze"]:
		medal_labels[medal].text = "%.2f" % Global.target_times[Global.current_stage][medal]

	for texture: TextureRect in medal_textures.values():
		texture.material.set_shader_parameter("active", false)
	for label: Label in medal_labels.values():
		label.modulate = Color(1.0, 1.0, 1.0, 0.7)

	if achievement == "gold":
		medal_textures["gold"].material.set_shader_parameter("active", true)
		medal_textures["silver"].material.set_shader_parameter("active", true)
		medal_textures["bronze"].material.set_shader_parameter("active", true)
		medal_labels["gold"].modulate = achieved_color
		medal_labels["silver"].modulate = achieved_color
		medal_labels["bronze"].modulate = achieved_color
	elif achievement == "silver":
		medal_textures["silver"].material.set_shader_parameter("active", true)
		medal_textures["bronze"].material.set_shader_parameter("active", true)
		medal_labels["silver"].modulate = achieved_color
		medal_labels["bronze"].modulate = achieved_color
	elif achievement == "bronze":
		medal_textures["bronze"].material.set_shader_parameter("active", true)
		medal_labels["bronze"].modulate = achieved_color


func update_scoreboard() -> void:
	scores.clear()
	# append top 5 scores
	# e.g. "1st score: 30.00"
	scores.append_text("[b]Stage: %d[/b]\n" % [Global.current_stage+1])
	for i in range(Global.best_lap_time[Global.current_stage].size()):
		var prize: String = "none"
		var laptime: float = Global.best_lap_time[Global.current_stage][i]
		for medal: String in ["gold", "silver", "bronze"]:
			if laptime < Global.target_times[Global.current_stage][medal]:
				prize = medal
				break
		scores.append_text("[img=16]res://Textures/%s.svg[/img] %.2f\n" % [prize, Global.best_lap_time[Global.current_stage][i]])
