extends Weapon

static func get_weapon_props():
	return {
		'clip_size': 8,
		'weapon_name': 'Shotgun',
		'price': 20,
		'reload_time': 3,
		'fire_rate': 1,
		'spread': PI/4,
		'num_projectiles': 15,
		'automatic': false,
		'texture': "res://assets/101-micro-pixel-guns/palette-1/guns/sheet-#1-with-firing.png"
	}
	
func _gen_projectile():
	var projectile = Projectile.instance()
	projectile.init(
		aim_dir, 
		500,  # speed
		150,  # range
		2,    # penetration
		25,   # damage
		0.9, # damage dropoff
		global_position - position)
	return projectile
