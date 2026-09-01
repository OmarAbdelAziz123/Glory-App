#!/usr/bin/env python3
"""Replace hardcoded Arabic strings with context.l10n.* calls."""

from __future__ import annotations

import json
import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MAP_FILE = ROOT / "tools" / "l10n_string_map.json"
LIB = ROOT / "lib"

SKIP_PARTS = {"l10n", ".dart_tool"}
SKIP_SUFFIXES = (".g.dart", ".freezed.dart")
SKIP_FILES = {"app_localizations", "app_localizations_en", "app_localizations_ar"}

# Strings that need method calls with placeholders (dart expr -> arb method args)
PARAM_PATTERNS: list[tuple[re.Pattern[str], str]] = [
    (re.compile(r"'\$days يوم'"), "context.l10n.daysCountLabel(days)"),
    (re.compile(r"'\$weight كيلو'"), "context.l10n.weightKilosLabel(weight)"),
    (re.compile(r"'\$min أحرف'"), "context.l10n.minCharsHint(min)"),
    (re.compile(r"'يجب ألا يقل عن \$min أحرف'"), "context.l10n.minLengthError(min)"),
    (re.compile(r"'يجب ألا يزيد عن \$max حرفاً'"), "context.l10n.maxLengthError(max)"),
    (re.compile(r"'المرحلة \$stepNumber'"), "context.l10n.workoutPhaseNumber(stepNumber)"),
    (
        re.compile(r"'الخطوة \$\{currentStep \+ 1\} من \$totalSteps'"),
        "context.l10n.questionnaireStepProgress(currentStep + 1, totalSteps)",
    ),
    (
        re.compile(r"'ستنتهي صلاحية الكود خلال \( \$timerText ثانية \) '"),
        "context.l10n.qrCodeExpiryTimer(timerText)",
    ),
    (
        re.compile(r"'ستنتهi صلاحية الكود خلال \( \$secondsLabel ثانية \)'"),
        "context.l10n.qrCodeExpirySeconds(secondsLabel)",
    ),
    (
        re.compile(
            r"'أهلاً بك في عائلة جلوري جيم! و نود ابلاغك بانه متبقي \$days يوم من اشتراكك في الجيم'"
        ),
        "context.l10n.subscriptionDaysRemainingWelcome(days)",
    ),
    (
        re.compile(
            r"'أهلاً بك في عائلة جلوري جيم! لقد تم تسجيل دخول لحصة \(\$\{result\.packageNameAr\}\) '"
        ),
        "context.l10n.checkinClassWelcomePrefix(result.packageNameAr)",
    ),
]

L10N_IMPORT = "import '../../../../../core/l10n/l10n_extension.dart';"
L10N_IMPORT_ALT = "import '../../../../core/l10n/l10n_extension.dart';"
L10N_IMPORT_CORE = "import '../core/l10n/l10n_extension.dart';"
L10N_IMPORT_PKG = "import 'package:glory_gym/core/l10n/l10n_extension.dart';"


def depth_to_import(path: Path) -> str:
    rel = path.relative_to(LIB)
    levels = len(rel.parts) - 1
    if levels == 0:
        return "import 'core/l10n/l10n_extension.dart';"
    return "import " + ("../" * levels) + "core/l10n/l10n_extension.dart';"


def should_skip(path: Path) -> bool:
    if any(p in path.parts for p in SKIP_PARTS):
        return True
    if path.name.endswith(SKIP_SUFFIXES):
        return True
    if any(s in path.stem for s in SKIP_FILES):
        return True
    if "tools" in path.parts:
        return True
    return False


def add_import(content: str, import_line: str) -> str:
    if "l10n_extension.dart" in content or "core/l10n/l10n.dart" in content:
        return content
    # insert after last import
    lines = content.split("\n")
    last_import = 0
    for i, line in enumerate(lines):
        if line.startswith("import "):
            last_import = i
    lines.insert(last_import + 1, import_line)
    return "\n".join(lines)


def process_file(path: Path, mapping: dict[str, str]) -> bool:
    content = path.read_text(encoding="utf-8")
    original = content

    # Skip utils/validators - handled separately with l10n param
    rel = str(path.relative_to(LIB))
    if rel.startswith("core/utils/") or rel.startswith("core/widgets/"):
        return False

    for pattern, replacement in PARAM_PATTERNS:
        content = pattern.sub(replacement, content)

    # Sort by length descending to replace longer strings first
    for arabic in sorted(mapping.keys(), key=len, reverse=True):
        key = mapping[arabic]
        if "$" in arabic or "{" in arabic:
            continue
        if len(arabic) < 2:
            continue
        repl = f"context.l10n.{key}"
        content = content.replace(f"'{arabic}'", repl)
        content = content.replace(f'"{arabic}"', repl)

    if content == original:
        return False

    # Remove const when l10n used in const constructors (simple heuristic)
    content = re.sub(
        r"const (\w+\([^)]*context\.l10n[^)]*\))",
        r"\1",
        content,
    )
    content = re.sub(
        r"const (App\w+\([^)]*context\.l10n)",
        r"\1",
        content,
    )

    import_line = depth_to_import(path)
    content = add_import(content, import_line)
    path.write_text(content, encoding="utf-8")
    return True


def main() -> None:
    mapping: dict[str, str] = json.loads(MAP_FILE.read_text(encoding="utf-8"))
    changed = 0
    for dirpath, _, filenames in os.walk(LIB):
        for fn in filenames:
            if not fn.endswith(".dart"):
                continue
            path = Path(dirpath) / fn
            if should_skip(path):
                continue
            if process_file(path, mapping):
                changed += 1
                print(f"Updated: {path.relative_to(ROOT)}")
    print(f"\nTotal files updated: {changed}")


if __name__ == "__main__":
    main()
