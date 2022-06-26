extends Node2D



func _ready():
	pass




func _on_Area2D_body_entered(body):
	body._set_has_weapon(true)
	queue_free()
