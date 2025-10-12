extends Node3D

var turret

# Called when the node enters the scene tree for the first time.
func _ready():
  turret = get_node("Turret")
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func pass_global_vect(globalVect):
  #takes camera global -z vector.
  #since this "position" object is the parent to the turret base we want to
  #convert the cameras global vector to this space.
  #convert by multiplying the inverse of this basis by the cameras -z vector
  var targetVect = global_transform.basis.inverse() * globalVect

  #the turret base will need a vector in this space but the barrels will need
  #the global vector because it will need it to convert turret bases basis
  turret.initiate_rotation(targetVect)
  pass
