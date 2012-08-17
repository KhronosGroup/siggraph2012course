//
// Vertex shader for procedural bricks
//
// Authors: Dave Baldwin, Steve Koren, Randi Rost
//          based on a shader by Darwyn Peachey
//
// Copyright (c) 2002-2006 3Dlabs Inc. Ltd. 
//
// See 3Dlabs-License.txt for license information
//

//uniform vec3 LightPosition;

#ifdef GL_ES
precision highp float;
#endif


// attributes
attribute vec3 vert;
attribute vec3 normal;
attribute vec2 texcoord;

uniform mat4 u_shadowLightWorld;
uniform mat4 u_shadowBiasMatrix;
uniform mat4 u_vShadowLight;
uniform vec3 u_lightPos;

// matrix uniforms
uniform mat4 u_mvMatrix;
uniform vec3 u_eye;
uniform mat4 u_normalMatrix;
uniform mat4 u_projMatrix;
uniform mat4 u_worldMatrix;

varying	vec2 v_uv;

void main(void)
{
	gl_Position = u_projMatrix * u_mvMatrix * vec4(vert,1.0) ;
	v_uv = texcoord;
}	