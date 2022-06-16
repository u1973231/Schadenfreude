extends Node


#Variales Globales
var currenDialogPath = "res://dialogs/Dialogo0.json"
var posJugador = Vector2.ZERO
var misionesAceptadas = []
var misionesProgreso = []
var misionesCompletadas = []
var misiones

#Variables privadas
var pathMisiones = "res://Misiones/Misiones.json"


func _ready():
	misiones = cargarMisiones()
	
	
func compMisionCompleta(i):
	var indexM = misionesAceptadas[i]
	if int(misiones[indexM]["Cantidad"]) <= misionesProgreso[i]:
		print("misionCumplida")
		misionesCompletadas.append(misionesAceptadas[i])#Añade la mision como completada para poder recivir la recompensa al hablar con el npc 
		misionesAceptadas[i] = -1 #Cuando una mision aceptada esta en -1 para indicar que ya no esta vijente
		
	
	pass

func addMistion(index):
	misionesAceptadas.append(index)
	misionesProgreso.append(0)
	misionesCompletadas.append(false)

#Carrga las misiones en memoria
func cargarMisiones() -> Array:
	var f = File.new()
	assert(f.file_exists(pathMisiones),"El path de las misiones no existe")
	
	f.open(pathMisiones, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
