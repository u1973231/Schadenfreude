extends Node2D


#variables exports
export var damage = 5
export var speed = 600

#Variables privadas
var dir = Vector2.RIGHT

func _ready():
	rotation = dir.angle()
	pass 

func _process(delta):
	position += dir * speed * delta
	

func setDir(direction):
	dir = direction.normalized()


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		body.recivirDamage(damage,position)
		queue_free()
	pass # Replace with function body.
