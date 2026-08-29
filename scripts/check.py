#!/usr/bin/env python3
"""Validate documentation, Pages HTML, local links, and identity policy."""

from html.parser import HTMLParser
from pathlib import Path
import re
import sys
from typing import Optional


ROOT = Path(__file__).resolve().parents[1]
ERRORS: list[str] = []


class StructureParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.tags: list[str] = []
        self.has_title = False

    def handle_starttag(self, tag: str, attrs: list[tuple[str, Optional[str]]]) -> None:
        self.tags.append(tag)
        if tag == "title":
            self.has_title = True


markdown_files = sorted(ROOT.rglob("*.md"))
for path in markdown_files:
    if ".git" in path.parts:
        continue
    content = path.read_text(encoding="utf-8")
    relative = path.relative_to(ROOT)

    if content.count("```") % 2:
        ERRORS.append(f"{relative}: unmatched fenced code block")

    for target in re.findall(r"\[[^]]+\]\(([^)]+)\)", content):
        if target.startswith(("https://", "http://", "#", "mailto:")):
            continue
        clean_target = target.split("#", 1)[0]
        if clean_target and not (path.parent / clean_target).resolve().exists():
            ERRORS.append(f"{relative}: missing local link target {target}")

pages_file = ROOT / "docs" / "index.html"
parser = StructureParser()
parser.feed(pages_file.read_text(encoding="utf-8"))
if "html" not in parser.tags or "body" not in parser.tags or not parser.has_title:
    ERRORS.append("docs/index.html: missing required HTML structure")

scannable = [
    path
    for path in ROOT.rglob("*")
    if path.is_file() and ".git" not in path.parts and path.suffix in {".md", ".html", ".sh", ".py", ".yml", ".yaml"}
]
all_text = "\n".join(path.read_text(encoding="utf-8") for path in scannable).lower()
for forbidden in ("mamu" + "duri", "jeevanm.aws" + "@gmail.com", "akia" + "iosf"):
    if forbidden in all_text:
        ERRORS.append("Repository contains a prohibited identity or credential pattern")

if ERRORS:
    print("Validation failed:", file=sys.stderr)
    for error in ERRORS:
        print(f"- {error}", file=sys.stderr)
    raise SystemExit(1)

print(f"Validated {len(markdown_files)} Markdown files and the Pages master map.")
