class_name enemy
extends KinematicBody2D

#variables export
export var vida := 7
export var damage = 5


func morir():
	queue_free()
	
func recivirDamage(damage,posDamage):
	vida -= damage
	if vida <= 0:
		morir()
		
func hacerDamage(objetivo):
	objetivo.recivirDamage(damage)
	pass
