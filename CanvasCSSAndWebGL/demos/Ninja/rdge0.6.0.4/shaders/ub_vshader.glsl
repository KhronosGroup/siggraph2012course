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

// attributes
attribute vec3 a_pos;
attribute vec3 a_normal;
attribute vec2 a_texcoord;

// uniforms
uniform mat4 u_worldMatrix;
uniform mat4 u_viewMatrix;
uniform mat4 u_projMatrix;
uniform mat4 u_mvMatrix;
uniform mat4 u_normalMatrix;
uniform mat4 u_uvMatrix;
uniform vec3 u_eye;

// attributes
#if defined( MATERIAL )
    uniform vec4        u_ambientColor;
    uniform vec4        u_diffuseColor;
    uniform vec4        u_specularColor;
    uniform float       u_specularPower;
#endif

#if defined( LIGHTING )
    varying vec3 v_normal;
    #if defined( LIGHT_0 )
        uniform int     u_light0Type;
        uniform vec3    u_light0Pos;
        uniform vec3    u_light0Dir;
        uniform vec3    u_light0Atten;
        uniform vec2    u_light0Spot;
        uniform vec4    u_light0Color;
        uniform vec4    u_light0Specular;
        varying vec3    v_light0Dir;
        varying vec3    v_light0SpotDir;
    #endif

    #if defined( LIGHT_1 )
        uniform int     u_light1Type;
        uniform vec3    u_light1Pos;
        uniform vec3    u_light1Dir;
        uniform vec3    u_light1Atten;
        uniform vec2    u_light1Spot;
        uniform vec3    u_light1Color;
        uniform vec4    u_light1Specular;
        varying vec3    v_light1Dir;
        varying vec3    v_light1SpotDir;
    #endif

    #if defined( LIGHT_2 )
        uniform int     u_light2Type;   // 0 - dir, 1 - point, 2 - spot
        uniform vec3    u_light2Pos;
        uniform vec3    u_light2Dir;
        uniform vec3    u_light2Atten;
        uniform vec2    u_light2Spot;   // 0 - spot light cutoff angle, 1 - spot light exponent
        uniform vec3    u_light2Color;
        uniform vec4    u_light2Specular;
        varying vec3    v_light2Dir;
        varying vec3    v_light2SpotDir;
    #endif

    #if defined( LIGHT_3 )
        uniform int     u_light3Type;
        uniform vec3    u_light3Pos;
        uniform vec3    u_light3Dir;
        uniform vec3    u_light3Atten;
        uniform vec2    u_light3Spot;
        uniform vec3    u_light3Color;
        uniform vec4    u_light3Specular;
        varying vec3    v_light3Dir;
        varying vec3    v_light3SpotDir;
    #endif
#endif

#if defined( ENVIRONMENT_MAP )
    uniform float u_envReflection;
#endif

varying vec3 v_mvPos;
varying vec3 v_eyeDir;
varying vec2 v_texcoord;

#if defined( PC )
void main() {
    //  position normals and vert
    v_mvPos = ( u_mvMatrix * vec4( a_pos, 1.0 ) ).xyz;

    v_texcoord = (u_uvMatrix * vec4(a_texcoord, 0, 1.0)).xy;
#if ( defined( LIGHTING ) || defined( ENVIRONMENT_MAP ) )
    v_normal = ( u_normalMatrix * vec4( a_normal, 0.0 ) ).xyz;
#endif

#if defined( LIGHTING )
    v_eyeDir = vec3(-u_viewMatrix[3][0], -u_viewMatrix[3][1], -u_viewMatrix[3][2]);
    #if defined( LIGHT_0 )
        {
            vec3    lpos = ( u_viewMatrix * vec4( u_light0Pos, 1.0 ) ).xyz;

            #if ( LIGHT_0 == 0 )
                v_light0Dir = ( u_viewMatrix * vec4( -u_light0Dir, 0.0 ) ).xyz;
            #else
                v_light0Dir = lpos - v_mvPos;
                #if ( LIGHT_0 == 2 )
                    v_light0SpotDir = (u_viewMatrix * vec4( -u_light0Dir, 0.0 )).xyz;
                #endif // ( LIGHT_0 == 2 )
            #endif // ( LIGHT_0 == 0 )
        }
    #endif // defined( LIGHT_0 )
    #if defined( LIGHT_1 )
        {
            vec3    lpos = ( u_viewMatrix * vec4( u_light1Pos, 1.0 ) ).xyz;

            #if ( LIGHT_1 == 0 )
                v_light1Dir = ( u_viewMatrix * vec4( -u_light1Dir, 0.0 ) ).xyz;
            #else
                v_light1Dir = lpos - v_mvPos;
                #if ( LIGHT_1 == 2 )
                    v_light1SpotDir = (u_viewMatrix * vec4( -u_light1Dir, 0.0 )).xyz;
                #endif // ( LIGHT_1 == 2 )
            #endif // ( LIGHT_1 == 0 )
        }
    #endif // defined( LIGHT_1 )
    #if defined( LIGHT_2 )
        {
            vec3    lpos = ( u_viewMatrix * vec4( u_light2Pos, 1.0 ) ).xyz;

            #if ( LIGHT_2 == 0 )
                v_light2Dir = ( u_viewMatrix * vec4( -u_light2Dir, 0.0 ) ).xyz;
            #else
                v_light2Dir = lpos - v_mvPos;
                #if ( LIGHT_2 == 2 )
                    v_light2SpotDir = (u_viewMatrix * vec4( -u_light2Dir, 0.0 )).xyz;
                #endif // ( LIGHT_2 == 2 )
            #endif // ( LIGHT_2 == 0 )
        }
    #endif // defined( LIGHT_2 )
    #if defined( LIGHT_3 )
        {
            vec3    lpos = ( u_viewMatrix * vec4( u_light3Pos, 1.0 ) ).xyz;

            #if ( LIGHT_3 == 0 )
                v_light3Dir = ( u_viewMatrix * vec4( -u_light3Dir, 0.0 ) ).xyz;
            #else
                v_light3Dir = lpos - v_mvPos;
                #if ( LIGHT_3 == 2 )
                    v_light3SpotDir = (u_viewMatrix * vec4( -u_light3Dir, 0.0 )).xyz;
                #endif // ( LIGHT_3 == 2 )
            #endif // ( LIGHT_3 == 0 )
        }
    #endif // defined( LIGHT_3 )
#endif // defined( LIGHTING )

    //  pass along the geo
    gl_Position = u_projMatrix * vec4(v_mvPos, 1.0);
}
#endif

