extends KinematicBody2D
signal hit_player(emitter)
signal mob_died(emitter)

export var mob_speed = 1
var is_pushback = false
var is_charge = false

# Health
export var max_health = 40
var remaining_health = max_health

export var money = 10

var dead = false
var wizard_attack_damage = 20

export var charge_speed = 2
export var charge_time = 1

export var pushback_speed = 2
export var pushback_time = 1

var goob = ""

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.playing = true
	randomize()
	var ran_sprite = randi()
	if ran_sprite % 3 == 0:
		goob = "goblin_"
	elif (ran_sprite + 1) % 3 == 0:
		goob = "fly_"
	$AnimatedSprite.animation = goob + "run"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Choose the velocity for the mob.
	if ($AnimatedSprite.animation == goob + "hit" and not is_pushback):
		pass		
	elif (is_pushback and not $AnimatedSprite.animation == goob + "die"):
		move_and_collide(Vector2(pushback_speed, 0))
	
	else:
		var collision
		if (is_charge and not $AnimatedSprite.animation == goob + "die"):
			collision = move_and_collide(Vector2(-charge_speed, 0))
			if (collision):
				kill()
		else:
			var velocity = Vector2(-mob_speed, 0.0)
			collision = move_and_collide(velocity)
		
			if (collision):
				
				hit(wizard_attack_damage)
				
				emit_signal("hit_player", self)
			

func hit(damage):
	remaining_health -= wizard_attack_damage
	if (remaining_health <= 0):
		kill()
	else:
		$AnimatedSprite.animation = goob + "hit"

func _on_RigidBody2D_body_entered(body):
	print("Mushroom collision")
	pass # Replace with function body.
	
func push_back():
	$PushbackTimer.start(pushback_time)
	is_pushback = true


func _on_PushbackTimer_timeout():
	is_pushback = false
	
func _on_charge():
	is_charge = true
	$ChargeTimer.start(charge_time)
	
func kill():
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite.animation = goob + "die"
	emit_signal("mob_died", self)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == goob + "die":
		hide()
	if $AnimatedSprite.animation == goob + "hit":
		$AnimatedSprite.animation = goob + "run"


func _on_ChargeTimer_timeout():
	is_charge = false
