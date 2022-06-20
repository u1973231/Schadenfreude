extends Area2D


export var outSide :=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_dorTavern_body_entered(body):
	if body.is_in_group("player"):
		if outSide:
			get_tree().change_scene("res://scenes/Tavern.tscn")
		else:
			get_tree().change_scene("res://scenes/Outside.tscn")
	pass # Replace with function body.
