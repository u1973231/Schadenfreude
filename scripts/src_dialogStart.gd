extends Node

export var dialogPath = ""
export var addMision = 0
var playerIn = false
var dialog
var HUDInter
var HUD
# Called when the node enters the scene tree for the first time.
func _ready():
	dialog = preload("res://scenes/DialogSystem.tscn")
	HUDInter = preload("res://scenes/HUDInteractuar.tscn")
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("interactue") and playerIn:
		hablar()
		
	

func hablar():
	ScrGlobal.currenDialogPath = dialogPath
	var scene = dialog.instance()
	scene.position = Vector2(-370,100)
	var padre = get_parent()
	padre.get_child(1).add_child(scene)
	if addMision != -1:
		ScrGlobal.addMistion(addMision)
		addMision = -1 
	
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		HUD = HUDInter.instance()
		var padre = get_parent()
		padre.get_child(1).add_child(HUD)
		playerIn = true



func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		HUD.queue_free()
		playerIn = false
	
