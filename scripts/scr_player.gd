extends KinematicBody2D


#Variables exportadas
var velocidad := 100.0

#Variables privadas
var vecMov := Vector2.ZERO

func _ready():
	pass 
	
func _process(delta):
	
	movePlayer()
	
	
	pass
	
func movePlayer():
	#Movimiento Jugador
	vecMov.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
	vecMov.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	vecMov.y /= 2
	vecMov = vecMov.normalized() * velocidad	
	move_and_slide(vecMov)

