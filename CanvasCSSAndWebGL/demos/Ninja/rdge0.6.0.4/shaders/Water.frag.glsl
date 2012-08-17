#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D u_tex0;
uniform float u_time;
uniform vec2 u_resolution;

const float speedx = 1./ 0.1;
const float speedy = 1./ .01;
const float speedr = 1./ 0.01;
const float delta = 20.;
const float intence = 10.;
const int dif = 7;

float col(vec2 coord)
{
  float delta_theta = 3.1415926535897932 / float(dif);
  float col = 0.;
  float theta = 0.;
  theta = u_time/200.;

  coord.x += u_time/speedx;
  coord.y += u_time/speedy;
  for (int i = 0; i < dif; i++)
  {
    coord.x += u_time/speedr;
    theta = theta + delta_theta;
    col = col + cos( (coord.x*cos(theta) - coord.y*sin(theta))*20. );
  }

  return cos(col);
}

void main(void)
{
	vec2 p = (gl_FragCoord.xy) / u_resolution.xy;

	vec2 c1 = p;
	vec2 c2 = p;

	c2.x = c2.x+u_resolution.x/delta;
	float dx = (col(c1)-col(c2))/delta;

	c2 = p;
	c2.y = c2.y + u_resolution.y/delta;
	float dy = (col(c1)-col(c2))/delta;

	c1.x = c1.x+dx;
	c1.y = -(c1.y+dy);

	float alpha = 1.+dot(dx,dy)*intence;
	if (alpha < 0.7) alpha = 0.7;
	gl_FragColor = texture2D(u_tex0,c1)*(alpha);
}
