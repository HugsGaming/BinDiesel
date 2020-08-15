extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var charge = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgress.value = 0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_select"):
		charge += 10
		$TextureProgress.value = charge
		if charge >= 100:
			frame = 4
		elif charge >= 75:
			frame = 3
		elif charge >= 50:
			frame = 2
		elif charge >= 25:
			frame = 1
		elif charge >= 0:
			frame = 0
