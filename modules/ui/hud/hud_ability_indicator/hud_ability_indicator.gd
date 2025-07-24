extends CenterContainer

@onready var progress_bar = $TextureProgressBar

func _ready():
	progress_bar.min_value = EnemyManager.MIN_METER
	progress_bar.max_value = EnemyManager.MAX_METER
	
	EnemyManager.focus_updated.connect(update_value)

func update_value(new_value):
	progress_bar.value = new_value
