class_name enemy
extends KinematicBody2D

#variables export
export var vida := 7
export var damage = 5


func morir():
	comprovarMisiones()
	queue_free()
	
func recivirDamage(damage,posDamage):
	vida -= damage
	if vida <= 0:
		morir()
		
func hacerDamage(objetivo):
	objetivo.recivirDamage(damage)
	pass

func comprovarMisiones():
	var i = 0
	var ma = ScrGlobal.misionesAceptadas
	var m = ScrGlobal.misiones
	while i < len(ma):
		if m[ma[i]]["Tipo"] == "matar" and m[ma[i]]["Objetivo"] == "slime":
			ScrGlobal.misionesProgreso[i] += 1
			print("+1 Slime")
			pass			
		i += 1
	pass
