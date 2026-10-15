# 中期检查（2026-10-15）

## 清理和修正

- GameController.employeeTexts已无任何运行时用途，删除字段及注释掉的旧调用；MvpBuilder和ArtUiBuilder不再创建/布局员工Label。当前场景清除对应废弃序列化数据。
- 早期ArtUiBuilder完整生成入口漏掉后加的功能：补齐MusicSetup、CurrencyIconSetup、TaskPanelBuilder、TaskChoiceBuilder；Task入口不再生成不可点击占位按钮。没有运行整场景重建，保护手调布局。
- 删除6张本轮开发过程中生成且经GUID搜索确认无引用的截图及meta，移除空Assets/Screenshots目录及meta。用户美术、字体、音频、Reference研究原始资料未删。
- 更新过时MVP状态和下一步记录。新增ProjectAudit编辑器菜单，检查当前场景和项目Prefab的缺失脚本/断开引用、必需数组、功能组件、任务池奖金配比。

## 保留原因

MvpBuilder仍被ArtUiBuilder调用，后者仍用于完整初始化；ArtButtonBinding/ResultUiBuilder/CardUiBuilder/TooltipUiBuilder等仍有生产或菜单调用。MvpSmoke/DragVerification/ArtUiVerification等是手动回归工具；MvpEditorBridge维持项目MCP自动连接。不能仅因不是运行时脚本就删除。

## 验证与界限

Unity编译完成；EditMode Test Runner 72/72通过（job cbca45fb93d841289bfa3ea53723e205）。结构检查353对象、1164组件、0问题，证据project-audit-results.txt。控制台无错误。未执行整场景再生成、独立构建、多人或全程人工游玩验收，不把这些算成已验证。

当前未完成范围见mvp-status.md；已取消四项机制不再列待办。
