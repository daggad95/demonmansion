extends Weapon

func _ready():
	clip_size   = 5
	clip        = 5
	weapon_name = 'Pistol'
	price       = 100
	reload_time = 3
	fire_rate = 1
	spread = PI/128
	num_projectiles = 1
	automatic = false
	
func _gen_projectile():
	var projectile = Projectile.instance()
	projectile.init(
		aim_dir, 
		600,  # speed
		300,  # range
		5,    # penetration
		200,   # damage
		0.1, # damage dropoff
		position)
	return projectile