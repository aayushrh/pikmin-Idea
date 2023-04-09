extends Camera2D

var zoom_level
# Amount zoomed on each zoom event
const ZOOM_SPEED = .25

func _ready():
	# Setup default zoom level
	zoom_level = zoom[0]

func _process(_delta):
	if (Input.is_action_just_pressed("zoom_in")):
		zoom_level += ZOOM_SPEED
		update_zoom()
	if (Input.is_action_just_pressed("zoom_out")):
		zoom_level -= ZOOM_SPEED
		update_zoom()

# sync camera's zoom to the zoom_level
func update_zoom():
	# Cap zoom level
	if zoom_level < 0.1:
		zoom_level = .25
	if zoom_level > 4:
		zoom_level = 4

	set_zoom(Vector2(zoom_level, zoom_level))
