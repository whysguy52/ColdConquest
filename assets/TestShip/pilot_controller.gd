extends Node3D

var camNod
var rotateRate = 0.005



@export var isPilot = true
var shipRotator
var cam

#ship rotation
var up
var isRotating:bool
var rotWeight = 0.0
var rotRate = 0.01
var finalDirection:Vector3
var initialDirection:Vector3
var lookAtVect:Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
  Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
  shipRotator = get_parent().get_node("ShipHull")
  camNod = get_node("PilotCamNod")
  cam = get_node("PilotCamNod/PilotCam")
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if isRotating:
    rotate_ship()
  pass

func _input(event):
  if event is InputEventMouseMotion:
    rotate_y(-1*rotateRate * event.relative.x)
    camNod.rotate_x(-1*rotateRate * event.relative.y)

  if !isPilot:
    return

  if event.is_action_pressed("RMB"):
    rotWeight = 0.0
    isRotating = true
    finalDirection = -cam.global_transform.basis.z #cam is nested so we have to take global
    initialDirection = -shipRotator.transform.basis.z

    return
  pass

func rotate_ship():
  if rotWeight == 1.0:    #if we are done rotating
    rotWeight = 0.0
    isRotating = false
    return
  elif rotWeight > 1.0:   #if we accidentally go past 1.0?
    rotWeight = 1.0
    lookAtVect = initialDirection.slerp(finalDirection, rotWeight)
  else:                   #normal rotation case
    rotWeight += rotRate
    lookAtVect = initialDirection.slerp(finalDirection, rotWeight)

  up = shipRotator.global_transform.basis.y
  shipRotator.transform.basis = shipRotator.transform.basis.looking_at(lookAtVect,up)
  pass
