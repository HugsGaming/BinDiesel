extends Control



func _ready():
	$Menu/CenterRow/CenterContainer/Buttons/Play.grab_focus()


func _physics_process(delta):
	if $Menu/CenterRow/CenterContainer/Buttons/Play. is_hovered() == true:
		$Menu/CenterRow/CenterContainer/Buttons/Play. grab_focus()
	if $Menu/CenterRow/CenterContainer/Buttons/Exit. is_hovered() == true:
		$Menu/CenterRow/CenterContainer/Buttons/Exit. grab_focus()

func _on_Play_pressed():
	get_tree().change_scene("Stage 0.tscn")


func _on_Exit_pressed():
	get_tree().quit()


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
