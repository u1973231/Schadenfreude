extends Node

export var dialogPath = ""

var playerIn = false
var dialog

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog = preload("res://scenes/DialogSystem.tscn")
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("interactue") and playerIn:
		ScrGlobal.currenDialogPath = dialogPath
		var scene = dialog.instance()
		scene.position = Vector2(-400,150)
		var padre = get_parent()
		padre.get_child(1).add_child(scene)
		print("hola")



func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		playerIn = true



func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		playerIn = false
	
