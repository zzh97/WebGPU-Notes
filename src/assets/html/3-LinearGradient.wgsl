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
    var color = vec3f(0.0, 0.0, 0.0); // 背景色
    let r = 0.5; // 球体半径
    var uv = (coord.xy * 2.0 - u.res) / min(u.res.y, u.res.x);
    uv.y = -uv.y; // 翻转Y轴
    let p = vec3f(uv, 0.0);
    // 计算距离
    let d = sdfSphere(p, r);
    if (d < 0.0) {
        let dist = d + r;
        // 假设 p 是你在 Raymarching 中找到的球面上的一点
        color = p * 0.5 + 0.5; // 将范围从 [-1, 1] 映射到 [0, 1]
    }

    return vec4<f32>(color, 1.0);
}
