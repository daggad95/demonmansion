extends Weapon

func _ready():
	clip_size   = 100
	clip        = 100
	weapon_name = 'Pistol'
	price       = 0
	reload_time = 1
	fire_rate = 10
	automatic = true
	aim_dir = Vector2(1,1)
	
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