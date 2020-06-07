extends KinematicBody2D
class_name Enemy
signal dead

const Money = preload("res://scenes/items/Money/Money.tscn")
const Health = preload("res://scenes/items/Health/Health.tscn")
const Ammo = preload("res://scenes/items/Ammo/Ammo.tscn")
const DROP_RATE = 0.25


onready var Game = get_tree().get_root().get_node('Game')
onready var SEFactory = get_node("/root/StatusEffectFactory")
onready var EffectType = SEFactory.EffectType


var speed = 50.0
var steer_rate = 500.0
var health = 100.0
var knockback_speed = 50
var knockback_duration = 0.1
var base_hit = 10
var face_right = true
var can_move = true
var map
var target
var players
var nav_path
var nav_line
var velocity = Vector2(0,0)
var accel_rate = 1000
var target_velocity
var path_update_delay = 0.5
var rng = RandomNumberGenerator.new()
var dead = false
onready var state_machine = $AnimationTree["parameters/playback"]
export var show_nav_path = false

func init(init_map, init_players):
	map = init_map
	players = init_players
	add_to_group('enemy')
	
func take_damage(damage):
	health -= damage
	$AnimationTree["parameters/Walk/DamageOneShot/active"] = true
	
	if health <= 0 and not dead:
		_die()

func apply_status_effect(type, args):
	self.add_child(
		SEFactory.create(
			type, self, args
		)
	)

func _ready():
	$Timers/PathUpdateTimer.start(
		path_update_delay 
		+ rng.randf_range(-path_update_delay/2, path_update_delay/2)
	)

func _die():
	emit_signal("dead")
	state_machine.travel("Die")
	dead = true
	$Hitbox.disabled = true
	$Timers/DeathTimer.start()
	
func _get_nearest_player():
	var min_dist = INF
	var nearest
	var dist
	
	for player in players:
		dist = position.distance_to(player.get_position())
		if dist < min_dist:
			min_dist = dist
			nearest = player
	return nearest

func _drop_item():
	var item
	var rng = RandomNumberGenerator.new()
	
	rng.randomize()
	var selection = rng.randi_range(0, 2)
	
	if rng.randf() <= DROP_RATE:
		if selection == 0:
			item = Health.instance()
		elif selection == 1:
			item = Ammo.instance()
		else:
			item = Money.instance()
			
		item.init(position)
		Game.add_child(item)

func _show_nav_path():
	if nav_path == null:
		return
		
	if nav_line != null:
		nav_line.queue_free()

	nav_line = Line2D.new()
	nav_line.add_point(global_position)
	nav_line.width = 2
	for i in len(nav_path):
		nav_line.add_point(Vector2(nav_path[i].x, nav_path[i].y))
	get_tree().get_root().add_child(nav_line)

func _follow_path_force():
	if nav_path != null and len(nav_path) > 0:
		var next_point = nav_path[0]
		
		if (
			global_position.distance_to(next_point) < map.get_cell_size().x * 4
			and len(nav_path) > 1
		):
			next_point = nav_path[1]
		
		return global_position.direction_to(next_point)
	return Vector2(0, 0)

func _separate_force():
	var separate_force = Vector2(0, 0)
	for body in $Sensor.get_overlapping_bodies():
		if body != self:
			separate_force += (
				-global_position.direction_to(body.global_position).normalized()
				* 200 / global_position.distance_to(body.global_position)
			)
	return separate_force

func _avoid_force():
	var avoid_force = Vector2(0, 0)
	
	if $ClockwiseFeeler.is_colliding():
		avoid_force += (
			velocity.normalized().rotated(-PI/2) 
			* 100 / $ClockwiseFeeler.get_collision_point().distance_to(global_position)
		)
	
	if $CounterClockwiseFeeler.is_colliding():
		avoid_force += (
			velocity.normalized().rotated(PI/2) 
			* 100 / $ClockwiseFeeler.get_collision_point().distance_to(global_position)
		)
		
	return avoid_force

func _chase_target():
	target_velocity = Vector2(0, 0)
	target_velocity += _follow_path_force() 
	target_velocity += _separate_force()
	target_velocity += _avoid_force() 
	target_velocity = target_velocity.normalized() * speed
	
	if target_velocity.x < 0:
		$Sprite.flip_h = true
	elif target_velocity.x > 0:
		$Sprite.flip_h = false

func _brake():
	target_velocity = Vector2(0, 0)

func _set_path_to_target():
	if target != null:
		nav_path = map.get_nav_path(global_position, target.global_position)
		
func _shared_update(delta):
	if dead:
		return 
		
	if can_move:
		var accel_dir = velocity.direction_to(target_velocity)
		var acceleration = accel_dir * min(accel_rate, velocity.distance_to(target_velocity) / delta)
		velocity += acceleration * delta
		
		var clockwise = velocity.normalized().rotated(PI/4) * 20
		var counter_clockwise = velocity.normalized().rotated(-PI/4) * 20
		$ClockwiseFeeler.set_cast_to(clockwise)
		$CounterClockwiseFeeler.set_cast_to(counter_clockwise)
		$DesiredVelocity.set_cast_to(target_velocity)
		
		if show_nav_path:
			_show_nav_path()
		
		move_and_slide(velocity)


func _on_PathUpdateTimer_timeout():
	_set_path_to_target()
	$Timers/PathUpdateTimer.start(
		path_update_delay 
		+ rng.randf_range(-path_update_delay/2, path_update_delay/2)
	)


func _on_DeathTimer_timeout():
	queue_free()
	_drop_item()
