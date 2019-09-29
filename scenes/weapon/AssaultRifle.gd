extends Weapon

func _ready():
	clip_size   = 35
	clip        = 35
	weapon_name = 'Assault Rifle'
	price       = 100
	reload_time = 2
	fire_rate = 10
	spread = PI/16
	num_projectiles = 1
	automatic = true
	
func _gen_projectile():
	var projectile = Projectile.instance()
	projectile.init(
		aim_dir, 
		400,  # speed
		200,  # range
		2,    # penetration
		15,   # damage
		0.25, # damage dropoff
		position)
	return projectile