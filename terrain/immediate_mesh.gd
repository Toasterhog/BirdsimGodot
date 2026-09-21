@tool
extends MeshInstance3D

var vec_origin
var vec_end
var addoffset = Vector3.ONE * 0.01

func generate():
	if not vec_origin is PackedVector3Array:
		print("generate not packed vector")
		return
	var scaleMul = 1.0/150
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	for i in range(vec_origin.size()):
		var col : Color = Color(vec_end[i].x,vec_end[i].y,vec_end[i].z)
		mesh.surface_set_color(col)
		mesh.surface_add_vertex(vec_origin[i])
		mesh.surface_set_color(col)
		mesh.surface_add_vertex(vec_origin[i] + vec_end[i] * scaleMul)
	mesh.surface_end()


func draw():
	if not vec_origin or not vec_end:
		return
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	
	mesh.surface_add_vertex(vec_origin)
	mesh.surface_add_vertex(vec_end)
	mesh.surface_add_vertex(vec_end + addoffset)
	
	mesh.surface_add_vertex(vec_origin)
	mesh.surface_add_vertex(vec_origin + addoffset)
	mesh.surface_add_vertex(vec_end + addoffset)
	
	mesh.surface_end()
