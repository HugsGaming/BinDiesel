extends Area2D


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_Oil_body_entered(body):
	if "Player" in body.name:
		global_vars.oilCollected += 1
		queue_free()
