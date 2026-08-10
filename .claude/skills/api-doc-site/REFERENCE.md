# API doc site — reference

Detail for Phase 2 (rendering) and the accuracy/verification traps. Load when you actually build the
HTML or hit a field-level or headless-Chrome gotcha.

---

## Converter

A one-time Markdown → static-HTML converter. This is a **reference implementation**, not a bundled
script: write it to a temp/scratch file and run it once (e.g.
`uv run --with markdown python /tmp/build_html.py API.md API.html`), then discard it. The deliverable
is the HTML. Adapt freely; the tricky parts are the escaped-pipe tables, the method-badge regex, the
TOC → sidebar walk, and the table wrapping.

```python
#!/usr/bin/env python3
import html, re, sys
from pathlib import Path
import markdown

SRC = Path(sys.argv[1] if len(sys.argv) > 1 else "API.md")
OUT = Path(sys.argv[2] if len(sys.argv) > 2 else "API.html")
text = SRC.read_text(encoding="utf-8")

# (optional) strip an in-page "## Contents" block — the sidebar replaces it
lines, keep, skip = text.splitlines(), [], False
for ln in lines:
    if ln.strip() == "## Contents": skip = True; continue
    if skip:
        if ln.strip() == "---": skip = False
        continue
    keep.append(ln)
text = "\n".join(keep)

md = markdown.Markdown(extensions=["tables", "fenced_code", "toc", "attr_list"])
body = md.convert(text)                       # md.toc_tokens is populated after convert()

METHOD = re.compile(r"(GET|POST|PUT|PATCH|DELETE)\s+(.+)", re.S)
def split_ep(name):                            # heading name -> (method, path, deprecated) or None
    m = METHOD.match(html.unescape(name).strip())
    if not m: return None
    path = re.split(r"\s*\(deprecated", m.group(2), maxsplit=1)[0].strip()
    return m.group(1), path, ("deprecated" in m.group(2).lower())

def enhance_h3(m):                             # add a method badge to endpoint <h3>
    hid, inner = m.group("id"), m.group("inner")
    ep = split_ep(re.sub(r"<[^>]+>", "", inner))
    if not ep: return m.group(0)
    meth, path, dep = ep
    tag = '<span class="dep">deprecated</span>' if dep else ""
    return (f'<h3 id="{hid}" class="endpoint">'
            f'<span class="method m-{meth.lower()}">{meth}</span>'
            f'<code class="path">{html.escape(path)}</code>{tag}</h3>')
body = re.sub(r'<h3 id="(?P<id>[^"]+)">(?P<inner>.*?)</h3>', enhance_h3, body, flags=re.S)

# wide tables scroll instead of breaking the layout
body = body.replace("<table>", '<div class="table-wrap"><table>').replace("</table>", "</table></div>")

# sidebar from the TOC token tree: root = single H1; root.children = H2; h2.children = H3
root = md.toc_tokens[0]
groups = []
for h2 in root["children"]:
    if html.unescape(h2["name"]).strip().lower() == "contents": continue
    kids = []
    for h3 in h2["children"]:
        ep = split_ep(h3["name"])
        if ep:
            meth, path, dep = ep
            kids.append(
                f'<a class="nav-endpoint{" dep-link" if dep else ""}" href="#{h3["id"]}" '
                f'title="{html.escape(path)}"><span class="method m-{meth.lower()}">{meth}</span>'
                f'<span class="nav-path">{html.escape(path)}</span></a>')
        else:
            kids.append(f'<a class="nav-sub" href="#{h3["id"]}">{html.unescape(h3["name"])}</a>')
    inner = f'<div class="nav-children">{"".join(kids)}</div>' if kids else ""
    groups.append(
        f'<div class="nav-group"><a class="nav-group-title" href="#{h2["id"]}">'
        f'{h2["name"]}</a>{inner}</div>')
nav = "\n".join(groups)

title = html.unescape(root["name"]); brand = title.split("—")[0].strip()
CSS = r"""PASTE THE CSS BLOCK FROM 'Styling assets' HERE"""
JS  = r"""PASTE THE SCROLL-SPY JS BLOCK FROM 'Styling assets' HERE"""
OUT.write_text(f"""<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(title)}</title><style>{CSS}</style></head>
<body>
<nav class="sidebar"><div class="brand"><span class="dot"></span><span>{html.escape(brand)}</span></div>
{nav}</nav>
<main><div class="content">
{body}
</div></main>
<script>{JS}</script></body></html>
""", encoding="utf-8")
print("wrote", OUT)
```

**Notes**
- Requires the source Markdown to have exactly **one H1** (the doc title). Groups come from H2,
  endpoints from H3 (`### `GET /path``). Keep that heading discipline in Phase 1.
- python-markdown's `fenced_code` emits `<pre><code class="language-json">…</code></pre>`; the styling
  below just renders code blocks cleanly (no syntax highlighting in the core build).
- If a parser is already vendored, use it; otherwise `uv run --with markdown` (or the language's
  equivalent one-shot) avoids touching `pyproject.toml` / lockfiles.

---

## Styling assets

Paste these verbatim into `CSS` and `JS` above. Clean single (light) theme, fixed sidebar,
method badges, scroll-spy, responsive fallback. No external resources.

### CSS

```css
:root{
  --bg:#ffffff; --fg:#1f2328; --muted:#59636e; --border:#d1d9e0; --border-soft:#e7ebef;
  --sidebar-bg:#f7f8fa; --accent:#0969da; --accent-soft:#ddf4ff; --link:#0969da;
  --code-bg:#f6f8fa; --th-bg:#f2f4f6; --row-alt:#fafbfc; --quote-bg:#f6f8fa;
  --m-get:#1a7f37; --m-post:#0969da; --m-patch:#9a6700; --m-delete:#cf222e;
}
*{box-sizing:border-box}
html{scroll-behavior:smooth}
body{margin:0; background:var(--bg); color:var(--fg);
  font:15px/1.65 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;
  -webkit-font-smoothing:antialiased;}
code,pre,.method,.nav-path,.path{font-family:ui-monospace,SFMono-Regular,"SF Mono",Menlo,Consolas,monospace}
.sidebar{position:fixed; top:0; left:0; width:300px; height:100vh; overflow-y:auto;
  background:var(--sidebar-bg); border-right:1px solid var(--border); padding:22px 14px 40px;}
main{margin-left:300px; padding:44px 48px 120px; max-width:920px}
.content{max-width:820px}
.brand{display:flex; align-items:center; gap:9px; font-weight:700; font-size:15px; padding:0 8px 16px;}
.brand .dot{width:10px;height:10px;border-radius:3px;background:var(--accent);flex:none}
.nav-group{margin-bottom:2px}
.nav-group-title{display:block; padding:7px 8px; margin-top:10px; color:var(--fg); text-decoration:none;
  font-weight:650; font-size:12px; letter-spacing:.03em; text-transform:uppercase;}
.nav-group-title:hover{color:var(--accent)}
.nav-children{display:flex; flex-direction:column; gap:1px}
.nav-endpoint,.nav-sub{display:flex; align-items:center; gap:8px; padding:5px 8px; border-radius:7px;
  color:var(--muted); text-decoration:none; font-size:13px; border-left:2px solid transparent;}
.nav-sub{padding-left:10px}
.nav-endpoint:hover,.nav-sub:hover{background:var(--accent-soft); color:var(--fg)}
.nav-endpoint.active,.nav-sub.active{background:var(--accent-soft); color:var(--fg);
  border-left-color:var(--accent); font-weight:600;}
.nav-path{overflow:hidden; text-overflow:ellipsis; white-space:nowrap}
.dep-link .nav-path{text-decoration:line-through; opacity:.7}
.method{flex:none; display:inline-block; min-width:44px; text-align:center; padding:2px 6px;
  border-radius:5px; font-size:10.5px; font-weight:700; letter-spacing:.04em; color:#fff;}
.m-get{background:var(--m-get)} .m-post{background:var(--m-post)}
.m-patch{background:var(--m-patch)} .m-delete{background:var(--m-delete)} .m-put{background:var(--m-patch)}
h1,h2,h3,p,li{overflow-wrap:break-word}
h1{font-size:30px; line-height:1.25; margin:0 0 8px; letter-spacing:-.01em}
h2{font-size:22px; margin:52px 0 14px; padding-bottom:8px; border-bottom:1px solid var(--border);
  letter-spacing:-.01em; scroll-margin-top:20px;}
h3{font-size:17px; margin:32px 0 12px; scroll-margin-top:20px}
h3.endpoint{display:flex; align-items:center; gap:10px; flex-wrap:wrap; min-width:0}
h3.endpoint .path{background:none; padding:0; font-size:16px; font-weight:600; overflow-wrap:anywhere; min-width:0}
h3 .dep{font-size:10.5px; font-weight:700; text-transform:uppercase; letter-spacing:.04em;
  color:var(--m-delete); border:1px solid var(--m-delete); border-radius:5px; padding:1px 6px;}
p{margin:12px 0} a{color:var(--link)} strong{font-weight:650}
hr{border:none; border-top:1px solid var(--border-soft); margin:40px 0}
:not(pre)>code{background:var(--code-bg); padding:.15em .4em; border-radius:5px; font-size:.88em;
  border:1px solid var(--border-soft);}
pre{background:var(--code-bg); padding:16px 18px; border-radius:10px; overflow-x:auto;
  border:1px solid var(--border); font-size:13px; line-height:1.55;}
pre code{background:none; border:none; padding:0; font-size:13px}
.table-wrap{overflow-x:auto; margin:16px 0; border:1px solid var(--border); border-radius:10px}
table{border-collapse:collapse; width:100%; font-size:13.5px}
th,td{text-align:left; padding:9px 14px; border-bottom:1px solid var(--border-soft); vertical-align:top}
thead th{background:var(--th-bg); font-weight:650; white-space:nowrap; border-bottom:1px solid var(--border)}
tbody tr:nth-child(even){background:var(--row-alt)}
tbody tr:last-child td{border-bottom:none}
td code{white-space:nowrap}
blockquote{margin:16px 0; padding:12px 16px; background:var(--quote-bg);
  border-left:3px solid var(--accent); border-radius:0 8px 8px 0;}
blockquote p{margin:6px 0}
ul{margin:12px 0; padding-left:22px} li{margin:5px 0}
@media (max-width:920px){
  .sidebar{position:static; width:auto; height:auto; max-height:46vh; overflow-y:auto;
    border-right:none; border-bottom:1px solid var(--border); padding:16px 14px;}
  main{margin-left:0; padding:28px 20px 100px}
  h1{font-size:23px} h2{font-size:19px} h3{font-size:16px}
  h3.endpoint .path{font-size:15px}
}
```

### Scroll-spy JS

```javascript
(function(){
  var navLinks={};
  document.querySelectorAll('.sidebar a[href^="#"]').forEach(function(a){
    navLinks[decodeURIComponent(a.getAttribute('href').slice(1))]=a;
  });
  var heads=[].slice.call(document.querySelectorAll('main h1[id],main h2[id],main h3[id]'));
  if(!heads.length) return;
  var active=null;
  function spy(){
    var cur=heads[0], i;
    for(i=0;i<heads.length;i++){
      if(heads[i].getBoundingClientRect().top<=130) cur=heads[i]; else break;
    }
    if(!cur||cur.id===active) return;
    active=cur.id;
    for(var k in navLinks) navLinks[k].classList.remove('active');
    var link=navLinks[cur.id];
    if(link){
      link.classList.add('active');
      var r=link.getBoundingClientRect();
      if(r.top<70||r.bottom>window.innerHeight-30) link.scrollIntoView({block:'center'});
    }
  }
  var ticking=false;
  window.addEventListener('scroll',function(){
    if(ticking) return; ticking=true;
    requestAnimationFrame(function(){ spy(); ticking=false; });
  },{passive:true});
  spy();
})();
```

---

## Accuracy traps

Response bodies are the error-prone half of Phase 1. Trace each to code; never assume.

- **Untyped handlers → empty generated bodies.** If handlers return raw dicts/maps (no response
  model/serializer type), the generated OpenAPI has no response schema. Derive the shape from the
  code that builds the payload.
- **Numbers serialized as strings.** Money/ratio fields are often emitted as JSON strings
  (`"12500000.00"`, `"0.32"`) while a sibling like `positionSharePct` is a real number. Document the
  type as it actually serializes.
- **Casing is not uniform.** One endpoint may remap keys to `snake_case` while its siblings use
  `camelCase`. Don't write a blanket "all fields camelCase" — check each builder.
- **Feature/flag-gated behaviour.** Some writes return **503** (not 401) when a schema/feature flag
  is off; some GETs still work by serving synthetic/default data. Note it per endpoint.
- **Scoping vs global.** Owner-scoped resources return **404 for both missing and foreign** ids;
  other resources are global. State which is which.
- **Opaque composite IDs.** base64/encoded ids (`impact_…`, `client-impact_…`) — tell clients to
  treat them as opaque and echo them back; don't parse or construct.
- **Optimistic concurrency.** Mutations may require `expectedVersion` / `expectedStatus` and return
  **409** on mismatch. Document the precondition field and the conflict code.
- **Strict request bodies.** Bodies may reject unknown fields (**422**) and use camelCase aliases
  distinct from internal field names. The generated schema is authoritative here — use it.

---

## Headless verification

To confirm the HTML renders (and scroll-spy works) with headless Chrome, these are required or it
fails silently. Learned the hard way.

- **Screenshots capture from the top only.** `chrome --headless=new --screenshot` renders from
  scroll position 0; it cannot screenshot a scrolled state. A scrolled highlight won't show.
- **`window.scrollTo` is a no-op in headless.** Programmatic window scroll does not move the layout
  (`pageYOffset` stays 0). To actually scroll, drive CDP `Input.dispatchMouseEvent`
  `{type:"mouseWheel", x, y, deltaY}`. A NONE/empty scroll-spy result is usually this, not a bug —
  confirm by reading back `pageYOffset`.
- **CDP needs `--remote-allow-origins`.** Modern Chrome rejects the DevTools websocket handshake with
  **403** unless launched with `--remote-allow-origins='*'` (quote the `*` so the shell doesn't glob
  it). Also pass `--remote-debugging-address=127.0.0.1` and query `127.0.0.1` — Chrome may otherwise
  bind only IPv6 `[::1]`, so an IPv4 `/json` fetch returns "no target".
- **Fresh profile per launch.** Use a unique `--user-data-dir` and kill the process afterward; a
  stale `SingletonLock` aborts the next launch ("Failed to create a ProcessSingleton").
- **Avoid `--virtual-time-budget` with scrolling** — it can yield blank screenshots.
- Connect to the websocket with `uv run --with websocket-client` (no project dependency). Do the
  whole launch → poll `/json` → drive → kill in one shell so lifecycle can't strand a process.
- **Cheaper check, no scroll needed:** verify structure instead — every endpoint id appears as both a
  heading and a nav `href`, tables are wrapped, and there are no external resource references.
