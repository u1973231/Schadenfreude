extends enemy

export (float) var MAXSPEED := 100.0

onready var projectile := preload("res://scenes/ProjectileEnemy.tscn")

var motion := Vector2.ZERO
var playerIn := false
var playerIn2 := false
var positionPlayer = null
var posicionInicio
onready var path_follow = get_parent()

func _ready(): #comienza moviéndose
	motion.x = MAXSPEED
	motion.y = MAXSPEED
	posicionInicio = path_follow.get_parent().get_parent().position
	print(posicionInicio)
	pass

func _process(delta):

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
		
		path_follow.set_offset(path_follow.get_offset() + MAXSPEED * delta)
		$AnimationPlayer.play("Run")
		pass
		
	
	motion = move_and_slide(motion)

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
		

func _on_Area2D2_body_entered(body):
	playerIn2 = true
	pass # Replace with function body.


func _on_Area2D2_body_exited(body):
	playerIn2 = false
	pass # Replace with function body.
