extends Node

export var dialogoDefault = ""
export var dialogoMision = ""
export var dialogoTengoMision = ""
export var dialogoRecompensa = ""
export var addMision = 0
export var recompensa = true
export var cantidadRecompensa = 100
var playerIn = false
var dialog
var HUDInter
var HUD
var indexMision
var path = "res://dialogs/"

# Called when the node enters the scene tree for the first time.
func _ready():
	dialog = preload("res://scenes/DialogSystem.tscn")
	HUDInter = preload("res://scenes/HUDInteractuar.tscn")
	indexMision = addMision #Nos guardamos el indice de la mision
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("interactue") and playerIn and not ScrGlobal.getJugadorHablando():
		hablar()
		ScrGlobal.setJugadorHablando(true)
		
	

func hablar():
	crearCuadroDialogo()
	aniadirMision()
	if recompensa and ScrGlobal.comprovarMisionCompletada(indexMision):
		ScrGlobal.darRecompensa(cantidadRecompensa)
		recompensa = false
	
func aniadirMision():
	if addMision != -1:
		ScrGlobal.addMistion(addMision)
		addMision = -1 	

func crearCuadroDialogo():
	if addMision != -1: #Dialogo de mision
		ScrGlobal.currenDialogPath = path + dialogoMision
	elif not recompensa: #El jugador ya ha sido recompensado
		ScrGlobal.currenDialogPath = path + dialogoDefault
	elif ScrGlobal.comprovarMisionCompletada(indexMision): #El jugador ya posee la mision
		ScrGlobal.currenDialogPath = path + dialogoRecompensa
	else: #El jugador ya posee la mision
		ScrGlobal.currenDialogPath = path + dialogoTengoMision
	
	var scene = dialog.instance()
	scene.position = Vector2(280,480)
	get_parent().add_child(scene)	
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		HUD = HUDInter.instance()
		var padre = get_parent().get_parent()
		padre.get_child(1).add_child(HUD)
		playerIn = true
		


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		HUD.queue_free()
		playerIn = false
	
