extends Area2D

var motion := Vector2.ZERO
var findVec := Vector2.ZERO
var speed := 10
var positionPlayer = null #player
var damage := 10

func _ready():
	findVec = ScrGlobal.posJugador - global_position #guardo el vector distancia

func _physics_process(delta):
	motion = Vector2.ZERO
	
	motion = motion.move_toward(findVec,delta) #movimiento del proyectil
	motion = motion.normalized() * speed
	
	position += motion #aumenta la posicion


func _on_ProjectileEnemy_body_entered(body):
	if body.is_in_group("player"): #si el player entra en el area del proyectil pierde vida y el proyectile desparece
		body.recivirDamage(position)
		queue_free()
