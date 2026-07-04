extends Node

var bottom_limit: float = 574.0
var total_loop_height: float = 520.0
var top_spawn_y: float = 124.0

	
var apple = preload("res://apple.png")
var pear = preload("res://pear.png")
var cherry = preload("res://cherry.png")

var symbols = []

var speed = 0.0  #movement speed/ 0=stop
var is_spinning = false

func randomise_symbol():
	var list = [apple, cherry, pear]
	## Generates a random number: 0, 1, or 2
	return list[randi()%3]

func start_spinning():
	is_spinning = true
	speed = 200.0   # Change this number to make it faster or slower

func _ready():
	symbols = [$Sprite21, $Sprite22, $Sprite23]#, $Sprite14, $Sprite15#]

	for sprite in symbols:
		sprite.texture = randomise_symbol()
		# FORCE ALL SPRITES TO A PERFECTLY CENTERED X AXIS (hard coding the issue)
		sprite.position.x = 0.0
			
func _process(delta):
	if not is_spinning:
		return
	for sprite in symbols:
		sprite.position.y += speed * delta
		# Moving every symbol down	
		if sprite.position.y > bottom_limit:
			sprite.position.y -= total_loop_height
func stop_spinning():
	is_spinning = false
	# Snap sprites to the grid
	for sprite in symbols:
		sprite.position.y = stepify(sprite.position.y, 150.0)


func get_middle_symbol_texture():
	# reading middle row Y coordinate
	var middle_target_y = 274.0 
	
	for sprite in symbols:
		# abs() turns negative numbers positive.
		# Check if the sprite is within 5 pixels of the perfect 274.0 center line
		if abs(sprite.position.y - middle_target_y) < 5.0:
			return sprite.texture
			
	# just in case
	return $Sprite22.texture
