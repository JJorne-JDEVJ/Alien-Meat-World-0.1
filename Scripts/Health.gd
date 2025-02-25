extends Area3D

class_name Health

@export var empathy_ok = false

@onready var meat_mesh = $Meat_Object

var default_material = StandardMaterial3D.new()
var hover_material = StandardMaterial3D.new()
var select_material = StandardMaterial3D.new()


func _ready():
	# TODO: Cows shouldn't need to be on layer 1, but unfortunately... they do
#	set_collision_layer_value(1, false)
	
	set_collision_layer_value(3, true)
	set_collision_layer_value(4, true)
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(16, true)
	
	self.add_to_group("Meat")
	# Temporary Collidable Healing
	area_entered.connect(check_area)
	
	# Messenger informing script what is hovered
	Messenger.grab_target.connect(is_grabbed)	
	
	
	# Setting up meat material changes based on cursor behavior
	default_material.set_albedo(Color(.32, .75, .35))
	hover_material.set_albedo(Color(.32, .75, .35))
	select_material.set_albedo(Color(1, 0, .1))
	
func check_area(collided_bodypart):
	# collided_bodypart.mesh.hide()
	# collided_bodypart.mesh
	# print("Health Sees Player")
	Messenger.health_detected.emit(collided_bodypart, empathy_ok)
	
	
func is_grabbed(grab_target):
	# Meat is Hovered
	if self == grab_target:
		# Show Arrow
		meat_mesh.visible = true
	else:
		# Hide Arrow
		meat_mesh.visible = false
		
	# Meat is Selected	
	if self == grab_target and Input.is_action_pressed("Grab"):
		Messenger.health_grabbed.emit()
		# Hide Arrow
		meat_mesh.visible = false

		
	# Meat is Unselected (When Not Hovering)	
	if meat_mesh.material_override == select_material and self == grab_target:
		# Hide Arrow
		meat_mesh.visible = false
		# Change Material
		meat_mesh.material_override = default_material
