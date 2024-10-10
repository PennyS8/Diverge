extends CharacterBody2D


# Please, don't re-use this code, it is just a joke!

@export var speed := 60.0
var dir = 1


func _ready():
	velocity.x = speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if get_slide_collision_count() > 0:
		dir *= -1
		$AnimatedSprite.scale.x = dir
		velocity.x = dir * speed
	move_and_slide()
