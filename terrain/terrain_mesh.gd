@tool
extends MeshInstance3D

@export var reload := false :
	set(new_reload):
		reload = false
		set_heightmap()
		regenerate_mesh()
@export_range(1, 300) var subdivisions := 1 :
	set(new_subdivisions):
		subdivisions = new_subdivisions
		regenerate_mesh()
@export var HeightMapTexture : Texture2D :
	set(new_HeightMapTexture):
		HeightMapTexture = new_HeightMapTexture
		set_heightmap()
		regenerate_mesh()
@export_range(0.1,2.0) var Yscale : float = 1.0
@export_range(0.1,4) var NormalStep = 1.0:
	set(v):
		NormalStep = v
		regenerate_mesh()
@onready var HeightMapCollisionShape: CollisionShape3D = $"../CollisionShapeTerrain"

var array_mesh: ArrayMesh
var HeightMapImage : Image
var HeightMapSize : Vector2 

func _ready() -> void:
	await set_heightmap()
	regenerate_mesh()

func set_heightmap():
	if not HeightMapTexture:
		HeightMapTexture = load("res://icon.svg")
		push_error("No heightmap set")
	if HeightMapTexture is NoiseTexture2D:
		if not HeightMapTexture.get_image():
			await HeightMapTexture.changed
	HeightMapImage = HeightMapTexture.get_image()
	if HeightMapImage:
		HeightMapImage.decompress()
	else:
		push_error("cant get_image on HM texture")
	#HeightMapImage.convert(Image.FORMAT_RGBF)
	HeightMapSize = HeightMapTexture.get_size()
	
	var mat = get_surface_override_material(0)
	if !mat:
		mat = get_active_material(0)
	if mat:
		mat.set_shader_parameter("maskHeight", HeightMapTexture)
	else:
		print("mat is still null")

func regenerate_mesh() -> void:
	if not HeightMapCollisionShape:
		print("HeightMapCollisionShape is null")
		return
	
	if !array_mesh:
		array_mesh = ArrayMesh.new()
		mesh = array_mesh
	array_mesh.clear_surfaces()
	var surface_array := create_plane(subdivisions)
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_array)
	#mesh.surface_set_material(0,mat)

func h(u : float, v : float) -> float:
	var col = sample(u,v)
	return col.r * Yscale

func sample(u : float, v : float):
	if not HeightMapImage:
		return Color.BLACK
	return HeightMapImage.get_pixel(
		min(HeightMapSize.x * u, HeightMapSize.x-1),
		min(HeightMapSize.y * v, HeightMapSize.y-1))

func create_plane(subdiv: int) -> Array:
	var surface_array: Array = []
	surface_array.resize(Mesh.ARRAY_MAX)
	
	var positions := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	var uvs := PackedVector2Array()
	
	var heightMapShapeData := PackedFloat32Array()
	var heights := PackedFloat32Array() #temp
	var step : float = 1.0/subdiv
	#positions.resize((subdiv+1)*(subdiv+1))
	#normals.resize((subdiv+1)*(subdiv+1))
	for y: int in subdiv+1:
		var d :float = y * step
		for x: int in subdiv+1:
			var w :float = x * step
			heights.append(h(w,d))
	
	for y: int in subdiv+1:
		var d :float = y * step
		for x: int in subdiv+1:
			var w :float = x * step
			var index = y * (subdiv+1) + x
			var h = heights[index]
			
			positions.append(Vector3(w, h, d))
			uvs.append(Vector2(w,d))
			heightMapShapeData.append(h * subdiv)
			
			var towardX
			var towardZ
			if x > 0 and x < subdiv:
				towardX = (heights[index-1] - heights[index+1]) *0.5 
			elif x > 0:
				towardX = heights[index-1] - heights[index] 
			else:
				towardX = heights[index] - heights[index+1] 
			if y > 0 and y < subdiv:
				towardZ = (heights[index-subdiv-1] - heights[index+subdiv+1]) *0.5 
			elif y > 0:
				towardZ = heights[index-subdiv-1] - heights[index] 
			else:
				towardZ = heights[index] - heights[index+subdiv+1]
			
			var px = Vector3(step, -towardX, 0)
			var pz = Vector3(0, -towardZ, step)
			var normal = pz.cross(px).normalized()
			normals.append(normal)
			#normals.append(Vector3( h(w,d)-h(w+1.0/subdiv,d), 0.01, h(w,d)-h(w,d+1.0/subdiv) ).normalized())
	
	#indices.resize(6 * subdiv * subdiv)
	for x: int in subdiv:
		for y: int in subdiv:
			var i := x + (subdiv + 1) * y
			indices.append_array([
				i,
				i + 1,
				i + (subdiv + 1),
				
				i + (subdiv + 1) + 1,
				i + (subdiv + 1),
				i + 1,
				])
				
	surface_array[Mesh.ARRAY_VERTEX] = positions
	surface_array[Mesh.ARRAY_NORMAL] = normals
	surface_array[Mesh.ARRAY_INDEX] = indices
	surface_array[Mesh.ARRAY_TEX_UV] = uvs
	
	HeightMapCollisionShape.shape.map_width = subdiv+1
	HeightMapCollisionShape.shape.map_depth = subdiv+1
	HeightMapCollisionShape.shape.map_data = heightMapShapeData
	HeightMapCollisionShape.scale = Vector3.ONE * 1.0/subdiv
	
	#var immMesh = $immediate
	#immMesh.vec_origin = positions
	#immMesh.vec_end = normals
	#immMesh.generate()
	#print("immediate normal set")
	
	
	return surface_array
