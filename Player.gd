extends Node3D

var trace_length = 500
var TraceDot = load("res://TraceDot.tscn")
# Called when the node enters the scene tree for the first time.

var traces = []
var trace_index = 0
var trace_scale = 0.2
var trace_distance = 100
var rendered_trace_scale = 0.25
var enable_trace = true
var enable_non_rendered_trace = false
var lock_with_camera = true
func _ready():
    for i in range(trace_length):
        var dot = TraceDot.instantiate()
        dot.scale = Vector3(trace_scale, trace_scale, trace_scale)
        #dot.get_node("Box").material = dot.get_node("Box").material.duplicate()
        traces.append(dot)
        add_child(dot)
    pass # Replace with function body.

var last_camera = Basis()
var last_position = Vector3()
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _process(delta):
    $Observer.handle_movement(delta)
    if lock_with_camera:
        $PlayerModel.transform = $Observer.transform
    else:
        $PlayerModel.handle_movement(delta)
    if enable_trace:
        if ($PlayerModel.transform.origin != last_position) or ((not enable_non_rendered_trace) and ($PlayerModel.transform.basis != last_camera)):
            record_trace()
        if ($PlayerModel.transform.basis != last_camera) or ($PlayerModel.transform.origin != last_position):
            last_camera = $PlayerModel.transform.basis
            last_position = $PlayerModel.transform.origin
        traces[trace_index].get_node("Box").material.albedo_color = Color(0.3, 0.8, 0.3)
        traces[trace_index].scale = Vector3(rendered_trace_scale, rendered_trace_scale, rendered_trace_scale)


func record_trace():
    trace_index = (trace_index + 1) % trace_length
    traces[trace_index].position = $PlayerModel.position + $PlayerModel.transform.basis.z * -1 * trace_distance

func _input(event):
    if event is InputEventMouseMotion:
        #print("x: ", event.relative.x, ", y: ", event.relative.y)
        if lock_with_camera:
            $Observer.rotate_with_input(event.relative.x, event.relative.y)
            $PlayerModel.transform = $Observer.transform
        else:
            if Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
                $PlayerModel.rotate_with_input(event.relative.x, event.relative.y)
            else:
                $Observer.rotate_with_input(event.relative.x, event.relative.y)
    elif event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
            enable_trace = !enable_trace
        if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
            lock_with_camera = !lock_with_camera
    elif event is InputEventKey:
        if event.pressed:
            if event.echo == false:
                if event.keycode == KEY_Y:
                    enable_non_rendered_trace = !enable_non_rendered_trace
                    print("enable_non_rendered_trace: ", enable_non_rendered_trace)
                if event.keycode == KEY_LEFT:
                    $Observer.rotate_with_input(-1, 0)
                if event.keycode == KEY_RIGHT:
                    $Observer.rotate_with_input(1, 0)
                if event.keycode == KEY_UP:
                    $Observer.rotate_with_input(0, -1)
                if event.keycode == KEY_DOWN:
                    $Observer.rotate_with_input(0, 1)
                if event.keycode == KEY_H:
                    #$Observer.transform.origin = Vector3(0, 0, 0)
                    $Observer.transform = Transform3D()
                if event.keycode == KEY_R:
                    for i in range(trace_length):
                        traces[i].position = Vector3(0, 99999, 0)

    if enable_trace and enable_non_rendered_trace and $PlayerModel.transform.basis != last_camera:
        record_trace()
        last_camera = $PlayerModel.transform.basis
        traces[trace_index].get_node("Box").material.albedo_color = Color(0.8, 0.3, 0.3)
        traces[trace_index].scale = Vector3(trace_scale, trace_scale, trace_scale)
        #trace_index = (trace_index + 1) % trace_length
