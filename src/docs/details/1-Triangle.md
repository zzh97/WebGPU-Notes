[返回目录](#/docs/webgpu.md)

### 1. 画三角形

<iframe src="./assets/html/1-Triangle.html" scrolling="no"></iframe>

[窗口演示](./assets/html/1-Triangle.html)

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