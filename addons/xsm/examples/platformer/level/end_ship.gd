extends Area2D


var sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite = $AnimatedSprite
	sprite.play("Idle")


func fly_away():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:x", 1500.0, 4.0)
	tween.parallel().tween_property(self, "position:y", -1000.0, 4.0)


func _on_EndArea2D_body_entered(body:Node):
	if body is CharacterBody2D:
		sprite.animation = "Open"


func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "Open":	
		sprite.animation = "Close"
		sprite.play()
	elif sprite.animation == "Close":	
		get_node("%ExplanationEnd").show()
		fly_away()