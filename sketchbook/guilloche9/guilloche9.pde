

float fmodulus(float a, float b)
{
        return a - floor(a / b) * b;
}

/* Find distance between two points x1, y1, x2, y2 */
float hypot(float x1, float y1, float x2, float y2)
{
  return sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
}

/* Given array of npoints points, (px[],py[]) calculate lengths len[] */ 
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

/* given a polygon traverse in a period, and time t, find x coord
 * of where we are in the polygon.
 */
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

/* given a polygon traverse in a period, and time t, find y coord
 * of where we are in the polygon.
 */
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
  
  rad1 = 15;
  rad2 = 300;
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

float t = 0;

void draw()
{
  float x1, y1, x2, y2, x3, y3, x4, y4;
  float ox, oy;
  float period, w, h;
  float rad1 = 0;
  float rad2 = 30;
  float rad4 = 50;
  float rad3;
  
  ox = 400;
  oy = 300;
  period = 3.1415927 * 2;
  w = 800;
  h = 400;
  
  for (int i = 0; i < 1000; i++) {
    // x1 = prectanglex(t, period, w, h);
    // y1 = prectangley(t, period, w, h);
    x1 = polygonx(t, period, starx, stary, tlen, npoints, total_len);
    y1 = polygony(t, period, starx, stary, tlen, npoints, total_len);

    //point(x1 + ox, y1 + oy);
    
    
    rad3 = rad1 - sin(t * 3) * rad1 * 0.1;
    x2 = x1 + sin(t * 3) * rad1;
    y2 = y1 + cos(t * 6) * rad1;
    // point(x2 + ox, y2 + oy);
    x3 = x2 + 0.8 * sin(t * 20) * rad2;
    y3 = y2 + 0.9 * cos(t * 20) * rad2;
    // point(x3 + ox, y3 + oy);
    x4 = x3 + sin(t * 700) * rad4;
    y4 = y3 + cos(t * 700) * rad4;
    point(x4 + ox, y4 + oy);
    
    t += 0.000015;
  }
}
