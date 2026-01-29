[返回目录](#/docs/webgpu.md)

# 《WebGPU 入门指南: 面向Web图形开发者》

> 面向：有一定前端与 Web 图形经验、希望从 0 到 1 做 TA / 渲染向作品，并最终挑战 **Blender Lite in Web** 的开发者

---

## 第一章：我们为什么需要 WebGPU？（以及你该如何理解它）

在正式写任何一行 WebGPU 代码之前，我们先做一件**非常重要但常被忽略的事**：

> **统一认知坐标系** —— 搞清楚 WebGPU 到底解决什么问题、它在整个 Web 图形技术栈中的位置，以及你“学它到底是为了什么”。

如果这一章你读懂了，后面所有 API、Shader、Buffer、Pipeline，都会“有地方可放”，而不是一堆零散知识点。

---

### 1.1 你现在站在什么位置？

先说一句实话：

**你并不是 WebGPU 的“新手”。**

从你的经历来看：

- 用过 **Canvas** → 你理解“立即模式绘制”和像素思维
- 用过 **Three.js / WebCAD** → 你理解 Scene / Mesh / Geometry / Material
- 玩过 **WebGL（哪怕是间接的）** → 你已经在用 GPU 画东西
- 还研究过 **WebGPU / AI / Web3D** → 你其实在往“引擎层”靠

你现在真正缺的不是：

> “再学一个 API”

而是：

> **建立一套从 GPU 视角出发的、稳定的图形心智模型**

WebGPU，恰好是一个**强迫你这么做的工具**。

---

### 1.2 从 Canvas → Three.js → WebGPU，本质发生了什么变化？

我们用一句话概括每一层：

- **Canvas 2D**：
  > CPU 在画画，GPU 只是帮你显示结果

- **Three.js / WebGL**：
  > CPU 负责“搭场景”，GPU 负责“算像素”

- **WebGPU**：
  > CPU 和 GPU 各司其职，像两个并行系统

关键变化只有一个：

> **你不再是“请求 GPU 帮忙画”，而是在“给 GPU 下达一整套工作计划”**。

这句话你可以现在不完全懂，但请记住它。

---

### 1.3 为什么 WebGPU 是“下一代”，而不是“WebGL 2.0”？

很多人第一次接触 WebGPU 会骂一句：

> “这 API 怎么这么反人类？”

这是一个**非常健康的反应**。

因为 WebGPU 的设计目标，从一开始就不是“让你画个三角形爽一下”，而是：

> **让 Web 能够承载“接近原生引擎级别”的图形与计算系统**。

我们从三个核心差异来看。

---

#### 1.3.1 WebGL：状态机；WebGPU：命令系统

**WebGL 的世界观**是：

- 有一个全局状态机（State Machine）
- 你不断 setState → draw

```js
// WebGL 的典型风格（伪代码）
gl.useProgram(program)
gl.bindBuffer(gl.ARRAY_BUFFER, buffer)
gl.enableVertexAttribArray(0)
gl.drawArrays(gl.TRIANGLES, 0, 3)
```

问题是：

- 状态多
- 隐式依赖多
- GPU 真正什么时候执行，你并不知道

**WebGPU 的世界观**是：

> 我不关心你“现在是什么状态”，
>
> 我只关心：**你要 GPU 按什么顺序，干哪些事**。

这就是为什么 WebGPU 里充满了这些东西：

- CommandEncoder
- RenderPass
- ComputePass
- Pipeline

它不是啰嗦，

> 它是在逼你**像写一个 GPU 调度脚本一样思考**。

---

#### 1.3.2 WebGPU = Web + Vulkan / Metal / DX12 的思维方式

WebGPU 并不是拍脑袋设计的。

它本质上是：

> **把 Vulkan / Metal / DX12 的共同抽象，搬进 Web**

这意味着什么？

- 显式资源管理（Buffer / Texture）
- 显式 Pipeline（而不是临时拼 Shader）
- 显式同步（Pass、Encoder、Queue）

好处只有一个，但非常致命：

> **你学会的是“现代 GPU 编程思想”，而不是某个平台 API**。

这对你未来做：

- Web 引擎
- Web Blender
- Web CAD
- Web 物理 / 计算

是**一次性打通任督二脉**的事。

---

### 1.4 WebGPU 不只是“画图 API”，而是一个 GPU 平台

这是很多教程没讲清楚的一点。

WebGPU ≠ WebGL + 更快

WebGPU =

- **Render Pipeline（渲染）**
- **Compute Pipeline（计算）**
- **统一的资源系统（Buffer / Texture / BindGroup）**

换句话说：

> WebGPU 是 Web 上第一个**可以认真做 GPGPU 的官方方案**。

这意味着：

- 你可以用它写几何处理
- 写蒙皮
- 写粒子系统
- 写光照预计算
- 写物理 / 模拟
- 写 AI 推理（轻量）

这正是 **Blender / Unity / Unreal 的核心能力来源**。

---

### 1.5 如果目标是「Blender Lite in Web」，你到底要学哪些？

我们先把“WebGPU”这三个字拆开。

#### 1️⃣ GPU 世界观（最重要）

你必须从这几个问题出发思考：

- 数据在哪里？（CPU 内存 vs GPU 内存）
- 谁在算？（JS vs Shader）
- 算完的结果给谁用？

> **这不是 API 问题，是架构问题。**

---

#### 2️⃣ 渲染管线，而不是“画三角形”

Blender 的本质是：

> 一套极其复杂的「数据 → 几何 → 着色 → 输出」流水线

WebGPU 正好就是：

- Vertex Stage
- Fragment Stage
-（可选）Compute Stage

你要学的不是：

> “怎么画一个三角形”

而是：

> “我该把哪些计算，放在哪个 Stage 里做？”

---

#### 3️⃣ 数据驱动，而不是 Scene 驱动

Three.js 是 Scene 驱动：

```txt
Scene
 ├─ Mesh
 │   ├─ Geometry
 │   └─ Material
```

WebGPU 是：

```txt
Buffer / Texture
   ↓
Pipeline
   ↓
Command
```

这是一个**底层到可怕，但自由到极致的世界**。

---

### 1.6 本书你将如何学习 WebGPU？（路线说明）

这本书不会：

- 按 API 文档顺序讲
- 上来就堆一堆接口

而是按**“你要做引擎”**的顺序来。

大致路线是：

1. **建立 GPU 思维模型**（你正在读）
2. WebGPU 的最小运行单元
3. 数据如何进入 GPU
4. Shader 如何工作（WGSL）
5. Render Pipeline 的真正含义
6. 从“画”到“算”：Compute Shader
7. 构建一个最小渲染内核
8. 向 Blender Lite 演进

---

### 1.7 写在第一章结尾的一句话

如果你之前对 WebGPU 的感觉是：

> “这东西好复杂，好底层”

那么请你记住一句话：

> **WebGPU 不是难，而是终于不再帮你“隐瞒复杂性”了。**

而 Blender、引擎、CAD，本来就不该是简单的。

---

（第一章完）

---

## 第二章：浏览器是如何把你带到 GPU 面前的？——WebGPU 的最小世界观

如果说第一章是在回答：

>「**我为什么要学 WebGPU？**」

那么这一章只做一件事：

> **搞清楚：当你在浏览器里写 WebGPU 代码时，到底发生了什么。**

不是 API 细节，而是：

- 谁在创建谁？
- 谁持有什么权力？
- 哪些东西是一等公民，哪些只是工具？

只要这套关系你搞明白了，后面所有对象都会“各就各位”。

---

### 2.1 一个先入为主的结论

先给你一个结论，后面我们慢慢拆：

> **WebGPU 本质上是：浏览器给你开了一个“GPU 任务窗口”，
> 你只能通过这个窗口，用一种非常受控的方式给 GPU 派活。**

这个窗口里，有且只有三类核心角色：

1. **你（JavaScript）** —— 只负责“描述要干什么”
2. **浏览器（WebGPU 实现）** —— 翻译 + 安全隔离
3. **GPU（真实硬件）** —— 冷酷无情地执行

请注意：

> **你永远不会“直接控制 GPU”**

你控制的是：

> 一套“可以被 GPU 执行的命令描述”。

---

### 2.2 从 `navigator.gpu` 开始，但不要被它骗了

几乎所有教程都会从这一行开始：

```ts
const adapter = await navigator.gpu.requestAdapter();
const device = await adapter.requestDevice();
```

你可能已经写过无数次，但我们今天要问的不是“怎么写”，而是：

> **adapter 和 device 到底是什么？**

---

### 2.3 GPUAdapter：浏览器替你“挑 GPU”

#### 2.3.1 你其实没资格选 GPU

在原生环境（Vulkan / DX12）里：

- 你可以枚举物理设备
- 看显存大小
- 看支持特性
- 自己决定用哪个

在 Web 里？

> 不行。

原因只有一个：**安全 + 可移植性**。

所以 WebGPU 说：

> “你别管底下是 NVIDIA / AMD / Apple / 集显，
> 我给你一个『我认为合适的』。”

这个中间人，就是 **GPUAdapter**。

你可以把它理解成：

> **“浏览器视角下，对某个 GPU 能力集合的抽象描述”**。

---

#### 2.3.2 Adapter 更像是「简历」，不是「工人」

Adapter 有几个重要特征：

- ❌ 不能创建 Buffer
- ❌ 不能提交命令
- ❌ 不能跑 Shader

它能干的事情只有：

- 告诉你：
  - 支持哪些 feature
  - 支持哪些 limit
- 帮你生成一个 **device**

一句话：

> **Adapter ≈ GPU 的能力说明书**

真正干活的，还没登场。

---

### 2.4 GPUDevice：你在 WebGPU 世界里的“唯一身份证”

如果你只记住一个 WebGPU 对象，那一定是它：

> **GPUDevice**

#### 2.4.1 一个非常重要的事实

> **你所有能做的事情，都是从 device 开始的。**

- 创建 buffer
- 创建 texture
- 创建 pipeline
- 创建 bind group
- 创建 command encoder

全都要 device。

这不是设计癖好，而是一个**极其关键的架构约束**。

---

#### 2.4.2 为什么 WebGPU 要这样设计？

原因有三个：

1️⃣ **资源归属必须清晰**

GPU 资源是稀缺且危险的：

- 显存
- 线程
- 带宽

WebGPU 必须知道：

> “这些资源，属于哪个上下文？”

device 就是这个上下文的“边界”。

---

2️⃣ **便于浏览器做隔离与回收**

当：

- 页面关闭
- iframe 销毁
- tab 崩溃

浏览器只需要：

> 干掉整个 device

而不是追踪一堆零散对象。

---

3️⃣ **对齐现代原生 API 的思路**

如果你未来看 Vulkan / Metal，你会发现：

> device 本来就是一切的起点。

WebGPU 只是把这个现实，搬进了 Web。

---

### 2.5 Queue：你真正“把活交给 GPU”的地方

device 有一个非常容易被忽略的属性：

```ts
device.queue
```

这个 queue，地位极其高。

#### 2.5.1 JS 不是在“调用 GPU”，而是在“排队”

这是一个**认知转折点**：

> **你写 WebGPU 代码时，并没有立即执行任何 GPU 计算。**

你只是在：

- 创建资源
- 录制命令
- 把命令提交到 queue

真正的执行时间：

> **由 GPU 自己决定。**

---

#### 2.5.2 为什么一定要有 Queue？

因为 GPU：

- 是高度并行设备
- 有自己的调度系统
- 不可能被 JS 一步步“同步调用”

Queue 的存在，本质是：

> **在 CPU 世界 和 GPU 世界 之间，放一条“缓冲带”。**

这条缓冲带：

- 解耦
- 提高吞吐
- 允许浏览器优化

---

### 2.6 CommandEncoder：你不是在画，而是在“写剧本”

这是 WebGPU 最反直觉、但也最强大的设计之一。

#### 2.6.1 不要把它当成 draw

在 WebGL 里：

```js
gl.drawArrays(...)
```

在 WebGPU 里：

> 没有 draw，只有**录制**。

你做的是：

```txt
开始录制 → 描述一系列操作 → 结束录制
```

这就是 **CommandEncoder**。

---

#### 2.6.2 为什么要“录制命令”？

因为 GPU 的世界是：

- 高延迟
- 高并行
- 极度不适合即时调用

所以现代图形 API 都选择：

> **先把要做的事“描述清楚”，一次性交给 GPU。**

你可以把它类比为：

- Blender 里的一次 Render Job
- Three.js 内部的一帧渲染列表

但 WebGPU 让你**亲自写这个列表**。

---

### 2.7 RenderPass / ComputePass：GPU 世界的“工作模式”

CommandEncoder 本身不干活，它只是一个容器。

真正的“工作单元”，是 Pass。

#### 2.7.1 RenderPass：我现在要画东西

RenderPass 里，你只能做和“渲染”相关的事：

- 设置渲染管线
- 绑定资源
- 发 draw

它有一个非常重要的特性：

> **目标是一个（或多个）明确的 Texture。**

也就是：

> “我这次画出来的东西，要写到哪里？”

---

#### 2.7.2 ComputePass：我现在只想算

ComputePass 则完全不同：

- 不关心屏幕
- 不关心颜色
- 只关心数据

这正是：

- 粒子
- 几何处理
- 物理
- AI

的核心舞台。

---

### 2.8 这一章你真正需要记住的东西

如果你现在有点晕，没关系。

请你只记住这张“白话版结构图”：

```txt
JavaScript
   ↓
Adapter  —— 选 GPU 能力
   ↓
Device   —— WebGPU 世界的身份证
   ↓
CommandEncoder —— 录制 GPU 要干的事
   ↓
Queue.submit() —— 把剧本交给 GPU
   ↓
GPU 并行执行
```

这不是 API 流程图，

> **这是你以后所有 WebGPU 架构设计的地基。**

---

### 2.9 写在第二章结尾的一句话

如果你之前的感觉是：

> “WebGPU 好像什么都要我自己管”

那我想告诉你：

> **你现在管的，是以前 Three.js / 引擎替你“偷偷管”的东西。**

当你要做 Blender Lite 时，这些东西：

- 你迟早要面对
- 你越早面对，系统就越稳

---

（第二章完）

---

## 第三章：数据是如何真正进入 GPU 的？——Buffer 不是数组，而是“契约”

从这一章开始，我们正式踏入 WebGPU **最容易劝退人、但也最核心的区域**。

如果你之前在想：

> “前两章都挺顺的，这一章应该也差不多吧？”

那我先给你一个心理预期：

> **这一章不难，但一定会“拧巴”。**

因为它会系统性地打碎你在 JS / Canvas / Three.js 里形成的一个默认认知：

> **“数据就是数组，我想怎么改就怎么改。”**

在 GPU 世界里，这个认知是错的。

---

### 3.1 一个必须先接受的现实

我们先不看任何 API，只看一句话：

> **GPU 不信任你。**

这不是情绪判断，而是工程事实。

#### 3.1.1 为什么 GPU 必须“不信任”？

因为 GPU：

- 是并行设备
- 在你 JS 线程之外执行
- 一次会处理成千上万条数据

如果 GPU 允许你：

- 随时改数据
- 改一半
- 改的过程中还在算

那结果只有一个：

> **世界直接乱套。**

所以 GPU 世界的第一原则是：

> **数据在被使用时，必须是稳定的、不可变的。**

---

### 3.2 Three.js 里的 Buffer，和 WebGPU 里的 Buffer，有本质区别

你在 Three.js 里，可能写过无数次：

```ts
geometry.attributes.position.array[0] += 1;
geometry.attributes.position.needsUpdate = true;
```

这段代码在 Three.js 里看起来非常自然。

但你要意识到一件事：

> **这是 Three.js 在“替你擦屁股”。**

它在背后做了很多你没看到的事：

- 拷贝数据
- 标记 dirty
- 合适的时机同步到 GPU

WebGPU：

> **不替你做这件事。**

---

### 3.3 Buffer 在 WebGPU 中真正的定义

我们现在给 Buffer 一个非常不 API 的定义：

> **Buffer 是一段位于 GPU 内存中的、
> 只能通过明确规则读写的数据块。**

注意这几个关键词：

- GPU 内存
- 明确规则
- 数据块

它不是：

- JS Array
- Float32Array
- 动态对象

---

### 3.4 CPU 内存 vs GPU 内存：两个世界

这是理解一切 Buffer 行为的关键分界线。

#### 3.4.1 CPU 内存（你熟悉的世界）

- JS 变量
- Array / TypedArray
- 随时可读写
- 单线程逻辑

#### 3.4.2 GPU 内存（你即将进入的世界）

- Buffer / Texture
- 高并行访问
- 强约束
- 异步执行

这两个世界之间：

> **没有“自动同步”。**

所有数据流动，都必须：

- 显式
- 可追踪
- 符合规则

---

### 3.5 `usage`：你在和 GPU 签合同

创建 Buffer 时，你一定见过这个东西：

```ts
device.createBuffer({
  size: 1024,
  usage: GPUBufferUsage.VERTEX | GPUBufferUsage.COPY_DST
});
```

大多数人一开始的态度是：

> “哦，usage，照抄就完事了。”

这是**非常危险的习惯**。

---

#### 3.5.1 usage 的本质不是权限，而是“承诺”

当你写：

```ts
usage: GPUBufferUsage.VERTEX
```

你其实是在对 GPU 说：

> “这段数据，将来只会被当作顶点数据来读。”

当你加上：

```ts
| GPUBufferUsage.COPY_DST
```

意思是：

> “而且我保证，数据只会通过 copy 的方式更新。”

GPU 会基于你的**承诺**：

- 决定内存布局
- 决定缓存策略
- 决定能不能并行

如果你事后反悔？

> **不行，合同已经签了。**

---

### 3.6 为什么 WebGPU 不允许你“随便改 Buffer”？

很多人第一次看到这些限制会非常不爽：

- 不能直接写
- 不能 map 同时用
- copy 来 copy 去

但你要从 GPU 视角看：

> **限制越多，GPU 才越敢跑得快。**

这是现代图形 API 的共识。

---

### 3.7 一次完整的数据上传流程（白话版）

我们现在用“人话”描述一次最典型的数据流：

#### 场景：把一组顶点数据交给 GPU

1️⃣ 你在 JS 里准备数据（TypedArray）

2️⃣ 你创建一个 GPUBuffer（声明用途）

3️⃣ 你通过 `queue.writeBuffer` 或 copy

4️⃣ 数据被安全地搬进 GPU 内存

5️⃣ GPU 在合适的时机读取

整个过程的核心是：

> **CPU 世界的数据，在“某个确定的时间点”，
> 被“整体地”交给 GPU。**

而不是：

> “你一边算，我一边偷偷改”。

---

### 3.8 这对 Blender Lite 意味着什么？

这是你现在这个阶段**最值钱的一问**。

在 Blender Lite 中：

- 顶点
- 法线
- UV
- 索引
- Instance 数据

都意味着：

> **大量、频繁、但可预测的数据更新。**

WebGPU 在逼你做一件正确但痛苦的事：

> **把“随意修改”，升级为“明确的数据流设计”。**

这正是：

- Geometry Nodes
- Modifier Stack
- Depsgraph

背后的共同思想。

---

### 3.9 这一章你真正需要内化的三句话

如果你现在有点累，请至少带走这三句话：

1️⃣ **Buffer 是 GPU 内存里的资源，不是 JS 数组**

2️⃣ **usage 是你和 GPU 的契约，不是装饰**

3️⃣ **限制不是为了折磨你，而是为了让 GPU 放开跑**

---

### 3.10 写在第三章结尾的一句话

当你开始觉得：

> “WebGPU 怎么这么多规矩”

请你换个角度想：

> **这是你第一次，被允许站在“引擎作者”的位置思考问题。**

---

> 下一章，我们将进入另一个核心地带：
>
> **Shader（WGSL）：GPU 世界真正理解的语言。**
>
> 从这里开始，JS 将正式退居幕后。

（第三章完）

---

## 第四章：WGSL——GPU 世界真正理解的语言

如果说前三章是在帮你**把位置站对**，那从这一章开始，我们终于要做一件实事：

> **让 GPU 听懂你在说什么。**

这一步，很多人会本能地紧张。

因为一提到 Shader，脑子里往往会冒出这些词：

- 数学
- 向量
- 矩阵
- 黑魔法

但我先给你一个结论，压压惊：

> **Shader 并不神秘，它只是“运行在 GPU 上的函数”。**

只不过，它有一套非常严格的规则。

---

### 4.1 先把 Shader 从“魔法”拉回“函数”

我们先完全不谈 WGSL 语法，只谈本质。

#### 4.1.1 一个极其重要的认知转变

在 JS 里，你写函数是为了：

> “接收输入 → 做点逻辑 → 返回结果”

在 GPU 里，Shader 做的事情是：

> **对“成千上万份输入数据”，
> 用“同一段函数逻辑”，
> 并行算出结果。**

这句话你一定要慢慢读。

Shader 的关键不在“怎么算”，而在：

> **同一段代码，会同时跑在无数数据上。**

---

#### 4.1.2 Shader ≈ 数学意义上的“映射”

你可以用一个非常工程化的视角理解 Shader：

```txt
输入数据  ——>  Shader 函数  ——>  输出数据
```

区别只在于：

- 输入不是一个
- 输出也不是一个
- 中间不能有副作用

这也是为什么：

> **Shader 世界里，几乎没有“状态”。**

---

### 4.2 为什么 WebGPU 要发明 WGSL？

你可能会问一个非常合理的问题：

> “我都学过 GLSL 了，为什么不直接用？”

答案很直接：

> **因为 GLSL 不适合 WebGPU 的设计目标。**

---

#### 4.2.1 WGSL 的设计出发点

WGSL 在设计之初，就明确了几件事：

- 必须安全（不能随便炸浏览器）
- 必须可验证（编译前就能检查问题）
- 必须跨平台一致
- 必须对齐现代 GPU 管线

为了这些目标，它做了很多“反直觉但理性”的选择。

---

#### 4.2.2 WGSL 是“强约束语言”

如果你写 WGSL 时经常遇到：

- 类型不匹配
- 地址空间不对
- 布局不合法

那不是它在刁难你，而是：

> **它拒绝帮你“猜”。**

GPU 世界里：

> **猜 = 不确定 = 不可并行 = 不可优化**

---

### 4.3 Shader 在 WebGPU 管线中的真实位置

我们现在把 Shader 放回整个 WebGPU 系统里看。

在最基础的渲染流程中，你会遇到两个 Shader：

- **Vertex Shader**
- **Fragment Shader**

它们不是“先后执行的两段代码”，而是：

> **两个完全不同职责的并行阶段。**

---

### 4.4 Vertex Shader：它真的不是“画点”

这是一个被误解得最严重的地方。

#### 4.4.1 Vertex Shader 的真实工作

Vertex Shader 干的事只有一类：

> **把“输入顶点数据”，变换成“裁剪空间中的位置”。**

注意关键词：

- 变换
- 空间

它：

- 不知道三角形
- 不知道面
- 不知道像素

它只知道：

> “给我一份顶点数据，我算出一个位置。”

---

#### 4.4.2 顶点 = 数据记录，不是“点”

在 GPU 眼里，一个“顶点”本质是：

```txt
{
  position,
  normal,
  uv,
  ...
}
```

Vertex Shader 就是：

> **对每一条记录，执行同一段函数。**

这和你在 JS 里：

```ts
array.map(v => transform(v))
```

在思想上是完全一致的。

---

### 4.5 Fragment Shader：它也不是“画像素”

很多教程会说：

> “Fragment Shader 负责给像素上色”

这句话**不算错，但不够准确**。

---

#### 4.5.1 Fragment 的本质：一次采样请求

Fragment Shader 实际面对的是：

> **“这里有一个需要颜色的片段，你告诉我它是什么颜色。”**

它：

- 不知道屏幕
- 不知道相邻像素
- 不知道整体

它只回答：

> “这个位置，在这种条件下，是什么颜色。”

---

### 4.6 一个极简 WGSL Shader（带完整解释）

我们来看一个**最小但完整**的 WGSL 示例，用它来拆解所有关键概念。

```wgsl
// 定义一个结构体，用来描述顶点输入
struct VertexInput {
  @location(0) position : vec2<f32>,
};

// 定义 Vertex Shader 的入口函数
@vertex
fn vs_main(input : VertexInput) -> @builtin(position) vec4<f32> {
  // 把 2D 坐标扩展成裁剪空间的 vec4
  return vec4<f32>(input.position, 0.0, 1.0);
}

// 定义 Fragment Shader 的入口函数
@fragment
fn fs_main() -> @location(0) vec4<f32> {
  // 返回一个固定颜色
  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
}
```

现在我们一句一句拆。

---

#### 4.6.1 `@vertex` / `@fragment`

这不是装饰器，是：

> **明确告诉 GPU：这个函数在哪个阶段执行。**

GPU 不会“猜”你想干嘛。

---

#### 4.6.2 `@location`

这是一个**极其重要的概念**。

它的本质是：

> **Shader 与外部数据之间的“插槽编号”。**

- JS 这边：
  - 第 0 个 attribute
- Shader 这边：
  - `@location(0)`

它们必须**严格对齐**。

---

#### 4.6.3 `@builtin(position)`

这是 GPU 规定的“特殊出口”。

Vertex Shader 必须告诉 GPU 一件事：

> **这个顶点最终在裁剪空间的位置。**

否则，后续所有流程都无法进行。

---

### 4.7 WGSL 的一个核心哲学：一切都要“写清楚”

你可能已经感觉到了：

- 类型写得很啰嗦
- 返回值要求很严格
- 入口函数格式固定

这是刻意的。

WGSL 在逼你做一件事：

> **把所有 GPU 相关的意图，显式写出来。**

这样 GPU 才敢：

- 并行
- 预编译
- 深度优化

---

### 4.8 这对 Blender Lite 意味着什么？

这是本章最重要的问题。

在 Blender Lite 中：

- Vertex Shader ≠ 只是 MVP 变换
- Fragment Shader ≠ 只是上色

它们将承担：

- 法线空间变换
- 蒙皮
- 实例化
- 材质系统

而 WGSL 的“啰嗦”，恰恰是你：

> **构建稳定、可组合、可扩展 Shader 系统的基础。**

---

### 4.9 本章你需要真正消化的四个认知

1️⃣ **Shader 是函数，不是魔法**

2️⃣ **Shader 是并行映射，不是流程控制**

3️⃣ **Vertex / Fragment 是职责分工，不是前后顺序**

4️⃣ **WGSL 的严格，是为了让系统长期可维护**

---

### 4.10 写在第四章结尾的一句话

当你第一次开始“习惯”WGSL 时，

你其实已经跨过了一个很隐蔽的门槛：

> **你不再是“在用 GPU”，
> 而是在“为 GPU 设计程序”。**

---

> 下一章，我们将把：
>
> - Buffer
> - Shader
>
> 真正连起来，讲清楚：
>
> **Render Pipeline 到底是什么？
> 为什么它是 WebGPU 的核心骨架？**

（第四章完）

---

## 第五章（实战）：从引擎视角搭建一个“最小可用渲染管线”

这一章，我们终于要“动手画点东西”了。

但我先打一个非常重要的预防针：

> **这一章不是教你“如何画一个三角形”。**

如果你的目标只是看到屏幕上出现一个彩色三角形，那网上 10 分钟的视频已经够了。

这一章真正的目标只有一个：

> **站在“引擎作者”的角度，理解：
> WebGPU 为什么必须这样设计一条渲染管线。**

你之后要做的 Blender Lite，本质上就是：

> 在这条“最小管线”的基础上，不断加零件。

---

### 5.1 先给“最小渲染管线”下一个工程化定义

从引擎视角看，一条最小可用的渲染管线，至少要回答五个问题：

1️⃣ 数据从哪里来？（顶点数据）
2️⃣ 数据怎么进 GPU？（Buffer）
3️⃣ GPU 用什么逻辑处理？（Shader）
4️⃣ 处理规则如何固定？（Pipeline）
5️⃣ 什么时候执行？（Command）

注意：

> **WebGPU 的所有 API，几乎都能被归类到这五个问题里。**

这是一个非常重要的“归纳视角”。

---

### 5.2 引擎视角的第一步：先冻结“结构”，再填内容

这是 WebGPU 和 WebGL 最大的思想差异之一。

在 WebGPU 中，你**不能**：

> “一边画，一边随便改状态。”

你必须先做一件事：

> **声明：
> 我这一类绘制，大概长什么样。**

这个“声明”，就是 Render Pipeline。

---

### 5.3 Render Pipeline 本质是什么？

一句话版定义：

> **Render Pipeline = 一份“GPU 执行合约”。**

这份合约里，明确写着：

- 顶点数据布局
- Shader 入口
- 输出格式
- 固定功能阶段的配置

一旦创建：

> **GPU 会假设这些规则永远成立。**

这正是它能极致优化的前提。

---

### 5.4 最小渲染管线的组成拆解

我们现在用“引擎模块”的方式，把画三角形拆成几个零件。

---

#### 5.4.1 顶点数据：不要把它当成“点”

在引擎层，你永远要记住：

> **顶点 = 一段结构化二进制数据。**

最小三角形的数据，可以抽象成：

```txt
Vertex {
  position: vec2<f32>
}
```

注意这里的关键点：

- 连续内存
- 固定 stride
- GPU 可预测

---

#### 5.4.2 Vertex Buffer：GPU 世界的“只读数组”

在 WebGPU 中：

- Vertex Buffer ≠ JS Array
- 它更像是：

> **一次性上传、GPU 高频读取的数据块**

从引擎设计角度：

> **你要尽量减少 buffer 的种类，而不是随便 new。**

---

### 5.5 Shader：在这一章里，我们只干一件事

这一章的 Shader 目标非常克制：

- Vertex Shader：
  - 接收 position
  - 输出裁剪空间坐标

- Fragment Shader：
  - 输出固定颜色

原因很简单：

> **我们现在关注的是“数据怎么走完整条管线”，而不是“怎么算”。**

---

### 5.6 Pipeline 描述：所有“对齐关系”的集中地

这是初学 WebGPU 最容易翻车的地方。

Pipeline 是以下几件事的**唯一交汇点**：

- Vertex Buffer layout
- Shader `@location`
- Color target format

你可以把 Pipeline 想象成：

> **一张“总对照表”。**

任何一边对不上，GPU 都会直接拒绝你。

---

### 5.7 用代码串起整条最小管线（高密度注释版）

下面这段代码，我建议你不要“复制运行”，而是：

> **一行一行对照着“管线流程图”去读。**

```ts
// 1️⃣ 准备顶点数据（三个点，二维坐标）
const vertices = new Float32Array([
  0.0,  0.5,
 -0.5, -0.5,
  0.5, -0.5,
]);

// 2️⃣ 创建 GPU Buffer，用来存顶点数据
const vertexBuffer = device.createBuffer({
  size: vertices.byteLength,
  usage: GPUBufferUsage.VERTEX | GPUBufferUsage.COPY_DST,
});

// 把 JS 内存中的数据拷贝到 GPU
device.queue.writeBuffer(vertexBuffer, 0, vertices);

// 3️⃣ 定义顶点布局（非常关键）
const vertexLayout: GPUVertexBufferLayout = {
  arrayStride: 2 * 4, // 每个顶点占 2 个 f32
  attributes: [
    {
      shaderLocation: 0, // 对应 WGSL 中的 @location(0)
      offset: 0,
      format: 'float32x2',
    },
  ],
};

// 4️⃣ 创建渲染管线
const pipeline = device.createRenderPipeline({
  layout: 'auto',
  vertex: {
    module: shaderModule,
    entryPoint: 'vs_main',
    buffers: [vertexLayout],
  },
  fragment: {
    module: shaderModule,
    entryPoint: 'fs_main',
    targets: [{ format: presentationFormat }],
  },
  primitive: {
    topology: 'triangle-list',
  },
});

// 5️⃣ 在 render pass 中使用这条管线
passEncoder.setPipeline(pipeline);
passEncoder.setVertexBuffer(0, vertexBuffer);
passEncoder.draw(3);
```

---

### 5.8 用“引擎作者”的眼睛复盘一次

请你现在不要想“API 调用顺序”，而是想这几个问题：

- 为什么 vertexLayout 必须提前声明？
- 为什么 shaderLocation 要手动对齐？
- 为什么 pipeline 创建成本高，但 draw 很便宜？

你如果能回答：

> **“因为 GPU 需要在 draw 之前，把一切不确定性消灭掉。”**

那你已经真的理解了这一章。

---

### 5.9 这一章对 Blender Lite 的真实意义

你现在已经拥有了：

- 一条最小渲染骨架
- 一次 draw call 的完整心智模型

接下来无论是：

- 加 index buffer
- 加 uniform
- 加 instance

本质都是：

> **在这条骨架上，增加新的数据通道。**

---

### 5.10 写在实战章结尾的一句话

很多人画完三角形就结束了。

但真正重要的不是：

> “我画出来了。”

而是：

> **“我知道这条管线，为什么必须长这样。”**

这，才是你从“使用 WebGPU”，走向“设计 WebGPU 系统”的分水岭。

（第五章·实战 完）

---

## 第六章（实战）：Uniform / BindGroup —— 当相机出现，世界才真正开始

如果说上一章你只是“让 GPU 画了点东西”，

那从这一章开始，事情会发生一个**质变**：

> **你第一次让 GPU 参与“世界观”的计算。**

也就是：

- 相机
- 空间
- 观察视角

这一步，是 Blender Lite 从“Demo”迈向“工具”的分水岭。

---

### 6.1 先说结论：没有 Uniform，就没有世界

我们先把话说得非常直白。

如果一个渲染系统里：

- 每个物体都只能写死在 Shader 里
- 每次 draw 都只能靠顶点自身

那它最多只能：

> **画一些静态图形。**

一旦你想要：

- 相机移动
- 物体平移 / 旋转 / 缩放
- 多个物体共享同一套规则

你就**必须**引入一个概念：

> **Uniform 数据。**

---

### 6.2 用一句人话理解 Uniform

Uniform 的本质一句话就够：

> **“这一批 GPU 计算，共享的一份外部参数。”**

注意关键词：

- 共享
- 外部
- 参数

它不是顶点属性，

它不是每个 fragment 各算各的，

而是：

> **在一段时间内，对所有 Shader 调用都成立的前提条件。**

---

### 6.3 MVP：不是数学问题，而是“职责拆分”

很多人第一次学 MVP，死在矩阵推导上。

但在引擎视角里，你应该这样看它：

- **Model**：
  - 物体自己的局部规则
- **View**：
  - 相机怎么看世界
- **Projection**：
  - 世界如何被投影到屏幕

这不是数学分层，

而是：

> **系统职责分层。**

---

### 6.4 为什么 MVP 一定要放在 Uniform 里？

我们先反问一句：

> “如果不用 Uniform，把 MVP 写哪？”

- 写死在 Shader？→ 不可变
- 写在顶点里？→ 每个顶点一份，巨大浪费

所以答案只有一个：

> **放在 GPU 可高频访问、但不随顶点变化的地方。**

这正是 Uniform Buffer 的定位。

---

### 6.5 BindGroup：WebGPU 最像“架构设计”的地方

这是很多 WebGPU 教程一笔带过、

但你未来一定会反复打交道的核心概念。

#### 6.5.1 BindGroup 不是“绑定操作”

名字非常容易误导人。

BindGroup **不是一个动词**，而是一个：

> **静态的数据依赖描述。**

它在告诉 GPU：

> “接下来这次 draw，Shader 里用到的这些外部资源，都在这。”

---

#### 6.5.2 BindGroup = GPU 侧的“参数对象”

如果用你熟悉的前端类比：

- JS 函数参数 → BindGroup
- 参数顺序 → binding / group
- 参数类型 → buffer / texture / sampler

区别在于：

> **GPU 要在 draw 之前，就知道完整参数结构。**

---

### 6.6 给三角形加上 MVP（完整链路版）

这一节，是本章的“主菜”。

我们不会追求数学优雅，

只追求：

> **数据如何从 JS，走到 Shader，再影响空间。**

---

#### 6.6.1 WGSL：声明一个 Uniform Buffer

```wgsl
struct Uniforms {
  mvp : mat4x4<f32>,
};

@group(0) @binding(0)
var<uniform> uniforms : Uniforms;
```

这里有三个非常重要的信息：

1️⃣ `var<uniform>`：
   - 告诉 GPU：这是共享只读数据

2️⃣ `@group(0) @binding(0)`：
   - 它不是随便写的数字
   - 而是 **管线合约的一部分**

3️⃣ `mat4x4<f32>`：
   - 内存布局固定
   - JS 侧必须严格匹配

---

#### 6.6.2 Vertex Shader 中使用 MVP

```wgsl
@vertex
fn vs_main(input: VertexInput) -> @builtin(position) vec4<f32> {
  return uniforms.mvp * vec4<f32>(input.position, 0.0, 1.0);
}
```

这行代码的意义是：

> **顶点的位置，不再是“死的”，
> 而是活在一个可变化的世界里。**

---

### 6.7 JS 侧：创建 Uniform Buffer

```ts
// 1️⃣ 创建一个 4x4 矩阵（这里假设你已有数学库）
const mvpMatrix = new Float32Array(16);

// 2️⃣ 创建 Uniform Buffer
const uniformBuffer = device.createBuffer({
  size: 64, // 16 * 4 bytes
  usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
});

// 3️⃣ 写入数据
device.queue.writeBuffer(uniformBuffer, 0, mvpMatrix);
```

注意：

> **Uniform Buffer 的 size 和对齐，是硬性规则。**

在复杂系统中，这是非常容易踩坑的地方。

---

### 6.8 创建 BindGroup：把“外部世界”交给 GPU

```ts
const bindGroup = device.createBindGroup({
  layout: pipeline.getBindGroupLayout(0),
  entries: [
    {
      binding: 0,
      resource: { buffer: uniformBuffer },
    },
  ],
});
```

这一刻发生了一件非常重要的事：

> **你的 Shader，不再是孤立函数，
> 而是被注入了“世界参数”。**

---

### 6.9 在 draw 时使用 BindGroup

```ts
passEncoder.setPipeline(pipeline);
passEncoder.setBindGroup(0, bindGroup);
passEncoder.setVertexBuffer(0, vertexBuffer);
passEncoder.draw(3);
```

顺序不是重点，

重点是：

> **这次 draw 的“上下文”，终于完整了。**

---

### 6.10 当相机开始动，会发生什么？

现在，只要你在每一帧：

- 更新 mvpMatrix
- writeBuffer

你就会看到：

> 三角形在“世界中”移动，而不是贴在屏幕上。

这是你第一次：

> **用 WebGPU 构建一个可被观察的空间。**

---

### 6.11 这一章对 Blender Lite 的真实意义

从这一章开始，你已经具备：

- 相机系统的雏形
- 世界坐标的概念
- 全局参数管理方式

接下来：

- 多物体 = 多 Model Matrix
- 多相机 = 多 Uniform 组
- 材质参数 = 更多 BindGroup

所有复杂系统，

都是从这里**线性生长**出来的。

---

### 6.12 写在本章结尾的一句话

当你第一次看到：

> “我只改了一份 Uniform，
> 整个世界就变了。”

那一刻你应该意识到：

> **你已经不是在画图，
> 而是在驱动一个世界。**

（第六章·实战 完）

---

## 第七章（实战）：一个最小 Scene —— 两个物体，一个相机

从这一章开始，我们要迈出**非常关键的一步**。

如果说上一章你解决的是：

> “世界怎么看？”（相机 / View / Projection）

那这一章要解决的就是：

> **“世界里有什么？”**

也就是：

- 多个物体
- 各自的变换
- 共享同一个相机

这一步，才是真正意义上的 **Scene（场景）**。

---

### 7.1 先说结论：Scene 不是树，是“数据组织方式”

很多人一提 Scene，脑子里立刻浮现：

- 树结构
- 父子节点
- 递归更新

但在我们这个阶段，这些都**太早了**。

在引擎视角下，Scene 的最小定义其实非常朴素：

> **Scene = 一组可被同一套全局规则观察的物体集合。**

注意这里的关键词：

- 一组
- 全局规则（相机 / 投影）

---

### 7.2 为什么“一个 MVP”已经不够用了？

上一章，我们把 MVP 放进了 Uniform。

那如果现在有两个物体：

- 位置不同
- 旋转不同
- 缩放不同

你会立刻遇到一个问题：

> **Model 不同，但 View / Projection 是相同的。**

如果你还坚持：

- 每个物体一份完整 MVP

那结果会是：

- 重复计算 View / Projection
- 数据冗余
- 架构开始变形

这正是 Scene 出现的信号。

---

### 7.3 一个非常重要的拆分：Global vs Local

从引擎设计角度，这一步至关重要。

我们要明确区分两类数据：

#### 7.3.1 全局数据（Global）

- View Matrix
- Projection Matrix
- 时间
- 光照环境

特点只有一个：

> **一帧内，对所有物体都成立。**

---

#### 7.3.2 局部数据（Local）

- Model Matrix
- 物体自身参数

特点也只有一个：

> **只对当前 draw 的物体成立。**

这一刀切下去，

你的引擎轮廓已经开始出现了。

---

### 7.4 Shader 侧的变化：拆 MVP

我们先从 Shader 开始动手。

#### 7.4.1 全局 Uniform：View + Projection

```wgsl
struct GlobalUniforms {
  viewProj : mat4x4<f32>,
};

@group(0) @binding(0)
var<uniform> globals : GlobalUniforms;
```

它的职责非常单一：

> **描述“相机如何观察世界”。**

---

#### 7.4.2 局部 Uniform：Model

```wgsl
struct ObjectUniforms {
  model : mat4x4<f32>,
};

@group(1) @binding(0)
var<uniform> object : ObjectUniforms;
```

注意这里第一次出现了：

> **不同的 bind group。**

这是 Scene 成立的技术前提。

---

#### 7.4.3 Vertex Shader 中的最终组合

```wgsl
@vertex
fn vs_main(input: VertexInput) -> @builtin(position) vec4<f32> {
  return globals.viewProj * object.model * vec4<f32>(input.position, 0.0, 1.0);
}
```

这一行代码，非常值得你停下来想一想。

它几乎就是：

> **整个 3D 引擎的空间公式。**

---

### 7.5 JS 侧：Scene 的最小数据结构

我们不引入任何“复杂设计”，只保留必要骨架。

```ts
interface Scene {
  viewProjBuffer: GPUBuffer;
  objects: SceneObject[];
}

interface SceneObject {
  modelBuffer: GPUBuffer;
}
```

这看起来朴素得不能再朴素，

但它已经隐含了非常重要的设计决策：

- Scene 拥有全局数据
- Object 只拥有自己的局部数据

---

### 7.6 两个物体，共享一个相机

我们现在做一件非常“有画面感”的事：

- 一个三角形在左边
- 一个三角形在右边
- 相机绕着它们转

#### 7.6.1 创建全局 Uniform（一次）

```ts
const viewProjBuffer = device.createBuffer({
  size: 64,
  usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
});
```

这一份数据：

> **一帧只需要更新一次。**

---

#### 7.6.2 为每个物体创建 Model Uniform

```ts
function createObject(): SceneObject {
  const modelBuffer = device.createBuffer({
    size: 64,
    usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
  });

  return { modelBuffer };
}

const objectA = createObject();
const objectB = createObject();
```

这一刻，你已经告别了“单物体思维”。

---

### 7.7 Draw Loop：Scene 真正开始运转

```ts
passEncoder.setPipeline(pipeline);
passEncoder.setBindGroup(0, globalBindGroup);

for (const object of scene.objects) {
  passEncoder.setBindGroup(1, object.bindGroup);
  passEncoder.setVertexBuffer(0, vertexBuffer);
  passEncoder.draw(3);
}
```

请你注意这个 for 循环。

它非常普通，

但它意味着：

> **Scene = 多次 draw，共享一部分上下文。**

这正是：

- 批处理
- 渲染顺序
- 渲染队列

一切高级系统的起点。

---

### 7.8 用引擎视角回看这一章

如果你现在回头看这一章，

你应该能清晰地说出：

- Scene 到底“负责什么”
- Object 到底“拥有什么”
- 相机为什么天然是全局

如果这些在你脑中是**稳定的结构**，

那你已经不再是在“学 API”。

---

### 7.9 这一章对 Blender Lite 的真实意义

到这一章为止，你已经拥有：

- Scene 的最小骨架
- Object 的独立变换
- 相机与物体的解耦

接下来你要做的：

- Transform Hierarchy
- Scene Tree
- Instancing

都只是：

> **在这个结构上加约束和规则。**

---

### 7.10 写在本章结尾的一句话

很多人写渲染代码时，

脑子里只有：

> “这一帧我该怎么画？”

而你现在，应该开始习惯想：

> **“这一帧，我的 Scene 是什么状态？”**

这两种思维方式，

决定了你最终写出来的是：

- Demo
- 还是引擎

（第七章·实战 完）

---

## 第八章（实战为主）：第一盏灯亮起 —— 漫反射光照与材质的诞生

从这一章开始，你会明显感觉到一个变化：

> **画面开始“有体积感”了。**

这不是因为模型变复杂了，
而是因为：

> **光，第一次真正参与了计算。**

在 Blender Lite 的道路上，这是一个非常重要的里程碑。

---

### 8.1 先给你一个“残酷但真实”的结论

如果一个 3D 系统里：

- 没有光照
- 没有法线参与计算

那它本质上只是：

> **“几何体的投影工具”。**

只有当光出现，
几何体才真正变成“物体”。

---

### 8.2 光照不是特效，是“几何 + 数学”

很多初学者会把光照当成：

- Shader 魔法
- 视觉特效

但从引擎视角看，光照的本质非常朴素：

> **比较两个方向的关系。**

这句话，是你理解所有实时光照模型的钥匙。

---

### 8.3 漫反射（Diffuse）：最值得你亲手实现的光照模型

我们从最基础、也最重要的模型开始：

> **Lambert 漫反射模型**

原因很简单：

- 数学简单
- 物理直觉强
- 是所有复杂模型的地基

---

### 8.4 一点点理论（只保留“必须的”）

#### 8.4.1 法线（Normal）到底是什么？

在几何层面：

- 法线 = 垂直于表面的方向

在光照计算里：

> **法线 = 表面“朝向”的代表。**

它告诉光：

> “我这一小块面，是朝哪边的。”

---

#### 8.4.2 光照的核心公式（白话版）

Lambert 漫反射只有一句话：

> **光照强度 = 光的方向 · 表面的朝向**

用数学写出来就是：

```txt
intensity = max(dot(N, L), 0)
```

解释一下这三个东西：

- `N`：表面法线（单位向量）
- `L`：光照方向（单位向量）
- `dot`：点积，表示“方向相似度”

你可以把它理解为：

> **表面越正对光，越亮；越背对光，越暗。**

---

### 8.5 在我们的最小引擎中，引入“光”意味着什么？

从系统角度看，你要新增三类信息：

1️⃣ 每个顶点的法线
2️⃣ 光源的方向（或位置）
3️⃣ 材质的基础颜色

注意：

> **这一章我们不追求“真实”，只追求“成立”。**

---

### 8.6 顶点数据升级：加入法线

#### 8.6.1 新的顶点结构

```txt
Vertex {
  position: vec3<f32>
  normal:   vec3<f32>
}
```

这是你第一次真正意义上：

> **把“几何信息”送进 GPU。**

---

#### 8.6.2 JS 侧顶点布局调整

```ts
const vertexLayout: GPUVertexBufferLayout = {
  arrayStride: 6 * 4, // 3 position + 3 normal
  attributes: [
    {
      shaderLocation: 0,
      offset: 0,
      format: 'float32x3', // position
    },
    {
      shaderLocation: 1,
      offset: 3 * 4,
      format: 'float32x3', // normal
    },
  ],
};
```

请你注意：

> **position 和 normal 是并排存储的。**

这是 GPU 高效读取的前提。

---

### 8.7 Shader 侧：让法线和光相遇

#### 8.7.1 Vertex Shader：传递法线

```wgsl
struct VertexInput {
  @location(0) position : vec3<f32>,
  @location(1) normal   : vec3<f32>,
};

struct VertexOutput {
  @builtin(position) position : vec4<f32>,
  @location(0) vNormal : vec3<f32>,
};

@vertex
fn vs_main(input: VertexInput) -> VertexOutput {
  var out: VertexOutput;

  out.position = globals.viewProj * object.model * vec4<f32>(input.position, 1.0);

  // 暂时假设 model 不包含非均匀缩放
  out.vNormal = input.normal;

  return out;
}
```

这一段有一个**刻意的简化**：

> 我们暂时不做 normal matrix。

后面会专门讲。

---

#### 8.7.2 Fragment Shader：计算漫反射

```wgsl
@fragment
fn fs_main(input: VertexOutput) -> @location(0) vec4<f32> {
  let lightDir = normalize(vec3<f32>(0.5, 1.0, 0.3));
  let n = normalize(input.vNormal);

  let diffuse = max(dot(n, lightDir), 0.0);

  let baseColor = vec3<f32>(0.8, 0.4, 0.2);
  let color = baseColor * diffuse;

  return vec4<f32>(color, 1.0);
}
```

这段代码虽然短，但它完成了三件事：

- 把几何方向转成亮度
- 把亮度转成颜色
- 第一次让“材质”出现

---

### 8.8 材质（Material）的最小定义

现在我们可以给“材质”一个工程化定义了：

> **Material = 一组参与光照计算的参数集合。**

在这一章里，它只有一个参数：

- baseColor

但这已经足够：

> **让系统开始“按材质思考”。**

---

### 8.9 用引擎视角看：我们刚刚搭建了什么？

到这里，请你停下来想一件事。

我们这一章新增的，其实不是：

- 几行 Shader 代码

而是：

- 法线数据通道
- 光照计算模型
- 材质这一抽象层

这三样东西一旦出现：

> **整个渲染系统的复杂度等级，直接跃迁。**

---

### 8.10 这一章对 Blender Lite 的真实意义

从现在开始，你已经具备：

- 最基础的光照模型
- 材质参数的雏形
- 从“几何”走向“外观”的能力

接下来你要做的，无非是：

- 更多光源
- 更复杂的 BRDF
- 纹理参与计算

但无论多复杂，

都不会逃离这一章的核心公式。

---

### 8.11 写在本章结尾的一句话

当你第一次看到：

> “同一个模型，转个角度，明暗就变了”

那一刻，你应该意识到：

> **你已经不只是‘画形状’，
> 而是在‘塑造物体的存在感’。**

这，是所有 3D 工具真正迷人的地方。

（第八章·实战 完）

---

## 第九章：法线与空间 —— 光照真正开始工作的地方

> 本章目标：**彻底搞清楚“法线在哪个空间”“为什么要 normalMatrix”“光照计算到底应该发生在哪”**。
> 
> 这是 WebGPU / OpenGL / WebGL 中**最容易死记硬背、也最容易在真实项目里出 bug 的一章**。

如果你曾经有过这些困惑：

- “法线为什么不能直接用 modelMatrix 乘？”
- “非均匀缩放后光照为什么怪怪的？”
- “lightDir 到底是 world space 还是 view space？”

那这一章，就是专门为你写的。

---

### 9.1 一个反直觉的问题：法线为什么这么麻烦？

我们先不讲矩阵，先讲**直觉**。

你已经知道：

- **位置（position）**：描述一个点“在哪”
- **法线（normal）**：描述一个面“朝哪”

位置是“点”，法线是“方向”。

问题来了：

> 如果一个物体被缩放、旋转、移动了，
> 
> 那它的“朝向”是怎么跟着变的？

很多人第一反应是：

> “那不就和 position 一样，乘一个 modelMatrix 吗？”

**这是错的，而且是渲染里最经典的一个坑。**

原因一句话先拍在这：

> **位置可以被“拉伸”，但方向不能被“拉伸”。**

我们慢慢拆。

---

### 9.2 位置 vs 法线：它们在数学上的根本不同

#### 9.2.1 position 是“点”

position 是一个点：

- 会随平移改变
- 会随缩放改变距离
- 会随旋转改变方向

所以：

```text
position' = M * position
```

是完全合理的。

#### 9.2.2 normal 是“方向”

normal 的本质是：

> **一个与表面垂直的方向向量**

它只关心：

- 朝向
- 垂直关系

它**不关心**：

- 在哪里
- 离原点多远

所以第一条结论：

> **法线不应该受到平移影响**

这也是为什么在 shader 里：

```wgsl
vec3 normal;
```

而不是 vec4。

但这只是最简单的一层。

真正致命的问题在下面。

---

### 9.3 非均匀缩放：法线“炸掉”的根源

假设你有一个立方体：

```text
scale = (2, 1, 1)
```

也就是说：

- x 拉伸 2 倍
- y、z 不变

几何表面被拉长了。

现在问你一个问题：

> 拉伸之后，这个面的“垂直方向”还是原来那个方向吗？

答案是：**不是。**

直觉解释：

- 表面被拉歪了
- 原本“垂直”的方向，已经不再垂直

这意味着：

> **法线必须根据“表面形变”重新计算方向**

而不是简单跟着 position 走。

---

### 9.4 normalMatrix：不是技巧，是必然结果

现在进入本章最核心的结论。

#### 9.4.1 法线的数学定义（关键一句）

> **法线，是一个与切平面所有方向都“正交”的向量**

当模型经过 modelMatrix 变换后：

- 切平面方向被 modelMatrix 变换
- 那么法线，必须仍然与“新切平面”正交

这在数学上意味着：

```text
normal' = (inverse(transpose(modelMatrix))) * normal
```

这就是你在所有教程里看到的：

```text
normalMatrix = inverse(transpose(mat3(modelMatrix)))
```

不是因为“大家都这么写”，而是：

> **只有这样，正交关系才能被保持**

---

### 9.5 为什么是 mat3，而不是 mat4？

这是另一个常见困惑。

答案其实很简单：

- 法线不需要平移
- 我们只关心旋转 + 缩放

而这正好是：

```text
modelMatrix 的左上 3x3
```

所以标准写法是：

```wgsl
let normalMatrix = mat3x3<f32>(modelMatrix);
let worldNormal = normalize(normalMatrix * in.normal);
```

⚠️ 注意：

- **必须 normalize**
- inverse + transpose 通常在 CPU 侧算好

---

### 9.6 光照计算：到底在哪个空间算？

现在我们回到光照。

Lambert 的核心公式你已经很熟了：

```text
diffuse = max(dot(N, L), 0)
```

关键不是公式，而是：

> **N 和 L 在哪个空间？**

#### 9.6.1 唯一铁律

> **参与 dot 的向量，必须在同一个空间**

就这么一句。

#### 9.6.2 常见三种选择

1️⃣ **World Space（最推荐）**

- normal：world
- lightDir：world
- position：world

优点：
- 直观
- 和 Scene / Light 结构天然一致

2️⃣ View Space

- 摄像机为原点
- 适合早期 OpenGL

3️⃣ Tangent Space（法线贴图）

- 这是后话，第十章以后再说

👉 对你当前阶段：

> **World Space 是最干净、最不容易出错的选择**

---

### 9.7 一个“引擎作者视角”的总结

如果你现在回头看本章，其实你已经掌握了三条**非常工程化的原则**：

1️⃣ 法线不是“随便乘矩阵”的数据
2️⃣ normalMatrix 是由“保持垂直关系”推导出来的
3️⃣ 光照空间的选择，本质是 Scene 架构选择

这三条一旦吃透：

- 你写 Shader 会非常稳
- 你调 Bug 会非常快
- 你设计引擎结构会非常自然

---

### 9.8 站在这里，你已经超过了 80% 的 WebGPU 学习者

说一句很实在的话：

> **绝大多数人，会在“法线 + 空间”这里彻底迷路**

而你现在已经：

- 知道问题本质
- 知道错误来源
- 知道工程上的“正确姿势”

这意味着：

> 你已经具备继续走向 **PBR / 法线贴图 / 实时阴影** 的全部前置认知。

---

下一步建议（你可以选）：

- 🔥 第十章：**从 Lambert 走向 Phong / Blinn-Phong（高光从哪来）**
- 🧱 材质系统进阶：normal / albedo / uniform 的组织方式
- 🌍 空间再深化：View Space / Clip Space / NDC 的统一心智模型

你选一个，我继续把这本书往“真正能打”的方向推。

---

## 第十章：高光从哪来 —— Phong / Blinn-Phong 并不神秘

> 本章目标：**搞清楚“高光是什么”“为什么会有塑料感”“视线方向在光照中到底起什么作用”**。
>
> 你将第一次真正理解：
> - 为什么物体会“发亮”
> - 为什么同一个光源下，不同材质差异巨大
> - 为什么这一步是走向 PBR 的必经之路

如果你曾经：
- 能写 Lambert，但场景“很灰”
- 加了高光，却感觉“假”“塑料”
- 看过 Phong 公式，但完全靠背

这一章，就是专门把这些东西**还原成直觉 + 几何关系**。

---

### 10.1 漫反射的极限：为什么世界看起来“不够亮”

回顾 Lambert：

```text
diffuse = max(dot(N, L), 0)
```

它只描述了一件事：

> **光从正面打过来，面就亮；从侧面打过来，就暗**

但现实中你会发现：

- 金属
- 塑料
- 陶瓷

即使在同一个角度下，看起来也完全不同。

原因是：

> **Lambert 完全忽略了“你在看哪里”**

而人眼看到的亮度，**和视线方向强相关**。

---

### 10.2 高光的本质：镜面反射的一点点“泄漏”

先给一句非常重要的直觉定义：

> **高光 = 光线接近“镜面反射方向”时，被人眼捕捉到的能量**

我们拆开来看。

---

### 10.3 关键几何关系：三条向量

在高光模型中，一定会出现这三条向量：

- **N**：法线（表面朝向）
- **L**：光照方向（光从哪来）
- **V**：视线方向（你从哪看）

如果你只记一句话：

> **高光，本质是 L、N、V 三者之间的夹角关系**

那你已经抓住了 80%。

---

### 10.4 Phong 模型：最直观的“反射思维”

Phong 的思路非常“几何直觉”：

1️⃣ 光线 L 打到表面
2️⃣ 沿着法线 N 反射出一个方向 R
3️⃣ 如果你的视线 V 接近 R，就看到高光

数学上是：

```text
R = reflect(-L, N)
specular = pow(max(dot(R, V), 0), shininess)
```

这里每一项都有**非常明确的物理含义**：

- dot(R, V)：你是否站在“反射方向附近”
- shininess：表面有多“光滑”

shininess 越大：
- 高光越小
- 越集中
- 越像镜子

---

### 10.5 为什么 Phong 看起来“对”，但算得有点贵？

问题出在这里：

```text
reflect(-L, N)
```

- 需要一次反射计算
- 再做 dot

在早期 GPU 上，这一步并不便宜。

于是就有了一个**非常聪明的近似方案**。

---

### 10.6 Blinn-Phong：不是“另一个模型”，而是换了观察角度

Blinn-Phong 的核心思想是：

> **与其算“反射方向”，不如算“中间方向”**

定义一个新向量：

```text
H = normalize(L + V)
```

H 是什么？

> **光线方向和视线方向的“中间人”**

然后高光变成：

```text
specular = pow(max(dot(N, H), 0), shininess)
```

直觉解释：

- 如果法线 N 正好对着 H
- 那说明：
  - 光差不多会反射到你眼睛

这在视觉上和 Phong **非常接近**，但：

- 更稳定
- 更便宜
- 更适合实时渲染

👉 所以你在现代引擎里看到的，大多是 **Blinn-Phong**。

---

### 10.7 一个非常容易踩的坑：所有向量必须在同一空间

再强调一次（这是第九章的延续）：

> **N、L、V、H 必须在同一个空间**

推荐组合（继续保持一致）：

- normal：world space
- lightDir：world space
- viewDir：world space

viewDir 通常这样算：

```text
V = normalize(cameraPosition - worldPosition)
```

这一步，正式把 **Camera** 引入了光照系统。

---

### 10.8 为什么“塑料感”会出现？

现在我们可以解释一个常见现象了。

“塑料感”通常来自三个原因之一：

1️⃣ shininess 设置过大
2️⃣ specular 强度过高
3️⃣ 所有物体共用同一套高光参数

本质原因是：

> **材质被简化成了“只有一种表面”**

而现实世界中：

- 木头
- 金属
- 塑料

它们的高光行为是完全不同的。

👉 这正是 **Material 系统**存在的理由。

---

### 10.9 站在引擎作者视角看高光

到这里，你已经可以站在“引擎设计”的高度总结：

- 漫反射：几何 + 光
- 高光：几何 + 光 + 视线

这意味着：

> **光照模型的复杂度，本质是“引入了多少世界要素”**

Lambert：
- 只需要 Light

Blinn-Phong：
- Light
- Camera
- Material

👉 这一步，是从“能画”到“像真的”的关键跃迁。

---

### 10.10 本章小结（非常重要）

如果你现在合上这一章，你至少应该带走这些东西：

1️⃣ 高光不是魔法，而是方向关系
2️⃣ Phong 和 Blinn-Phong 只是“选角度算”的不同
3️⃣ 塑料感不是公式错，而是材质系统还没到位

你现在已经：

> **站在了传统实时渲染模型的门口**

下一步，就是把这些东西**组织成真正的系统**。

---

下一章路线建议：

- 🧱 第十一章：**Material 系统设计（为 PBR 铺路）**
- 🌍 第十一章（另一种）：**统一空间心智模型（一次性解决空间恐惧）**
- 🔥 或直接跳：**PBR 为什么必然出现？（从 Blinn-Phong 到物理世界）**

你选，我继续。

---

## 第十一章：Material 系统设计 —— 给 Blender Lite 的每个物体赋予灵魂

> 本章目标：**建立一个最小但可扩展的材质系统，让你的物体不再“同质化”，为后续 PBR 铺路**。

经过前十章，你的渲染管线已经有：

- 位置 + 法线
- Lambert 漫反射
- Blinn-Phong 高光
- 相机视线与光照统一空间

唯一缺的，是**把这些参数抽象成一个系统**。

---

### 11.1 为什么需要 Material 系统

想象一下：

- 你的场景里有多个物体
- 它们的颜色、光泽、粗糙度都不一样
- 每个物体都有自己的光照反应

如果没有材质系统，你只能：

- 在 shader 里写很多 if / switch
- 或者每个物体都开一套 shader

两者都不可维护。Material 系统的作用就是：

> **把光照参数从几何体中抽离出来，形成可复用、可组合的单元**

这就是为什么 Blender / Three.js 都有 Material 概念。它不是特效，而是架构必需品。

---

### 11.2 最小 Material 架构

我们先定义一个最小化的材质结构：

```ts
interface Material {
  baseColor: vec3<f32>;      // 基础颜色
  specular: vec3<f32>;       // 高光颜色
  shininess: f32;            // 高光集中度
}
```

为什么这么简单？

- baseColor 对应 Lambert 漫反射
- specular + shininess 对应 Blinn-Phong 高光
- 这是最核心、最通用的参数集合

从这个最小单位开始，你可以随时扩展，例如加入 roughness、metallic 等，为 PBR 做准备。

---

### 11.3 Material 与 Mesh 的关系

你的每个 Mesh（物体）不再直接承担光照参数，而是引用一个 Material：

```ts
interface Mesh {
  geometry: Geometry;
  material: Material;
  modelMatrix: mat4x4<f32>;
}
```

优势：

1️⃣ 复用性高：多个 Mesh 可以共用一个 Material
2️⃣ 易扩展：修改 Material 不用改 Shader 或 Mesh
3️⃣ 清晰职责：Mesh 只负责几何和变换，Material 只负责光照属性

---

### 11.4 Shader 侧的改造

#### 11.4.1 Uniform Buffer Packing

为了 GPU 高效读取，我们通常把 Material 放进 Uniform Buffer：

```wgsl
struct Material {
  baseColor: vec3<f32>,
  specular: vec3<f32>,
  shininess: f32,
};

@group(1) @binding(0) var<uniform> material: Material;
```

> 注意对齐规则：vec3 会占用 16 字节空间以满足 std140 / WGSL 对齐要求

#### 11.4.2 Fragment Shader 使用

```wgsl
@fragment
fn fs_main(input: VertexOutput) -> @location(0) vec4<f32> {
  let N = normalize(input.vNormal);
  let L = normalize(lightPosition - input.worldPos);
  let V = normalize(cameraPosition - input.worldPos);
  let H = normalize(L + V);

  // 漫反射
  let diffuse = max(dot(N, L), 0.0);

  // 高光
  let specular = pow(max(dot(N, H), 0.0), material.shininess);

  // 颜色合成
  let color = material.baseColor * diffuse + material.specular * specular;

  return vec4<f32>(color, 1.0);
}
```

这样，每个物体只要绑定不同的 Material，shader 就能自动计算正确的光照结果。

---

### 11.5 引擎视角下的扩展能力

从这个最小系统开始，你可以轻松做：

1️⃣ **多光源**：遍历 Light 数组，累加 diffuse + specular
2️⃣ **纹理贴图**：baseColor 可换成纹理采样
3️⃣ **材质类型扩展**：金属、透明、双面

也就是说，这个最小 Material 系统是你的**未来 PBR 的雏形**。

---

### 11.6 这一章的核心原则

1️⃣ **分离职责**：Mesh 只管理几何，Material 只管理光照属性
2️⃣ **可复用性**：多个物体可以共用同一 Material
3️⃣ **扩展友好**：从最小化参数出发，随时加入复杂属性

掌握这三条，你的 Blender Lite 渲染架构就有了**骨架 + 肌肉**。

---

下一步，你可以选择：

- 🔥 第十二章：**纹理系统入门——给物体穿衣服**
- 🌍 第十二章（另一种）：**多光源与全局光照管理**
- 🧠 或直接：**法线贴图与 PBR 铺路**

你选，我继续帮你写下一章。

## 第十二章：纹理系统入门 —— 给物体穿衣服

> 本章目标：**学会在最小 Material 系统上添加纹理，让物体不再只有单色，而是拥有丰富表面细节**。

经过前十章和第十一章，你的渲染管线已经具备：

- 位置 + 法线
- Lambert 漫反射 + Blinn-Phong 高光
- 相机视线统一空间
- Material 系统支持多物体不同参数

现在缺的，是**材质表面的纹理**。

---

### 12.1 为什么需要纹理

如果没有纹理，即便你有材质系统，物体仍然只是“平涂的颜色”：

- 没有细节
- 没有凹凸感
- 很难区分不同物体

纹理的作用就是：

> **用图片或者程序生成的数据，替换或增强材质的某些属性，让物体表面看起来更真实**。

最常见的纹理类型：

1️⃣ **Albedo / Diffuse**：基础颜色
2️⃣ **Specular / Glossiness Map**：控制高光强度和分布
3️⃣ **Normal Map**：微表面法线扰动
4️⃣ **Roughness / Metallic Map**：PBR 专用参数

本章先从最基础的 Albedo 开始。

---

### 12.2 在 WGSL 中使用纹理

#### 12.2.1 纹理绑定

纹理在 GPU 中是资源，需要绑定到 shader：

```wgsl
@group(1) @binding(1) var textureSampler: sampler;
@group(1) @binding(2) var textureData: texture_2d<f32>;
```

> sampler 控制采样方式（线性/最近点）
> textureData 是实际纹理数据

#### 12.2.2 Fragment Shader 采样

```wgsl
@fragment
fn fs_main(input: VertexOutput) -> @location(0) vec4<f32> {
  let N = normalize(input.vNormal);
  let L = normalize(lightPosition - input.worldPos);
  let V = normalize(cameraPosition - input.worldPos);
  let H = normalize(L + V);

  // 采样纹理
  let texColor = textureSample(textureData, textureSampler, input.uv);

  // 漫反射
  let diffuse = max(dot(N, L), 0.0);

  // 高光
  let specular = pow(max(dot(N, H), 0.0), material.shininess);

  // 颜色合成：baseColor 替换为纹理颜色
  let color = texColor.rgb * diffuse + material.specular * specular;

  return vec4<f32>(color, 1.0);
}
```

> 注意：这里 uv 是顶点传入的纹理坐标，需要在顶点着色器中传递

---

### 12.3 Mesh 需要支持 UV

每个 Mesh 的 geometry 现在除了位置和法线，还需要 UV 坐标：

```ts
interface Vertex {
  position: vec3<f32>;
  normal: vec3<f32>;
  uv: vec2<f32>;
}
```

- UV 决定纹理在表面上的映射
- 通常在建模软件或者 procedural 生成时计算

这样 fragment shader 就能正确从纹理读取颜色。

---

### 12.4 引擎设计思路

为了管理多个纹理和材质，我们可以在 Material 中加入纹理引用：

```ts
interface Material {
  baseColor: vec3<f32>;
  specular: vec3<f32>;
  shininess: f32;
  albedoTexture?: Texture;
}
```

- 有纹理就采样纹理，否则使用 baseColor
- 可以进一步扩展更多纹理类型（normal map、roughness map）

在渲染循环中，根据 Material 判断是否绑定对应的 GPU 资源。

---

### 12.5 实战建议

1️⃣ **先从单一纹理开始**：先实现 Albedo，再扩展高光/法线
2️⃣ **保持 uniform + texture 分离**：Material 数据放 uniform，纹理资源放 texture + sampler
3️⃣ **调试 UV 映射**：在初期先用 checkerboard 测试纹理，确认映射方向正确
4️⃣ **可扩展性优先**：即使只有 Albedo，也用统一的 Material 结构，为未来 PBR 铺路

---

### 12.6 这一章的核心总结

- 纹理是材质最直接的外延，让物体表面丰富起来
- WGSL 中需要 sampler + texture 绑定，并在 fragment shader 采样
- Mesh geometry 必须包含 UV 坐标
- Material 系统要保持统一结构，便于扩展

掌握这一章，你的 Blender Lite 渲染管线已经有了**表面细节**，物体不再是单色“积木”，而是真正可以区分和表现不同材质的形态。

---

下一步可以选择：

- 🔥 第十三章：**多光源与光照管理**（场景亮起来）
- 🌍 第十三章（另一种）：**法线贴图与 PBR 铺路**
- 🧠 直接跳：**环境光、全局光照与 SSAO**

## 第十三章：多光源与光照管理（场景真正亮起来）

> 到目前为止，我们的世界是“有材质的、能被一盏灯照亮的”。
> 这一章开始，它才像一个**真正的场景**。

这一章你会彻底搞清楚三件很多人长期模糊的事：

1. **为什么光源不应该写死在 Shader 里**
2. **多光源在工程上是“数据问题”，不是“数学问题”**
3. **WebGPU 里，光照系统应该如何被“管理”，而不是“堆代码”**

我们会用最小但正确的方式：
- 多个点光源
- 一个统一的 Light 管理结构
- Shader 中的可扩展光照循环

目标只有一个：
> **为后面的阴影、PBR、编辑器打好结构地基**。

---

### 13.1 从“一盏灯”到“灯是场景的一部分”

先回忆你现在的状态：

```wgsl
let lightDir = normalize(vec3<f32>(1.0, 1.0, 1.0));
let diffuse = max(dot(normal, lightDir), 0.0);
```

这段代码**本身没错**，但它隐含了三个致命限制：

- 光的数量 = 1
- 光的参数 = 写死在 Shader
- 光无法被编辑、增删、保存

换句话说：
> **这不是“场景里的光”，而是“程序员脑补的一盏灯”**。

而 Blender / Unity / Unreal 里的光，本质是：

> 👉 **一种场景数据**

它应该：
- 像 Mesh 一样存在于 Scene
- 能被序列化
- 能被 UI 操作
- 能被 GPU 批量消费

---

### 13.2 定义最小 Light 结构（工程第一步）

我们先不追求“真实”，只追求“正确”。

一个最小点光源，至少需要：

```ts
interface PointLight {
  position: Vec3
  color: Vec3
  intensity: number
}
```

注意：
- **没有方向**（点光）
- **没有范围衰减模型细节**（先用最简单）

Scene 层面：

```ts
class Scene {
  objects: Mesh[] = []
  lights: PointLight[] = []
}
```

到这一刻，
你已经在**架构层面**超过了 90% 的 WebGPU 教程。

---

### 13.3 光照数据如何进 GPU？（关键抉择）

现在出现第一个工程分岔路：

> 多光源，用什么传？

常见选项：

- 🟥 每个光一个 Uniform（不可扩展）
- 🟨 StorageBuffer（正确，但需要设计）
- 🟩 Uniform Array（我们这一章用）

我们选择 **Uniform Array + 固定上限**：

```wgsl
struct PointLight {
  position: vec3<f32>
  intensity: f32
  color: vec3<f32>
  _pad: f32
}

struct LightUniforms {
  count: u32
  _pad: vec3<u32>
  lights: array<PointLight, 8>
}

@group(1) @binding(0)
var<uniform> uLights: LightUniforms;
```

> 为什么要 padding？

因为 **WebGPU / WGSL 对齐规则是硬约束**，
你现在是在写“GPU 数据结构”，不是 JS 对象。

---

### 13.4 Fragment Shader：光照循环才是真正的开始

之前：

```wgsl
diffuse = max(dot(n, lightDir), 0.0)
```

现在：

```wgsl
var result = vec3<f32>(0.0);

for (var i = 0u; i < uLights.count; i++) {
  let light = uLights.lights[i];
  let L = normalize(light.position - vWorldPos);
  let NdotL = max(dot(normal, L), 0.0);
  result += light.color * light.intensity * NdotL;
}
```

这一刻非常重要：

> **Shader 从“公式”，进化成了“系统执行器”**。

你不再关心“第几盏灯”，
你只关心：

> **遍历场景给我的所有光**。

---

### 13.5 光照管理 ≠ Shader 技巧

很多人会在这里犯一个大错：

> ❌ 把所有复杂度都堆进 Shader

但真正的分工应该是：

| 层级 | 责任 |
|----|----|
| CPU / Scene | 光的组织、增删、排序 |
| Uniform | 数据快照 |
| Shader | 数学计算 |

比如：
- 超过 8 盏灯怎么办？👉 CPU 裁剪
- 按距离排序？👉 CPU
- 阴影光单独通道？👉 Render Pass

> Shader 不应该“做决定”，它只负责“算”。

这是你做编辑器时非常重要的心智模型。

---

### 13.6 这一章，你真正掌握了什么？

如果你现在回头看 Blender Lite 的目标：

- 场景里有多个灯
- 灯能被选中、移动、删除
- 灯影响所有物体

你已经完成了：

- ✅ 光照的数据模型
- ✅ GPU 传输方式
- ✅ Shader 执行结构
- ✅ 后续阴影 / PBR 的接口位置

**你已经不再是“在写 WebGPU Demo”，
而是在搭一个渲染引擎。**

---

### 下一章路线建议（非常关键）

现在你站在一个真正的分水岭：

- 🅰️ 阴影贴图（光终于有“体积感”）
- 🅱️ PBR 基础（走向真实感）
- 🅲️ 渲染管线拆分（Forward → Forward+ / Deferred 预备）

选一个，我们继续把 Blender Lite 往“不可回头”的方向推。

## 第十四章：PBR 基础 —— 从“看起来对”到“物理上更合理”

> 如果说前面的光照是在“调颜色”，那从这一章开始，你是在**建立一套对现实世界的近似模型**。

PBR（Physically Based Rendering）并不是魔法，它解决的其实只有一个问题：

> **为什么不同材质，在同一套光照下，看起来就是不一样？**

塑料、金属、木头、陶瓷——
它们的差异，并不是“换个公式”，而是**对光的响应方式不同**。

这一章我们只做三件事：

1. 建立正确的 PBR 心智模型（不陷公式地狱）
2. 用“最小可用”的方式落地到 Shader
3. 为后续 IBL / 金属度贴图 / 法线贴图留好接口

目标不是“还原 Unreal”，而是：

> **让你的引擎第一次具备“材质物理意义”**。

---

### 14.1 为什么要抛弃 Blinn-Phong？

Blinn-Phong 最大的问题不是“不真实”，而是：

- ❌ 参数没有物理意义
- ❌ 不同光照下难以保持一致
- ❌ 材质之间无法共享规则

比如：

- shininess = 32 是什么材料？没人知道
- 同一个材质，灯一变就“崩”

PBR 的核心思想只有一句话：

> **把“拍脑袋的参数”，换成“可以解释的参数”**。

---

### 14.2 PBR 的四个核心量（先吃透）

我们采用目前工业界最主流的一套：

1. **Albedo**：表面基础颜色（不含光照）
2. **Metallic**：金属度（0 = 非金属，1 = 金属）
3. **Roughness**：粗糙度（0 = 镜面，1 = 磨砂）
4. **Normal**：微表面朝向

其中最容易被误解的是：

#### Metallic

- 非金属：
  - 颜色主要来自 Albedo
  - 高光是白色
- 金属：
  - 几乎没有漫反射
  - 高光颜色 = Albedo

👉 **这是金属“看起来高级”的根源**。

#### Roughness

它不是“亮不亮”，而是：

> **高光是集中，还是摊开**。

- roughness = 0.0 → 镜子
- roughness = 1.0 → 粉笔

---

### 14.3 一个“最小 PBR 光照模型”

我们用业界通用但可裁剪的版本：

- Lambert 漫反射（能量守恒版本）
- GGX 高光（先接受它的存在）

核心结构：

```wgsl
fn computePBR(
  N: vec3<f32>,
  V: vec3<f32>,
  L: vec3<f32>,
  albedo: vec3<f32>,
  metallic: f32,
  roughness: f32,
  lightColor: vec3<f32>
) -> vec3<f32> {
  let H = normalize(V + L);

  let NdotL = max(dot(N, L), 0.0);
  let NdotV = max(dot(N, V), 0.0);

  // 非金属 vs 金属 的反射比例
  let F0 = mix(vec3<f32>(0.04), albedo, metallic);

  // 这里先用简化版 Fresnel
  let F = F0 + (1.0 - F0) * pow(1.0 - max(dot(H, V), 0.0), 5.0);

  let diffuse = (1.0 - metallic) * albedo / PI;
  let specular = F;

  return (diffuse + specular) * lightColor * NdotL;
}
```

> 不要被公式吓到：
> 你现在只需要理解“每一项在控制什么”。

---

### 14.4 Material 升级：参数终于“像材料了”

```ts
interface PBRMaterial {
  albedo: vec3
  metallic: number
  roughness: number
}
```

你会发现一个巨大变化：

- ❌ 不再有 specularColor / shininess
- ✅ 材质参数开始“跨项目通用”

这意味着：

> **你今天调的材质，明天放进别的引擎，也成立**。

---

### 14.5 多光源 × PBR：体系开始闭环

把第十三章的多光源循环，换成 PBR：

```wgsl
var color = vec3<f32>(0.0);

for (var i = 0u; i < uLights.count; i++) {
  let light = uLights.lights[i];
  let L = normalize(light.position - vWorldPos);

  color += computePBR(
    N, V, L,
    material.albedo,
    material.metallic,
    material.roughness,
    light.color * light.intensity
  );
}
```

这一刻，你已经具备了：

- 多光源
- 可解释材质
- 可扩展光照模型

这就是现代实时渲染的“主干”。

---

### 14.6 本章你真正跨过的门槛

如果你回头看很多教程：

- 它们教你“公式”
- 但没教你“为什么这些参数能统一世界”

而你现在已经理解了：

- 材质不是效果，是模型
- 光照不是技巧，是能量分配
- PBR 不是高级，是**自洽**

你的 Blender Lite，
从这一章开始，**已经站在现代引擎同一条逻辑线上了**。

---

### 下一章（真正危险，也真正有成就感）

- 🅰️ IBL / 环境光照（PBR 的最后一块拼图）
- 🅱️ 阴影贴图（让光真正进入三维空间）
- 🅲️ 法线贴图 × PBR（材质细节爆炸）

选一个，我们继续把世界“点亮成真的”。

---

## 第十五章：IBL / 环境光照 —— PBR 的最后一块拼图

> 如果说前面的光照解决的是“灯照在物体上”，那 IBL 解决的是：
>
> **物体活在一个什么样的世界里。**

这一章非常关键，也非常容易被误学。

很多教程会直接告诉你：
- 用 HDR 环境贴图
- 做一堆 prefilter
- 套一堆看不懂的公式

结果是：
> **照着抄能跑，但不知道为什么世界突然变“高级”了。**

这一章我们反过来，从**引擎视角**讲清楚三件事：

1. 为什么 PBR 没有 IBL 一定是“假亮”
2. IBL 在系统里扮演的真实角色
3. 一个“最小但正确”的 IBL 落地方案

目标不是做 Unreal 级别，而是：

> **让你的 Blender Lite 第一次拥有“空气感”和“整体光环境”。**

---

### 15.1 为什么没有 IBL，PBR 会显得“很干”

回忆一下你现在的系统：

- 光源：点光 / 平行光（第十三章）
- 材质：PBR（第十四章）

问题来了：

- 灯照不到的地方，全黑
- 金属在阴影里，直接死掉
- 物体“孤零零”地亮着

现实世界不是这样的。

现实里：
- 光会反弹
- 环境会发光
- 物体会被“包裹”在光里

IBL 的本质不是“高级算法”，而是一句非常朴素的话：

> **把整个世界，当成一个巨大的光源。**

---

### 15.2 IBL 在引擎里的真实定位

从系统角度看，IBL 干的事只有一件：

> **为 PBR 提供“没有方向的光照贡献”。**

你可以把它理解为：

| 光照类型 | 来自哪里 | 特点 |
|--------|----------|------|
| 直接光 | 点光 / 平行光 | 有方向、强对比 |
| IBL    | 环境      | 无方向、柔和 |

它不是替代灯光，而是：

> **给世界一个“底色”。**

---

### 15.3 IBL 必须拆成两部分（这是关键）

这是很多人卡死的地方。

IBL 在 PBR 里，**必须**拆成：

1. **Diffuse IBL**（给漫反射用）
2. **Specular IBL**（给高光用）

原因很简单：

- 漫反射：对方向不敏感
- 高光：对方向极度敏感

所以：

> **一张环境贴图，不能直接一把梭。**

---

### 15.4 Diffuse IBL：世界的“环境底色”

Diffuse IBL 的思想非常直白：

> 从四面八方来的光，平均一下。

工程上通常做法是：

- 使用一张 **低频的环境立方体贴图**
- 或者直接用预计算好的 irradiance map

在“最小实现”阶段，你可以先：

```wgsl
// 假设 envColor 是环境颜色
let ambientDiffuse = envColor * material.albedo * (1.0 - material.metallic);
```

这一行代码的效果是：

- 阴影不再死黑
- 非金属开始“有空气感”

这是 IBL 带来的**第一层提升**。

---

### 15.5 Specular IBL：金属“高级感”的来源

如果说 Diffuse IBL 是“救命”，那 Specular IBL 是：

> **让 PBR 看起来值钱的东西。**

Specular IBL 解决的是：

- 金属在没有直射光时，为什么还能反光
- 粗糙度变化，为什么会影响环境反射

最小心智模型是：

> **粗糙度 = 看世界的模糊程度**

- 光滑 → 看到清晰环境
- 粗糙 → 看到模糊环境

工程上对应的是：

- 一张 environment cubemap
- 多个 mip level
- roughness → mip level

最小版本你可以先理解为：

```wgsl
let reflection = reflect(-V, N);
let envSpecular = sampleEnvMap(reflection, roughness);
```

不需要立刻实现完整 prefilter，
但**这个结构必须成立**。

---

### 15.6 把 IBL 接入你现有的 PBR 管线

最终，你的 Fragment Shader 结构会变成：

```wgsl
var color = vec3<f32>(0.0);

// 直接光
for (var i = 0u; i < uLights.count; i++) {
  color += computePBR(...);
}

// 环境光
color += diffuseIBL;
color += specularIBL;
```

这一刻非常重要。

因为你已经从：

> “物体被灯照亮”

变成了：

> **“物体存在于一个光环境中”**。

---

### 15.7 这一章你真正获得的能力

不是“会做 IBL”，而是：

- 你知道 IBL **为什么必须存在**
- 你知道它在系统里的**职责边界**
- 你知道怎么从最小实现，走向工业级

这意味着：

> **你已经站在 PBR 渲染的完整闭环里了。**

你的 Blender Lite：
- 不再依赖“多放几盏灯”
- 开始拥有“世界感”

---

### 下一章建议（按成长性排序）

- 🥇 阴影贴图（让光真正有体积）
- 🥈 法线贴图 × PBR（细节爆炸）
- 🥉 Forward+ / Deferred（规模化渲染）

你一句话选路，我继续帮你把这个引擎写到**不像教程，像作品**。

## 第十六章：阴影贴图 —— 光的存在感

> 前面的章节，我们让光照得到了“颜色”和“环境”，但是光还不能告诉你“哪里被挡住”。阴影就是光给世界的“厚度感”。

这一章的目标非常明确：

1. 理解阴影在实时渲染里的本质
2. 学会最小可用 Shadow Map 管线
3. 明确工程中 CPU / GPU / Shader 的职责划分
4. 让 Blender Lite 的场景真正立体“活起来”

---

### 16.1 阴影为什么重要

没有阴影的 PBR + IBL，看起来像是“飘在空中”的物体：

- 无论金属还是塑料，物体在地面上像悬浮
- 相机移动时，没有深度感
- 场景缺乏空间层次感

阴影是最直接的“空间感提示”，同时也是光照的自然延伸：
> 光照不仅决定亮度，还告诉你被挡住的地方。

工程上，阴影就是**光源视角下的深度采样**。

---

### 16.2 最小 Shadow Map 思路

我们从最常用的点光 / 平行光阴影贴图说起。

1️⃣ **从光源看世界**
- 建立一张摄像机（光源视角）的矩阵：`lightViewProj`
- 渲染场景深度到纹理（Depth Texture）

2️⃣ **从相机看物体**
- Fragment shader 中拿当前片元位置转换到光空间
- 与 Shadow Map 对比，判断是否在阴影中

3️⃣ **实现最小 Shadow Map Shader**

```wgsl
@fragment
fn fs_main(input: VertexOutput) -> @location(0) vec4<f32> {
  let fragPosLightSpace = lightViewProj * vec4<f32>(input.worldPos, 1.0);
  let depthFromLight = fragPosLightSpace.z / fragPosLightSpace.w;
  let shadowDepth = textureSample(shadowMap, shadowSampler, fragPosLightSpace.xy);

  let shadow = depthFromLight > shadowDepth + 0.005 ? 0.0 : 1.0;
  let lighting = computePBR(...);
  let color = lighting * shadow;
  return vec4<f32>(color, 1.0);
}
```

> 注意：0.005 是 bias，避免自阴影伪影（shadow acne）

---

### 16.3 Shadow Map 的关键设计点

1. **分辨率**：
- 太低 → 阴影锯齿
- 太高 → 性能开销大

2. **偏置 (bias)**：
- 避免自投影阴影
- 需要和场景深度比例匹配

3. **光类型差异**：
- 平行光 → 正交投影
- 点光 → 六面立方 Shadow Map（最小实现可先忽略）

4. **可扩展性**：
- CPU 负责生成 lightViewProj / Shadow Map
- GPU 负责采样并混合

这一切都是为了**职责清晰，不让 Shader 堆砌逻辑**。

---

### 16.4 与 PBR 管线结合

把 Shadow Map 加入现有 PBR + IBL 管线：

```wgsl
var color = vec3<f32>(0.0);

// 多光源直接光
for (var i = 0u; i < uLights.count; i++) {
  let shadow = computeShadow(uLights[i], input.worldPos);
  color += computePBR(..., shadow);
}

// 环境光照
color += diffuseIBL + specularIBL;
```

这一刻，你的物体：
- 会被灯光照亮
- 会根据遮挡形成阴影
- 会受到 IBL 环境光柔和影响

整个场景立刻有了“重量感”和立体感。

---

### 16.5 实战建议

1. **先做平行光 Shadow Map**，再考虑点光立方贴图
2. **注意光空间矩阵和偏置**，避免阴影抖动和 Self Shadow
3. **可视化 Shadow Map**，调试最直接
4. **保持 CPU / Shader 分工**，后期扩展多光源阴影更简单

---

### 16.6 本章你真正获得的能力

- 光不只是亮度和颜色，它有存在感
- 你知道 Shadow Map 如何在 GPU 实现
- Scene、Light、Shader 的责任划分清晰
- Blender Lite 的物体终于“落地”

> 阴影是最直接的空间感，Blender Lite 场景真正活了。

## 插曲(可选)：全局光照的第一步 —— 为什么世界不该只有“直射光”

> 本章目标：**建立“全局光照”的正确心智模型，并在 WebGPU / 实时渲染条件下，实现一个“看起来像全局光照”的最小方案**。
>
> 这一章不是要你“做出电影级 GI”，而是要让你明白：
> - 为什么没有 GI 的世界是“假”的
> - 实时引擎是如何一步步逼近真实世界的
> - Blender Lite 在 Web 中，应该从哪里切入

---

### 17.1 一个你早就见过、但可能没认真想过的问题

现在回头看你目前的渲染结果：

- 有光源
- 有阴影明暗
- 有高光

但你可能已经隐约感觉到：

> **场景“很黑”、对比很生硬、物体像被手电筒照着**

这不是你哪里写错了，而是因为：

> **你现在的世界，只有“直射光（Direct Lighting）”**

而真实世界中，绝大多数光，其实来自——

> **反射、反弹、再反射**

这就是全局光照（Global Illumination, GI）。

---

### 17.2 什么是全局光照（先别急着上公式）

一句“人话版”的定义：

> **全局光照 = 光不只照一次，而是在世界里到处弹**

现实世界里：

- 阳光照到地面
- 地面把光反射到墙上
- 墙又把光反射到天花板

所以你会看到：

- 阴影里也不是全黑
- 颜色会“互相染色”（红墙让白桌子偏红）

这两点，在没有 GI 的渲染中，是完全不存在的。

---

### 17.3 为什么“真正的 GI”在实时渲染中这么难

从物理角度，真正的 GI 意味着：

- 对每个像素
- 向半个球方向发射大量光线
- 追踪它们在场景中的反射路径

这就是：

> **Path Tracing / Ray Tracing**

而问题是：

- 实时渲染只有几毫秒
- WebGPU 运行在浏览器里

所以结论很现实：

> **我们不可能一上来就做“真实 GI”**

引擎的发展路线，一直是：

> **用“看起来像”的方法，逼近真实**

---

### 17.4 实时引擎里的第一步：环境光（Ambient Light）

几乎所有实时引擎的 GI 起点，都是一个非常朴素的东西：

> **环境光（Ambient）**

它的思想非常简单：

> “假设世界里，到处都有一点点光”

数学上甚至粗暴到：

```text
ambient = material.baseColor * ambientIntensity
```

没有方向
没有法线
没有阴影

但它立刻解决了一个问题：

> **阴影区域不再死黑**

---

### 17.5 为什么环境光“假”，但又“必须有”

环境光的问题你一眼就能看出来：

- 墙背面也一样亮
- 角落没有层次

但注意一件事：

> **几乎所有引擎，在任何 GI 方案下，都会保留一个 Ambient 项**

原因是：

- 它是所有间接光的“最低保”
- 它让数值稳定
- 它让场景不至于塌陷

所以正确的理解是：

> **Ambient 不是 GI，但它是 GI 的地基**

---

### 17.6 一个“进阶但仍然可控”的方案：环境贴图（IBL 雏形）

接下来，是实时引擎非常关键的一步。

与其说“世界里到处有光”，不如说：

> **世界被一个“环境”包住了**

这就是：

> **Environment Map（环境贴图）**

通常是：

- 一张立方体贴图（Cubemap）
- 或一张全景 HDR 图

它表达的是：

> “从某个方向看出去，世界是什么颜色”

---

### 17.7 用环境贴图做“假 GI”的直觉

最简单的做法是：

- 根据法线方向 N
- 去环境贴图中采样一个颜色
- 作为间接光

直觉上：

- 法线朝向天空 → 偏蓝
- 法线朝向草地 → 偏绿

你会立刻得到：

- 颜色互相影响
- 阴影区有层次

这已经**非常接近 GI 的视觉效果**了。

---

### 17.8 把环境光正式引入你的 Material / Shader

从引擎角度看，这一步意味着：

- 光照不再只有 Light
- Scene 开始有“环境”这个概念

在 shader 中，你可以这样拆：

```text
finalColor =
  directDiffuse +
  directSpecular +
  ambient / indirect
```

而 ambient / indirect 的来源，可以是：

- 常量（最简单）
- 环境贴图（进阶）

这一步，是你从“打灯”走向“造世界”的开始。

---

### 17.9 站在 Blender Lite 作者的角度看 GI

到这里，你应该意识到一件事：

> **GI 不是一个 shader 技巧，而是一个系统问题**

它牵扯到：

- Scene 是否有 Environment
- Material 是否区分 direct / indirect
- 渲染管线是否支持多次累加

也就是说：

> **GI 的引入，往往意味着“引擎层级的升级”**

---

### 17.10 本章你真正需要带走的东西

请记住这几条，它们会在你之后的学习中反复出现：

1️⃣ 世界不是只有直射光，GI 是必然需求
2️⃣ 实时渲染的 GI，永远是“近似”
3️⃣ Ambient 是最低级 GI，但不可或缺
4️⃣ Environment Map 是通向 PBR 的桥梁

你现在，已经站在了：

> **从传统光照 → 现代基于物理渲染（PBR）**

的门口。

---

## 第十七章：全局光照（GI） —— 光的传播与真实世界感

> 到现在，你的 Blender Lite 已经有：PBR 材质、多光源、IBL 和阴影。物体立体、光环境完整，但光还停留在“直接照射 + 环境光”阶段。全局光照才是**光真正在场景中传播的感觉**。

### 17.1 什么是全局光照（GI）

全局光照的核心思想非常直接：

> **光不仅照亮物体表面，它会反弹，照亮其他物体。**

直观理解：
- 房间里，一盏灯不仅照亮直接可见的墙，还会让整个房间亮起来。  
- 物体间的光互相影响，反弹产生颜色混合（color bleeding）。

如果没有 GI：
- 阴影里完全黑  
- 金属或墙面反射很假  
- 场景缺乏真实感和空间感

所以，GI 是“PBR + 光的存在感”的最后一环。它的挑战在于**光是连续传播的**，而 GPU 是离散渲染的。

---

### 17.2 GI 的核心思路

从工程和思路角度看，GI 解决三个问题：

1. **光的传播**：从光源出发，沿着方向反弹多次。  
2. **光的积分**：计算每个表面在所有光的作用下的总光照。  
3. **效率问题**：直接模拟所有光线代价极高，必须有近似策略。

常见思路：

- **光线追踪 (Ray Tracing)**：沿射线计算光与物体交点，追踪反弹路径。适合高质量离线渲染。  
- **路径追踪 (Path Tracing)**：光线追踪的扩展，随机采样多条光线路径，计算能量平均。能实现物理正确渲染。  
- **屏幕空间全局光照 (SSGI)**：近似方法，只在当前屏幕可见区域内采样光反弹，实时性强。  
- **光子映射 / Radiosity**：提前计算光能在场景中的分布，存储为纹理或场景数据。

> 总结一句话：GI = 光的传播 + 能量积分 + 高效近似

---

### 17.3 从思路到最小实现

作为 WebGPU 入门和 Blender Lite 的目标，我们追求**可落地的最小 GI**：

1️⃣ **光反弹次数**：限制 1-2 次反弹，避免实时开销过大  
2️⃣ **采样策略**：随机采样或简单体素化（Voxel GI）  
3️⃣ **存储与复用**：反弹光可以写入 Light Probe / G-Buffer / 纹理

简单示意：

```ts
// 每个点计算直接光
let direct = computeDirectLight(point);

// 简单近似全局光：采样场景表面光贡献
let indirect = sampleNearbySurfaces(point) * bounceFactor;

let finalColor = direct + indirect;
```

> 这里的 sampleNearbySurfaces 可以是屏幕空间或体素采样，先理解原理，再优化实现。

---

### 17.4 光线追踪与路径追踪的关键概念

1. **光线与场景交点**：
- 追踪光从相机或光源发出的路径
- 找到与物体表面的交点

2. **BRDF 采样**：
- 每次光线反弹，按照材质的反射模型随机选择方向  
- 遵循 PBR 的粗糙度和金属度特性

3. **能量守恒与累积**：
- 每条光线有能量  
- 反弹时衰减  
- 多条光线平均，得到最终颜色

> 你会发现，前面 PBR 的四个参数在这里作用最大：albedo、metallic、roughness 决定了反弹光的分布

---

### 17.5 实时 GI 的折中方案

对于 WebGPU 或浏览器实时渲染，我们一般不会做完整路径追踪，而是**近似策略**：

- **屏幕空间全局光照 (SSGI)**：只采样可见像素，实时性能好  
- **体素全局光照 (VXGI)**：场景划分体素，光能量存储在体素中，每帧更新，实时感不错  
- **光探针 (Light Probe)**：预计算场景中的光照环境，用三维纹理保存，适合静态场景或半动态

> 总结：实时 GI = “采样 + 近似 + 衰减”

---

### 17.6 工程实现建议

1. **从简单开始**：先做单次反弹或低分辨率 SSGI  
2. **分层处理**：CPU 管理 Light Probe / 光探针更新，GPU 采样和混合  
3. **保持模块化**：GI 系统和 PBR / 阴影 / IBL 管线分离，便于后续优化  
4. **可视化调试**：像之前 Shadow Map 一样，先输出 GI 贡献到纹理，调试正确性

---

### 17.7 本章收获

- 你知道全局光照在场景中扮演什么角色  
- 了解光线追踪、路径追踪的思路和核心原理  
- 明确实时 GI 的折中策略  
- 为后续 Blender Lite 的高级渲染（动态 GI / Light Probe / SSGI）打好结构基础

> 现在你的 Blender Lite 已经有了：PBR 材质、多光源、IBL、阴影，并开始拥有光的传播感，这就是 GI 带来的第一次质变。

