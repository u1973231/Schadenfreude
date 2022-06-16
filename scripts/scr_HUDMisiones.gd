extends Node


#Variables Export
var margen = 20
var posInicialY = 20
var posX = 20
var posYCompletadas = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _process(delta):
	actualizarMisiones()

func actualizarMisiones():
	for i in get_children():
		if i.name != "Mision":
			i.queue_free()
	
	var ma = ScrGlobal.misionesAceptadas
	var mp = ScrGlobal.misionesProgreso
	var mc = ScrGlobal.misionesCompletadas
	var m = ScrGlobal.misiones	
	var i = 0
	var row = 0
	var text = ""
	#Actualiza las misiones no completadas
	while i < len(ma):
		if ma[i] != -1: #Recompensa obtenia
			text = m[ma[i]]["Descripcion"] + " " + str(mp[i]) + "/" + m[ma[i]]["Cantidad"] 			
			var label = Label.new()
			var ancla = Node2D.new()			
			label.text = text
			ancla.add_child(label)
			ancla.position = Vector2(20,posInicialY + margen * row)
			add_child(ancla)
			row += 1			
		i += 1
		

	
	text = "COMPLETADAS"
	var ancla = Node2D.new()
	var label = Label.new()
	label.text = text
	ancla.position = Vector2(0,posYCompletadas)
	ancla.add_child(label)
	add_child(ancla)
	row = 1
	i = 0	
	while i < len(mc):
		text = m[int(mc[i])]["Descripcion"]
		ancla = Node2D.new()
		label = Label.new()
		label.text = text
		ancla.position = Vector2(20,posYCompletadas + margen * row)
		ancla.add_child(label)
		add_child(ancla)
		row += 1
		i += 1
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
