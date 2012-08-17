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

// defines
#if defined( GL_ES )
    precision highp float;
#endif

uniform mat4 u_viewMatrix;

#if defined( MATERIAL )
    uniform vec4        u_ambientColor;
    uniform vec4        u_diffuseColor;
    uniform vec4        u_specularColor;
    uniform float       u_specularPower;
#endif

#if defined( LIGHTING )
    varying vec3 v_normal;
    #if defined( LIGHT_0 )
//      uniform int     u_light0Type;
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
//      uniform int     u_light1Type;
        uniform vec3    u_light1Pos;
        uniform vec3    u_light1Dir;
        uniform vec3    u_light1Atten;
        uniform vec2    u_light1Spot;
        uniform vec4    u_light1Color;
        uniform vec4    u_light1Specular;
        varying vec3    v_light1Dir;
        varying vec3    v_light1SpotDir;
    #endif

    #if defined( LIGHT_2 )
//      uniform int     u_light2Type;
        uniform vec3    u_light2Pos;
        uniform vec3    u_light2Dir;
        uniform vec3    u_light2Atten;
        uniform vec2    u_light2Spot;
        uniform vec4    u_light2Color;
        uniform vec4    u_light2Specular;
        varying vec3    v_light2Dir;
        varying vec3    v_light2SpotDir;
    #endif

    #if defined( LIGHT_3 )
//      uniform int     u_light3Type;
        uniform vec3    u_light3Pos;
        uniform vec3    u_light3Dir;
        uniform vec3    u_light3Atten;
        uniform vec2    u_light3Spot;
        uniform vec4    u_light3Color;
        uniform vec4    u_light3Specular;
        varying vec3    v_light3Dir;
        varying vec3    v_light3SpotDir;
    #endif
#endif

#if defined( ENVIRONMENT_MAP )
    uniform float   u_envReflection;
#endif

uniform vec3 u_eye;

uniform sampler2D   s_diffuseMap;
uniform sampler2D   s_normalMap;
uniform sampler2D   s_envMap;
uniform sampler2D   s_specMap;

varying vec3 v_mvPos;
varying vec3 v_eyeDir;
varying vec2 v_texcoord;

void main() {
    // these are the four principle color elements making up the final fragment equation.
    vec4 a = vec4(0.0,0.0,0.0,0.0); // ambient contribution
    vec4 d = vec4(0.0,0.0,0.0,0.0); // diffuse contribution
    vec4 s = vec4(0.0,0.0,0.0,0.0); // specular contribution
    vec4 l = vec4(0.0,0.0,0.0,0.0); // lighting contribution

#if defined( MATERIAL )
    a += u_ambientColor;
    d += u_diffuseColor;
#endif

#if defined( DIFFUSE_MAP )
    d *= texture2D(s_diffuseMap, v_texcoord);
#endif

#if ( defined( LIGHTING ) || defined( ENVIRONMENT_MAPPING ) )
    vec3 normal = normalize( v_normal );
#endif

#if defined( LIGHTING )
    #if defined( NORMAL_MAP )
        vec4 normalMap = texture2D(s_normalMap, v_texcoord);
        normalMap = vec4( (normalMap.xyz * 2.0 - 1.0), 0.0 );
        normal = normalize(normalMap.x*vec3(normal.z, 0.0, normal.x) + vec3(0.0, normalMap.y, 0.0) + normalMap.z*normal);
    #endif // NORMAL_MAP

    #if defined( LIGHT_0 )
        {
            // diffuse lighting
            float ldist = length( v_light0Dir.xyz );
            vec3 ldir = v_light0Dir.xyz / ldist;

            float atten = 1.0;

            #if ( LIGHT_0 > 0 )
                atten = 1.0 / ( u_light0Atten.x + u_light0Atten.y * ldist + u_light0Atten.z * ( ldist * ldist ) );
                #if (LIGHT_0 == 2)
                    float spotAngle = dot( ldir, normalize( v_light0SpotDir ) );
                    float spotAtten = 0.0;
                    if ( spotAngle > u_light0Spot.y ) {
                        spotAtten = min(1.0, max( 0.0, ( spotAngle - u_light0Spot.y ) / ( u_light0Spot.x - u_light0Spot.y ) ) );
                    }
                    atten *= spotAtten;
                #endif
            #endif

            float ndotl = max( 0.0, dot( normal, ldir ) );
            l += ndotl * atten * u_light0Color;

            #if defined( LIGHT_0_SPECULAR )
                // specular contribution
                vec3 halfAngleVec = normalize( normalize( v_light0Dir.xyz ) + vec3(0.0,0.0,1.0) );
                float ndoth = max( 0.0, dot( normal, halfAngleVec ) );
                s += atten * pow( ndoth, u_specularPower ) * (u_specularColor * u_light0Specular);
            #endif
        }
    #endif // LIGHT_0

    #if defined( LIGHT_1 )
        {
            // diffuse lighting
            float ldist = length( v_light1Dir.xyz );
            vec3 ldir = v_light1Dir.xyz / ldist;

            float atten = 1.0;

            #if ( LIGHT_1 > 0 )
                atten = 1.0 / ( u_light1Atten.x + u_light1Atten.y * ldist + u_light1Atten.z * ( ldist * ldist ) );
                #if (LIGHT_1 == 2)
                    float spotAngle = dot( ldir, normalize( v_light1SpotDir ) );
                    float spotAtten = 0.0;
                    if ( spotAngle > u_light1Spot.y ) {
                        spotAtten = min(1.0, max( 0.0, ( spotAngle - u_light1Spot.y ) / ( u_light1Spot.x - u_light1Spot.y ) ) );
                    }
                    atten *= spotAtten;
                #endif
            #endif

            float ndotl = max( 0.0, dot( normal, ldir ) );
            l += ndotl * atten * u_light1Color;

            #if defined( LIGHT_1_SPECULAR )
                // specular contribution
                vec3 halfAngleVec = normalize( normalize( v_light1Dir.xyz ) + vec3(0.0,0.0,1.0) );
                float ndoth = max( 0.0, dot( normal, halfAngleVec ) );
                s += atten * pow( ndoth, u_specularPower ) * (u_specularColor * u_light1Specular);
            #endif
        }
    #endif // LIGHT_1

    #if defined( LIGHT_2 )
        {
            // diffuse lighting
            float ldist = length( v_light2Dir.xyz );
            vec3 ldir = v_light2Dir.xyz / ldist;

            float atten = 1.0;

            #if ( LIGHT_2 > 0 )
                atten = 1.0 / ( u_light2Atten.x + u_light2Atten.y * ldist + u_light2Atten.z * ( ldist * ldist ) );
                #if (LIGHT_2 == 2)
                    float spotAngle = dot( ldir, normalize( v_light2SpotDir ) );
                    float spotAtten = 0.0;
                    if ( spotAngle > u_light2Spot.y ) {
                        spotAtten = min(1.0, max( 0.0, ( spotAngle - u_light2Spot.y ) / ( u_light2Spot.x - u_light2Spot.y ) ) );
                    }
                    atten *= spotAtten;
                #endif
            #endif

            float ndotl = max( 0.0, dot( normal, ldir ) );
            l += ndotl * atten * u_light2Color;

            #if defined( LIGHT_2_SPECULAR )
                // specular contribution
                vec3 halfAngleVec = normalize( normalize( v_light2Dir.xyz ) + vec3(0.0,0.0,1.0) );
                float ndoth = max( 0.0, dot( normal, halfAngleVec ) );
                s += atten * pow( ndoth, u_specularPower ) * (u_specularColor * u_light2Specular);
            #endif
        }
    #endif // LIGHT_2

    #if defined( LIGHT_3 )
        {
            // diffuse lighting
            float ldist = length( v_light3Dir.xyz );
            vec3 ldir = v_light3Dir.xyz / ldist;

            float atten = 1.0;

            #if ( LIGHT_3 > 0 )
                atten = 1.0 / ( u_light3Atten.x + u_light3Atten.y * ldist + u_light3Atten.z * ( ldist * ldist ) );
                #if (LIGHT_3 == 2)
                    float spotAngle = dot( ldir, normalize( v_light3SpotDir ) );
                    float spotAtten = 0.0;
                    if ( spotAngle > u_light3Spot.y ) {
                        spotAtten = min(1.0, max( 0.0, ( spotAngle - u_light3Spot.y ) / ( u_light3Spot.x - u_light3Spot.y ) ) );
                    }
                    atten *= spotAtten;
                #endif
            #endif

            float ndotl = max( 0.0, dot( normal, ldir ) );
            l += ndotl * atten * u_light3Color;

            #if defined( LIGHT_3_SPECULAR )
                // specular contribution
                vec3 halfAngleVec = normalize( normalize( v_light3Dir.xyz ) + vec3(0.0,0.0,1.0) );
                float ndoth = max( 0.0, dot( normal, halfAngleVec ) );
                s += atten * pow( ndoth, u_specularPower ) * (u_specularColor * u_light3Specular);
            #endif
        }
    #endif // LIGHT_3
#endif // LIGHTING

#if defined( SPECULAR ) && defined( SPECULAR_MAP )
    vec4 specMapColor = texture2D(s_specMap, v_texcoord);
    s *= specMapColor;
#endif

#if defined( ENVIRONMENT_MAP )
    vec3 r = reflect( normalize( vec3(0.0,0.0,1.0) ), normal );
    float m = 2.0 * length(r);
    vec4 envMapColor = texture2D(s_envMap, vec2(r.x/m + 0.5, r.y/m + 0.5)) * u_envReflection;

    #if defined( GLOSS_MAP )
        // this is an option to modulate the alpha channel of the specular map with the environment
        // map (i.e. - gloss mapping).
        envMapColor *= specMapColor.a;
    #endif

    s += envMapColor;
#endif

  gl_FragColor = ( a + l ) * d + s;
}
