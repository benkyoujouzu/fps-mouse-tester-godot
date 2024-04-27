extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    Input.use_accumulated_input = false
    #DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
    DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
    Engine.max_fps = 240
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
