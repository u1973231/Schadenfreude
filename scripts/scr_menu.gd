extends Control

func _on_Start_pressed():
	get_tree().change_scene("res://scenes/Mapa.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Menu_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
