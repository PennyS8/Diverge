extends Area2D


var sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $AnimatedSprite
	sprite.play("Idle")


func _on_ShardArea2D_body_entered(body:Node):
	if body is CharacterBody2D:
		sprite.animation = "Explosion"
		get_node("%ExplanationDash").show()
		$Particles2D.emitting = true


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Explosion":	
		sprite.hide()
		monitoring = false
