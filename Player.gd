extends Area2D
signal hit

export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
onready var barrel: Line2D = $Barrel

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y > 0

#	print($Barrel.point.to_global($Barrel.point.position))


func _on_Player_body_entered(body):
	if "mobs" in body.get_groups():
		hide()
		emit_signal("hit")
		$CollisionShape2D.set_deferred("disabled", true)


func start(pos: Vector2):
	position = pos
	show()
	$CollisionShape2D.disabled = false
