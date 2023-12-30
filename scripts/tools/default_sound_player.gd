extends AudioStreamPlayer

var loop : bool = false



func _on_finished() -> void :
	if not(loop) :
		queue_free()
		return
	self.play()
