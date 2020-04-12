extends KinematicBody2D

enum {FORWARD, LEFT, RIGHT, BACKWARD}
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
var health = 80.0
var money = 1000
var inventory = [null, null, null, null] # Stores weapon instances, not string weapon names
var equipped_weapon = null
var speed = 100
var velocity = Vector2()
var dir = Vector2()
var player_name = "<UNDEFINED>"
var player_id = -1
var burning = false
var burn_damage = 0
var knockback = null
var can_shoot = true # stop players from shooting when store open
var aim_dir = Vector2(1, 0)
var store_open = false
var current_dir = FORWARD
var ammo = {
	WEAPON.Ammo.SNIPER: 100,
	WEAPON.Ammo.RIFLE: 1000,
	WEAPON.Ammo.SHOTGUN: 100
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
func get_inventory():
	return inventory
	
func has_weapon(weapon_name):
	for player_weapon in inventory:
		if player_weapon != null and player_weapon.get_name() == weapon_name:
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

func add_ammo(ammo_type, amount):
	ammo[ammo_type] += amount
	emit_signal('reloaded', equipped_weapon, ammo)

func equip_weapon(weapon):
	if equipped_weapon != null:
		equipped_weapon.hide()
		
	equipped_weapon = weapon
	equipped_weapon.set_dir(current_dir)
	equipped_weapon.show()
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
	for idx in len(inventory):
		if inventory[idx] == null:
			var weapon = WEAPON_FACTORY.create(weapon_name)
			weapon.hide()
			inventory[idx] = weapon
			add_child(weapon)
			
			return true
	return false

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
	equip_weapon(inventory[0])

	add_to_group('player')

func link_store(store):
	store.connect("open", self, "_on_store_change", [true])
	store.connect("close", self, "_on_store_change", [false])

func link_controller(controller):
	controller.connect("player_change_dir", self, "_set_dir")
	controller.connect("player_aim", self, "_aim")
	controller.connect("player_start_shooting", self, "_shoot")
	controller.connect("player_stop_shooting", self, "_stop_shooting")
	controller.connect("player_inventory_1", self, "_switch_weapon", [0])
	controller.connect("player_inventory_2", self, "_switch_weapon", [1])
	controller.connect("player_inventory_3", self, "_switch_weapon", [2])
	controller.connect("player_inventory_4", self, "_switch_weapon", [3])

func _on_store_change(store_open):
	self.store_open = store_open

func _switch_weapon(weapon_num):
	if inventory[weapon_num] != null and not store_open:
		equip_weapon(inventory[weapon_num])

func _aim(dir):
	aim_dir = Vector2(dir[0], dir[1]).normalized()
	$Crosshairs.set_position(
		aim_dir
		* $Sprite.texture.get_size().x
		* $Sprite.get_global_scale().x)
	
func _set_dir(dir):
	self.dir = Vector2(dir[0], dir[1]).normalized()

func _shoot():
	if can_shoot and not store_open:
		if equipped_weapon.shoot(aim_dir, ammo):
			_set_sprite_dir(aim_dir)
			$Sprite/FrameTimer.start()
			emit_signal('fired_weapon', equipped_weapon, ammo)
		
		if not equipped_weapon.is_automatic():
			can_shoot = false

func _stop_shooting():
	can_shoot = true

func _physics_process(delta):
	if burning:
		take_damage(delta * burn_damage)
	
	if knockback:
		move_and_collide(knockback*delta)
		emit_signal('player_moved', player_name, position)
	
	velocity = dir * speed
	if velocity.length() > 0:
		move_and_slide(velocity)
		emit_signal('player_moved', player_name, position)
		
		_animate_movement()

func showMessage():
	$NotInStoreMessage.visible = true
	$NotInStoreMessage/Timer.start(1)

func _set_sprite_dir(dir_vector):
	if abs(dir_vector.x) > abs(dir_vector.y):
		if dir_vector.x < 0:
			$Sprite.set_frame(LEFT)
			equipped_weapon.set_dir(LEFT)
			current_dir = LEFT
		else:
			$Sprite.set_frame(RIGHT)
			equipped_weapon.set_dir(RIGHT)
			current_dir = RIGHT
	else:
		if dir_vector.y < 0:
			$Sprite.set_frame(BACKWARD)
			equipped_weapon.set_dir(BACKWARD)
			current_dir = BACKWARD
		else:
			$Sprite.set_frame(FORWARD)
			equipped_weapon.set_dir(FORWARD)
			current_dir = FORWARD

func _animate_movement():
	if !$Sprite/AnimationPlayer.is_playing():
		$Sprite/AnimationPlayer.play("Hop")
	
	if $Sprite/FrameTimer.get_time_left() == 0:
		_set_sprite_dir(velocity)

func _on_Timer_timeout():
	$NotInStoreMessage.visible = false

func _on_BurnTimer_timeout():
	burning = false
	$FireSprite.hide()

func _on_KnockbackTimer_timeout():
	knockback = null
	
func _on_reload_finish():
	emit_signal('reloaded', equipped_weapon, ammo)
	

