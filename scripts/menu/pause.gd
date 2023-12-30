extends CanvasLayer

@export var ResumeButton : Node

func _input(event) -> void :
	if event.is_action_pressed("pause") :
		if self.visible :
			get_tree().paused = false
			self.hide()
			ResumeButton.become_unselected()
		else :
			get_tree().paused = true
			self.show()
			ResumeButton.become_selected()
