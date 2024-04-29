extends Camera3D

var m_yaw = 0.022
var m_pitch = 0.022
var sensitivity = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


var velocity = Vector3()
var maxspeed = 250
var sv_stopspeed = 80
var sv_friction = 5.2
var sv_accelerate = 5.6


# simplified version of the movement in cstrike15_src/game/shared/gamemovement.cpp
func Friction(delta):
    var speed = velocity.length()
    var control = speed
    if speed < sv_stopspeed:
        control = sv_stopspeed
    var drop = control * sv_friction * delta
    var newspeed = speed - drop
    if newspeed < 0:
        newspeed = 0
    if newspeed != speed:
        self.velocity *= newspeed / speed

func WalkMove(wishdir, delta):
    Accelerate(wishdir, maxspeed, sv_accelerate, delta)
    if self.velocity.length() < 1:
        self.velocity = Vector3()
    self.global_transform.origin += self.velocity * delta
    
func Accelerate(wishdir, wishspeed, accel, delta):
    var currentspeed = self.velocity.dot(wishdir)
    var addspeed = wishspeed - currentspeed
    var kAccelerationScale = max(250, wishspeed)
    var accelspeed = accel * delta * kAccelerationScale
    if accelspeed > addspeed:
        accelspeed = addspeed
    self.velocity += accelspeed * wishdir

func FullWalkMove(wishdir, delta):
    Friction(delta)
    WalkMove(wishdir, delta)

func handle_movement(delta):
    var wishdir = Vector3()
    if Input.is_key_pressed(KEY_W):
        wishdir -= global_transform.basis.z
    if Input.is_key_pressed(KEY_S):
        wishdir += global_transform.basis.z
    if Input.is_key_pressed(KEY_A):
        wishdir -= global_transform.basis.x
    if Input.is_key_pressed(KEY_D):
        wishdir += global_transform.basis.x
    if Input.is_key_pressed(KEY_SPACE):
        wishdir += global_transform.basis.y
    #if Input.is_key_pressed(KEY_CTRL):
        #wishdir -= global_transform.basis.y
    if Input.is_key_pressed(KEY_SHIFT):
        self.maxspeed = 130
    else:
        self.maxspeed = 250
    wishdir = wishdir.normalized()
    FullWalkMove(wishdir, delta)
    
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func rotate_with_input(x, y):
    var rot_y = deg_to_rad(-x * m_yaw * sensitivity)
    var rot_x = deg_to_rad(-y * m_pitch * sensitivity)

    var euler = self.transform.basis.get_euler()
    euler.y += rot_y
    euler.x += rot_x
    euler.x = clampf(euler.x, -deg_to_rad(89), deg_to_rad(89))
    self.transform.basis = Basis.from_euler(euler)

