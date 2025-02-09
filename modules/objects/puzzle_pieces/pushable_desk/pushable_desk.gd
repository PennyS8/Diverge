extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var frames = sprite.texture.get_width() / sprite.region_rect.size.x

var pushing := false

# TODO: Figure out how to pass the specific sprite texture in the future
# to allow for multiple desk sprites.
func _ready() -> void:
	var random = randi_range(0, frames - 1)
	sprite.region_rect.position.x = random * sprite.region_rect.size.x
	

func push(area: HitBoxComponent2D):
	var direction = area.get_parent().swing_dir
	direction = direction * $BodyCollider.shape.size.x
	if !move_and_collide(direction, true):
		if !pushing:
			pushing = true
			var twe = create_tween()
			twe.tween_property(self, "global_position", global_position + direction, 0.2)
			twe.finished.connect(set.bind("pushing", false))
