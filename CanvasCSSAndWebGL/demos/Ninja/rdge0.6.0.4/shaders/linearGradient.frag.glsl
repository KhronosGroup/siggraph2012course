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

#ifdef GL_ES
precision highp float;
#endif


uniform vec4    u_color1;
uniform vec4    u_color2;
uniform vec4    u_color3;
uniform vec4    u_color4;
uniform float   u_colorStop1;
uniform float   u_colorStop2;
uniform float   u_colorStop3;
uniform float   u_colorStop4;
uniform vec2    u_cos_sin_angle;
//uniform int       u_colorCount;   // currently using 4

varying         vec2 v_uv;


void main(void)
{
    float t = dot(v_uv, u_cos_sin_angle);

    vec4 color;
    if (t < u_colorStop1)
        color = u_color1;
    else if (t < u_colorStop2)
    {
        float tLocal = (t - u_colorStop1)/(u_colorStop2 - u_colorStop1);
        color = mix(u_color1,u_color2,tLocal);
    }
    else if (t < u_colorStop3)
    {
        float tLocal = (t - u_colorStop2)/(u_colorStop3 - u_colorStop2);
        color = mix(u_color2,u_color3,tLocal);
    }
    else if (t < u_colorStop4)
    {
        float tLocal = (t - u_colorStop3)/(u_colorStop4 - u_colorStop3);
        color = mix(u_color3,u_color4,tLocal);
    }
    else
        color = u_color4;

    gl_FragColor =color;
}
