extends Sprite

onready var path_follow = get_parent()

export var speed := 100

func _physics_process(delta):
	path_follow.set_offset(path_follow.get_offset() + speed * delta)
	get_parent().get_parent().get_parent().get_node("AnimationPlayer").play("Run")
 
