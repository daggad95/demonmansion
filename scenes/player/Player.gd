extends KinematicBody2D

const WEAPON_FACTORY = preload("res://scenes/weapon/WeaponFactory.gd")
const WEAPON = preload("res://scenes/weapon/Weapon.gd")
class_name Player
signal player_moved
signal open_store
signal fired_weapon
signal switch_weapon
signal money_change
signal health_change
signal reloaded

var max_health = 100.0
var health = 100.0
var money = 10
var inventory = [] # Stores weapon instances, not string weapon names
var equipped_weapon = null
var speed = 100
var velocity = Vector2()
var player_name = "<UNDEFINED>"
var player_id = -1
var burning = false
var burn_damage = 0
var knockback = null
var can_shoot = true # stop players from shooting when store open
var aim_dir = Vector2(1, 0)
var ammo = {
	WEAPON.Ammo.SNIPER: 100,
	WEAPON.Ammo.RIFLE: 0,
	WEAPON.Ammo.SHOTGUN: 0
}

const TIMER_LIMIT = 0.5
var timer = 0.0

func _ready():
	emit_signal('player_moved', player_name, position)

func get_money():
	return money
	
func add_money(amount):
	money = max(money + amount, 0)
	emit_signal('money_change', money)
	
func get_health():
	return health

func get_max_health():
	return max_health
	
func set_health(health):
	self.health = health
	emit_signal("health_change", health, max_health)
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

func get_equipped_weapon():
	return equipped_weapon

func get_ammo():
	return ammo

func equip_weapon(weapon):
	equipped_weapon = weapon
	equipped_weapon.connect("reload_finish", self, "_on_reload_finish")
	emit_signal('switch_weapon', equipped_weapon, ammo)
	
func take_damage(damage):
	health -= damage
	emit_signal("health_change", health, max_health)

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
			match_idx = i
			break
	if match_idx != -1:
		inventory[match_idx].queue_free()
		inventory.remove(match_idx)

func apply_knockback(dir, speed, duration):
	knockback = dir * speed
	$KnockbackTimer.start(duration)

	
func init(init_pos, init_name, init_id):
	position = init_pos
	player_name = init_name
	player_id = init_id
	
	add_weapon_to_inventory('Pistol')
	add_weapon_to_inventory('Sniper')
	equip_weapon(inventory[1])

	add_to_group('player')
	
func link_controller(controller):
	controller.connect("player_move", self, "_move")
	controller.connect("player_shoot", self, "_shoot")
	controller.connect("player_aim", self, "_aim")
	controller.connect("player_not_shoot", self, "_not_shoot")

func _aim(dir):
	aim_dir = dir
	$Crosshairs.set_position(
		dir
		* $Sprite.texture.get_size().x
		* $Sprite.get_global_scale().x)
	
func _move(dir):
	velocity = dir * speed

func _shoot():
	if can_shoot:
		if equipped_weapon.shoot(aim_dir, ammo):
			emit_signal('fired_weapon', equipped_weapon, ammo)
		
		if not equipped_weapon.is_automatic():
			can_shoot = false

func _not_shoot():
	can_shoot = true

func _physics_process(delta):
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
	
func _on_store_opened():
	can_shoot = false
	
func _on_store_closed():
	can_shoot = true

func _on_reload_finish():
	print("reloaded!")
	emit_signal('reloaded', equipped_weapon, ammo)
	

