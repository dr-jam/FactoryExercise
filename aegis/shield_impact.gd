extends MeshInstance3D

#https://godotshaders.com/shader/energy-shield-with-impact-effect/
#https://github.com/AbstractBorderStudio/energy-shield-shader-with-impact-effect

@export var mAnimCurve:Curve
@export var mImpactCurve:Curve

@export var mAnimTime:float = 1.0

var mEnlapsedtime:float
var mMaterial:ShaderMaterial

var mAnimate:bool


func _ready() -> void:
	mMaterial = get_active_material(0)
	mEnlapsedtime = 0.0


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_accept"):
		mMaterial.set_shader_parameter("_impact_origin", Vector3.ZERO)
		mMaterial.set_shader_parameter("_impact_anim", 0.0)
		mAnimate = true
		mEnlapsedtime = 0.0
		

func _physics_process(delta: float) -> void:
	if mAnimate:
		if (mEnlapsedtime < mAnimTime):
			var normalizeTime:float = mEnlapsedtime / mAnimTime
			mMaterial.set_shader_parameter("_impact_blend", mAnimCurve.Sample(normalizeTime))
			mMaterial.set_shader_parameter("_impact_anim", mImpactCurve.Sample(normalizeTime))
			mEnlapsedtime += delta
		else:
			mMaterial.set_shader_parameter("_impact_blend", 0.0)
			mMaterial.set_shader_parameter("_impact_anim", 0.0)
			mEnlapsedtime = 0.0
			mAnimate = false
	#super(delta)




#using Godot;
#using System;
#
#public partial class Impact : MeshInstance3D
#{
	#[Export]
	#Curve mAnimCurve, mImpactCurve;
	#[Export]
	#private float mAnimTime = 1.0f;
	#private float mEnlapsedtime;
	#private ShaderMaterial mMaterial;
#
	#private bool mAnimate;
#
	#public override void _Ready()
	#{
		#mEnlapsedtime = 0.0f;
		#mAnimate = false;
		#mMaterial = (ShaderMaterial)this.GetActiveMaterial(0);
		#base._Ready();
	#}
#
	#private void SetImpactOrigin(Vector3 pos) 
	#{
		#// reset animation

		#mAnimate = true;
		#mEnlapsedtime = 0.0f;
	#}
#
	#private void OnArea3DInputEvent(Camera3D camera, InputEvent @event, Vector3 position, Vector3 normal, int shape_idx) 
	#{
		#if (@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed)
		#{
			#switch (mouseEvent.ButtonIndex)
			#{
				#case MouseButton.Left:
					#SetImpactOrigin(position);
					#break;
				#default:
					#break;
			#}
		#}
	#}
#
	#public override void _PhysicsProcess(double delta)
	#{
		#if (mAnimate)
		#{
			#if (mEnlapsedtime < mAnimTime)
			#{
				#float normalizeTime = mEnlapsedtime / mAnimTime;
				#mMaterial.SetShaderParameter("_impact_blend", mAnimCurve.Sample(normalizeTime));
				#mMaterial.SetShaderParameter("_impact_anim", mImpactCurve.Sample(normalizeTime));
				#mEnlapsedtime += (float)delta;
			#}
			#else 
			#{
				#mMaterial.SetShaderParameter("_impact_blend", 0.0f);
				#mMaterial.SetShaderParameter("_impact_anim", 0.0f);
				#mEnlapsedtime = 0.0f;
				#mAnimate = false;
			#}
		#}
		#base._PhysicsProcess(delta);
	#}
#}
