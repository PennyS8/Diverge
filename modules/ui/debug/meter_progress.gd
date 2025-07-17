extends Label

func _process(_delta):
	text = str(EnemyManager.focus_meter)
