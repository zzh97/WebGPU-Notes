### 1. 画三角形

<iframe src="./assets/html/1-Triangle.html" width="640px" height="480px" scrolling="no"></iframe>

```rust
// 定义统一变量结构体
struct Uniforms {
    res: vec2f, // 分辨率
    time: f32, // 时间
};
@group(0) @binding(0)
var<uniform> u : Uniforms;

// 定义一个结构体，用来描述顶点输入
struct VertexInput {
    @location(0) position : vec2<f32>,
};

// 定义 Vertex Shader 的入口函数
@vertex
fn vs_main(input: VertexInput) -> @builtin(position) vec4<f32> {
    // 把 2D 坐标扩展成裁剪空间的 vec4
    return vec4<f32>(input.position, 0.0, 1.0);
}

// 定义 Fragment Shader 的入口函数
@fragment
fn fs_main() -> @location(0) vec4<f32> {
    // 利用 time 让红色闪烁，这样 uniforms 就会被编译器视为“活跃”状态
    let pulse = 0.3 + 0.7 * abs(sin(u.time*2.0));
    return vec4<f32>(pulse, 0.0, 0.0, 1.0);
}
```

### 2. 画圆

<iframe src="./assets/html/2-Circle.html" width="640px" height="480px" scrolling="no"></iframe>

```rust
// 定义统一变量结构体
struct Uniforms {
    res: vec2f, // 分辨率
    time: f32, // 时间
};
@group(0) @binding(0)
var<uniform> u : Uniforms;

// 1. 球体的符号距离函数 (SDF)
// p: 点坐标
// r: 半径
fn sdfSphere(p: vec3f, r: f32) -> f32 {
    let center = vec3f(0.0, 0.0, 0.0); // 球心坐标
    return length(p - center) - r; // 点到球心距离减半径即为球体距离
}

// 定义一个结构体，用来描述顶点输入
struct VertexInput {
    @location(0) position : vec2<f32>,
};

// 定义 Vertex Shader 的入口函数
@vertex
fn vs_main(@builtin(vertex_index) idx: u32) -> @builtin(position) vec4<f32> {
    // 定义顶点位置数组
    var pos = array<vec2f, 3>(
        vec2f(-1.0, -1.0), vec2f(3.0, -1.0), vec2f(-1.0, 3.0) // 三个顶点覆盖整个屏幕
    );
    return vec4<f32>(pos[idx], 0.0, 1.0);
}

// 定义 Fragment Shader 的入口函数
@fragment
fn fs_main(@builtin(position) coord: vec4f) -> @location(0) vec4<f32> {
    // 利用 time 让红色闪烁，这样 uniforms 就会被编译器视为“活跃”状态
    let pulse = 0.2 + 0.3 * abs(sin(u.time*1.5));
    // 初始化背景色
    var color = vec3f(0.05, 0.05, 0.1);
    // 计算UV坐标
    var uv = (coord.xy * 2.0 - u.res) / min(u.res.y, u.res.x);
    uv.y = -uv.y; // 翻转Y轴
    // 计算距离
    let d = sdfSphere(vec3f(uv, 0.0), pulse);
    // 点在球体内
    if (d < 0.0) {
        color = vec3f(1.0, 0.0, 0.0); // 红色
    }
    return vec4<f32>(color, 1.0);
}
```

