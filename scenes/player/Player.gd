extends KinematicBody2D
const Pistol = preload("res://scenes/weapon/Pistol.tscn")
const Shotgun = preload("res://scenes/weapon/Shotgun.tscn")
const AssaultRifle = preload("res://scenes/weapon/AssaultRifle.tscn")
const Sniper = preload("res://scenes/weapon/Sniper.tscn")
class_name Player
signal player_moved
signal open_store

var health = 100
var money = 0
var inventory = []
var equipped_weapon = null
var speed = 100
var velocity = Vector2()
var player_name = "<UNDEFINED>"
var player_id = -1
var burning = false
var burn_damage = 0

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
	if Input.is_action_just_pressed('player%d_open_store' % player_id):
		emit_signal('open_store', self)
		
	velocity = velocity.normalized() * speed
	
	if not equipped_weapon.is_automatic() and Input.is_action_just_pressed('player%d_shoot' % player_id):
		equipped_weapon.shoot()
	if equipped_weapon.is_automatic() and Input.is_action_pressed('player%d_shoot' % player_id):
		equipped_weapon.shoot()
		
func get_money():
	return money
	
func add_money(amount):
	money = max(money + amount, 0)
	
func get_health():
	return health
	
func add_to_inventory(weapon):
	inventory.append(weapon)
	
# Get an array of Weapon objects that the player currently owns
func get_inventory():
	return inventory
	
func has_weapon(weapon_name):
	for player_weapon in inventory:
		if player_weapon.get_name() == weapon_name:
			print("has_weapon(): ", player_weapon.get_name(), " ", weapon_name)
			return true
	return false

func get_name():
	return player_name
	
func get_sprite():
	var player_sprite = get_node("Sprite")
	return player_sprite
	
func take_damage(damage):
	health -= damage
	print('player took %f damage, current health: %f' % [damage, health])

func inflict_burn(damage_per_second, duration):
	if not burning:
		burning = true
		$FireSprite.show()
		burn_damage = damage_per_second
		$BurnTimer.start(duration)
	else:
		burn_damage = max(damage_per_second, burn_damage)
		$BurnTimer.set_wait_time(max(duration, $BurnTimer.get_time_left()))
	
func init(init_pos, init_name, init_id):
	position = init_pos
	player_name = init_name
	player_id = init_id
	
	# Set the default weapon to Pistol
	var pistol = Pistol.instance()
	inventory.append(pistol)
	add_child(pistol)
	
	# Debug
	var ar = AssaultRifle.instance()
	var sniper = Sniper.instance()
	var shotgun = Shotgun.instance()
	inventory.append(ar)
	inventory.append(sniper)
	inventory.append(shotgun)
	add_child(ar)
	add_child(sniper)
	add_child(shotgun)

	equipped_weapon = pistol
	add_to_group('player')

func _physics_process(delta):
	get_input()
	
	if burning:
		take_damage(delta * burn_damage)
		
	if velocity.length() > 0:
		move_and_slide(velocity)
		emit_signal('player_moved', player_name, position)

func showMessage():
	$NotInStoreMessage.visible = true
	$NotInStoreMessage/Timer.start(1)

func _on_Timer_timeout():
	$NotInStoreMessage.visible = false

func _on_BurnTimer_timeout():
	burning = false
	$FireSprite.hide()
