extends Node2D
class_name Bullet

var direction: Vector2 = Vector2()
export var speed: int = 200

enum {DIR_X, DIR_Y}
var bullet_dir = DIR_X
