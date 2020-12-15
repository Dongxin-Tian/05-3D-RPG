extends Button

onready var t = get_node("/root/GamePlay/Label")
onready var door = get_node("/root/GamePlay/Door")

var index = 0

func _on_Button_pressed():
	index += 1
	
	if index == 1:
		t.text = "Kaishu: What about you guys?"
	elif index == 2:
		t.text = "Others: Just leave us alone. You are the only SQW \nthat can escape from this lab. We believe in you!"
	elif index == 3:
		t.text = "Kaishu: But..."
	elif index == 4:
		t.text = "Others: Remember, the system has sent red robots to \ndestroy you. Defend yourself with the pistol you have! \nThere's no time, just go! We'll shut the door for you.\nThe exit in in front of you, just jump out!"
		$Tween.interpolate_property(door, "translation", Vector3(0, -3, 2), Vector3(0, -1, 2), 1.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.start()
		get_node("/root/GamePlay/Sound").play()
		self.text = "Leave"
	elif index == 5:
		get_tree().change_scene("res://Scenes/Game.tscn")
