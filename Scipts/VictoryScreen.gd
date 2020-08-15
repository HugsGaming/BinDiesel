extends TextureRect


func _ready():
	$Timer.set_wait_time(5)
	$Timer.start()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta):
	pass

func _on_Timer_timeout():
	get_tree().change_scene("TitleScreen.tscn")
