extends Node3D

#for rotation
var isRotating = false
var rotWeight = 0.0
var rotRate = 0.01 #to add to rotation weight
var targetVect:Vector3
var currentVect:Vector3

var barrels

# Called when the node enters the scene tree for the first time.
func _ready():
  barrels = $Barrels
  isRotating = false
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if isRotating:
    barrel_rotation()
  pass

func barrel_angle_set(barrelVector):
  #set current and target vector
  currentVect = -barrels.transform.basis.z
  targetVect = barrelVector
  rotWeight = 0.0
  #if they are the same, exit. possibly prevents 0 vector crashes
  if currentVect == targetVect:
    return
  isRotating = true
  pass

func barrel_rotation():
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

  barrels.transform.basis = barrels.transform.basis.looking_at(lookAtVect, transform.basis.y)
  pass
