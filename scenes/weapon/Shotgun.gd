extends Weapon

func _ready():
	clip_size   = 8
	clip        = 8
	weapon_name = 'Shotgun'
	price       = 100
	reload_time = 3
	fire_rate = 1
	spread = PI/4
	num_projectiles = 15
	automatic = false
	
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