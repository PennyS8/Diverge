@icon("../../module.svg")
extends Area2D
class_name HitBoxComponent2D
## Used for hitting [HurtBoxComponent2D]'s and applying damage to their [HealthComponent],[br]
##[i](if specified inside [HurtBoxComponent2D])[/i].

## Amount of damage to deal to a [HurtBoxComponent2D]'s [HealthComponent],[br]
##[b](if specified inside [HurtBoxComponent2D])[/b].
@export var damage := 10

func _init() -> void:
	monitoring = false
	collision_mask = 0
