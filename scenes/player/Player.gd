extends KinematicBody2D

class_name Player
signal player_moved

var health    = 100
var money     = 0
var inventory = []
var speed = 100
var velocity = Vector2()
var player_name = "<UNDEFINED>"

const TIMER_LIMIT = 0.5
var timer = 0.0

func _ready():
	emit_signal('player_moved', player_name, position)

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('player_right'):
	    velocity.x += 1
	if Input.is_action_pressed('player_left'):
	    velocity.x -= 1
	if Input.is_action_pressed('player_down'):
	    velocity.y += 1
	if Input.is_action_pressed('player_up'):
	    velocity.y -= 1
	velocity = velocity.normalized() * speed

func get_money():
	return money

func get_inventory():
	return inventory

func get_name():
	return player_name
	
func init(init_pos, init_name):
	position = init_pos
	player_name = init_name
	inventory.append(Pistol.new())

func _physics_process(delta):
	get_input()
	
	timer += delta
	if timer > TIMER_LIMIT: # Prints every 2 seconds
		timer = 0.0
		print("fps: " + str(Engine.get_frames_per_second()))

	if velocity.length() > 0:
		if player_name == 'Player1':
			move_and_slide(velocity)
			emit_signal('player_moved', player_name, position)
