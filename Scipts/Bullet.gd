extends Area2D

const bulletSpeed = 300
const bulletDamage = 1
var lifeTime = 2
var direction = 1
var radians = 1.5708
var bulletVelocity = Vector2()
var dir


func _ready():
	var bulletSprite = $Sprite
	var bulletCollision = $CollisionShape2D
	$Lifetime.set_wait_time(lifeTime)
	$Lifetime.start(lifeTime)

func set_shot_direction(dir, delta):
	if dir == 1:
		bulletVelocity.x = bulletSpeed * delta * direction
		bulletVelocity.y = 0
		translate(bulletVelocity)
	elif dir == 2:
		bulletVelocity.x = bulletSpeed * delta * direction
		bulletVelocity.y = 0
		translate(bulletVelocity)
	elif dir == 3:
		$CollisionShape2D.rotate(radians)
		$Sprite.rotate(radians)
		bulletVelocity.x = 0
		bulletVelocity.y = bulletSpeed * delta * direction
		translate(bulletVelocity)
	elif dir == 4:
		$CollisionShape2D.rotate(radians)
		$Sprite.rotate(radians)
		bulletVelocity.x = 0
		bulletVelocity.y = bulletSpeed * delta * -direction
		translate(bulletVelocity)
	pass
	
func _physics_process(delta):
	translate(bulletVelocity)
	pass
	

func _on_Lifetime_timeout():
	queue_free()
	pass 


func _on_Bullet_body_entered(body):
	if "Enemy" in body.name:
		body.take_damage(bulletDamage)
		body.dead()
		queue_free()
	if body.get_class() == "TileMap":
		queue_free()
	pass # Replace with function body.


func _on_Bullet_area_entered(area):
	area.take_damage(bulletDamage)
	area.dead()
	pass # Replace with function body.
