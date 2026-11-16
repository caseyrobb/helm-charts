#!/usr/bin/env python3
"""Render the GitHub Pages landing page from the published Helm index.yaml.

Used by .github/workflows/release.yaml: after chart-releaser updates
index.yaml on the gh-pages branch, this script regenerates index.html so
the landing page always reflects the current chart releases.
"""
import argparse
import datetime
import html
import re
import sys

import yaml


def semver_key(v):
    m = re.match(r"^(\d+)\.(\d+)\.(\d+)", str(v))
    if not m:
        return (0, 0, 0, str(v))
    return (int(m.group(1)), int(m.group(2)), int(m.group(3)), "")


def latest_entries(index):
    """Return {chart_name: latest_entry_dict} from a parsed index.yaml."""
    out = {}
    for name, entries in (index.get("entries") or {}).items():
        if not entries:
            continue
        out[name] = max(entries, key=lambda e: semver_key(e.get("version", "0")))
    return out


def release_tag_url(entry, repo_url):
    name = entry.get("name", "")
    version = entry.get("version", "")
    return f"{repo_url}/releases/tag/{name}-{version}"


PAGE_TMPL = """<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Casey Robb — Helm Charts</title>
<style>
  :root {{ color-scheme: dark; }}
  body {{ font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
         margin: 0; padding: 2rem 1rem; background: #0d1117; color: #e6edf3; }}
  main {{ max-width: 1080px; margin: 0 auto; }}
  h1 {{ font-size: 1.7rem; margin-bottom: .25rem; }}
  .sub {{ color: #8b949e; margin-bottom: 1.5rem; }}
  a {{ color: #4493f8; text-decoration: none; }}
  a:hover {{ text-decoration: underline; }}
  table {{ border-collapse: collapse; width: 100%; }}
  th, td {{ text-align: left; padding: .55rem .7rem; border-bottom: 1px solid #21262d; }}
  th {{ color: #8b949e; font-weight: 600; font-size: .85rem; text-transform: uppercase; }}
  tr:hover td {{ background: #161b22; }}
  code {{ background: #161b22; padding: .15rem .4rem; border-radius: 4px; font-size: .9em; }}
  .ver {{ font-family: ui-monospace, SFMono-Regular, Menlo, monospace; }}
  .foot {{ color: #8b949e; font-size: .8rem; margin-top: 2rem; }}
</style>
</head>
<body>
<main>
  <h1>Helm Charts</h1>
  <p class="sub">Charts by <a href="{repo_url}">Casey Robb</a>, published with
     <a href="https://github.com/helm/chart-releaser-action">chart-releaser</a>.</p>
  <p>Add the repository:</p>
  <p><code>helm repo add caseyrobb https://caseyrobb.github.io/helm-charts</code><br>
     <code>helm repo update</code></p>
  <table>
    <thead><tr><th>Chart</th><th>Description</th><th>Version</th><th>App&nbsp;version</th><th>Released</th><th>Links</th></tr></thead>
    <tbody>
{rows}
    </tbody>
  </table>
  <p class="foot">Current releases generated automatically from
     <a href="index.yaml">index.yaml</a> on {generated}.
     Chart sources live under <a href="{repo_url}/tree/master/charts">{repo_url}/charts</a>.</p>
</main>
</body>
</html>
"""


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--index", required=True, help="path to published index.yaml")
    ap.add_argument("--output", required=True, help="path to write index.html")
    ap.add_argument("--repo-url", default="https://github.com/caseyrobb/helm-charts")
    args = ap.parse_args()

    with open(args.index) as f:
        index = yaml.safe_load(f) or {}

    rows = []
    latest = latest_entries(index)
    for name in sorted(latest):
        e = latest[name]
        desc = html.escape(str(e.get("description", "")).strip())
        ver = html.escape(str(e.get("version", "")))
        app = html.escape(str(e.get("appVersion", "—")))
        created = str(e.get("created", ""))[:10] or "—"
        home = e.get("home") or (e.get("sources") or [None])[0] or args.repo_url
        tag = release_tag_url(e, args.repo_url)
        rows.append(
            f'      <tr><td><a href="{tag}">{html.escape(name)}</a></td>'
            f"<td>{desc}</td>"
            f'<td class="ver">{ver}</td>'
            f'<td class="ver">{app}</td>'
            f"<td>{created}</td>"
            f'<td><a href="{home}">upstream</a> · <a href="{tag}">notes</a></td></tr>'
        )

    page = PAGE_TMPL.format(
        repo_url=args.repo_url,
        rows="\n".join(rows),
        generated=datetime.datetime.now(datetime.timezone.utc).strftime("%Y-%m-%d %H:%M UTC"),
    )
    with open(args.output, "w") as f:
        f.write(page)
    print(f"wrote {args.output} with {len(rows)} charts")


if __name__ == "__main__":
    sys.exit(main())
