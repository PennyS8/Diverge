@icon("res://addons/basecomponents/module.svg")
extends Node2D
class_name YarnableComponent

## Defines the yarn behavior on this object
@export var yarn_behavior : YarnBehavior

## The point that the yarn visually (and physics-ally) latches to, relative to component location
@export var knot_point : Vector2

func rip_it(end_position : Vector2):
	yarn_behavior.rip_it(get_parent(), knot_point, end_position)
