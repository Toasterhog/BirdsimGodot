@tool
extends Node
class_name FoleagePlacer

@export var FoleageNoiseTexture : NoiseTexture2D
@export var HM_texture : Texture2D
var noise_img : Image
@export_range(0, 1, 0.01) var amount = 0.5:
	set(new_amount):
		amount = new_amount
		replace = false
@export_range(0, 1.0, 0.01) var contrast = 1.0
@export_range(0, 3000, 2) var max_count = 100
@export var mmi_grass : Node
@onready var grass_blade: MeshInstance3D = $"../mmiGrass/grassBlade"
@export var replace : bool:
	set(new_replace):
		place(HM_image)
		replace = false
	
var HM_image : Image
var terrain_size := 150.0
var img_in_size_ := 512
var img_noise_size := 512
var step_in_meters := 1.5
var Yscale := 0.115 * terrain_size

func _ready() -> void:
	HM_image = HM_texture.get_image()

func place(img_in : Image):
	print("place func start")
	noise_img = FoleageNoiseTexture.get_image()
	if not img_in:
		print("img in is not")
		return
	elif img_in.is_compressed(): 
		img_in.decompress()
	if not noise_img:
		await FoleageNoiseTexture.changed
		noise_img = FoleageNoiseTexture.get_image()
	if not noise_img: 
		print("faild to get noise img")
		return
	elif noise_img.is_compressed(): 
		noise_img.decompress()
	print("noise img: ", noise_img," tex ",FoleageNoiseTexture)
	
	var mm : MultiMesh = mmi_grass.multimesh
	mm.instance_count = 0
	mm.instance_count = max_count
	var num_placed = 0
	var num_steps : int = terrain_size / step_in_meters
	for i in range(0, num_steps, 1):
		for j in range(0, num_steps, 1):
			var z = i + randf_range(0,step_in_meters) - step_in_meters/2.0
			var x = j + randf_range(0,step_in_meters) - step_in_meters/2.0
			var HMvalue = sample(x  * img_in_size_ / num_steps, z  * img_in_size_/ num_steps, img_in).r
			var prob = (1 if HMvalue > 0.2 else 0) * sample(x  * img_noise_size / num_steps, z  * img_noise_size/ num_steps, noise_img).r
			if prob < 0 or prob > 1.0:
				print("prob; ", prob)
			#print("prob: ", prob, " amount", amount, " u noise ",x, " u in ", x  * img_in_size_ / num_steps)
			#print("samp noise: ", sample(x  * img_noise_size / num_steps, z  * img_noise_size/ num_steps, noise_img).r)
			#print("samp in: ", sample(x  * img_in_size_ / num_steps, z  * img_in_size_/ num_steps, img_in).r)
			if prob > amount:
				if num_placed >= max_count:
					break
				var trans = Transform3D.IDENTITY.translated( Vector3((x * step_in_meters-terrain_size/2.0) ,Yscale*HMvalue,(z * step_in_meters-terrain_size/2.0)))
				trans = trans.rotated_local(Vector3.UP, HMvalue*50.0*prob+x+z)
				mm.set_instance_transform(num_placed, trans)
				trans = trans.rotated_local(Vector3.UP, PI/2.0)
				mm.set_instance_transform(num_placed+1, trans)
				num_placed += 2
				
	mmi_grass.multimesh = mm
	print("end, num placed: ", num_placed)


func sample(u : int, v : int, img : Image):
	if not img:
		#print("no img in sample()")
		return Color.BLACK
	var size = img.get_size()
	return img.get_pixel(
		clampi(u, 0, size.x-1),
		clampi(v, 0, size.y-1))
	#return img.get_pixel(
		#clampi(size.x * u, 0, size.x-1),
		#clampi(size.y * v, 0, size.y-1))
