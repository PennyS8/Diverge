@tool
extends BTAction

@export var attack_damage: float = 10.0
@export var attack_cooldown: float = 1.0
@export var attack_range: float = 50.0

var _time_since_attack: float = 0.0

func _generate_name() -> String:
	return "AttackTarget damage: %.0f cooldown: %.1fs" % [attack_damage, attack_cooldown]

func _tick(p_delta: float) -> Status:
	_time_since_attack += p_delta
	
	var target = blackboard.get_var("target_player")
	if not target:
		return FAILURE
	
	var distance = agent.global_position.distance_to(target.global_position)
	if distance > attack_range:
		return FAILURE
	
	if _time_since_attack >= attack_cooldown:
		# Face the target
		agent.look_at(target.global_position)
		
		# Perform attack
		if target.has_method("take_damage"):
			target.take_damage(attack_damage)
		
		# Play attack animation if available
		if agent.has_node("AnimationPlayer"):
			agent.get_node("AnimationPlayer").play("attack_right")
		
		_time_since_attack = 0.0
		return SUCCESS
	
	return RUNNING
