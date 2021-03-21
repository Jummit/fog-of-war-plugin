tool
extends Sprite
class_name FogOfWar, "fog_of_war_icon.svg"

# How large the area the fog is covering is.
export var fog_area := Vector2(500, 500) setget set_fog_area
# How large a single fog pixel is on screen. Larger values produces smoother
# results, and low values are more performance intensive.
export var fog_pixel_size := 10 setget set_fog_pixel_size
# The color of the fog that covers the world.
export var fog_color := Color(1, 1, 1, .6) setget set_fog_color
# If the borders should fade out when uncovering an area.
export var smooth_borders := true
# The amount of frames between fog updates.
export var update_rate := 4
# The distance a node has to travel to uncover fog again.
export var distance_to_update := 500.0

var image := Image.new()
# A cache of the positions of nodes that uncover the fog. Used to only perform
# image operations if the position changed.
var position_cache : Dictionary

func _ready() -> void:
	setup_image()


func _process(_delta : float) -> void:
	if Engine.get_frames_drawn() % update_rate != 0:
		return
	for node in get_tree().get_nodes_in_group("UncoverFog"):
		if not node in position_cache or\
				position_cache[node].distance_squared_to(
				node.position) > distance_to_update:
			uncover_sphere(node.position, 200 if not "see_range" in node else\
					node.see_range)
			position_cache[node] = node.position


func uncover_sphere(at : Vector2, radius := 200.0) -> void:
	at = to_local(at).round()
	radius /= scale.x
	for x in range(at.x - radius, at.x + radius):
		for y in range(at.y - radius, at.y + radius):
			if x < 0 or y < 0 or x >= image.get_width() or y >= image.get_height():
				continue
			var distance := at.distance_to(Vector2(x, y))
			if distance < radius:
				var new_alpha = 0.0
				if smooth_borders:
					new_alpha = ease(distance / radius, 3)
				if image.get_pixel(x, y).a > new_alpha:
					image.set_pixel(x, y, Color(0, 0, 0, new_alpha))
	texture.set_data(image)


func set_fog_area(to):
	fog_area = to
	setup_image()


func set_fog_pixel_size(to):
	fog_pixel_size = to
	setup_image()


func set_fog_color(to):
	fog_color = to
	setup_image()


func setup_image():
	centered = false
	scale = Vector2.ONE * fog_pixel_size
	var image_size := (fog_area / fog_pixel_size).ceil()
	image = Image.new()
	image.create(image_size.x, image_size.y, true, Image.FORMAT_RGBA8)
	image.lock()
	for x in image_size.x:
		for y in image_size.y:
			image.set_pixel(x, y, fog_color)
	texture = ImageTexture.new()
	texture.create_from_image(image)
