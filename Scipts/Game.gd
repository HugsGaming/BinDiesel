extends Node2D

export (int) var number_of_oil_needed
export (int) var number_of_seconds_per_game

#UI
var oilCollected = 0
var bulletsLeft = 0
export (NodePath) var ui_label_timer_path
onready var ui_label_timer = get_node(ui_label_timer_path)
export (NodePath) var ui_label_oilCollected_path
onready var ui_label_oilCollected = get_node(ui_label_oilCollected_path)
export (NodePath) var ui_label_bulletsLeft_path
onready var ui_label_bulletsLeft = get_node(ui_label_bulletsLeft_path)
export (String) var nextScenePath
export (NodePath) var ui_label_bulletDelay_path
onready var ui_label_bulletDelay = get_node(ui_label_bulletDelay_path)




func _ready():
	$VictoryTimer.set_wait_time(4)
	$VictoryTimer.one_shot = true
	$GameTimer.set_wait_time(number_of_seconds_per_game)
	$GameTimer.one_shot = true
	$GameTimer.start()
	pass 


func _process(delta):
	global_vars.oilNeeded = number_of_oil_needed
	bulletsLeft = global_vars.bulletsLeft
	oilCollected = global_vars.oilCollected
	global_vars.oilNeeded = number_of_oil_needed
	ui_label_timer.set_text(str(int($GameTimer.get_time_left())))
	ui_label_oilCollected.set_text(str(oilCollected))
	ui_label_bulletsLeft.set_text(str(bulletsLeft))
	checkForWin()
	pass

func checkForWin():
	var percentCompleted
	percentCompleted = (float(oilCollected)/float(number_of_oil_needed))
	var progressBar = $UI/BiodieselBar
	progressBar.value = percentCompleted * 100
	print(percentCompleted)
	print(progressBar.value)
	if percentCompleted == 1:
		$City/AnimatedSprite.frame = 4
		$VictoryMusic.play()
		$VictoryTimer.start()
		global_vars.oilCollected = 0
		get_tree().change_scene(nextScenePath)
	elif percentCompleted >= .75:
		$City/AnimatedSprite.frame = 3
	elif percentCompleted >= .50:
		$City/AnimatedSprite.frame = 2
	elif percentCompleted >= .25:
		$City/AnimatedSprite.frame = 1
	elif percentCompleted >= 0:
		$City/AnimatedSprite.frame = 0

func _on_Game_Timer_timeout():
	global_vars.oilCollected = 0
	get_tree().change_scene("GameOver.tscn")


func _on_VictoryTimer_timeout():
	get_tree().change_scene(nextScenePath)


func _on_GameTimer_timeout():
	global_vars.oilCollected = 0
	get_tree().change_scene("GameOver.tscn")
