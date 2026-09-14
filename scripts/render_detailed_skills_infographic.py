import json
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "docs" / "assets"
SOURCE = ASSETS / "53-codex-skills-sa-infographic.png"
OUTPUT = ASSETS / "53-codex-skills-complete-directory.png"
MANIFEST = ROOT / "manifests" / "personal-skills.json"

W, H = 3840, 2160
BG, WHITE, INK, MUTED = "#F4F5F7", "#FFFFFF", "#172033", "#657083"
FONT_CJK = Path("C:/Windows/Fonts/msjh.ttc")
FONT_LATIN = Path("C:/Windows/Fonts/segoeui.ttf")
FONT_LATIN_BOLD = Path("C:/Windows/Fonts/segoeuib.ttf")

CATEGORIES = [
    ("硬體與系統架構", "Architecture", "#0F766E", [
        "soc-architecture", "pcb-eda-review", "mechanical-cad-review",
    ]),
    ("程式開發與測試", "Development & Testing", "#2563EB", [
        "brainstorming", "writing-plans", "planning-with-files", "executing-plans",
        "subagent-driven-development", "dispatching-parallel-agents",
        "using-git-worktrees", "test-driven-development", "systematic-debugging",
        "receiving-code-review", "requesting-code-review", "code-review",
        "verification-before-completion", "finishing-a-development-branch",
        "cli-creator", "gh-fix-ci", "jupyter-notebook", "webapp-testing", "mcp-builder",
    ]),
    ("Web 與瀏覽器自動化", "Web Automation", "#7C3AED", [
        "agent-reach", "firecrawl", "defuddle", "browser-use", "screenshot",
    ]),
    ("知識庫與工程資料", "Knowledge & Data", "#D97706", [
        "obsidian-cli", "obsidian-markdown", "obsidian-bases", "json-canvas",
    ]),
    ("UI/UX 與設計落地", "Design", "#DB2777", [
        "frontend-design", "superdesign", "figma", "ui-ux-pro-max", "humanizer",
    ]),
    ("文件、簡報與多媒體", "Documents & Media", "#0891B2", [
        "codex-ppt", "guizang-ppt-skill", "image-to-editable-ppt",
        "remotion-best-practices", "hyperframes", "speech", "transcribe", "humanizer-zh",
    ]),
    ("Skill 工程與維護", "Skill Engineering", "#65A30D", [
        "awesome-skills", "find-skills", "using-superpowers", "writing-skills",
    ]),
    ("AI 評測與模型生命週期", "AI Evaluation & Models", "#DC5A4A", [
        "evaluation", "advanced-evaluation", "huggingface-community-evals",
        "huggingface-local-models", "huggingface-llm-trainer",
    ]),
]


def font(size, *, bold=False, cjk=False):
    path = FONT_CJK if cjk else (FONT_LATIN_BOLD if bold else FONT_LATIN)
    return ImageFont.truetype(str(path), size=size)


def rounded_photo(canvas, source, box, radius=44):
    x0, y0, x1, y1 = box
    width, height = x1 - x0, y1 - y0
    crop = source.crop((1120, 48, 1856, 274))
    ratio = max(width / crop.width, height / crop.height)
    crop = crop.resize((int(crop.width * ratio), int(crop.height * ratio)), Image.Resampling.LANCZOS)
    left, top = (crop.width - width) // 2, (crop.height - height) // 2
    crop = crop.crop((left, top, left + width, top + height))
    mask = Image.new("L", (width, height), 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, width, height), radius=radius, fill=255)
    canvas.paste(crop, (x0, y0), mask)


def draw_card(draw, x, y, w, h, index, title, english, color, names):
    draw.rounded_rectangle((x, y, x + w, y + h), radius=30, fill=WHITE, outline="#DDE2E8", width=3)
    draw.rounded_rectangle((x, y, x + 14, y + h), radius=7, fill=color)
    draw.ellipse((x + 34, y + 30, x + 108, y + 104), fill=color)
    draw.text((x + 71, y + 67), f"{index:02d}", font=font(28), fill=WHITE, anchor="mm")
    draw.text((x + 132, y + 29), title, font=font(37, cjk=True), fill=INK)
    draw.text((x + 132, y + 79), f"{english}  ·  {len(names)} Skills", font=font(25), fill=color)
    draw.line((x + 34, y + 128, x + w - 34, y + 128), fill="#E6E9ED", width=3)

    columns = 2 if len(names) > 10 else 1
    rows = (len(names) + columns - 1) // columns
    name_size = 25 if columns == 2 else 30
    line_h = 47 if columns == 2 else 66
    col_w = (w - 80) // columns
    for i, name in enumerate(names):
        col, row = i // rows, i % rows
        nx, ny = x + 42 + col * col_w, y + 157 + row * line_h
        draw.ellipse((nx, ny + 14, nx + 10, ny + 24), fill=color)
        draw.text((nx + 24, ny), name, font=font(name_size), fill="#344054")


def validate_manifest():
    manifest_names = {item["name"] for item in json.loads(MANIFEST.read_text(encoding="utf-8"))["skills"]}
    designed_names = {name for _, _, _, names in CATEGORIES for name in names}
    if len(designed_names) != 53 or manifest_names != designed_names:
        missing = sorted(manifest_names - designed_names)
        extra = sorted(designed_names - manifest_names)
        raise RuntimeError(f"Skill directory mismatch: missing={missing}, extra={extra}")


def main():
    validate_manifest()
    source = Image.open(SOURCE).convert("RGB")
    canvas = Image.new("RGB", (W, H), BG)
    draw = ImageDraw.Draw(canvas)

    for i, (_, _, color, _) in enumerate(CATEGORIES):
        draw.rectangle((i * W // 8, 0, (i + 1) * W // 8, 22), fill=color)

    draw.text((96, 72), "ENGINEERING CAPABILITY DIRECTORY", font=font(32), fill="#D45B28")
    draw.text((96, 126), "53 Codex Skills", font=font(100, bold=True), fill=INK)
    draw.text((96, 252), "SA 工程施作｜完整 Skill 名錄", font=font(57, cjk=True), fill=INK)
    draw.text((96, 332), "穿戴系統架構  ×  軟體開發  ×  AI 驗證", font=font(34, cjk=True), fill=MUTED)
    draw.rounded_rectangle((96, 404, 560, 472), radius=34, fill="#E2F4EE")
    draw.text((328, 438), "53 / 53  已安裝・已驗證", font=font(28, cjk=True), fill="#08775A", anchor="mm")

    rounded_photo(canvas, source, (2390, 70, 3710, 470))
    draw.rounded_rectangle((2440, 390, 3660, 452), radius=24, fill="#172033")
    draw.text((3050, 421), "WEARABLE SA · ENGINEERING WORKBENCH", font=font(26), fill=WHITE, anchor="mm")

    margin, gap = 80, 34
    card_w = (W - margin * 2 - gap * 3) // 4
    card_h = 670
    for i, category in enumerate(CATEGORIES):
        row, col = divmod(i, 4)
        x = margin + col * (card_w + gap)
        y = 530 + row * (card_h + 38)
        draw_card(draw, x, y, card_w, card_h, i + 1, *category)

    draw.text((80, 1991), "SA 施作流程", font=font(31, cjk=True), fill=INK)
    stages = [("需求", "#0F766E"), ("架構", "#2563EB"), ("開發", "#7C3AED"),
              ("測試", "#D97706"), ("AI 評測", "#DB2777"), ("交付", "#0891B2")]
    x = 390
    for i, (stage, color) in enumerate(stages):
        draw.rounded_rectangle((x, 1964, x + 360, 2034), radius=25, fill=color)
        draw.text((x + 180, 1999), stage, font=font(30, cjk=True), fill=WHITE, anchor="mm")
        if i < len(stages) - 1:
            draw.text((x + 400, 1998), "→", font=font(40), fill="#8A94A4", anchor="mm")
        x += 470

    draw.line((80, 2070, 3760, 2070), fill="#D5DAE0", width=3)
    draw.text((80, 2094), "github.com/johnson68878-ops/codex-skills-backup", font=font(28), fill="#2563EB")
    draw.text((3760, 2094), "OPEN · REPRODUCIBLE · VERIFIED", font=font(25), fill=MUTED, anchor="ra")

    canvas.save(OUTPUT, optimize=True)
    print(f"Rendered {OUTPUT} with 53 verified names")


if __name__ == "__main__":
    main()
