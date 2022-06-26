extends KinematicBody2D

export (float) var speed = 100.0
export (float) var jump_power = 140.0
export (float) var jump_power2 = 100
export (float) var gravity = 6
export (bool) var has_weapon = false setget _set_has_weapon
export (int) var max_health = 3
export (int) var health = 3
export (int) var max_ammo = 3
export (int) var ammo = 3

var dir: float
var velocity: Vector2 = Vector2()
var extra_velocity: Vector2 = Vector2()
var playback: AnimationNodeStateMachinePlayback

var jump_state
enum {JUMP0, JUMP1}

var my_bullets = preload("res://scenes/BasicBullet.tscn")

onready var player_sprite: Sprite = $Body
onready var player_weapon_sprite: Sprite = $Body/Gun 
onready var animplayer: AnimationPlayer = $AnimationPlayer
onready var animtree: AnimationTree = $AnimationPlayer/AnimationTree
onready var muzzle: Position2D = $Muzzle
onready var muzzle_b: Position2D = $MuzzleB
onready var bottom_raycast: RayCast2D = $BottomRaycast



func _ready():
	playback = animtree.get("parameters/playback")
	
	if has_weapon == false:
		player_weapon_sprite.visible = false
	else:
		player_weapon_sprite.visible = true
	
	
func _physics_process(delta: float):
	get_input(delta)
	apply_gravity()
	set_jump_condition()
	player_animation()
	velocity = move_and_slide(velocity, Vector2.UP)
	$Label.set_text(str(ammo))

	
func get_input(_delta: float):
	dir = sign(Input.get_action_strength("ui_right")) - sign(Input.get_action_strength("ui_left"))
	if dir != 0:
		velocity.x = speed * dir
	else:
		velocity.x = speed * dir
		
	if Input.is_action_just_pressed("z") and has_weapon == true:
		fire()
		ammo -= 1

	
func fire():
	var bullet = my_bullets.instance()
	get_parent().add_child(bullet)
	bullet._set_direction_x(Vector2(sign(muzzle.position.x), 0.0))
	bullet.global_position = muzzle_b.global_position


func fire_b():
	var bullet = my_bullets.instance()
	get_parent().add_child(bullet)
	bullet._set_direction_y(Vector2(0.0, sign(muzzle_b.position.y)))
	bullet.global_position = muzzle_b.global_position
	
	
func jump_input():
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			velocity.y = -jump_power
			playback.travel("jump")
			
	
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y = 0
	
	if Input.is_action_just_released("ui_accept"):
		jump_state = JUMP1

	
func jump_input2():
	if Input.is_action_just_pressed("ui_accept") and ammo > 0:
		if has_weapon == true:
			velocity.y = -jump_power2
			fire_b()
			ammo -= 1
			animtree.set("parameters/conditions/boost", true)
			animtree.set("parameters/conditions/fall to boost", true)
	elif Input.is_action_just_released("ui_accept"):
		animtree.set("parameters/conditions/fall to boost", false)
			
	
func set_jump_condition():
	if is_on_floor():
		animtree.set("parameters/conditions/boost", false)
		animtree.set("parameters/conditions/fall to boost", false)
		jump_state = JUMP0
		ammo = max_ammo
	match jump_state:
		JUMP0:
			jump_input()
		JUMP1:
			jump_input2()
			

func apply_gravity():
	velocity.y += gravity
	
	
func player_animation():
	if dir == 1:
		player_sprite.flip_h = false
		player_weapon_sprite.flip_h = false
		muzzle.position.x = 7
		muzzle_b.position.x = 6
	elif dir == -1:
		player_sprite.flip_h = true
		player_weapon_sprite.flip_h = true
		muzzle.position.x = -7
		muzzle_b.position.x = -6
	if is_on_floor():
		if dir != 0:
			playback.travel("walk")
		else:
			playback.travel("idle")
	elif not is_on_floor():
		if velocity.y > 0:
			playback.travel("fall")
		else:
			playback.travel("jump")


func _set_has_weapon(value: bool):
	has_weapon = value
	player_weapon_sprite.visible = true
