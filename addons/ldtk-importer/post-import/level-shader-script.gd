@tool

# Level Post-Import Template for LDTK-Importer.
var smooth_pixel : ShaderMaterial = preload("res://assets/debug/pixel_perfect_styling/smooth-pixel.tres") 

func post_import(level: LDTKLevel) -> LDTKLevel:
	# Behaviour goes here
	#print("Level: ", level)

	for child in level.get_children():
		if child is TileMapLayer:
			child.material = smooth_pixel
			
			for grandchild in child.get_children():
				grandchild.use_parent_material = true
	return level
