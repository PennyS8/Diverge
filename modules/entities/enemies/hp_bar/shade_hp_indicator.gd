extends Node2D

@export var num_hp_max : int
var num_current : int

@export var hp_indicators : Array[Texture2D]
@export var health_component : HealthComponent

var current_heart_nodes : Array[TextureRect]
var shade_hp = preload("res://modules/entities/enemies/hp_bar/shade_hp.tscn")

@onready var hbox = %HBoxContainer
@onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	if !health_component:
		print("Need to assign a health component to the HP indicator!")
		return
	
	health_component.update_complete.connect(hp_update)
	num_hp_max = ceil(health_component.max_health / 10.0)
	
	for i in range(1, num_hp_max+1):
		var heart : TextureRect = shade_hp.instantiate()
		hbox.add_child(heart)
		current_heart_nodes.append(heart)
		
		heart.texture = hp_indicators.pick_random()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func hp_update():
	$AnimationPlayer.play("fade_in")
	num_current = ceil(health_component.health / 10.0)
	for heart : TextureRect in current_heart_nodes.slice(num_current, num_hp_max):
		var tween = create_tween()
		tween.tween_property(heart, "modulate:a", 0, 0.1)
	timer.start()

func timer_timeout():
	$AnimationPlayer.play("fade_out")
	
