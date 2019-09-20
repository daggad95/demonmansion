extends Weapon

func _ready():
	clip_size   = 10
	clip        = 10
	weapon_name = 'Pistol'
	price       = 0
	projectile  = null
	aim_dir = Vector2(1,1)