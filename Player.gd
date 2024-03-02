extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = "attack2"
	$AnimatedSprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
