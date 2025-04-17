@icon("../module.svg")
extends Node
class_name HealthComponent
## Used for managing a Node's health. 

## Total/maximum amount of health.
@export var max_health := 10

## Current amount of health,[br]
## [b]Default is [member HealthComponent.max_health][/b].
@onready var health := max_health

## Added reference to HUD
@onready var heart_hud = get_tree().get_first_node_in_group("gui")

# Stores parent node
@onready var parent = get_parent()

## Boolean for if the Node is alive or dead.
var alive := true

signal update_complete

## Signal that is emitted when the Node dies.
signal Died

## Reduces the [member HealthComponent.health] by the amount specified,[br]
## and will kill if the [member HealthComponent.health] reaches 0.
func damage(amount := 0) -> void:
	if alive: 
		# Checks that parent is player in order to prevent HUD from being updated by
		# boxes and enemies
		if parent.is_in_group("player"):
			heart_hud.heart_damage(amount)
		
		health = clamp(health - abs(amount), 0, max_health)
		
		if health <= 0: kill()
	else: print(owner.name + " is already dead!")
	update_complete.emit()

## Increases the [member HealthComponent.health] by the amount specified,[br]
## and will not go higher than [member HealthComponent.max_health].
func heal(amount := 0) -> void:
	if alive: 
		# Checks that parent is player in order to prevent HUD from being updated by
		# boxes and enemies
		if parent.is_in_group("player"):
			heart_hud.heart_heal(amount)
		
		health = clamp(health + abs(amount), 0, max_health)
	else: print(owner.name + " is already dead!")
	update_complete.emit()

## Kills the Node, which emits the [signal HealthComponent.Died],
## sets [code]health = 0[/code], and [code]alive = false[/code].
func kill() -> void:
	Died.emit()
	health = 0
	alive = false
