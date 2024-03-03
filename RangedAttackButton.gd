extends Area2D

export var cooldown_timer = 3.0
var enabled = true

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RangedAttack_input_event(viewport, event, shape_idx):
	if(enabled and (event is InputEventScreenTouch or (event is InputEventMouseButton and event.pressed))):
		$GreenButton.play()
		enabled = false
		$Timer.start(cooldown_timer)


func _on_Timer_timeout():
	$GreenButton.stop()
	$GreenButton.frame = 0
	enabled = true
