extends KinematicBody2D


#Variables exportadas
export var velocidad := 6000.0
export var vida = 6
export var hitNokback = 250
export var dashSpeed = 600.0
export var exterior = false
#Variables privadas
var vecMov := Vector2.ZERO
var inmune = false
var animationHit = false
var stun = false
var posHit
var arrow
var disparar = true
var dashing = false
var dash = true
var caminando = false
var sonidoPasos = false
var muerto = false



func _ready():
	arrow = preload("res://scenes/arrow.tscn")
	pass 

	
func _process(delta):
	
	if caminando and not sonidoPasos:
		if exterior:
			$Sonidos/pasosHierba.play()
		else:
			$Sonidos/pasosMadera.play()
			
		sonidoPasos = true
	elif not caminando:
		if exterior:
			$Sonidos/pasosHierba.stop()
		else:
			$Sonidos/pasosMadera.play()
		sonidoPasos = false
	
	if not ScrGlobal.getJugadorHablando() and not muerto:
		if not stun and not dashing:
			movePlayer(delta)
		elif stun:
			moveStun()
		elif dashing:
			dash(delta)
		
		if Input.is_action_pressed("atacar") and disparar:
			lanzarFlecha()
			disparar = false
			$disparar.start()
		
		
		if Input.is_action_just_pressed("dash") and dash:
			dashing = true
			dash = false
			set_collision_mask_bit(1, false) #Desactivamos la colision para los enemigos
			$dash.start()
			$dashCD.start()
	
	ScrGlobal.posJugador = position
	
	if vida <= 0 and not muerto:
		$menuMuero.start()
		muerto = true
	
	if muerto:
		$AnimationPlayer.play("muerte")
	
	pass

func dash(delta):
	var dirDash = vecMov * dashSpeed * delta
	move_and_slide(dirDash)
	pass

func moveStun():
	var dir = position - posHit
	dir = dir.normalized()
	move_and_slide(dir*hitNokback)
	pass
	
	
func movePlayer(delta):
	#Movimiento Jugador
	vecMov.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
	vecMov.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	vecMov.y /= 2
	vecMov = vecMov.normalized() * velocidad 
	if vecMov != Vector2.ZERO:
		caminando = true
	else: 
		caminando = false
	vecMov = move_and_slide(vecMov)
	
	
	#Animaciones
	if not animationHit and not dashing:
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
	elif animationHit:
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
		$inmune.start()
		$Sonidos/hit.play()


func _on_inmune_timeout():
	inmune = false


func _on_animationHit_timeout():
	animationHit = false
	pass # Replace with function body.


func _on_stun_timeout():
	stun = false
	pass # Replace with function body.

func lanzarFlecha():
	$Sonidos/arco.play()
	var mouse = get_global_mouse_position()
	var dir = mouse - position
	var inst = arrow.instance()
	inst.setDir(dir)
	add_child(inst)
	pass



func _on_disparar_timeout():
	disparar = true



func _on_dash_timeout():
	dashing = false
	set_collision_mask_bit(1, true) #Activamos la colision para los enemigos



func _on_dashCD_timeout():
	dash = true
	


func _on_menuMuero_timeout():
	get_tree().change_scene("res://scenes/GameOver.tscn")
	pass # Replace with function body.
