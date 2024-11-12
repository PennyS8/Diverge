extends Node

signal key(id : int, state : bool)

var num_smallkeys := 0
var num_bigkeys := 0

var timer

func puzzle_chime(audio : AudioStreamPlayer):
	timer = Timer.new()
	
	# so that it plays during pause
	timer.process_mode = Node.PROCESS_MODE_ALWAYS
	audio.process_mode = Node.PROCESS_MODE_ALWAYS
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	timer.timeout.connect(unpause)
	audio.play()
	timer.wait_time = 1.5
	timer.autostart = true
	timer.one_shot = true
	add_child(timer)
	get_tree().paused = true
	
func unpause():
	get_tree().paused = false
	timer.queue_free()
