extends KinematicBody2D

enum {FORWARD, LEFT, RIGHT, BACKWARD}
enum SpriteType {IDLE, WALK, DODGE}
const WEAPON_FACTORY = preload("res://scenes/weapon/WeaponFactory.gd")
const WEAPON = preload("res://scenes/weapon/Weapon.gd")
class_name Player
signal player_moved
signal open_store
signal fired_weapon
signal switch_weapon
signal money_change
signal health_change
signal ammo_change
signal ammo_stock_change
signal weapon_change
signal inventory_change

onready var sprites = {
	SpriteType.IDLE: $IdleSprite,
	SpriteType.WALK: $WalkSprite,
	SpriteType.DODGE: $DodgeSprite
}

var current_sprite
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
var player_texture = null
var burning = false
var burn_damage = 0
var knockback = null
var can_shoot = true # stop players from shooting when store open
var aim_dir = Vector2(1, 0)
var store_open = false
var current_dir = FORWARD
var aiming = false
var ammo = {
	WEAPON.Ammo.SNIPER: 100,
	WEAPON.Ammo.RIFLE: 1000,
	WEAPON.Ammo.SHOTGUN: 100
}
var dodging = false
var dodge_dir
var can_dodge = true

const TIMER_LIMIT = 0.5
var timer = 0.0

func _ready():
	emit_signal('player_moved', player_name, position)
#	PlayerSprite.set_texture(player_texture)
	add_weapon_to_inventory('Pistol')
	equip_weapon(inventory[0])
	_switch_sprite(SpriteType.IDLE)
	
func init(init_pos, init_name, init_id, init_texture):
	position = init_pos
	player_name = init_name
	player_id = init_id
	player_texture = init_texture
	add_to_group('player')

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
	emit_signal("ammo_stock_change", ammo)
	emit_signal('ammo_change', equipped_weapon.clip, equipped_total_ammo_str())

func equip_weapon(weapon):
	if equipped_weapon != null:
		get_tree().get_root().remove_child(equipped_weapon)
		equipped_weapon.hide()
		equipped_weapon.disconnect("reload_finish", self, "_on_reload_finish")
		self.disconnect("player_moved", equipped_weapon, "_on_player_moved")
		
	equipped_weapon = weapon
	get_tree().get_root().add_child(weapon)
	equipped_weapon.set_dir(current_dir)
	equipped_weapon.show()
	equipped_weapon.connect("reload_finish", self, "_on_reload_finish")
	self.connect("player_moved", equipped_weapon, "_on_player_moved")
	emit_signal('ammo_change', equipped_weapon.clip, equipped_total_ammo_str())
	
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
			emit_signal("inventory_change", inventory)
			
			return true
	return false

func remove_weapon_from_inventory(weapon_name):
	var match_idx = -1
	
	for i in range(len(inventory)):
		if inventory[i] != null and  weapon_name == inventory[i].get_name():
			match_idx = i
			break
			
	if match_idx != -1:
	
		inventory[match_idx].queue_free()
		inventory[match_idx] = null

func apply_knockback(dir, speed, duration):
	knockback = dir * speed
	$KnockbackTimer.start(duration)

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
	controller.connect("player_dodge", self, "_dodge")

func equipped_total_ammo_str():
	if equipped_weapon.ammo_type != Weapon.Ammo.NONE:
		return str(ammo[equipped_weapon.ammo_type])
	else: 
		return "∞"

func _dodge():
	if not dodging and can_dodge:
		dodging = true
		can_dodge = false
		dodge_dir = dir
		_switch_sprite(SpriteType.DODGE)
		$DodgeTimer.start(0.5)

func _switch_sprite(sprite_type):
	if sprites[sprite_type] != current_sprite:
		if current_sprite != null:
			current_sprite.hide()
			current_sprite.get_node("AnimationPlayer").stop()
	
		current_sprite = sprites[sprite_type]
		current_sprite.show()
		current_sprite.get_node("AnimationPlayer").play("default")

func _on_store_change(store_open):
	self.store_open = store_open

func _switch_weapon(weapon_num):
	if inventory[weapon_num] != null and not store_open:
		equip_weapon(inventory[weapon_num])
		emit_signal("weapon_change", weapon_num)

func _aim(dir):
	aiming = false
	
	if abs(dir[0]) > 0 or abs(dir[1]) > 0:
		aim_dir = Vector2(dir[0], dir[1]).normalized()
		_set_sprite_dir(aim_dir)
		aiming = true
	elif current_dir == RIGHT:
		aim_dir = Vector2(1, 0)
	elif current_dir == LEFT:
		aim_dir = Vector2(-1, 0)
		
	$Crosshairs.set_position(
			aim_dir * 100)
	equipped_weapon.point_towards($Crosshairs.global_position)
	
func _set_dir(dir):
	self.dir = Vector2(dir[0], dir[1]).normalized()

func _shoot():
	if can_shoot and not store_open:
		if equipped_weapon.shoot(aim_dir, ammo):
			_set_sprite_dir(aim_dir)
#			$Sprite/FrameTimer.start()
			emit_signal('ammo_change', equipped_weapon.clip, equipped_total_ammo_str())
		
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
	
	if dodging:
		velocity = dodge_dir * speed * 2
	else:
		velocity = dir * speed
		
		if velocity.length() > 0:
			_switch_sprite(SpriteType.WALK)
		else:
			_switch_sprite(SpriteType.IDLE)
	
	if velocity.length() > 0:
		move_and_slide(velocity)
		emit_signal('player_moved', player_name, position)
		if not aiming:
			_set_sprite_dir(dir)

func showMessage():
	$NotInStoreMessage.visible = true
	$NotInStoreMessage/Timer.start(1)

func _set_sprite_dir(dir_vector):
	if dir_vector.x < 0:
		for sprite in sprites.values():
			sprite.flip_h = true
		equipped_weapon.set_dir(LEFT)
		current_dir = LEFT
	else:
		for sprite in sprites.values():
			sprite.flip_h = false
		equipped_weapon.set_dir(RIGHT)
		current_dir = RIGHT


func _on_Timer_timeout():
	$NotInStoreMessage.visible = false

func _on_BurnTimer_timeout():
	burning = false
	$FireSprite.hide()

func _on_KnockbackTimer_timeout():
	knockback = null
	
func _on_reload_finish():
	emit_signal('ammo_change', equipped_weapon.clip, equipped_total_ammo_str())
	
func _on_DodgeTimer_timeout():
	if dodging:
		dodging = false
		$DodgeTimer.start(1)
	else:
		can_dodge = true
