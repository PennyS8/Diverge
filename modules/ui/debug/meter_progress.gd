extends Label

func _process(delta):
	text = str(EnemyManager.focus_meter)
