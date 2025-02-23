extends Node3D

var Barrels

#for rotation
var isRotating = false
var rotWeight = 0.0
var rotRate = 0.01 #to add to rotation weight
var targetVect:Vector3
var currentVect:Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
  Barrels = get_node("barrels")
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if isRotating:
    turret_rotation()
  pass


func initiate_rotation(inTargetVect):
  #set current and target vector for slerp
  currentVect = -transform.basis.z
  targetVect = inTargetVect
  #if player clicks RMB in the middle of a slerp, reset weight
  #or else rotation will start in the middle of a new slerp.
  rotWeight = 0.0
  #if they are the same, exit. possibly prevents 0 vector crashes
  if currentVect == targetVect:
    return
  isRotating = true
  #collapse the y component so we only rotate around y. don't tilt back or forward
  targetVect.y = 0

  #BARREL VECTOR CALCULATION
  #calculate angle between barrelTarget and base's y axis
  var barrelAngle = inTargetVect.angle_to(transform.basis.y)
  #create a new vector from the angle that excludes x
  #we exclude x so barrel only moves in yz plane
  #since angle is between y axis and vector, y = cos() not sin()
  var barrelVector = Vector3(0,cos(barrelAngle), -sin(barrelAngle)).normalized()
  barrelVector.y = clamp(barrelVector.y,0,90)
  Barrels.barrel_angle_set(barrelVector)

func turret_rotation():
  var lookAtVect
  if rotWeight == 1.0:    #if we are done rotating
    rotWeight = 0.0
    isRotating = false
    return
  elif rotWeight > 1.0:   #if we accidentally go past 1.0?
    rotWeight = 1.0
    lookAtVect = currentVect.slerp(targetVect, rotWeight)
    #transform.basis = transform.basis.orthonormalized()
  else:                   #normal rotation case
    rotWeight += rotRate
    lookAtVect = currentVect.slerp(targetVect, rotWeight)

  transform.basis = transform.basis.looking_at(lookAtVect, transform.basis.y)
    #transform.basis = transform.basis.orthonormalized()
