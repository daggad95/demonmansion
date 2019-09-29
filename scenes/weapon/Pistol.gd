extends Weapon

func _ready():
	clip_size   = 10
	clip        = 10
	weapon_name = 'Pistol'
	price       = 0
	reload_time = 1
	fire_rate = 5
	spread = PI/8
	num_projectiles = 1
	automatic = false
	
func _gen_projectile():
	var projectile = Projectile.instance()
	projectile.init(
		aim_dir, 
		400,  # speed
		100,  # range
		2,    # penetration
		25,   # damage
		0.25, # damage dropoff
		position)
	return projectile