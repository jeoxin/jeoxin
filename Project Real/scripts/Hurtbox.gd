extends Area2D

var is_invicible:bool = false setget set_invicible

onready var timer: Timer = $Timer

signal invicibility_started
signal invicibility_ended


func start_invicibility(duration: float):
	self.is_invicible = true
	timer.start(duration)


func set_invicible(value: bool):
	is_invicible = value
	if is_invicible == true:
		emit_signal("invicibility_started")
	else:
		emit_signal("invicibility_ended")
	

func _on_Timer_timeout():
	self.is_invicible = false


func _on_Hurtbox_invicibility_started():
	set_deferred("monitoring", false)


func _on_Hurtbox_invicibility_ended():
	monitoring = true
