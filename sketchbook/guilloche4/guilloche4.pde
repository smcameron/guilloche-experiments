
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
  size(800, 500);
  frameRate(30);
}

float t = 0;

void draw()
{
  float x1, y1, x2, y2, x3, y3;
  float ox, oy;
  float period, w, h;
  float rad1 = 60;
  float rad2 = 60;
  
  ox = 150;
  oy = 150;
  period = 100;
  w = 500;
  h = 300;
  
  for (int i = 0; i < 10000; i++) {
    x1 = prectanglex(t, period, w, h);
    y1 = prectangley(t, period, w, h);

    point(x1 + ox, y1 + oy);
    
    x2 = x1 + sin(t * 0.5) * rad1;
    y2 = y1 + cos(t * 0.5) * rad1;
    // point(x2 + ox, y2 + oy);
    x3 = x2 + sin(t * 30) * rad2;
    y3 = y2 + cos(t * 30) * rad2;
    point(x3 + ox, y3 + oy);
    t += 0.0001;
  }
}
