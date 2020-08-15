extends KinematicBody2D

var Direction = Vector2()
var bulletSpeed = 300
var oilCollected = 0

signal dead

export(PackedScene) var Bullet

var gunReloadTime = 5
var can_shoot = true
var is_dead = false
var numberOfBullets = 10
var facing_right = true
var facing_left = false
var facing_up = false
var facing_down = false
var gunDelay = 1

var waitTime = 5
const TOP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const RIGHT = Vector2(1, 0)
const LEFT = Vector2(-1, 0)

var velocity = Vector2()

var speed = 0
const MAX_SPEED = 250

func _ready():
	var game_vars = get_node("/root/Game")
	$GunCoolDown.wait_time = gunReloadTime
	$GunDelay.wait_time = gunDelay
	$DeathTimer.wait_time = 2
	$InGameMusic.play()
	set_physics_process(true)
	
	
func control():
	var is_moving = Input.is_action_pressed("move_up") or Input.is_action_pressed("move_down") or Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left")
	
	Direction = Vector2()
	if is_moving:
		speed = MAX_SPEED
		if Input.is_action_pressed("move_up"):
			Direction += TOP
			speed /= 2
			$Animation.play("Walk(Up)")
			if ($Animation.flip_h == true):
				$Bullet_position.set_position(Vector2(-6, 6))
			else:
				$Bullet_position.set_position(Vector2(6, 3))
			facing_up = true
			facing_right = false
			facing_down =  false
			facing_left = false
		elif Input.is_action_pressed("move_down"):
			Direction += DOWN
			speed /= 2
			$Animation.play("Walk(Down)")
			if ($Animation.flip_h == true):
				$Bullet_position.set_position(Vector2(6, 3))
			else:
				$Bullet_position.set_position(Vector2(-6, 6))
			facing_down = true
			facing_right = false
			facing_left = false
			facing_up = false
		elif Input.is_action_pressed("move_right"):
			Direction += RIGHT
			$Animation.play("Walk(Side)")
			$Animation.flip_h = false
			$Bullet_position.set_position(Vector2(3, 4))
			facing_right = true
			facing_down =  false
			facing_left = false
			facing_up = false
		elif Input.is_action_pressed("move_left"):
			Direction += LEFT
			$Animation.play("Walk(Side)")
			$Animation.flip_h = true
			$Bullet_position.set_position(Vector2(-3, 4))
			facing_left = true
			facing_right = false
			facing_down =  false
			facing_up = false
	else:
		if facing_right:
			$Animation.play("Idle(Side)")
			$Animation.flip_h = false
		elif facing_left:
			$Animation.play("Idle(Side)")
			$Animation.flip_h = true
		elif facing_down:
			$Animation.play("Idle(Down)")
		elif facing_up:
			$Animation.play("Idle(Up)")
	pass

func shoot(delta):
	if Input.is_action_pressed("shoot") and can_shoot == true and numberOfBullets > 0:
			var newBullet = Bullet.instance()
			get_parent().add_child(newBullet)
			newBullet.position = $Bullet_position.global_position
			if facing_right:
				newBullet.bulletVelocity.x = bulletSpeed * delta * 1
			elif facing_left:
				newBullet.bulletVelocity.x = bulletSpeed * delta * -1
			elif facing_down:
				newBullet.bulletVelocity.y = bulletSpeed * delta * 1
			elif facing_up:
				newBullet.bulletVelocity.y = bulletSpeed * delta * -1
			can_shoot = false
			$GunDelay.start()
			global_vars.bulletDelayTime = $GunDelay.time_left
			numberOfBullets -= 1
			if numberOfBullets == 0:
				can_shoot = false
				$GunCoolDown.start()
	pass

func _process(delta):
	global_vars.bulletsLeft = numberOfBullets
	if is_dead == false:
		control()
		shoot(delta)
		velocity = speed * Direction.normalized() * delta
		move_and_collide(velocity)
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "Enemy" in get_slide_collision(i).collider.name:
				dead()
	
	if global_vars.oilCollected == global_vars.oilNeeded:
		$InGameMusic.stop()
	pass

func dead():
	is_dead = true
	velocity = Vector2(0, 0)
	$CollisionShape2D.disabled = true
	$Animation.play("Dead")
	$InGameMusic.stop()
	$DeathMusic.play()
	$DeathTimer.start()


func _on_GunCoolDown_timeout():
	$GunCoolDown.stop()
	can_shoot = true
	numberOfBullets = 10
	pass # Replace with function body.

func collect():
	global_vars.oilCollected += 1
	pass

func _on_GunDelay_timeout():
	can_shoot = true
	pass 


func _on_DeathTimer_timeout():
	get_tree().change_scene("GameOver.tscn")
	global_vars.oilCollected = 0


func _on_Movement_timeout(delta):
	pass



func _on_InGameMusic_finished():
	$InGameMusic.play()
