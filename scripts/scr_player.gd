extends KinematicBody2D


#Variables exportadas
export var velocidad := 100.0
export var vida = 6
export var hitNokback = 250
export var dashSpeed = 600.0
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

func _ready():
	arrow = preload("res://scenes/arrow.tscn")
	pass 

	
func _process(delta):
	
	
	
	if not stun and not dashing:
		movePlayer()
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
	
	
func movePlayer():
	#Movimiento Jugador
	vecMov.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
	vecMov.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	vecMov.y /= 2
	vecMov = vecMov.normalized() * velocidad
	move_and_slide(vecMov)
	
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

func lanzarFlecha():
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
	
