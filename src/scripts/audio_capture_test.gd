extends Node3D


const SPACING = 0.1
const SPECTRUM_BAR = preload("res://scenes/spectrum_bar.tscn")


var effect: AudioEffectSpectrumAnalyzerInstance
var recording
var spectrum: Array[float]
var spectrum_bars: Array[GPUParticles3D]


@onready var audio_stream_player = $AudioStreamPlayer
@onready var mesh_instance_3d = $MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var idx = AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect_instance(idx, 0)
	spectrum = []
	spectrum.resize(31)
	spectrum.fill(0.0)
	
	var xval = -31.0 * SPACING / 2.0
	for i in 31:
		var new_spectrum_bar = SPECTRUM_BAR.instantiate()
		add_child(new_spectrum_bar)
		spectrum_bars.append(new_spectrum_bar)
		new_spectrum_bar.global_position.x = xval
		
		xval += SPACING


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var spec = get_spectrum()
	var speclen = spec.size()
	
	for i in 31:
		spectrum[i] = lerpf(spectrum[i], spec[i], 0.3)
	
	#var new_im = ImmediateMesh.new()
	#
	#new_im.surface_begin(Mesh.PRIMITIVE_LINES)
	
	var xval = -31.0 * SPACING / 2.0
	for i in 31:
		var s = spectrum[i]
		var scaled_y = max(log(s + 0.135) + 2.0, 0.0) * 10.0
		#new_im.surface_add_vertex(Vector3(xval, 0.0, 0.0))
		#new_im.surface_add_vertex(Vector3(xval, scaled_y, 0.0))
		spectrum_bars[i].global_position.y = scaled_y
		xval += SPACING
	
	#new_im.surface_end()
	#
	#mesh_instance_3d.mesh = new_im


func get_spectrum() -> Array[float]:
	var ranges = [Vector2(300.0, 400.0),
					Vector2(400.0, 500.0),
					Vector2(500.0, 600.0),
					Vector2(600.0, 700.0),
					Vector2(700.0, 800.0),
					Vector2(800.0, 900.0),
					Vector2(900.0, 1000.0),
					Vector2(1000.0, 1100.0),
					Vector2(1100.0, 1200.0),
					Vector2(1200.0, 1300.0),
					Vector2(1300.0, 1400.0),
					Vector2(1400.0, 1500.0),
					Vector2(1500.0, 1600.0),
					Vector2(1600.0, 1700.0),
					Vector2(1700.0, 1800.0),
					Vector2(1800.0, 1900.0),
					Vector2(1900.0, 2000.0),
					Vector2(2000.0, 2100.0),
					Vector2(2100.0, 2200.0),
					Vector2(2200.0, 2300.0),
					Vector2(2300.0, 2400.0),
					Vector2(2400.0, 2500.0),
					Vector2(2500.0, 2600.0),
					Vector2(2600.0, 2700.0),
					Vector2(2700.0, 2800.0),
					Vector2(2800.0, 2900.0),
					Vector2(2900.0, 3000.0),
					Vector2(3000.0, 3100.0),
					Vector2(3100.0, 3200.0),
					Vector2(3200.0, 3300.0),
					Vector2(3300.0, 3400.0),]
	var results: Array[float] = []
	for rnge in ranges:
		results.append(effect.get_magnitude_for_frequency_range(rnge.x, rnge.y).x)
	
	return results
