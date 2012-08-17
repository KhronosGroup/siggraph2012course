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


// attributes
attribute vec3 vert;
attribute vec3 normal;
attribute vec2 texcoord;

// scalar uniforms
uniform float u_limit1;
uniform float u_limit2;
uniform float u_limit3;
uniform float u_taperAmount;
uniform float u_minVal;
uniform float u_maxVal;
uniform float u_center;


// matrix uniforms
uniform mat4 u_mvMatrix;
uniform mat4 u_projMatrix;
uniform mat4 u_worldMatrix;

varying vec4 v_color;



float TaperAmount( float param )
{
    // Bezier coordinates of the X coordinate.
    // Adjust these to get tighter or looser
    float tightness = 0.8;

    float x0, y0,  x1, y1,  x2, y2;
    float t;
    if (param < 0.5)
    {
        t = 2.0*param;
        x0 = 0.0;  y0 = 0.0;
        x1 = tightness;  y1 = 0.0;
        x2 = 1.0;  y2 = 0.5;
    }
    else
    {
        t = (param - 0.5)*2.0;
        x0 = 0.0;  y0 = 0.5;
        x1 = 1.0 - tightness;  y1 = 1.0;
        x2 = 1.0;  y2 = 1.0;
    }

    float a = x0 - 2.0*x1 + x2;
    float b = 2.0*(x1 - x0);
    float c = x0 - t;

    float descr = sqrt( b*b - 4.0*a*c );
    float denom = 2.0*a;
    float n1 = (-b + descr)/denom;
    float n2 = (-b - descr)/denom;
    if      ((n1 >= 0.0) || (n1 <= 1.0))  t = n1;
    else if ((n2 >= 0.0) || (n2 <= 1.0))  t = n2;
    else
        t = 0.0;

    float ya = y0 + t*(y1 - y0);
    float yb = y1 + t*(y2 - y1);
    float yc = ya + t*(yb - ya);

    return yc;
}


void main(void)
{
    vec3 pos = vert;
    vec2 uv = texcoord;


    float   limit1 = u_limit1,
            limit2 = u_limit2,
            limit3 = u_limit2;

    v_color = vec4(texcoord.x, texcoord.y, 0, 1);
    if ((uv.x > u_limit1) && (uv.x < u_limit3))
    {
        float t;
        if (uv.x < u_limit2)
        {
            t = (uv.x - u_limit1)/(u_limit2 - u_limit1);
        }
        else
        {
            t = 1.0 - (uv.x - u_limit2)/(u_limit3 - u_limit2);
        }
        t = TaperAmount( t );

        float maxVal;
        if (pos.y > u_center)
        {
            maxVal = u_maxVal;
        }
        else
        {
            maxVal = u_minVal;
        }

        float yFrac = (pos.y - u_center)/(maxVal-u_center);
        pos.y = pos.y - yFrac * (maxVal - u_center)*t*u_taperAmount;
    }

    gl_Position = u_projMatrix * u_mvMatrix * vec4(pos,1.0) ;
}
