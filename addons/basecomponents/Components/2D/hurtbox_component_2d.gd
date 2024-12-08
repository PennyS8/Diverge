@icon("../../module.svg")
extends Area2D
class_name HurtBoxComponent2D
## Used for managing when a Node gets hit by a [HitBoxComponent2D].

@export_group("Components")
## Health component used for taking damage.
@export var health_component : HealthComponent

## Signal that is emitted when the HurtBoxComponent2D is hit by a [HitBoxComponent2D].
signal Hit

func _init() -> void:
	monitorable = false
	collision_layer = 0
	
	connect("area_entered", hitbox_entered)

func _ready() -> void:
	pass
	#if (!health_component):
		#printerr("Missing HealthComponent on " + str(get_path()) + "'s HurtBoxComponent")

## Function that is run on a [HitBoxComponent2D] collision.[br]
## Applies the [member HitBoxComponent2D.damage] to the health component
## and emits [signal HurtBoxComponent2D.Hit].
func hitbox_entered(area : Area2D) -> void:
	if (area is HitBoxComponent2D):
		Hit.emit(area)
		
		if (health_component):
			health_component.damage(area.damage)
