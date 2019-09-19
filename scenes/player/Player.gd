extends KinematicBody2D
const Pistol = preload("res://scenes/weapon/Pistol.tscn")

class_name Player
signal player_moved

var health    = 100
var money     = 0
var inventory = []
var equipped_weapon = null
var speed = 100
var velocity = Vector2()
var player_name = "<UNDEFINED>"
var player_id = -1

const TIMER_LIMIT = 0.5
var timer = 0.0

func _ready():
	emit_signal('player_moved', player_name, position)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('player%d_right' % player_id):
	    velocity.x += 1
	if Input.is_action_pressed('player%d_left' % player_id):
	    velocity.x -= 1
	if Input.is_action_pressed('player%d_down' % player_id):
	    velocity.y += 1
	if Input.is_action_pressed('player%d_up' % player_id):
	    velocity.y -= 1
	velocity = velocity.normalized() * speed
	
	if Input.is_action_just_pressed('player%d_shoot' % player_id):
		equipped_weapon.shoot()

func get_money():
	return money

func get_inventory():
	return inventory

func get_name():
	return player_name
	
func init(init_pos, init_name, init_id):
	position = init_pos
	player_name = init_name
	player_id = init_id
	
	var pistol = Pistol.instance()
	inventory.append(pistol)
	equipped_weapon = pistol
	add_child(pistol)

func _physics_process(delta):
	get_input()

	if velocity.length() > 0:
		move_and_slide(velocity)
		emit_signal('player_moved', player_name, position)
