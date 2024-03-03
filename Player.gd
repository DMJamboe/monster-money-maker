extends KinematicBody2D
signal hit
signal game_over

# Health
export var maximum_health = 50
export var default_maximum_health = 50
var current_health = maximum_health

var incoming_damage = 10

export var beam_damage = 10


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var knockback_speed = 100

var screen_size
var charging = false
var charge_time = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = "run"
	$AnimatedSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass#print("Player is at " + str(position.x) + " " + str(position.y))


func _on_HitTimer_timeout():
	# Rest animation
	$AnimatedSprite.animation = "run"


func _on_player_hit():
	if (charging):
		return
		
	# Don't hit if already hit
	elif(!$HitTimer.is_stopped()):
		return
		
	# Recieve hit damage
	current_health-=incoming_damage
	
	# Die
	if (current_health <= 0):
		$AnimatedSprite.frame = 0
		$AnimatedSprite.animation = "die"
		emit_signal("game_over")
	
	
	# hide() # Player disappears after being hit.
	emit_signal("hit")
	$AnimatedSprite.animation = "hit"
	
	# Set collision timer
	$HitTimer.start(1)
	
	# Must be deferred as we can't change physics properties on a physics callback.
	# CollisionShape2D.set_deferred("disabled", true)
	
	
	
	


func _on_Main_charge():
	charging = true;
	$AnimatedSprite.animation = "charge"
	$ChargeTimer.start(charge_time)


func _on_ChargeTimer_timeout():
	charging = false;
	$AnimatedSprite.animation = "run"


func _on_Main_player_attack():
	if(not charging):
		$AnimatedSprite.animation="attack"
		


func _on_AnimatedSprite_animation_finished():
	if ($AnimatedSprite.animation == "attack"):
		$AnimatedSprite.animation = "run"
		
	if ($AnimatedSprite.animation == "die"):
		emit_signal("game_over")


func _on_BeamSprite_animation_finished():
	$MagicBeam/BeamSprite.visible = false
	$MagicBeam/BeamSprite.stop()
	$MagicBeam/BeamSprite.frame = 0
	$MagicBeam/BeamCollision.disabled = true


func _on_Main_ranged_attack():
	$MagicBeam/BeamSprite.visible = true
	$MagicBeam/BeamSprite.play()
	$MagicBeam/BeamCollision.disabled = false

func _on_MagicBeam_body_entered(body):
	body.hit(beam_damage) # Replace with function body.


func _on_Main_reset_all():
	# Reset wizard health
	current_health = maximum_health
	$AnimatedSprite.animation = "run"


func _on_Main_total_death_wizard():
	current_health = default_maximum_health
	maximum_health = default_maximum_health
	$AnimatedSprite.animation = "run"
