extends Control


func _ready():
	for button in $Options/CentreRow/Buttons.get_children():
		button.connect("pressed", Callable(self, "_on_Button_pressed").bind(button.scene_to_load))


func _on_Button_pressed(scene_to_load):
	get_tree().change_scene_to_file(scene_to_load)
