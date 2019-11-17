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
		'texture': "res://assets/WWIIweapons/Tokarev TT-33.png"
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
		400,  # speed
		100,  # range
		2,    # penetration
		25,   # damage
		0.25, # damage dropoff
		global_position - position)
	return projectile