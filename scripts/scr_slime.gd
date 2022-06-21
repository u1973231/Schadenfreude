extends enemy


enum stats {jumping,idle}
var currenStat

#Variables export
export var jumpForce := 150.0
export var gravity := 10.0
export var speed = 50
export var distPerseguir = 130

#Variables privadas
var tocandoJugador = false
var jugador
#Control estado jumping
var waitingForJump = false
var isJumping =  false
var yBeforeJump = 0
var movJump := Vector2.ZERO
var dirJump = Vector2.LEFT



func _ready():
	currenStat = stats.jumping
	
	pass 

func _process(_delta):
	
	if tocandoJugador:
		jugador.recivirDamage(position)
	
	#Maquina de estados Slime
	if currenStat == stats.idle:
		$AnimationPlayer.play("idle")		
		pass
	elif currenStat == stats.jumping:
		
		if movJump.x > 0:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
			
		if not isJumping: # esta en el suelo			
			if not waitingForJump:
				$AnimationPlayer.play("idle")
				var rng = RandomNumberGenerator.new()
				rng.randomize()
				$jumpDely.wait_time = rng.randf_range(0.5,1.2)
				$jumpDely.start()
				waitingForJump = true
		else: # esta saltando
			movJump.y += gravity
			move_and_slide(movJump)			
				
			
		pass
	pass
		

func _on_jumpDely_timeout():
	#Animacion
	$sounds/jump.play()
	$AnimationPlayer.play("jump")
	$jumpDuration.start()
	#Establecemos la direccion del salto.
	yBeforeJump = position.y	
	if getDistanciaJugador() <= distPerseguir:
		movJump = getDirJgador()*speed
	else:
		movJump = getDireccionAleatoria()*speed
	movJump.y -= jumpForce

	#Semaforos
	isJumping = true
	waitingForJump = false


func _on_jumpDuration_timeout():	
	isJumping = false
	waitingForJump = false

func getVectorJugador():
	return ScrGlobal.posJugador - position

func getDistanciaJugador():
	var vec = getVectorJugador()
	var mod = sqrt(vec.x * vec.x + vec.y * vec.y)
	return mod
	
	
func getDirJgador():	
	return getVectorJugador().normalized()
	
func getDireccionAleatoria():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1)).normalized()


func _on_damageArea_body_entered(body):
	if body.is_in_group("player"):
		tocandoJugador = true
		jugador = body
	pass # Replace with function body.


func _on_damageArea_body_exited(body):
	if body.is_in_group("player"):
		tocandoJugador = false
	pass # Replace with function body.
