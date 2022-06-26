extends "res://scripts/Bullet.gd"
var velocity: Vector2 = Vector2()


onready var sprite: Sprite = $Sprite
onready var raycast: RayCast2D = $RayCast2D
onready var hitbox: Area2D = $Hitbox



func _ready():
	pass

func _physics_process(delta):
	match bullet_dir:
		DIR_X:
			velocity.x = speed * delta * sign(direction.x)
			translate(velocity)
		DIR_Y:
			velocity.y = speed * delta * sign(direction.y)
			translate(velocity)
	
	
	
func _set_direction_x(dirx: Vector2):
	direction = dirx
	raycast.cast_to = dirx
	bullet_dir = DIR_X


func _set_direction_y(diry: Vector2):
	direction = diry
	raycast.cast_to = diry
	hitbox.rotation_degrees = 90
	sprite.rotation_degrees = 90
	sprite.position = Vector2(-0.5, 0.0)
	bullet_dir = DIR_Y


func _on_Hitbox_area_entered(area):
	area -= hitbox.damage


func _on_Hitbox_body_entered(body):
	queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


