extends Node

export(PackedScene) var mob_scene
export(PackedScene) var bullet_scene
var score
var power = 500
var able_to_shoot: bool = false


func _ready():
	randomize()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	able_to_shoot = false


func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	able_to_shoot = true


func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	direction += rand_range(-PI /4, PI/ 4)
	mob.rotation = direction
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and able_to_shoot:
		var bullet = bullet_scene.instance()
		bullet.position = $Player.position
		bullet.apply_central_impulse($Player.position.direction_to(get_viewport().get_mouse_position()) * power)
		add_child(bullet)
