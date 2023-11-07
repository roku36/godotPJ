#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8) in;

layout(set = 0, binding = 0, rgba32f) uniform image2D cells_in;
layout(set = 0, binding = 1, rgba32f) uniform image2D cells_out;

const int kernelSize = 5; // Define the kernel size here
const float birth_low = 0.278;
const float birth_high = 0.8; // Increased to allow for more births
const float survival_low = 0.367;
const float survival_high = 0.945;

float rand(vec2 co){
  return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 updateCell(ivec2 cell_idx) {
  float current_status = imageLoad(cells_in, cell_idx).x;
  float alive_cells = 0.0;
  float total_cells = 0.0;

  for (int dx = -kernelSize; dx <= kernelSize; ++dx) {
    for (int dy = -kernelSize; dy <= kernelSize; ++dy) {
      float cell_value = imageLoad(cells_in, cell_idx + ivec2(dx, dy)).x;
      // change weight according to euclidean distance from center
      float weight = kernelSize - sqrt((dx * dx) + (dy * dy));
      // float weight = 1.0;
      alive_cells += cell_value;
      total_cells += 1.5 * weight;
    }
  }

  float mean = alive_cells / total_cells;
  float variance = 0.0;

  for (int dx = -kernelSize; dx <= kernelSize; ++dx) {
    for (int dy = -kernelSize; dy <= kernelSize; ++dy) {
      float cell_value = imageLoad(cells_in, cell_idx + ivec2(dx, dy)).x;
      variance += (cell_value - mean) * (cell_value - mean);
    }
  }

  variance /= total_cells;
  float density = sqrt(variance);

  float next_status = current_status;

  if (mean > birth_low && mean < birth_high && density > survival_low && density < survival_high) {
    next_status = min(1.0, current_status + 1.5 * rand(cell_idx)); // Increase cell state
  } else if (!(mean > survival_low && mean < survival_high && density > survival_low && density < survival_high)) {
    next_status = max(0.0, current_status - 1.5 * rand(cell_idx)); // Decrease cell state
  }

  return vec2(next_status, 0.0);
}

void main() {
  ivec2 gidx = ivec2(gl_GlobalInvocationID.xy);
  vec2 next_status = updateCell(gidx);
  imageStore(cells_out, gidx, vec4(vec3(next_status.x), 1.0));
}
