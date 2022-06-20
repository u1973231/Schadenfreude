extends enemy

export (float) var MAXSPEED := 100.0

onready var projectile := preload("res://scenes/ProjectileEnemy.tscn")

var motion := Vector2.ZERO
var playerIn := false
var playerIn2 := false
var positionPlayer = null
var rng = RandomNumberGenerator.new()
var posicionInicio
onready var path_follow = get_parent()
#signal pathActivate()

func getDireccionAleatoria(): 
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return Vector2(rng.randf_range(-1,1),rng.randf_range(-1,1)).normalized()

func _ready(): #comienza moviéndose
	motion.x = MAXSPEED
	motion.y = MAXSPEED
	posicionInicio = path_follow.get_parent().get_parent().position
	print(posicionInicio)
	pass

func _process(delta):
	#motion = getDireccionAleatoria()
	#_change_direction()
	motion = Vector2.ZERO
	
	if positionPlayer != null: #si player esta en el area de rastreo el enemigo lo persigue
		if not playerIn2:
			motion = position.direction_to(positionPlayer.position) * MAXSPEED
			var posicionEnemigo = position + path_follow.position
			posicionEnemigo = posicionEnemigo + posicionInicio
			motion = posicionEnemigo.direction_to(positionPlayer.position) * MAXSPEED
			$AnimationPlayer.play("Run")
		else:
			$AnimationPlayer.play("Idle")
	else:
		
		#emit_signal("pathActivate")
		path_follow.set_offset(path_follow.get_offset() + MAXSPEED * delta)
		
		$AnimationPlayer.play("Run")
		#_walk()
		#motion = move_and_slide(motion)
		#$Idle.set_wait_time(1)
	#	print("Enter")
	
		pass
		
	
	motion = move_and_slide(motion)

#func _physics_process(delta):
	

func _walk():
	print(motion)
	$AnimationPlayer.play("Run")
	$Walk.set_wait_time(1)
	motion = move_and_slide(motion)

func _walk_right():
	var positionCurrent = false
	if position.x > MAXSPEED+100:
		positionCurrent = true
	return position

func _walk_left():
	var positionCurrent = false
	if position.x < MAXSPEED-100:
		positionCurrent = true
	return positionCurrent
	
func _walk_up():
	var positionCurrent = false
	if position.x > MAXSPEED+100:
		positionCurrent = true
	return positionCurrent
		
func _walk_down():
	var positionCurrent = false
	if position.y < MAXSPEED-100:
		positionCurrent = true
	return positionCurrent

func _change_direction():
	rng.randomize() #crea una direccion aleatoria
	motion.x = (rng.randf_range(-1,1)) * MAXSPEED
	motion.y = (rng.randf_range(-1,1)) * MAXSPEED
	return motion
	print(motion)

func _fire_projectile():
	var bullet = projectile.instance() #instanciamos el proyectile y lo insertamos en la escena
	bullet.position = position
	bullet.positionPlayer = positionPlayer
	get_parent().add_child(bullet)
	$Fire.set_wait_time(1) #cada segundo se lanza un proyectil

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"): #si el player entra e
		playerIn = true
		positionPlayer = body
		print("player in")
		
func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		print("player out")
		playerIn = false
		positionPlayer = null

func _on_Fire_timeout():
	if playerIn == true:
		_fire_projectile()
		
#func _die():
#	if vida	<= 0:
		#$Fire.set_wait_time(0.6)
		#$AnimationPlayer.play("Death")
#		recivirDamage(damage,position)

#func _on_Walk_timeout():
#	$AnimationPlayer.play("Run")
#	_change_direction()
#	print("WALK HERE")
#	return motion

#func _on_Idle_timeout():
#	motion = Vector2.ZERO
#	$AnimationPlayer.play("Idle")
#	print("IDLE HERE")





func _on_Area2D2_body_entered(body):
	playerIn2 = true
	pass # Replace with function body.


func _on_Area2D2_body_exited(body):
	playerIn2 = false
	pass # Replace with function body.
