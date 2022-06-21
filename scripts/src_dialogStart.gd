extends Node

export var dialogoDefault = ""
export var dialogoMision = ""
export var dialogoTengoMision = ""
export var dialogoRecompensa = ""
export var addMision = 0
export var recompensa = true
export var cantidadRecompensa = 100
export var hunterAlchemist = false
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

func _process(_delta):
	if Input.is_action_just_pressed("interactue") and playerIn and not ScrGlobal.getJugadorHablando():
		hablar()
		ScrGlobal.setJugadorHablando(true)
		
	

func hablar():
	crearCuadroDialogo()
	aniadirMision()
	if recompensa and ScrGlobal.comprovarMisionCompletada(indexMision):
		if hunterAlchemist:
			get_tree().change_scene("res://scenes/GameWin.tscn")
		else:
			ScrGlobal.darRecompensa(cantidadRecompensa)
			recompensa = false
	
func aniadirMision():
	if not ScrGlobal.tieneMision(addMision) and not ScrGlobal.comprovarMisionCompletada(indexMision):
		ScrGlobal.addMistion(addMision)
	
	if not ScrGlobal.tieneMision(addMision) and ScrGlobal.misiones[addMision]["Tipo"] == "recaudar"  and ScrGlobal.misiones[addMision]["Objetivo"] == "reputacion":
		ScrGlobal.comprovarReputacion()
		pass

func crearCuadroDialogo():
	if not ScrGlobal.tieneMision(addMision) and not ScrGlobal.comprovarMisionCompletada(indexMision): #Dialogo de mision
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
	
