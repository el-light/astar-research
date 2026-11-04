#!/usr/bin/env python3
"""Pack slides/web/ into one file you can e-mail: slides/astar_defence_deck.html.

The fonts are embedded as base64, so the file opens with a double-click,
offline, in any modern browser.  Rerun after editing slides/web/index.html.
"""

import base64
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
WEB = ROOT / "slides" / "web"
OUT = ROOT / "slides" / "astar_defence_deck.html"


def main() -> None:
    css = (WEB / "fonts" / "fonts.css").read_text()

    def embed(match: re.Match) -> str:
        data = base64.b64encode((WEB / "fonts" / match.group(1)).read_bytes()).decode()
        return f"url(data:font/woff2;base64,{data})"

    css = re.sub(r"url\(([\w.-]+\.woff2)\)", embed, css)
    html = (WEB / "index.html").read_text()
    link = '<link rel="stylesheet" href="fonts/fonts.css">'
    assert link in html, "font link not found in slides/web/index.html"
    OUT.write_text(html.replace(link, f"<style>\n{css}</style>"))
    print(f"{OUT.relative_to(ROOT)}: {OUT.stat().st_size / 1024:.0f} KB")


if __name__ == "__main__":
    main()
