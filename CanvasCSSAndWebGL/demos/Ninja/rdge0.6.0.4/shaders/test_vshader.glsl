/* <copyright>
Copyright (c) 2012, Motorola Mobility LLC.
All Rights Reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice,
  this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of Motorola Mobility LLC nor the names of its
  contributors may be used to endorse or promote products derived from this
  software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
</copyright> */


attribute vec3 vert;
attribute vec3 normal;
attribute vec2 texcoord;

// matrix uniforms
uniform mat4 u_mvMatrix;
uniform vec3 u_eye;
uniform mat4 u_normalMatrix;
uniform mat4 u_projMatrix;
uniform mat4 u_worldMatrix;

uniform mat4 u_shadowLightWorld;
uniform mat4 u_shadowBiasMatrix;
uniform mat4 u_vShadowLight;
uniform vec3 u_lightPos;

// varyings
varying vec4 vNormal;   // w = texcoord.x
varying vec4 vECPos;    // w = texcoord.y
varying vec3 vEyePos;
varying vec4 vShadowCoord;
varying vec2 vEnvTexCoord;
varying float vDiffuseIntensity;

#ifdef PC
void main()
{
    vNormal.w       = texcoord.x;
    vECPos.w        = texcoord.y;
    vEyePos         = u_eye;

//  position normals and vert
    vECPos.xyz  = (u_mvMatrix*vec4(vert, 1.0)).xyz;
    vNormal.xyz = (u_normalMatrix*vec4(normal, 0.0)).xyz;

//  pass along the geo
    gl_Position = u_projMatrix * vec4(vECPos.xyz, 1.0);

    mat4 shadowMat  = u_shadowBiasMatrix*u_projMatrix*u_vShadowLight*u_worldMatrix;
     vShadowCoord    = shadowMat * vec4(vert, 1.0);
}
#endif

#ifdef DEVICE

void main()
{
    vNormal.w       = texcoord.x;
    vECPos.w        = texcoord.y;
    vEyePos         = u_eye;

//  position normals and vert
    vECPos.xyz  = (u_mvMatrix*vec4(vert, 1.0)).xyz;
    vNormal.xyz = (u_normalMatrix*vec4(normal, 0.0)).xyz;

//  pass along the geo
    gl_Position = u_projMatrix * vec4(vECPos.xyz, 1.0);

    //mat4 shadowMat  = u_shadowBiasMatrix*u_projMatrix*u_vShadowLight*u_worldMatrix;
    //vShadowCoord    = shadowMat * vec4(vert, 1.0);

    // normal mapping
    vec3 normal = normalize(vNormal.xyz);

    // create envmap coordinates
    vec3 r = reflect( vec3(vECPos.xyz - u_eye.xyz), normal);
    float m = 2.0 * length(r);
    vEnvTexCoord = vec2(r.x/m + 0.5, r.y/m + 0.5);

    vec3 lightDirection = normalize(u_lightPos - vECPos.xyz);
    vDiffuseIntensity = max(0.0, dot(normal, lightDirection));

}

#endif
