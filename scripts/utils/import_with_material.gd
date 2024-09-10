@tool # Needed so it runs in editor.
extends EditorScenePostImport

@export var extract_mesh = false
var material = preload("res://textures/Farming_Color_Palette_Mat.tres")

func _post_import(scene):
	for child in scene.get_children():
		if child is MeshInstance3D:
			child.material_override = material
			child.mesh.surface_set_material(0, material)
	return scene # Remember to return the imported scene

