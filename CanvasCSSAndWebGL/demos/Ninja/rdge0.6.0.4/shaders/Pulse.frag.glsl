#ifdef GL_ES
precision highp float;
#endif

uniform float u_time;
uniform vec2 u_resolution;
uniform sampler2D u_tex0;

uniform float u_speed;
uniform float u_xscale;
uniform float u_yscale;

void main(void)
{
    vec2 halfres = u_resolution.xy/2.0;
    vec2 cPos = gl_FragCoord.xy;

	float time = u_time * u_speed;

    cPos.x -= u_xscale*halfres.x*sin(time/2.0)+0.3*halfres.x*cos(time)+halfres.x;
    cPos.y -= u_yscale*halfres.y*sin(time/5.0)+0.3*halfres.y*cos(time)+halfres.y;
    float cLength = length(cPos);

    vec2 uv = gl_FragCoord.xy/u_resolution.xy+(cPos/cLength)*sin(cLength/30.0-time*10.0)/25.0;
	uv.y = 1.0 - uv.y;
    vec3 col = texture2D(u_tex0,uv).xyz*50.0/cLength;

    gl_FragColor = vec4(col,1.0);
}