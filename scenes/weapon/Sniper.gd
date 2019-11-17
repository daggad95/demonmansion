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
		'texture': "res://assets/101-micro-pixel-guns/palette-1/guns/sheet-#1-with-firing.png"
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
		600,  # speed
		300,  # range
		5,    # penetration
		200,   # damage
		0.1, # damage dropoff
		global_position - position)
	return projectile