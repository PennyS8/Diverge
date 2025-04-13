extends Context
class_name AISteering

# Godot is funny about _inits with parameters. So we need to pass it along.
func _init(size := 16):
	super._init(size)

# Adds desirability towards a given angle
func apply_seek(seek_angle : float, weight := 1.0):
	# Save processing if this is going to zero out
	if is_zero_approx(weight):
		return
	
	# Angle difference between directions
	var separation = 2 * PI / context.size()
	for i in context.size():
		# -INF means we will never go this direction, so ignore this direction
		if context[i] == -INF:
			continue
		var angle = i * separation
		# Use dot product to get desirability of this direction
		var dot = cos(seek_angle - angle)
		# Normalize the dot value between 0 and 1
		dot = (dot + 1) * 0.5
		# Apply desirability
		context[i] += dot * weight

# Fleeing is just seeking safety from danger.
func apply_flee(from_angle : float, weight := 1.0):
	apply_seek(from_angle + PI, weight)

# Avoids walls
func apply_collision_avoidance(body : CharacterBody2D, distance : float, repel := false):
	var separation = 2 * PI / context.size()
	var v = Vector2()
	for i in context.size():
		var angle = i * separation
		var vel = Vector2(distance, 0).rotated(angle)
		# Test move in every direction to detect for walls
		# May not be the best performance wise, but will be accurate
		if body.test_move(body.global_transform, vel):
			# If collision then -INF will make sure we don't use this direction
			context[i] = -INF
			# Accumulate normal if we wish to move away from walls
			v += Vector2.RIGHT.rotated(angle + PI)
	# If moving away from walls then seek away
	if repel && v != Vector2.ZERO:
		apply_seek(v.angle())

# Moves away from nearby nodes
func apply_separation(position : Vector2, neighbors : Array, radius : float, weight := 1.0):
	if neighbors.size() == 0 || weight <= 0:
		return
	
	var away = Vector2()
	for neighbor in neighbors:
		var displacement = position - neighbor.global_position
		var distance = displacement.length()
		# If directly over top of something then pick a random direction
		if is_zero_approx(distance):
			away += Vector2.RIGHT.rotated(randf_range(-PI, PI))
		# Else move away from
		elif distance < radius:
			var factor = 1.0 - (distance / radius)
			away += displacement.normalized() * factor
	
	# Use accumulated vectors to seek away
	if away != Vector2.ZERO:
		apply_seek(away.angle(), weight)

# Aligns with the velocity of nearby entities so that we move as one
func apply_alignment(position : Vector2, neighbors : Array, radius : float, weight := 1.0):
	if neighbors.size() == 0 || weight <= 0:
		return
	
	var v = Vector2()
	var sum = 0
	for neighbor in neighbors:
		var displacement = neighbor.global_position - position
		var distance = displacement.length()
		if distance < radius:
			v += neighbor.velocity
			sum += 1
	
	if sum > 0:
		v /= sum
	
	if v != Vector2.ZERO:
		apply_seek(v.angle(), weight)

# Moves towards nearby entities so we group together
func apply_cohesion(position : Vector2, neighbors : Array, radius : float, weight := 1.0):
	if neighbors.size() == 0 || weight <= 0:
		return
	
	var v = Vector2()
	var sum = 0
	for neighbor in neighbors:
		var displacement = neighbor.global_position - position
		var distance = displacement.length()
		if distance < radius:
			v += neighbor.global_position - position
			sum += 1
	
	if sum > 0:
		v /= sum
	
	if v != Vector2.ZERO:
		apply_seek(v.angle(), weight)

func apply_strafe(target_angle : float, weight := 1.0):
	if weight <= 0:
		return
	
	var separation = 2 * PI / context.size()
	for i in context.size():
		if context[i] == -INF:
			continue
		
		var angle = i * separation
		var dot = cos(target_angle - angle)
		var modifier = 1.0 - pow(abs(dot + 0.25), 2.0)
		context[i] += (dot + 1) * 0.5 * modifier * weight
