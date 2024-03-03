extends ParallaxBackground

export var speed = 0.5
export var stun_speed = -0.5
export var stun_timer = 1.0
export var charge_speed = 1
export var charge_timer = 1

var charge = false
var stun = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (charge):
		set_scroll_offset(get_scroll_offset() + Vector2(charge_speed,0))
	elif (stun):
		set_scroll_offset(get_scroll_offset() + Vector2(stun_speed,0))
	else:
		set_scroll_offset(get_scroll_offset() + Vector2(speed,0))


func _on_Main_push_back():
	$Timer.start(stun_timer)
	stun = true


func _on_Timer_timeout():
	charge = false
	stun = false


func _on_Main_charge():
	$Timer.start(charge_timer) # Replace with function body.
	charge = true
