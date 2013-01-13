
float fmodulus(float a, float b)
{
        return a - floor(a / b) * b;
}

float hypot(float x1, float y1, float x2, float y2)
{
  return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
}

float calc_lengths(float px[], float py[], float len[], int npoints)
{
  float t;
  int i;
  
  t = 0;
  for (i = 0; i < npoints - 1; i++) {
    len[i] = hypot(px[i], py[i], px[i + 1], py[i + 1]);
    t += len[i];
  }
  return t;
}

float polygonx(float t, float period, 
float px[], float py[], float len[], 
int npoints, float total_len)
{
  float z, len_so_far, t1, t2;
  int i, segment;
  float prev_segs_len;
  float tt;
  
  tt = fmodulus(t, period);
  
  /* find which segment we're currently in */
  len_so_far = 0;
  segment = 0;
  for (i = 0; i < npoints - 1; i++) {
    len_so_far += len[i];
    if ((len_so_far / total_len) > (tt / period)) {
      segment = i;
      break;
    }
  }
  
  /* find how far into the current segment we are */
  prev_segs_len = (len_so_far - len[segment]);
  t1 = (prev_segs_len / total_len) * period; /* find t1 == t at beginning of this seg */
  t2 = ((prev_segs_len + len[segment]) / total_len) * period; /* find t2 = t at the end of this seg */
  z = (tt - t1) / (t2 - t1); /* fraction of the way through this segment that we are right now at t */
  
  return px[segment] + z * (px[segment + 1] - px[segment]);
  
}

float polygony(float t, float period, float px[], float py[], float len[], int npoints, float total_len)
{
  float z, len_so_far, t1, t2;
  int i, segment;
  float prev_segs_len;
  float tt;
  
  tt = fmodulus(t, period);
  
  /* find which segment we're currently in */
  len_so_far = 0;
  segment = 0;
  for (i = 0; i < npoints - 1; i++) {
    len_so_far += len[i];
    if ((len_so_far / total_len) > (tt / period)) {
      segment = i;
      break;
    }
  }
  
  /* find how far into the current segment we are */
  prev_segs_len = (len_so_far - len[segment]);
  t1 = (prev_segs_len / total_len) * period; /* find t1 == t at beginning of this seg */
  t2 = ((prev_segs_len + len[segment]) / total_len) * period; /* find t2 = t at the end of this seg */
  z = (tt - t1) / (t2 - t1); /* fraction of the way through this segment that we are right now at t */
  
  return py[segment] + z * (py[segment + 1] - py[segment]);
  
}

int npoints = 15;
float[] starx = new float[npoints];
float[] stary = new float[npoints];
float[] tlen = new float[npoints];
float total_len;

void setup() {  // setup() runs once

  float angle = 0;
  float rad1, rad2, r;
  float da;
  
  rad1 = 150;
  rad2 = 200;
  size(1500, 1000);
  frameRate(30);
  background(0,0,0);
  stroke(255,255,255);
 
  da = (2 * 3.1415927) / (npoints - 1);
  
  for (int i = 0; i < npoints; i++) {
    if ((i % 2) == 0) {
      r = rad1;
    } else {
      r = rad2;
    }
    starx[i] = cos(angle) * r;
    stary[i] = sin(angle) * r;
    angle += da;
  } 
  total_len = calc_lengths(starx, stary, tlen, npoints);
}

float angrecx(float t, float period, float width, float height)
{
	float angle;
	float adjacent;

	t = fmodulus(t, period);
	angle = (t / period) * 2 * PI;

	if (t == 0.0)
		return width / 2.0;
	if (t == PI)
		return -width / 2.0;

	/* we know that opposite == height / 2.0
	 * and that opposite / adjacent = tan(angle)
	 * so adjacent = (height / 2.0) / tan(angle);
	 */

	if (t >= 0 && t <= PI) {
		adjacent = (height / 2.0) / tan(angle);
	} else {
		adjacent = -(height / 2.0) / tan(angle);
	}
	if (adjacent > width / 2.0) {
		return width / 2.0;
	}
	if (adjacent < -width / 2.0) {
		return -width / 2.0;
	}
	return adjacent;
}

float angrecy(float t, float period, float width, float height)
{
	float angle;
	float opposite;

	t = fmodulus(t, period);
	angle = (t / period) * 2 * PI;

	if (t == PI / 2.0)
		return -height / 2.0;
	if (t == 3 * PI / 2.0)
		return height / 2.0;

	/* we know that adjacent == width / 2.0
	 * and that opposite / adjacent = tan(angle)
	 * so opposite = (width / 2.0) * tan(angle);
	 */

	opposite = -(width / 2.0) * tan(angle);
	if (opposite > height / 2.0) {
		return height / 2.0;
	}
	if (opposite < -height / 2.0) {
		return -height / 2.0;
	}
	return opposite;
}

float t = 0;

void draw()
{
  float x1, y1, x2, y2, x3, y3, x4, y4, x5, y5;
  float ox, oy;
  float period, w, h;
  float rad1 = 200;
  float rad2 = 50;
  float rad4;
  float rad5;
  float outer_env_rad = 180;
  float inner_env_rad = 40;
  float third_env_rad = 250;
  float renv3, env3x, env3y;
  float env4x, env4y;
 
  float outerx, outery;
  float innerx, innery;
  float current_inner_rad;
  float current_outer_rad, r1, r2;
  int j;
  
  ox = 750;
  oy = 350;
  period = 2 * 3.1415927 / 10.0;
  w = 800;
  h = 400;
  
  for (int i = 0; i < 1000; i++) {

    /* Basic circle of radius rad1... */
    x1 = cos(t * 10) * rad1; 
    y1 = sin(t * 10) * rad1; 

    // point(x1 + ox, y1 + oy);

    /* calculate outer envelope shape... */
    outerx = polygonx(t, period, starx, stary, tlen, npoints, total_len);
    outery = polygony(t, period, starx, stary, tlen, npoints, total_len);

    /* calculate inner envelope shape... */
    rad5 = sin(t * 10 * 5) * 10 + inner_env_rad;
    innerx = cos(t * 10) * rad5;  
    innery = sin(t * 10) * rad5;  

    /* calculate current inner and outer radii */
    current_inner_rad = sqrt(innerx * innerx + innery * innery);
    current_outer_rad = sqrt(outerx * outerx + outery * outery);

    /* calculate midpoint between inner and outer envelope */
    x2 = ((outerx - innerx) / 2.0) + innerx;
    y2 = ((outery - innery) / 2.0) + innery;

    /* calculate unit vector in dirction of x2,y2 */
    x3 = x2 / sqrt(x2 * x2 + y2 * y2);
    y3 = y2 / sqrt(x2 * x2 + y2 * y2);

    for (j = 0; j < 16; j++) {
	    r1 = (sin(t * 10 * 10 + j * PI / 8) / 2.0) + 0.5;
	    x4 = x3 * r1 * (current_outer_rad - current_inner_rad) + innerx;
	    y4 = y3 * r1 * (current_outer_rad - current_inner_rad) + innery;
	    stroke(0, 255, 255); /* cyan */
	    point(x4 + ox, y4 + oy);
    }

    /* calculate 3rd envelope */
    renv3 = sin(t * 10 * 9) * 20 + third_env_rad;
    env3x = cos(t * 10) * renv3;  
    env3y = sin(t * 10) * renv3;  

    /* calculate current inner and outer radii */
    current_inner_rad = sqrt(outerx * outerx + outery * outery);
    current_outer_rad = sqrt(env3x * env3x + env3y * env3y);

    stroke(0, 255, 0); /* green */
    for (j = 0; j < 16; j++) {
	    r1 = (sin(t * 10 * 10 + j * PI / 8) / 2.0) + 0.5;
	    x4 = x3 * r1 * (current_outer_rad - current_inner_rad) + outerx;
	    y4 = y3 * r1 * (current_outer_rad - current_inner_rad) + outery;
	    point(x4 + ox, y4 + oy);
    }

    /* calculate the 4th envelope */
    env4x = angrecx(t, 2 * PI / 10.0, 1200, 650);
    env4y = angrecy(t, 2 * PI / 10.0, 1200, 650);

    /* calculate current inner and outer radii */
    current_inner_rad = sqrt(env3x * env3x + env3y * env3y);
    current_outer_rad = sqrt(env4x * env4x + env4y * env4y);

    // stroke(0, 0, 255); /* blue */
    // point(env4x + ox, env4y + oy);
    stroke(255, 255, 255); /* white */
    for (j = 0; j < 16; j++) {
	    r1 = (sin(t * 10 * 10 + j * PI / 8) / 2.0) + 0.5;
	    x4 = x3 * r1 * (current_outer_rad - current_inner_rad) + env3x;
	    y4 = y3 * r1 * (current_outer_rad - current_inner_rad) + env3y;
	    point(x4 + ox, y4 + oy);
    }

    // stroke(255,255,255); /* white */
    // point(innerx + ox, innery + oy);

    // stroke(0,0,255); /* blue */
    // point(x2 + ox, y2 + oy);

    // stroke(0, 255,0); /* green */
    // point(outerx + ox, outery + oy);

    // stroke(255,0,0); /* red */
    // point(innerx + ox, innery + oy);

    // stroke(0,255,255); /* blue */
    // point(x5 + ox, y5 + oy);

    t += 0.001;
  }
}
