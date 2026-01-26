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

fn getNormal(p: vec3f, r: f32) -> vec3f {
    let e = 0.001; // 一个极小的偏移量
    // 采样周围三个点的距离差
    let n = vec3f(
        sdfSphere(p + vec3f(e, 0.0, 0.0), r) - sdfSphere(p - vec3f(e, 0.0, 0.0), r),
        sdfSphere(p + vec3f(0.0, e, 0.0), r) - sdfSphere(p - vec3f(0.0, e, 0.0), r),
        sdfSphere(p + vec3f(0.0, 0.0, e), r) - sdfSphere(p - vec3f(0.0, 0.0, e), r)
    );
    return normalize(n);
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
    let pulse = 0.3 * sin(u.time*1.5);
    // 初始化背景色
    var color = vec3f(0.0, 0.0, 0.0);
    // 计算UV坐标
    var uv = (coord.xy * 2.0 - u.res) / min(u.res.y, u.res.x);
    uv.y = -uv.y; // 翻转Y轴
    uv.y += pulse; // 上下摇摆
    // 1. 定义光线起点 (相机位置) 和 方向
    let ro = vec3f(0.0, 0.0, 2.0); // Camera at Z=2
    let rd = normalize(vec3f(uv, -1.0)); // Ray direction pointing into the screen

    // 2. 简单的 Ray Marching (光线步进)
    var t = 0.0;
    for(var i = 0; i < 64; i++) {
        let p = ro + rd * t; // 沿光线走 t 距离后的点
        let r = 0.6;
        // 计算距离
        let d = sdfSphere(p, r);
        // 点在球体内
        if (d < 0.001) {
            // 1. 获取法线
            let normal = getNormal(p, r);
            // 2. 定义光源位置（假设在右上角）
            let lightPos = vec3f(1.0, 1.0, 1.0);
            let lightDir = normalize(lightPos - p);

            // 3. 漫反射 (Diffuse) 计算
            // 使用 dot 计算夹角余弦值，max 确保光照不为负数
            let diff = max(dot(normal, lightDir), 0.0);
            color = vec3f(1.0, 0.2, 0.2); // 红色
            return vec4f(color * (diff + 0.1), 1.0);
        }
        t += d; // 没撞到？根据距离函数放心地向前走一段
        if (t > 10.0) { break; } // 走太远了，放弃
    }
    return vec4<f32>(color, 1.0);
}
