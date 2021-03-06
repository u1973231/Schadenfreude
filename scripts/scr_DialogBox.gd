extends ColorRect


#Variables exportadas
export var dialogPath = ""
export(float) var textSpeed = 0.05

var dialog

var phraseNum = 0
var finished = false
var sound = false
func _ready():
	$content/Indicator/AnimationPlayer.play("indicator")
	dialogPath = ScrGlobal.currenDialogPath
	print(dialogPath)
	$content/Timer.wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, "Dialogo no encontrado")
	nextPhrase()
	pass 
	
func _process(_delta):
	if finished:
		$content/Indicator.visible = true
	else:
		$content/Indicator.visible = false
		
	if finished and sound:
		sound = false
		$sonidos/texto.stop()
	elif not sound:
		$sonidos/texto.play()
		sound = true
		
		
	if Input.is_action_just_pressed("ui_accept"):
		if finished:
			nextPhrase()
		else:
			$content/Text.visible_characters = len($content/Text.text)
	
func getDialog() -> Array:
	var f = File.new()
	assert(f.file_exists(dialogPath),"El path del dialogo no existe")
	
	f.open(dialogPath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	if typeof(output) == TYPE_ARRAY:
		return output
	else:
		return []
		
func nextPhrase() -> void:
	if phraseNum >= len(dialog): #Termina de hablar
		queue_free()
		ScrGlobal.setJugadorHablando(false)
		return
	finished = false
	$content/Name.bbcode_text = dialog[phraseNum]["Name"]
	$content/Text.bbcode_text = dialog[phraseNum]["Text"]
	
	$content/Text.visible_characters = 0
	
	var f = File.new()
	var img = "res://textures/avatares/" + dialog[phraseNum]["Name"] + dialog[phraseNum]["Emotion"] + ".png"
	print(img)
	if f.file_exists(img):
		$content/Portrait.texture = load(img)
	else: $content/Portrait.texture = null
	
	while $content/Text.visible_characters < len($content/Text.text):
		$content/Text.visible_characters += 1
		
		$content/Timer.start()
		yield($content/Timer,"timeout")
	
	finished = true
	phraseNum += 1
	return

