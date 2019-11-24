extends Weapon

static func get_weapon_props():
	return {
		'clip_size': 35,
		'weapon_name': 'Assault Rifle',
		'price': 100,
		'reload_time': 2,
		'fire_rate': 10,
		'spread': PI/16,
		'num_projectiles': 1,
		'automatic': true,
		'texture': "res://assets/Store/Assault Rifle.png"
	}

	
func _gen_projectile():
	var projectile = Projectile.instance()
	projectile.init(
		aim_dir, 
		400,  # speed
		200,  # range
		2,    # penetration
		15,   # damage
		0.25, # damage dropoff
		global_position - position)
	return projectile