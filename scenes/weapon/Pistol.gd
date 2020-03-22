extends Weapon

static func get_weapon_props():
	return {
		'clip_size': 10,
		'weapon_name': 'Pistol',
		'price': 10,
		'reload_time': 1,
		'fire_rate': 5,
		'spread': PI/8,
		'num_projectiles': 1,
		'automatic': false,
		'ammo_type': Ammo.NONE,
		'texture': "res://assets/WWIIweapons/Tokarev TT-33.png"
	}
	
func _gen_projectile():
	var projectile = Projectile.instance()
	projectile.init(
		aim_dir, 
		400,  # speed
		100,  # range
		2,    # penetration
		25,   # damage
		0.25, # damage dropoff
		global_position - position)
	return projectile
