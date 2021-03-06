
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

int npoints = 55;
float[] starx = new float[npoints];
float[] stary = new float[npoints];
float[] tlen = new float[npoints];
float total_len;

void setup() {  // setup() runs once

  float angle = 0;
  float rad1, rad2, r;
  float da;
  
  rad1 = 15;
  rad2 = 300;
  size(1500, 1000);
  frameRate(30);
  background(0,0,0);
  stroke(255,255,255);
  
  da = (2 * 3.1415927) / 20;
  r = 5;
  
  for (int i = 0; i < npoints; i++) {

    starx[i] = cos(angle) * r;
    stary[i] = sin(angle) * r;
    angle += da;
    r = r + 11;
  }
  total_len = calc_lengths(starx, stary, tlen, npoints);
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
  float outer_env_rad = 220;
  float inner_env_rad = 60;
 
  float outerx, outery;
  float innerx, innery;
  float current_inner_rad;
  float current_outer_rad;
  
  ox = 600;
  oy = 300;
  period = 3.1415927 * 6;
  w = 800;
  h = 400;
  
  for (int i = 0; i < 1000; i++) {

    /* Basic circle of radius rad1... */
    x1 = cos(t * 10) * rad1; 
    y1 = sin(t * 10) * rad1; 

    point(x1 + ox, y1 + oy);

    /* calculate outer envelope shape... */
    rad4 = sin(t * 10 * 10) * 20 + outer_env_rad;
    outerx = cos(t * 10) * rad4;  
    outery = sin(t * 10) * rad4;  

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

    x3 = cos(t * 10 * 100) * (current_outer_rad - current_inner_rad) / 4.0;
    y3 = sin(t * 10 * 100) * (current_outer_rad - current_inner_rad) / 4.0;

    x4 = x3 + x2;
    y4 = y3 + y2;

    stroke(0, 255, 255); /* cyan */
    point(x4 + ox, y4 + oy);

    stroke(255,255,255); /* white */
    point(innerx + ox, innery + oy);

    stroke(0,0,255); /* blue */
    point(x2 + ox, y2 + oy);

    stroke(0, 255,0); /* green */
    point(outerx + ox, outery + oy);

    stroke(255,0,0); /* red */
    point(innerx + ox, innery + oy);

    stroke(0,255,255); /* blue */
    // point(x5 + ox, y5 + oy);

    t += 0.01;
  }
}
