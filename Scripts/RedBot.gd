extends KinematicBody

var hp = 5
onready var player = get_node("/root/GamePlay/Kaishu")

# Called when the node enters the scene tree for the first time.
func die():
	hp -= 1
	get_node("/root/GamePlay/Audios/Hit").play()
	if hp <= 0:
		queue_free()


func _process(delta):
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	var g_vec_to_player = player.get_global_transform().origin - get_global_transform().origin
	g_vec_to_player = g_vec_to_player.normalized()
	move_and_collide(vec_to_player * 1 * delta)

