extends CanvasLayer

func _process(_delta):
	#Muestra el valor de la vida en el HUD
	$TextureProgress.value = get_parent().get_node("Player").vida
	pass
