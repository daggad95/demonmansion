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
		'automatic': true
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
		200,  # range
		2,    # penetration
		15,   # damage
		0.25, # damage dropoff
		global_position - position)
	return projectile