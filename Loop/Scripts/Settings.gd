extends CanvasLayer
@onready var panel: Panel = $Panel
@onready var setting_button: TextureButton = $SettingButton
@onready var credits: RichTextLabel = $Credits

func _ready() -> void:
	pass


func _on_texture_button_toggled(toggled_on: bool) -> void:
	# if on, animate forwward, else animate back
	var tween: Tween = create_tween()
	if toggled_on:
		tween.tween_property(panel, "position", Vector2(0,0), 0.2)
	else:
		tween.tween_property(panel, "position", Vector2(-panel.size.x,0), 0.2)


func _on_main_enter_exit_title(is_enter: bool) -> void:
	setting_button.button_pressed = false
	# _on_texture_button_toggled(false)
	if is_enter:
		setting_button.visible = true
		credits.visible = true
	else:
		setting_button.visible = false
		credits.visible = false
