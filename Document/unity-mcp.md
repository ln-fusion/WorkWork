# Unity MCP 安装记录

- 来源：https://github.com/CoplayDev/unity-mcp
- 固定版本v10.0.0；本次实际clone commit d49ae2953580f3481beb1e084a1da2682f0b5610。
- Unity 2022.3兼容的MCP for Unity包，已在编辑器内编译并成功连接项目WorkWork。
- 最终使用嵌入式包 `Packages/com.coplaydev.unity-mcp`，版本10.0.0，附带MIT许可证；避免工程依赖被忽略的Document/Tools目录。曾尝试Git固定版本依赖，但Unity包管理器fetch超时，因此保留已验证的同版本源码包。
- Python服务源码和虚拟环境在 `Document/Tools/unity-mcp/Server`，下载工具被Document/.gitignore排除。
- Codex现有配置已含unityMCP：`http://127.0.0.1:8080/mcp`，没有改动全局配置。
- 已实际通过MCP生成场景、运行测试、控制Play模式和截图。本轮客户端经项目内Python FastMCP客户端调用；新MCP工具不一定即时出现在当前聊天的原生工具列表。

恢复本机服务：

```powershell
git clone --depth 1 --branch v10.0.0 https://github.com/CoplayDev/unity-mcp.git Document/Tools/unity-mcp
uv sync --project Document/Tools/unity-mcp/Server --no-dev
& ./Document/Tools/unity-mcp/Server/.venv/Scripts/mcp-for-unity.exe --transport http --http-url http://127.0.0.1:8080
```

已有下载不需要重新clone。服务仅监听本机回环地址，系统代理需对localhost/127.0.0.1绕过。

打开Unity的Window > MCP for Unity可检查连接。项目内MvpEditorBridge在编辑器加载时尝试连接已运行的服务，不修改全局自动启动偏好。

已有Unity实例打开项目，不能再用批处理第二实例打开同一项目。本次先识别现有编辑器，再接入它，没有关闭用户编辑器。
