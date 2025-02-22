extends Node3D

var camNod
var rotateRate = 0.005

@export var isPilot = true
var cam

# Called when the node enters the scene tree for the first time.
func _ready():
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  camNod = get_node("PilotCamNod")
  cam = get_node("PilotCamNod/PilotCam")
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

func _input(event):
  if event is InputEventMouseMotion:
    rotate_y(-1*rotateRate * event.relative.x)
    camNod.rotate_x(-1*rotateRate * event.relative.y)
