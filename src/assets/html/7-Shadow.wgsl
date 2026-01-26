// 定义着色器代码字符串
struct Uniforms { // 定义统一变量结构体
    res: vec2f, // 分辨率
    time: f32, // 时间
};
@group(0) @binding(0) var<uniform> u: Uniforms; // 声明统一变量

fn map(p: vec3f) -> f32 { // 定义场景距离场函数
    let sphere = length(p - vec3f(0.0, abs(sin(u.time*2.0)) * 1.0, 0.0)) - 0.8; // 计算球体距离场
    let plane = p.y + 0.8; // 计算平面距离场
    return min(sphere, plane); // 返回最小距离
}

fn getNormal(p: vec3f) -> vec3f { // 定义法线计算函数
    let e = vec2f(0.001, 0.0); // 定义偏移量
    return normalize(vec3f( // 计算并归一化法线
        map(p + e.xyy) - map(p - e.xyy), // x方向偏移
        map(p + e.yxy) - map(p - e.yxy), // y方向偏移
        map(p + e.yyx) - map(p - e.yyx)  // z方向偏移
    ));
}

fn getAO(p: vec3f, n: vec3f) -> f32 { // 定义环境光遮蔽计算函数
    var occ = 0.0; // 初始化遮蔽值
    var sca = 1.0; // 初始化缩放因子
    for (var i = 1; i <= 5; i++) { // 循环5次采样
        let h = 0.1 * f32(i); // 计算采样高度
        let d = map(p + n * h); // 计算采样点距离
        occ += (h - d) * sca; // 累加遮蔽值
        sca *= 0.95; // 衰减缩放因子
    }
    return clamp(1.0 - 3.0 * occ, 0.0, 1.0); // 限制并返回AO值
}

fn getShadow(ro: vec3f, rd: vec3f) -> f32 { // 定义阴影计算函数
    var res = 1.0; // 初始化阴影值
    var t = 0.01; // 初始化步进距离
    for (var i = 0; i < 30; i++) { // 循环30次步进
        let h = map(ro + rd * t); // 计算当前点距离
        if (h < 0.001) { return 0.0; } // 如果距离太小则返回完全阴影
        res = min(res, 20.0 * h / t); // 更新阴影值
        t += h; // 增加步进距离
    }
    return res; // 返回阴影值
}

@vertex // 顶点着色器入口
fn vs_main(@builtin(vertex_index) idx: u32) -> @builtin(position) vec4f { // 顶点着色器主函数
    var pos = array<vec2f, 3>( // 定义顶点位置数组
        vec2f(-1.0, -1.0), vec2f(3.0, -1.0), vec2f(-1.0, 3.0) // 三个顶点覆盖整个屏幕
    );
    return vec4f(pos[idx], 0.0, 1.0); // 返回顶点位置
}

@fragment // 片段着色器入口
fn fs_main(@builtin(position) coord: vec4f) -> @location(0) vec4f { // 片段着色器主函数
    var uv = (coord.xy * 2.0 - u.res) / min(u.res.y, u.res.x); // 计算UV坐标
    uv.y = -uv.y; // 翻转Y轴
    let ro = vec3f(0.0, 1.0, -3.5); // 定义射线原点
    let rd = normalize(vec3f(uv, 1.2)); // 计算射线方向

    var color = vec3f(0.05, 0.05, 0.1); // 初始化背景色
    var t = 0.0; // 初始化步进距离
    for (var i = 0; i < 100; i++) { // 循环100次步进
        let p = ro + rd * t; // 计算当前点位置
        let d = map(p); // 计算当前点距离
        if (d < 0.001) { // 如果距离足够小则认为击中物体
            let n = getNormal(p); // 计算法线
            let lightPos = vec3f(2.0, 4.0, -2.0); // 定义光源位置
            let l = normalize(lightPos - p); // 计算光照方向
            let v = -rd; // 计算视线方向

            let diff = max(dot(n, l), 0.0); // 计算漫反射
            let shadow = getShadow(p + n * 0.02, l); // 计算阴影
            let ao = getAO(p, n); // 计算环境光遮蔽

            let fresnel = pow(1.0 - max(dot(n, v), 0.0), 5.0); // 计算菲涅尔效应

            let spec = pow(max(dot(reflect(-l, n), v), 0.0), 32.0); // 计算高光

            let baseColor = select(vec3f(0.2), vec3f(0.9, 0.1, 0.1), p.y > -0.59); // 根据高度选择基础颜色

            let ambient = 0.2 * ao; // 计算环境光
            let reflection = vec3f(1.0) * fresnel * ao; // 计算反射

            color = baseColor * (diff * shadow + ambient) + (spec * shadow) + reflection * 0.05; // 合成最终颜色
            break; // 跳出循环
        }
        t += d; // 增加步进距离
        if (t > 20.0) { break; } // 如果距离过大则跳出循环
    }
    return vec4f(color, 1.0); // 返回最终颜色
}
