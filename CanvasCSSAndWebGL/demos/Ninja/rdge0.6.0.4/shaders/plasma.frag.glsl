//
// Fragment shader for procedural bricks
//
// Authors: Dave Baldwin, Steve Koren, Randi Rost
//          based on a shader by Darwyn Peachey
//
// Copyright (c) 2002-2006 3Dlabs Inc. Ltd. 
//
// See 3Dlabs-License.txt for license information
//

#ifdef GL_ES
precision highp float;
#endif


varying vec2 	v_uv;
uniform float 	u_time;

uniform float u_wave;
uniform float u_wave1;
uniform float u_wave2;
uniform float u_speed;

void main(void)
{
	float x = v_uv.x ;
	float y = v_uv.y ;
	float time = u_time*u_speed;

	float wave =	(cos(time + y / (u_wave+0.2)  + cos(x / (u_wave+0.3) + cos((y / (u_wave+0.1))))));
	float wave1 =	(sin(abs(wave + y/u_wave1)));
	float wave2 =	(sin(abs(wave1 + y/u_wave2)));

	gl_FragColor = vec4( abs(vec3(wave2,wave1,wave)),1.0);
}	
