extends Area2D

export (int) var chase_timer
export (int) var cooldown_timer
var can_follow = true
var is_dead = false
export (int) var health
export (int) var MAX_SPEED
export (int) var radius

var velocity = Vector2()

func _ready():
	pass 

func take_damage(damage):
	health -= damage
	pass
	
func dead():
	if health == 0:
		is_dead = true
		queue_free()

func _process(delta):
	pass
