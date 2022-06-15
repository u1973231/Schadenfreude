extends KinematicBody2D


#Variables exportadas
export var velocidad := 100.0
export var vida = 6
export var hitNokback = 250
#Variables privadas
var vecMov := Vector2.ZERO
var inmune = false
var animationHit = false
var stun = false
var posHit
func _ready():
	pass 
	
func _process(delta):
	if not stun:
		movePlayer()
	else:
		moveStun()
	
	ScrGlobal.posJugador = position
	
	pass

func moveStun():
	var dir = position - posHit
	dir = dir.normalized()
	move_and_slide(dir*hitNokback)
	pass
	
	
func movePlayer():
	#Movimiento Jugador
	vecMov.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
	vecMov.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	vecMov.y /= 2
	vecMov = vecMov.normalized() * velocidad
	move_and_slide(vecMov)
	
	#Animaciones
	if not animationHit:
		if vecMov.x > 0:
			$AnimationPlayer.play("walk")
			$Sprite.flip_h = false
		elif vecMov.x < 0:
			$AnimationPlayer.play("walk")
			$Sprite.flip_h = true
		elif vecMov.y != 0:
			$AnimationPlayer.play("walk")
		else:
			$AnimationPlayer.play("idle")
	else:
		$AnimationPlayer.play("hit")
	
func recivirDamage(posSurce):
	if not inmune:
		posHit = posSurce
		vida -= 1
		inmune = true
		animationHit = true
		stun = true
		$stun.start()
		$animationHit.start()
		print(vida) 
		$inmune.start()


func _on_inmune_timeout():
	inmune = false


func _on_animationHit_timeout():
	animationHit = false
	pass # Replace with function body.


func _on_stun_timeout():
	stun = false
	pass # Replace with function body.
