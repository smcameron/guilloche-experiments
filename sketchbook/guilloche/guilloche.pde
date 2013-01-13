
/* 
 * This program animates a rectangular path, such as might be used
 * as the path of the first wheel in a guilloche pattern for a certificate
 * or diploma, or something like that.
 *
 * It works by iterating t through two functions providing x and y 
 * coordinates as a function of t for a rectangle of given dimensions.
 */

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

/* parametric function for y = f(t) for rectangular path */
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
  float x1, y1, x2, y2;
  
  for (int i = 0; i < 10000; i++) {
    x1 = prectanglex(t, 100, 450, 225);
    y1 = prectangley(t, 100, 450, 225);
    point(x1 + 50, y1 + 50);
    t += 0.0001;
  }
}
