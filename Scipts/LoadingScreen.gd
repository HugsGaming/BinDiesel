extends TextureRect


func _ready():
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_LoadingTime_timeout():
	get_tree().change_scene("TitleScreen.tscn")
