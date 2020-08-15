extends KinematicBody2D

var Direction = Vector2()
var rng = RandomNumberGenerator.new()
export (PackedScene) var item

export (int) var chase_timer
export (int) var cooldown_timer
var can_follow = true
var is_dead = false
export (int) var health
export (int) var MAX_SPEED
export (int) var radius
var facing_right = false
var facing_left = true
var facing_up = false
var facing_down = false
var direction = -1
var enemyTracker


const TOP = Vector2(0, -1)
const DOWN = Vector2(0, 1)
const RIGHT = Vector2(1, 0)
const LEFT = Vector2(-1, 0)

var velocity = Vector2()

var speed = 0
var go_to
var go_right_up_down
var go_left_up_down
var go_left_right_down
var go_left_right_up


func _ready():
	rng.randomize()
	$Chase_Timer.wait_time = chase_timer
	$Cooldown_Timer.wait_time = cooldown_timer
	set_physics_process(true)
	
func movement(delta):
	
	if go_to == 1:
		speed = MAX_SPEED
		Direction = LEFT
		velocity = speed * Direction.normalized() * delta
		$AnimatedSprite.flip_h = false
		facing_left = true
		facing_right = false
		facing_down =  false
		facing_up = false
		move_and_slide(velocity)
	elif go_to == 2:
		speed = MAX_SPEED
		Direction = RIGHT
		velocity = speed * Direction.normalized() * delta
		$AnimatedSprite.flip_h = true
		facing_right = true
		facing_down =  false
		facing_left = false
		facing_up = false
		move_and_slide(velocity)
	elif go_to == 3:
		speed = MAX_SPEED/2
		Direction = TOP
		velocity = speed * Direction.normalized() * delta
		facing_up = true
		facing_right = false
		facing_down =  false
		facing_left = false
		move_and_slide(velocity)
	elif go_to == 4:
		speed = MAX_SPEED/2
		Direction = DOWN
		velocity = speed * Direction.normalized() * delta
		facing_down = true
		facing_right = false
		facing_left = false
		facing_up = false
		move_and_slide(velocity)
	
	if is_on_wall():
		if facing_left:
			$"onWallTimer(FacingLeft)".start()
			if go_right_up_down == 1:
				speed = MAX_SPEED
				Direction = RIGHT
				velocity = speed * delta * Direction.normalized()
				facing_left = false
				facing_right = true
				facing_down =  false
				facing_up = false
				move_and_slide(velocity)
			elif go_right_up_down == 2:
				speed = MAX_SPEED/2
				Direction = TOP
				velocity = speed * Direction.normalized() * delta
				facing_up = true
				facing_right = false
				facing_down =  false
				facing_left = false
			elif go_right_up_down == 3:
				speed = MAX_SPEED/2
				Direction = DOWN
				velocity = speed * Direction.normalized() * delta
				facing_down = true
				facing_right = false
				facing_left = false
				facing_up = false
				move_and_slide(velocity)
		elif facing_right:
			if go_left_up_down == 1:
				speed = MAX_SPEED
				Direction = LEFT
				velocity = speed * Direction.normalized() * delta
				$AnimatedSprite.flip_h = false
				facing_left = true
				facing_right = false
				facing_down =  false
				facing_up = false
				move_and_slide(velocity)
			elif go_left_up_down == 2:
				speed = MAX_SPEED/2
				Direction * TOP
				velocity = speed * Direction.normalized() * delta
				facing_up = true
				facing_right = false
				facing_down =  false
				facing_left = false
			elif go_left_up_down == 3:
				speed = MAX_SPEED/2
				Direction = DOWN
				velocity = speed * Direction.normalized() * delta
				facing_down = true
				facing_right = false
				facing_left = false
				facing_up = false
				move_and_slide(velocity)
		elif facing_up:
			if go_left_right_down == 1:
				speed = MAX_SPEED
				Direction = LEFT
				velocity = speed * Direction.normalized() * delta
				$AnimatedSprite.flip_h = false
				facing_left = true
				facing_right = false
				facing_down =  false
				facing_up = false
				move_and_slide(velocity)
			elif go_left_right_down == 2:
				speed = MAX_SPEED
				Direction = RIGHT
				velocity = speed * Direction.normalized() * delta
				$AnimatedSprite.flip_h = true
				facing_left = false
				facing_right = true
				facing_down =  false
				facing_up = false
				move_and_slide(velocity)
			elif go_left_right_down == 3:
				speed = MAX_SPEED/2
				Direction = DOWN
				velocity = speed * Direction.normalized() * delta
				facing_down = true
				facing_right = false
				facing_left = false
				facing_up = false
				move_and_slide(velocity)
		elif facing_down:
			if go_left_right_up == 1:
				speed = MAX_SPEED
				Direction = LEFT
				velocity = speed * Direction.normalized() * delta
				$AnimatedSprite.flip_h = false
				facing_left = true
				facing_right = false
				facing_down =  false
				facing_up = false
				move_and_slide(velocity)
			elif go_left_right_up == 2:
				speed = MAX_SPEED
				Direction = RIGHT
				velocity = speed * Direction.normalized() * delta
				$AnimatedSprite.flip_h = true
				facing_left = false
				facing_right = true
				facing_down =  false
				facing_up = false
				move_and_slide(velocity)
			elif go_left_right_up == 3:
				speed = MAX_SPEED/2
				Direction = TOP
				velocity = speed * Direction.normalized() * delta
				facing_up = true
				facing_right = false
				facing_down =  false
				facing_left = false
		
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

func _physics_process(delta):
	movement(delta)
	move_and_slide(velocity)
	
	
	if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Player" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.dead()
	
	pass




func _on_MovementTimer_timeout():
	go_to = rng.randi_range(1, 4)
	

func _on_onWallTimerFacingLeft_timeout():
	go_right_up_down = rng.randi_range(1, 3)


func _on_onWallTimerFacingRight_timeout():
	go_left_up_down = rng.randi_range(1, 3)


func _on_onWallTimerFacingUp_timeout():
	go_left_right_down = rng.randi_range(1, 3)


func _on_onWallTimerFacingDown_timeout():
	go_left_right_up = rng.randi_range(1, 3)
