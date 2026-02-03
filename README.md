# DrawTriangle
DrawTriangle for EditableImage but public, and FASTER?!?!

## Overview
Roblox currently does not have a public function to draw triangles. There is a private one, but not only is it outdated, it's actually SLOW. We'll get into this later.

This repository provides a publically available version of the function, but with an obviously different rasterization method.

## Why Scanline Rasterization?
Scanline rasterization was used in many older graphics libraries (old OpenGL, and some others). Since we're working with what is fundamentally a software renderer, we need to be wise about math. It is the fastest that I've found, and it heavily saves on math and draw calls.

## How much better is it than the original?
I know that many people reading this wanted to know, as they couldnt test it for themselves. So I decided to test it for you.

The benchmark I used can be recreated as such:
- Create a 512x512 EditableImage
- Generate random point vectors for a triangle to be at (via a function)
- For the count of how many times the benchmark should run (eg 5000), loop call the function with the randomized points
- Measure the execution time of the benchmark
- Use this benchmark for both this version and the original version
- Measure how long it took each function to perform its work.

For my benchmark, the statistics came out as such:

This version of DrawTriangle took 0.4369358000003558 seconds to complete the benchmark, taking around 145.64526666678526 microseconds per triangle.

The Roblox version of DrawTriangle took 0.9570504000002984 seconds to complete the benchmark, taking around 319.01680000009947 microseconds per triangle.

That means that this function is TWICE as fast as the Roblox implementation!

## Extras
To make this function extremely fast, native codegen was used. Without it, it would actually run slower than the original. This function also supports ImageCombineType when the original didn't (the API hasn't been updated in years)