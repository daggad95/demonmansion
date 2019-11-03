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
		'automatic': false
	}

func _ready():
	var weapon_props = get_weapon_props()
	clip_size   	= weapon_props['clip_size']
	clip        	= weapon_props['clip_size']
	weapon_name 	= weapon_props['weapon_name']
	price       	= weapon_props['price']
	reload_time 	= weapon_props['reload_time']
	fire_rate   	= weapon_props['fire_rate']
	spread      	= weapon_props['spread']
	num_projectiles = weapon_props['num_projectiles']
	automatic 		= weapon_props['automatic']
	
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