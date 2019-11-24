extends Weapon

static func get_weapon_props():
	return {
		'clip_size': 5,
		'weapon_name': 'Sniper',
		'price': 40,
		'reload_time': 3,
		'fire_rate': 1,
		'spread': PI/128,
		'num_projectiles': 1,
		'automatic': false,
		'texture': "res://assets/WWIIweapons/Mosin Nagant.png"
	}
	
func _gen_projectile():
	var projectile = Projectile.instance()
	projectile.init(
		aim_dir, 
		600,  # speed
		300,  # range
		5,    # penetration
		200,   # damage
		0.1, # damage dropoff
		global_position - position)
	return projectile