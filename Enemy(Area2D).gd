extends Area2D

export (int) var health
export (PackedScene) var item
var is_dead = false
func _ready():
	pass

func take_damage(damage):
	health -= damage
	pass

func dead():
	if health == 0:
		is_dead = true
		var newItem = item.instance()
		get_parent().add_child(newItem)
		newItem.position = $ItemPosition.global_position
		queue_free()


func _process(delta):
	pass
