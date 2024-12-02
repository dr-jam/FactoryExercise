shader_type spatial;
render_mode shadows_disabled, specular_disabled, ambient_light_disabled, unshaded;
//render_mode alpha_to_coverage; //, cull_disabled;

/*--------------------------------------------------------------
                          Shield Color Parameters
--------------------------------------------------------------*/

group_uniforms Shield_Color;

/**
Uniform: vec3 _shield_color
- Description: The base color of the shield.
*/
uniform vec3 _shield_color : source_color = vec3(0.0, 0.0, 1.0);

/**
Uniform: float _shield_color_brightness
- Description: Multiplier for the shield color brightness.
- Range: 0.25 to 20.0
*/
uniform float _shield_color_brightness : hint_range(0.25, 20.0, 0.05) = 1.1;

/**
Uniform: float _shield_intensity
- Description: Controls the intensity of the Fresnel effect on the shield.
- Range: 0.25 to 5.0
*/
uniform float _shield_intensity : hint_range(0.25, 5.0, 0.05) = 0.6;

/*--------------------------------------------------------------
                        Shield Transformation
--------------------------------------------------------------*/

group_uniforms Shield_Transform;
/**
Uniform: float _shield_size
- Description: A base displacement applied to the shield's vertices.
- Effect: Increases or decreases the overall size of the shield by displacing vertices along their normals.
*/
uniform float _shield_size = 0.0;
/**
Uniform: vec3 _rotation
- Description: Controls the rotation speed of the shield along each axis.
*/
uniform vec3 _rotation = vec3(0.1, 0.0, 0.0);

/*--------------------------------------------------------------
                           Impact Parameters
--------------------------------------------------------------*/

group_uniforms Impact_Shape;
/**
Uniform: vec3 _impact_origin
- Description: The world-space position where the impact occurs on the shield.
- Purpose: Serves as the center point from which the ripple effect emanates.
- Controlled By: Set in your GDScript code when a projectile hits the shield.
*/
uniform vec3 _impact_origin = vec3(1.0, 0.0, 0.0);

/**
Uniform: float _impact_frequency
- Description: Controls the speed at which the ripple waves oscillate.
- Effect: Higher values make the ripples oscillate faster, creating more waves within a given distance.
*/
uniform float _impact_frequency = 10.0;

/**
Uniform: float _impact_density
- Description: Determines the spatial frequency of the ripples (how close the waves are to each other).
- Effect: Higher values result in more ripples appearing within a certain distance from the impact origin.
*/
uniform float _impact_density = 2.0;

/**
Uniform: float _impact_amplitude
- Description: The height or strength of the ripple displacement.
- Effect: Higher values increase the intensity of the ripple, causing greater displacement of the vertices.
*/
uniform float _impact_amplitude = 5.0;

/**
Uniform: float _impact_anim
- Description: Represents the progression of the ripple animation over time.
- Purpose: Drives the expansion of the ripple effect across the shield.
- Controlled By: Incremented over time in your GDScript code to animate the ripple.
*/
uniform float _impact_anim = 0.0;

/**
Uniform: float _impact_speed
- Description: Controls the rate at which the ripple expands outward from the impact origin.
- Effect: Higher values make the ripple expand faster across the shield.
*/
uniform float _impact_speed = 5.0;

/**
Uniform: float _impact_width
- Description: Determines the width of the ripple front (the area over which the ripple effect transitions from full effect to no effect).
- Effect: Smaller values create a sharper ripple front, while larger values result in a smoother transition.
*/
uniform float _impact_width = 0.1;
/**
Uniform: float _impact_anim_max
- Description: Determines the total duration of the impact animation.
- Effect: Larger values increase the ripples effective time, so the ripple COULD (if value is high enough) propogate from one side back to the point of impact.
*/
uniform float _impact_anim_max = 3.0; // Total duration of the impact animation
/**
Uniform: float _impact_fade_duration
- Description: Determines the duration of the fade-out effect at end of ripple animation.
- Effect: Larger values smooth out the end state of the animation, making the animation end less abrupt.
*/
uniform float _impact_fade_duration = 0.5; // Duration of the fade-out at the end


/*--------------------------------------------------------------
                       Shield Pulse -- TEMP
--------------------------------------------------------------*/



group_uniforms Shield_Pulse;
/**
 ** NOT IN USE OR IMPLEMENTED -- code from original shader creator
 */
uniform float _shield_pulse_frequency = 1.0;
/**
 ** NOT IN USE OR IMPLEMENTED -- code from original shader creator
 */
uniform float _shield_pulse_density = 1.0;
/**
 ** NOT IN USE OR IMPLEMENTED -- code from original shader creator
 */
uniform float _shield_pulse_amplitude = 1.0;
/**
 ** NOT IN USE OR IMPLEMENTED -- code from original shader creator
 */
uniform float _shield_pulse_blend = 1.0;
/**
 ** NOT IN USE OR IMPLEMENTED -- code from original shader creator
 */
uniform float _shield_pulse_radius = 1.0;

/*--------------------------------------------------------------
                          Idle Pulse Parameters
--------------------------------------------------------------*/

/**
 ** Controls how fast the idle pulse cycles.
 */
uniform float _idle_frequency = 2.0;

/**
 ** Controls the strength of the idle pulse effect.
 */
uniform float _idle_amplitude = 0.05;

/*--------------------------------------------------------------
                           Utility Functions
--------------------------------------------------------------*/

/*
Function: saturate
- Clamps a value between 0 and 1.
- Parameters:
  - float x: The value to clamp.
- Returns: float clamped value.
*/
float saturate(float x) {
    return max(0.0, min(1.0, x));
}

/*
Function: ComputeFresnel
- Computes the Fresnel effect for the shield, which gives it a glowing edge.
- Parameters:
  - vec3 norm: The normal vector at the fragment.
  - vec3 view_dir: The view direction vector.
  - float intensity: The intensity of the Fresnel effect.
- Returns: float fresnel effect value.
*/
float ComputeFresnel(vec3 norm, vec3 view_dir, float intensity) {
	// dot product between mesh normals and view direction
	float fresnel = saturate(1.0 - dot(norm, view_dir));
	// modulate fresnel intensity
	fresnel = pow(fresnel, intensity);
	return fresnel;
}

/*
Function: Rotate
- Rotates a vector over time based on rotation speeds along each axis.
- Parameters:
  - vec3 vert: The vector to rotate.
  - vec3 speed: The rotation speeds along x, y, z axes.
- Returns: vec3 rotated vector.
*/
vec3 Rotate(vec3 vert, vec3 speed) {
    // Multiply speed by time to get rotation angles
    speed = speed * TIME * 5.0;

    // Build rotation matrices for each axis
    mat3 xrot = mat3(
        vec3(1.0, 0.0, 0.0),
        vec3(0.0, cos(speed.x), -sin(speed.x)),
        vec3(0.0, sin(speed.x), cos(speed.x))
    );

    mat3 yrot = mat3(
        vec3(cos(speed.y), 0.0, sin(speed.y)),
        vec3(0.0, 1.0, 0.0),
        vec3(-sin(speed.y), 0.0, cos(speed.y))
    );

    mat3 zrot = mat3(
        vec3(cos(speed.z), -sin(speed.z), 0.0),
        vec3(sin(speed.z), cos(speed.z), 0.0),
        vec3(0.0, 0.0, 1.0)
    );

    // Combine rotations
    mat3 rotation = xrot * yrot * zrot;

    // Rotate vector
    return rotation * vert;
}

/*--------------------------------------------------------------
                         Ripple Effect Functions
--------------------------------------------------------------*/

/*
Function: _FadeRipple
- Calculates an attenuation factor based on the distance from the impact origin and the current animation time.
- Ensures the ripple effect only affects vertices within the expanding ripple front.
- Parameters:
  - float distance: The distance from a vertex to the impact origin.
  - float anim: The current animation time (_impact_anim).
  - float speed: The expansion speed of the ripple (_impact_speed).
  - float width: The width of the ripple front (_impact_width).
  - float anim_max: The maximum time for the animation to play.
  - float fade_duration: The duration of the fade at the end of the animation.
- Returns: float attenuation value between 0.0 and 1.0.
*/
float _FadeRipple(float distance, float anim, float speed, float width, float anim_max, float fade_duration) {
    // If there's no animation, return zero attenuation
    if (anim <= 0.0 || anim > anim_max) {
        return 0.0;
    }
    // Calculate the current ripple radius based on time and speed
    float ripple_radius = anim * speed;
    // Compute attenuation using smoothstep to create a smooth transition at the ripple front
    float attenuation = smoothstep(ripple_radius + width, ripple_radius, distance);
    // Compute fade factor based on anim approaching anim_max
    float fade = 1.0;
    if (anim > anim_max - fade_duration) {
        fade = 1.0 - ((anim - (anim_max - fade_duration)) / fade_duration);
    }
    attenuation *= fade;
    return attenuation;
}

/*
Function: _ComputeRipple
- Calculates the ripple displacement for a given vertex based on attenuation and ripple parameters.
- Parameters:
  - vec3 vert: The position of the vertex in world space.
  - vec3 orig: The impact origin (_impact_origin).
  - float freq: The ripple frequency (_impact_frequency).
  - float dens: The ripple density (_impact_density).
  - float ampl: The ripple amplitude (_impact_amplitude).
  - float anim: The current animation time (_impact_anim).
  - float speed: The expansion speed of the ripple (_impact_speed).
  - float width: The width of the ripple front (_impact_width).
  - float anim_max: The maximum time for the animation to play. - same values from FadeRipple
  - float fade_duration: The duration of the fade at the end of the animation. - same values from FadeRipple
- Returns: float ripple displacement value.
*/
float _ComputeRipple(vec3 vert, vec3 orig, float freq, float dens, float ampl, float anim, float speed, float width, float anim_max, float fade_duration) {
    float distance = length(orig - vert);
    float attenuation = _FadeRipple(distance, anim, speed, width, anim_max, fade_duration);
    float ripple = sin(anim * freq - distance * dens) / ampl;
    return ripple * attenuation;
}

// OTHER VERSIONS OF RIPPLE FUNCTIONS

// fades ripple around a radius of the impact
float _FadeRippleBase(float orig, float blend, float radius) {
	// create a radius
	float b = clamp(blend, 0.0, radius);
	return smoothstep(b, -radius, orig);
}


float _FadeRippleAll(float dist, float blend) {
    // Use a smoothstep that covers the entire possible distance on the sphere
    float max_distance = 1.0; // Replace with the actual maximum distance (amount of sphere covered)
    return smoothstep(max_distance, blend, dist);
}


float _ComputeRippleBase(vec3 vert, vec3 orig, float blend, float radius, float freq, float dens, float ampl, float anim) {
	// calculate the intensity of the impact
	//float o = _GetRippleOrigin(vert, orig);
	//float i = sin(anim * freq - o * dens) / ampl;
	//return i * _FadeRipple(o, blend, radius);
	return 0.0;
}


float _ComputeRippleAll(vec3 vert, vec3 orig, float freq, float dens, float ampl, float anim) {
	// Calculate the distance from the vertex to the impact origin
    float dist = length(orig - vert);
    // No attenuation based on distance
    float attenuation = 1.0;
    // Calculate the ripple effect
    float ripple = sin(anim * freq - dist * dens) / ampl;
    // Apply attenuation (which is 1.0 in this case)
    return ripple * attenuation;
}

/*--------------------------------------------------------------
                       Idle Pulse Effect Function
--------------------------------------------------------------*/

/*
Function: _ComputeIdlePulse
- Creates a continuous pulsing effect when the shield is idle.
- Parameters:
  - float time: The current time (TIME).
- Returns: float idle pulse displacement value.
*/
float _ComputeIdlePulse(float time) {
    // Simple sine wave for pulsing effect
    return sin(time * _idle_frequency) * _idle_amplitude;
}

/*--------------------------------------------------------------
                             Vertex Shader
--------------------------------------------------------------*/

void vertex() {
    // Rotate VERTICES in local space
    VERTEX = Rotate(VERTEX, _rotation);
    // Rotate NORMALS accordingly
    NORMAL = Rotate(NORMAL, _rotation);
    // Normalize normals after rotation to prevent scaling artifacts
    NORMAL = normalize(NORMAL);

    // Convert vertex position to world space
    vec3 w_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // Initialize impact ripple to zero
    float impact_ripple = 0.0;

    // Only compute ripple if _impact_anim > 0.0
    impact_ripple = _ComputeRipple(
	    w_pos,
	    _impact_origin,
	    _impact_frequency,
	    _impact_density,
	    _impact_amplitude,
	    _impact_anim,
	    _impact_speed,
	    _impact_width,
	    _impact_anim_max,
	    _impact_fade_duration
	);

    // Compute idle pulse effect
    float idle_pulse = _ComputeIdlePulse(TIME);

    // Apply both effects and base shield size to the vertex position along the normal
    VERTEX += NORMAL * (impact_ripple + idle_pulse + _shield_size);
}

/*--------------------------------------------------------------
                            Fragment Shader
--------------------------------------------------------------*/

void fragment() {
    // Compute Fresnel effect for glowing edges
    float f = ComputeFresnel(NORMAL, VIEW, _shield_intensity);
    // Set the shield color modulated by brightness and Fresnel effect
    ALBEDO = f * _shield_color_brightness * _shield_color;
    // Set alpha based on Fresnel effect
    ALPHA *= f;
}

// END OF SHADER CODE