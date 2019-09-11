extends KinematicBody2D

class_name Player

var health    = 100
var money     = 0
var inventory = []
var speed = 100
var velocity = Vector2()

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

func _ready():
	inventory.append(Pistol.new())

func _physics_process(delta):
	get_input()
	move_and_slide(velocity)