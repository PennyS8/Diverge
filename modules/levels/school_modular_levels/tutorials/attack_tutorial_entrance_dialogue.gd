extends Area2D

var read : bool = false
@onready var shade = $"../ComplexShade"
@onready var player = get_tree().get_first_node_in_group("player")
@onready var door = $"../HallRightNorthEast"

var shade_spikes : Array[Vector2]
var juniper_spikes : Array[Vector2]

var darkness_end_color : Color = Color(0.149, 0.137, 0.337)

func _ready():
	for spike in $"../Spikes/Shade".get_children():
		shade_spikes.append(spike.global_position)
	
	for spike in $"../Spikes/Juniper".get_children():
		juniper_spikes.append(spike.global_position)
		
	shade.get_node("%Health").Died.connect(tutorial_done)

func _on_body_entered(_body: Node2D) -> void:
	if read: # Don't allow this dialogue to be read more than once
		return
	
	read = true
	
	player.dir = Vector2.ZERO
	player.get_node("PlayerFSM").disabled = true

	var tween = create_tween()
	tween.tween_interval(2.0)
	tween.tween_property($"../CanvasLayer/TransOverlay", "modulate:a", 0.0, 3.0)
	
	await tween.finished
	

	var dialogue = load("res://modules/dialogue/demo_scenes.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "hiding_away", [self])
	player.get_node("PlayerFSM").disabled = false
	player.dir = Vector2.ZERO
	await DialogueManager.dialogue_ended
	
	player.get_node("PlayerFSM").change_state("CanDash")
	player.get_node("PlayerFSM").change_state("CanAttack")

	LevelManager.enter_tutorial("AttackTutorial")
	
func move_shade(global_point, speed : float = 30.0) -> void:
	var dist = shade.global_position.distance_to(global_point)
	
	var tween = create_tween()
	tween.tween_property(shade, "global_position", global_point, dist / speed)
	
	await tween.finished

func tutorial_done():
	var tween = create_tween()
	tween.tween_property($"../Lighting/CanvasModulate", "color", Color.WHITE, 1.0)
	$"../Lighting/PointLight2D".hide()
	var dialogue = load("res://modules/dialogue/demo_scenes.dialogue")
	DialogueManager.show_dialogue_balloon(dialogue, "tutorial_done", [self])

func darken_lighting():
	var tween : Tween = create_tween()
	tween.tween_property($"../Lighting/CanvasModulate", "color", darkness_end_color, 5.0)
	tween.parallel().tween_property($"../Lighting/PointLight2D", "energy", 1.0, 5.0)
	#tween.
