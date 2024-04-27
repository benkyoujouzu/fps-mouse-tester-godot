extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

var max_frame_time = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var fps = Engine.get_frames_per_second()
    if delta > max_frame_time:
        max_frame_time = delta
    self.text = "FPS: " + str(fps) + "\n" + "FrameTime: " + str(max_frame_time * 1000) + "ms"
    pass

func _input(event):
    if event is InputEventKey:
        if event.pressed and event.keycode == KEY_R:
            max_frame_time = 0.0
