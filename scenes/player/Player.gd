extends KinematicBody2D
const WEAPON_FACTORY = preload("res://scenes/weapon/WeaponFactory.gd")
class_name Player
signal player_moved
signal open_store
signal damage_taken
signal fired_weapon

var max_health = 100.0
var health = 100.0
var money = 0
var inventory = [] # Stores weapon instances, not string weapon names
var equipped_weapon = null
var speed = 100
var velocity = Vector2()
var player_name = "<UNDEFINED>"
var player_id = -1
var burning = false
var burn_damage = 0
var knockback = null

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
		emit_signal('fired_weapon', equipped_weapon)
	if equipped_weapon.is_automatic() and Input.is_action_pressed('player%d_shoot' % player_id):
		equipped_weapon.shoot()
		emit_signal('fired_weapon', equipped_weapon)
		
func get_money():
	return money
	
func add_money(amount):
	money = max(money + amount, 0)
	
func get_health():
	return health
#
#func add_to_inventory(weapon):
#	inventory.append(weapon)
#
# Get an array of weapon instances
func get_inventory():
	return inventory
	
func has_weapon(weapon_name):
	for player_weapon in inventory:
		if player_weapon.get_name() == weapon_name:
			#print("has_weapon(): ", player_weapon.get_name(), " ", weapon_name)
			return true
	return false

func get_name():
	return player_name
	
func get_sprite():
	var player_sprite = get_node("Sprite")
	return player_sprite

func get_id():
	return player_id
	
func take_damage(damage):
	health -= damage
	emit_signal("damage_taken", health, max_health, damage)

func inflict_burn(damage_per_second, duration):
	if not burning:
		burning = true
		$FireSprite.show()
		burn_damage = damage_per_second
		$BurnTimer.start(duration)
	else:
		burn_damage = max(damage_per_second, burn_damage)
		$BurnTimer.set_wait_time(max(duration, $BurnTimer.get_time_left()))


# Takes a string weapon name and adds a weapon instance to the player inventory
func add_weapon_to_inventory(weapon_name):
	var weapon = WEAPON_FACTORY.create(weapon_name)
	inventory.append(weapon)
	add_child(weapon)

func remove_weapon_from_inventory(weapon_name):
	var match_idx = -1
	for i in range(len(inventory)):
		if weapon_name == inventory[i].get_name():
			match_idx = -1
	
	inventory[match_idx].queue_free()
	inventory.remove(match_idx)

func apply_knockback(dir, speed, duration):
	knockback = dir * speed
	$KnockbackTimer.start(duration)

	
func init(init_pos, init_name, init_id):
	position = init_pos
	player_name = init_name
	player_id = init_id
	
	# Set the default weapon to Pistol
	add_weapon_to_inventory('Pistol')
	add_weapon_to_inventory('Sniper')
	
	equipped_weapon = inventory[0]
	add_to_group('player')

func _physics_process(delta):
	get_input()
	
	if burning:
		take_damage(delta * burn_damage)
	
	if knockback:
		move_and_collide(knockback*delta)
		emit_signal('player_moved', player_name, position)
		
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

func _on_KnockbackTimer_timeout():
	knockback = null
