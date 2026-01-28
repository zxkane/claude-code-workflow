# Claude Code Development Workflow Template

一个用于 Claude Code 的开发工作流模板，通过 hook 系统强制执行端到端的开发流程，确保 AI 代理按照 TDD (测试驱动开发) 和代码审查的最佳实践完成 feature 开发和 bug 修复。

## 🎯 特性

- **设计先行**: 强制在实现前创建设计画布
- **测试驱动开发 (TDD)**: 强制在写代码前创建测试用例
- **代码简化**: commit 前强制运行 code-simplifier agent
- **代码审查**: push 前强制运行 pr-review agent
- **CI 验证**: 任务完成前强制等待 CI 通过
- **E2E 测试**: 强制在 Preview 环境执行 E2E 测试

## 📁 项目结构

```
.
├── CLAUDE.md                     # 项目配置和开发流程文档
├── .claude/
│   ├── settings.json            # Claude Code hooks 配置
│   └── hooks/                   # Hook 脚本
│       ├── lib.sh               # 共享工具函数
│       ├── state-manager.sh     # 工作流状态管理
│       ├── check-design-canvas.sh   # 设计画布检查
│       ├── check-test-plan.sh       # 测试计划检查
│       ├── check-code-simplifier.sh # 代码简化检查
│       ├── check-pr-review.sh       # PR 审查检查
│       ├── check-unit-tests.sh      # 单元测试检查
│       ├── warn-skip-verification.sh # --no-verify 警告
│       ├── post-file-edit-reminder.sh # 文件编辑后提醒
│       ├── post-git-action-clear.sh # Git 操作后状态清理
│       ├── post-git-push.sh         # Push 后验证提醒
│       └── verify-completion.sh     # 任务完成验证
├── docs/
│   ├── designs/                 # 设计画布文档
│   ├── test-cases/              # 测试用例文档
│   └── templates/               # 文档模板
│       ├── design-canvas-template.md
│       └── test-case-template.md
└── .github/
    └── workflows/
        └── ci.yml               # GitHub Actions CI 配置
```

## 🚀 使用方法

### 1. 从模板创建新项目

```bash
# 使用 GitHub CLI
gh repo create my-project --template your-username/claude-code-dev-workflow-template

# 或者手动克隆
git clone https://github.com/your-username/claude-code-dev-workflow-template.git my-project
cd my-project
rm -rf .git
git init
```

### 2. 自定义配置

1. **更新 CLAUDE.md**: 修改项目概述、技术栈等信息
2. **调整 hook 脚本**: 根据项目需要修改文件匹配模式
3. **配置 CI**: 根据项目需求调整 `.github/workflows/ci.yml`

### 3. 开始开发

使用 Claude Code 开始开发时，hooks 会自动强制执行开发流程。

## 🔧 开发流程

```
Step 1: 设计画布 (Pencil)
    ↓
Step 2: 测试用例 (TDD)
    ↓
Step 3: 功能实现
    ↓
Step 4: 单元测试通过
    ↓
Step 5: code-simplifier 审查 → commit
    ↓
Step 6: pr-review 审查 → push
    ↓
Step 7: 等待 CI 通过
    ↓
Step 8: E2E 测试 (Chrome DevTools)
    ↓
✅ 任务完成 → Peer Review
```

## 📋 Hook 说明

### PreToolUse Hooks

| Hook | 触发条件 | 行为 |
|------|---------|------|
| check-design-canvas | git commit | 提醒创建设计文档 |
| check-test-plan | Write/Edit 新文件 | 提醒创建测试计划 |
| check-code-simplifier | git commit | **阻止** 未审查的 commit |
| check-pr-review | git push | **阻止** 未审查的 push |
| check-unit-tests | git commit | 提醒运行单元测试 |
| warn-skip-verification | git --no-verify | 警告跳过验证 |

### PostToolUse Hooks

| Hook | 触发条件 | 行为 |
|------|---------|------|
| post-git-action-clear | git commit/push 成功 | 清理已完成的状态 |
| post-git-push | git push 成功 | 提醒验证 CI 和 E2E |
| post-file-edit-reminder | Write/Edit 源代码 | 提醒运行测试 |

### Stop Hook

| Hook | 触发条件 | 行为 |
|------|---------|------|
| verify-completion | 任务结束 | **阻止** 未完成验证的任务 |

## 🛠 状态管理

使用 `state-manager.sh` 管理工作流状态：

```bash
# 查看当前状态
.claude/hooks/state-manager.sh list

# 标记动作完成
.claude/hooks/state-manager.sh mark design-canvas
.claude/hooks/state-manager.sh mark test-plan
.claude/hooks/state-manager.sh mark code-simplifier
.claude/hooks/state-manager.sh mark pr-review
.claude/hooks/state-manager.sh mark unit-tests
.claude/hooks/state-manager.sh mark e2e-tests

# 清除状态
.claude/hooks/state-manager.sh clear <action>
.claude/hooks/state-manager.sh clear-all
```

## 📝 文档模板

### 设计画布模板

位置: `docs/templates/design-canvas-template.md`

包含:
- 问题陈述
- 架构设计
- API 设计
- 数据模型
- UI 设计
- 安全考虑

### 测试用例模板

位置: `docs/templates/test-case-template.md`

包含:
- 测试场景定义
- 测试步骤
- 预期结果
- 优先级标记
- 验收标准

## 🔐 依赖的 Claude Code Plugins

确保启用以下 Claude Code 官方插件:

- `code-simplifier@claude-plugins-official` - 代码简化
- `pr-review-toolkit@claude-plugins-official` - PR 审查

## 📊 GitHub Actions

默认 CI 包含:
- Lint & Type Check
- Unit Tests (with coverage)
- Build

可选启用:
- E2E Tests (Playwright)
- Deploy Preview

## 🤝 参考项目

本模板参考自 [VidSyllabus](https://github.com/zxkane/VidSyllabus) 项目的 Claude Code memory 和 hook 系统实现。

## 📄 License

MIT License
