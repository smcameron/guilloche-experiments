
/* floating point modulus function */
float fmodulus(float a, float b)
{
        return a - floor(a / b) * b;
}

/* parametric function for x = f(t) for rectangular path */
float prectanglex(float t, float period, float width, float height)
{
    float z;
    float r1, r2, r3; /* 4 regions, boundaries at r1, r2, r3 */
    float total_len = 2 * width + 2 * height;
    
    z = fmodulus(t, period);
    r1 = (width / total_len) * period;
    r2 = ((width + height) / total_len) * period;
    r3 = ((2 * width + height) / total_len) * period;

    if (z <= r1) { /* bottom of rectangle, moving right */
       return (z / r1) * width;
    }
    if (z <= r2) { /* right side of rectangle, moving up */
       return width;
    }
    if (z <= r3) { /* top of rectangle, moving left */
      return  -(((z - r1 - r2) / (r3 - r2)) * width);
    }
    return 0;    /* left side of rectangle, moving down */
}

float prectangley(float t, float period, float width, float height)
{
  float z;
  float r1, r2, r3; /* 4 regions, boundaries at r1, r2, r3 */
  float total_len = 2 * width + 2 * height;
    
  z = fmodulus(t, period);
  r1 = (width / total_len) * period;
  r2 = ((width + height) / total_len) * period;
  r3 = ((2 * width + height) / total_len) * period;
  
  
  if (z <= r1) { /* bottom of rectangle, moving right */
    return height;
  }
  if (z <= r2) { /* right side of rectangle, moving up */
    return height - (((z - r1) / (r2 - r1)) * height);
  }
  if (z <= r3) { /* top of rectangle */
      return 0;
  }
  /* left side of rectangle, moving down. */
  return ((z - r3) / (period - r3)) * height;
}

void setup() {  // setup() runs once
  size(1500, 1000);
  frameRate(30);
  background(0,0,0);
  stroke(255,255,255);
}

float t = 0;

void draw()
{
  float x1, y1, x2, y2, x3, y3, x4, y4;
  float ox, oy;
  float period, w, h;
  float rad1 = 1;
  float rad2 = 80;
  float rad4 = 90;
  float rad3;
  
  ox = 200;
  oy = 200;
  period = 3.1415927 * 4;
  w = 800;
  h = 400;
  
  for (int i = 0; i < 1000; i++) {
    x1 = prectanglex(t, period, w, h);
    y1 = prectangley(t, period, w, h);

    //point(x1 + ox, y1 + oy);
    
    rad3 = rad1 - sin(t * 3) * rad1 * 0.1;
    x2 = x1 + sin(t * 3) * rad1;
    y2 = y1 + cos(t * 6) * rad1;
    // point(x2 + ox, y2 + oy);
    x3 = x2 + 0.8 * sin(t * 20) * rad2;
    y3 = y2 + 0.9 * cos(t * 10) * rad2;
    // point(x3 + ox, y3 + oy);
    x4 = x3 + sin(t * 700) * rad4;
    y4 = y3 + cos(t * 700) * rad4;
    point(x4 + ox, y4 + oy);
    t += 0.000015;
  }
}
