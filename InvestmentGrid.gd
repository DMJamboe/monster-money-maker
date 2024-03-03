extends ColorRect

signal add
signal take

export var text_title = "Type"
export var text_desc = "Desc"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Title.text = text_title
	$Description.text = text_desc

func setValue(value):
	$ValueBox/ValueLabel.text = "£" + str(stepify(value, 0.01))
	
func setRate(rate):
	$ValueBox/ValueChange.text = str(stepify(int((rate-1) * 100), 0.01)) + "%"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AddToSnS_input_event(viewport, event, shape_idx):
	if(event is InputEventScreenTouch or (event is InputEventMouseButton and event.pressed)):
		emit_signal("add")

func _on_TakeFromSnS_input_event(viewport, event, shape_idx):
	if(event is InputEventScreenTouch or (event is InputEventMouseButton and event.pressed)):
		emit_signal("take")
