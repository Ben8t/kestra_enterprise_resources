import os
from ftplib import FTP, error_perm
from flask import Flask, request, render_template_string, jsonify

FTP_HOST = os.environ.get("FTP_HOST", "ftp")
FTP_PORT = int(os.environ.get("FTP_PORT", "21"))
FTP_USER = os.environ.get("FTP_USER", "demo")
FTP_PASS = os.environ.get("FTP_PASS", "demo")
KESTRA_URL = os.environ.get("KESTRA_URL", "http://localhost:8080/ui/main/executions")

app = Flask(__name__)
app.config["MAX_CONTENT_LENGTH"] = 100 * 1024 * 1024  # 100 MB

PAGE = """<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Kestra FTP Drop</title>
  <style>
    :root {
      --background: hsl(0 0% 100%);
      --foreground: hsl(240 10% 3.9%);
      --card: hsl(0 0% 100%);
      --border: hsl(240 5.9% 90%);
      --input: hsl(240 5.9% 90%);
      --muted: hsl(240 4.8% 95.9%);
      --muted-foreground: hsl(240 3.8% 46.1%);
      --primary: hsl(240 5.9% 10%);
      --primary-foreground: hsl(0 0% 98%);
      --ring: hsl(240 5.9% 10%);
      --success: hsl(142 71% 38%);
      --destructive: hsl(0 84.2% 60.2%);
      --radius: 0.5rem;
      --hover: hsl(240 4.8% 95.9%);
    }
    * { box-sizing: border-box; }
    html, body { height: 100%; }
    body {
      margin: 0;
      font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      font-size: 14px;
      line-height: 1.5;
      background: var(--background);
      color: var(--foreground);
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 24px;
      -webkit-font-smoothing: antialiased;
    }
    .card {
      width: 100%;
      max-width: 440px;
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: var(--radius);
    }
    .diagram-svg { width: 100%; height: auto; max-height: 56vh; display: block; margin: 0 auto; }
    .legend {
      margin-top: 18px;
      display: grid;
      grid-template-columns: auto 1fr;
      gap: 8px 12px;
      font-size: 13px;
      color: var(--muted-foreground);
    }
    .legend-key {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      color: var(--foreground);
      font-variant-numeric: tabular-nums;
    }
    .legend-dot { width: 10px; height: 10px; border-radius: 9999px; }
    /* Floating trigger */
    .fab {
      position: fixed;
      right: 24px;
      bottom: 24px;
      display: inline-flex;
      align-items: center;
      gap: 8px;
      height: 38px;
      padding: 0 16px;
      border: 1px solid var(--border);
      border-radius: 9999px;
      background: var(--card);
      color: var(--foreground);
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      font-family: inherit;
      box-shadow: 0 6px 20px rgba(0,0,0,0.35);
      transition: background-color .15s, border-color .15s, transform .1s;
    }
    .fab:hover { background: var(--hover); border-color: var(--ring); }
    .fab:active { transform: translateY(1px); }
    .fab svg { color: var(--muted-foreground); }
    /* Modal */
    .modal-overlay {
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,0.6);
      backdrop-filter: blur(4px);
      display: none;
      align-items: center;
      justify-content: center;
      padding: 24px;
      z-index: 50;
      animation: fade .15s ease-out;
    }
    .modal-overlay.open { display: flex; }
    @keyframes fade { from { opacity: 0; } to { opacity: 1; } }
    .modal {
      width: 100%;
      max-width: 880px;
      max-height: calc(100vh - 48px);
      overflow: auto;
      background: var(--card);
      border: 1px solid var(--border);
      border-radius: var(--radius);
      position: relative;
      animation: pop .15s ease-out;
    }
    @keyframes pop { from { opacity: 0; transform: scale(.97); } to { opacity: 1; transform: scale(1); } }
    .modal-close {
      position: absolute;
      top: 14px;
      right: 14px;
      width: 30px;
      height: 30px;
      border-radius: 6px;
      border: 0;
      background: transparent;
      color: var(--muted-foreground);
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      transition: background-color .15s, color .15s;
    }
    .modal-close:hover { background: var(--hover); color: var(--foreground); }
    .card-header {
      padding: 24px 24px 0;
    }
    .card-title {
      margin: 0;
      font-size: 18px;
      font-weight: 600;
      letter-spacing: -0.01em;
      line-height: 1;
    }
    .card-description {
      margin: 8px 0 0;
      font-size: 13px;
      color: var(--muted-foreground);
      line-height: 1.5;
    }
    .card-content {
      padding: 24px;
    }
    .dropzone {
      position: relative;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      gap: 8px;
      padding: 28px 16px;
      border: 1px dashed var(--border);
      border-radius: var(--radius);
      background: transparent;
      cursor: pointer;
      transition: border-color .15s, background-color .15s;
      text-align: center;
    }
    .dropzone:hover, .dropzone.over {
      border-color: var(--ring);
      background: var(--hover);
    }
    .dropzone svg { color: var(--muted-foreground); }
    .dropzone-title { font-size: 13px; font-weight: 500; color: var(--foreground); }
    .dropzone-hint { font-size: 12px; color: var(--muted-foreground); }
    input[type=file] { display: none; }
    .file-row {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 12px;
      margin-top: 12px;
      padding: 10px 12px;
      border: 1px solid var(--border);
      border-radius: var(--radius);
      font-size: 13px;
      background: var(--hover);
    }
    .file-row .name { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .file-row .size { color: var(--muted-foreground); font-variant-numeric: tabular-nums; flex-shrink: 0; }
    .button {
      margin-top: 16px;
      width: 100%;
      height: 36px;
      padding: 0 16px;
      border: 0;
      border-radius: var(--radius);
      background: var(--primary);
      color: var(--primary-foreground);
      font-size: 13px;
      font-weight: 500;
      cursor: pointer;
      transition: background-color .15s, opacity .15s;
      font-family: inherit;
    }
    .button:hover:not(:disabled) { background: hsl(240 5.9% 20%); }
    .button:focus-visible { outline: 2px solid var(--ring); outline-offset: 2px; }
    .button:disabled { opacity: .5; cursor: not-allowed; }
    .alert {
      margin-top: 12px;
      padding: 10px 12px;
      border-radius: var(--radius);
      font-size: 13px;
      border: 1px solid var(--border);
      display: none;
    }
    .alert.ok { display: block; border-color: hsl(142 71% 38% / 0.4); color: hsl(142 71% 28%); background: hsl(142 71% 38% / 0.08); }
    .alert.err { display: block; border-color: hsl(0 84% 60% / 0.4); color: hsl(0 70% 40%); background: hsl(0 84% 60% / 0.08); }
    .card-footer {
      padding: 16px 24px;
      border-top: 1px solid var(--border);
      font-size: 12px;
      color: var(--muted-foreground);
      display: flex;
      justify-content: space-between;
      gap: 8px;
    }
    .card-footer a { color: var(--foreground); text-decoration: none; }
    .card-footer a:hover { text-decoration: underline; }
    .badge {
      display: inline-flex;
      align-items: center;
      padding: 2px 8px;
      border-radius: 9999px;
      font-size: 11px;
      font-weight: 500;
      border: 1px solid var(--border);
      color: var(--muted-foreground);
      margin-bottom: 12px;
    }
    .badge::before {
      content: "";
      width: 6px; height: 6px;
      border-radius: 9999px;
      background: var(--success);
      margin-right: 6px;
    }
  </style>
</head>
<body>
  <div class="card">
    <div class="card-header">
      <span class="badge">Kestra · acme.demo</span>
      <h1 class="card-title">Upload a file</h1>
      <p class="card-description">Files land on the local FTP. The <code>parse-pdf</code> flow picks them up within ~10 seconds.</p>
    </div>

    <div class="card-content">
      <form id="form" method="post" action="/upload" enctype="multipart/form-data">
        <label class="dropzone" id="drop">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
          <span class="dropzone-title">Click to upload or drag and drop</span>
          <span class="dropzone-hint">PDF recommended — any file type accepted</span>
          <input type="file" name="file" id="file" />
        </label>
        <div class="file-row" id="fileRow" style="display:none;">
          <span class="name" id="fileName"></span>
          <span class="size" id="fileSize"></span>
        </div>
        <button type="submit" class="button" id="submit" disabled>Upload to FTP</button>
        <div id="msg" class="alert"></div>
      </form>
    </div>

    <div class="card-footer">
      <span>FTP · localhost:2121</span>
      <a href="{{ kestra_url }}" target="_blank">View executions →</a>
    </div>
  </div>

  <button class="fab" id="archBtn" type="button" aria-haspopup="dialog" aria-controls="archModal">
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
    How it works
  </button>

  <div class="modal-overlay" id="archModal" role="dialog" aria-modal="true" aria-labelledby="archTitle">
    <div class="modal">
      <button class="modal-close" id="archClose" aria-label="Close">
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
      </button>
      <div class="card-header">
        <span class="badge">Architecture</span>
        <h1 class="card-title" id="archTitle">How it works</h1>
        <p class="card-description">A polling FTP trigger feeds the file to a Tika parser, then a subflow runs an OpenAI agent to summarize the content in five sentences.</p>
      </div>
      <div class="card-content">
        <svg class="diagram-svg" viewBox="0 0 480 470" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="Demo architecture">
          <defs>
            <marker id="arrow" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
              <path d="M0,0 L10,5 L0,10 z" fill="hsl(240 5% 55%)"/>
            </marker>
            <marker id="arrow-accent" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="6" markerHeight="6" orient="auto-start-reverse">
              <path d="M0,0 L10,5 L0,10 z" fill="hsl(142 71% 38%)"/>
            </marker>
          </defs>
          <style>
            .node-box { fill: hsl(0 0% 100%); stroke: hsl(240 5.9% 85%); stroke-width: 1; }
            .node-title { fill: hsl(240 10% 3.9%); font: 600 12px ui-sans-serif, system-ui, sans-serif; }
            .node-sub { fill: hsl(240 3.8% 46.1%); font: 400 10px ui-sans-serif, system-ui, sans-serif; }
            .edge { stroke: hsl(240 5% 55%); stroke-width: 1.2; fill: none; }
            .edge-accent { stroke: hsl(142 71% 38%); stroke-width: 1.2; fill: none; stroke-dasharray: 4 3; }
            .edge-label { fill: hsl(240 3.8% 40%); font: 500 10px ui-sans-serif, system-ui, sans-serif; }
            .edge-label-accent { fill: hsl(142 71% 30%); font: 500 10px ui-sans-serif, system-ui, sans-serif; }
            .icon { stroke: hsl(240 10% 20%); stroke-width: 1.5; fill: none; stroke-linecap: round; stroke-linejoin: round; }
          </style>

          <!-- Browser node -->
          <g transform="translate(20, 130)">
            <rect class="node-box" width="100" height="60" rx="6"/>
            <g transform="translate(12, 14)" class="icon">
              <rect x="0" y="0" width="16" height="12" rx="2"/>
              <line x1="0" y1="4" x2="16" y2="4"/>
            </g>
            <text class="node-title" x="34" y="24">Browser</text>
            <text class="node-sub" x="12" y="44">localhost:8088</text>
          </g>

          <!-- FTP node -->
          <g transform="translate(160, 130)">
            <rect class="node-box" width="100" height="60" rx="6"/>
            <g transform="translate(12, 14)" class="icon">
              <path d="M0 12 L0 2 L10 2 L12 4 L16 4 L16 12 Z"/>
              <line x1="0" y1="6" x2="16" y2="6"/>
            </g>
            <text class="node-title" x="34" y="24">FTP server</text>
            <text class="node-sub" x="12" y="44">ftp:21 · demo/demo</text>
          </g>

          <!-- Kestra node -->
          <g transform="translate(300, 130)">
            <rect class="node-box" width="100" height="60" rx="6"/>
            <g transform="translate(12, 14)" class="icon">
              <circle cx="8" cy="6" r="6"/>
              <path d="M5 6 L8 6 L11 3 M8 6 L11 9"/>
            </g>
            <text class="node-title" x="34" y="24">Kestra</text>
            <text class="node-sub" x="12" y="44">parse-pdf flow</text>
          </g>

          <!-- Edge: Browser -> FTP -->
          <line class="edge" x1="120" y1="160" x2="160" y2="160" marker-end="url(#arrow)"/>
          <text class="edge-label" x="140" y="152" text-anchor="middle">STOR</text>

          <!-- Edge: Kestra polls FTP (curved, dashed, green) -->
          <path class="edge-accent" d="M 300 150 C 280 110, 240 110, 220 130" marker-end="url(#arrow-accent)"/>
          <text class="edge-label-accent" x="260" y="100" text-anchor="middle">poll every 10s</text>

          <!-- Edge: FTP -> Kestra (file delivered) -->
          <path class="edge" d="M 220 175 C 240 200, 280 200, 300 178" marker-end="url(#arrow)"/>
          <text class="edge-label" x="260" y="215" text-anchor="middle">UPLOAD</text>

          <!-- Parent flow tasks box -->
          <g transform="translate(260, 230)">
            <rect class="node-box" width="160" height="86" rx="6"/>
            <text class="node-title" x="12" y="20">parse-pdf · acme.demo</text>
            <circle cx="16" cy="38" r="3" fill="hsl(142 71% 38%)"/>
            <text class="node-sub" x="26" y="42">tika.Parse</text>
            <circle cx="16" cy="56" r="3" fill="hsl(142 71% 38%)"/>
            <text class="node-sub" x="26" y="60">core.log.Log</text>
            <circle cx="16" cy="74" r="3" fill="hsl(217 91% 60%)"/>
            <text class="node-sub" x="26" y="78">Subflow → summarize-pdf</text>
          </g>

          <!-- Connect Kestra to parent flow tasks -->
          <line class="edge" x1="340" y1="190" x2="340" y2="230" marker-end="url(#arrow)"/>

          <!-- Subflow box -->
          <g transform="translate(260, 350)">
            <rect class="node-box" width="160" height="86" rx="6" style="stroke: hsl(217 91% 75%);"/>
            <text class="node-title" x="12" y="20">summarize-pdf · acme</text>
            <circle cx="16" cy="38" r="3" fill="hsl(217 91% 60%)"/>
            <text class="node-sub" x="26" y="42">AIAgent · OpenAI</text>
            <circle cx="16" cy="56" r="3" fill="hsl(142 71% 38%)"/>
            <text class="node-sub" x="26" y="60">core.log.Log</text>
            <text class="node-sub" x="12" y="78" style="font-style: italic;">→ 5-sentence summary</text>
          </g>

          <!-- Connect parent flow to subflow -->
          <line class="edge" x1="340" y1="316" x2="340" y2="350" marker-end="url(#arrow)"/>
          <text class="edge-label" x="346" y="338">content</text>

          <!-- OpenAI external pill -->
          <g transform="translate(40, 380)">
            <rect class="node-box" width="86" height="34" rx="17"/>
            <circle cx="18" cy="17" r="7" fill="none" stroke="hsl(240 10% 20%)" stroke-width="1.5"/>
            <path d="M14 17 L18 13 L22 17 L18 21 Z" fill="none" stroke="hsl(240 10% 20%)" stroke-width="1.5" stroke-linejoin="round"/>
            <text class="node-title" x="32" y="21">OpenAI</text>
          </g>
          <path class="edge" d="M 126 397 C 180 397, 220 395, 260 393" marker-end="url(#arrow)" stroke-dasharray="3 3"/>
          <text class="edge-label" x="190" y="386" text-anchor="middle">API call</text>

          <!-- User node above browser -->
          <g transform="translate(48, 60)">
            <circle class="node-box" cx="22" cy="22" r="22"/>
            <g transform="translate(14, 12)" class="icon">
              <circle cx="8" cy="6" r="3.5"/>
              <path d="M2 18 C2 13, 14 13, 14 18"/>
            </g>
          </g>
          <line class="edge" x1="70" y1="104" x2="70" y2="130" marker-end="url(#arrow)"/>
          <text class="edge-label" x="78" y="120">drag &amp; drop</text>
        </svg>

        <div class="legend">
          <span class="legend-key"><span class="legend-dot" style="background:hsl(240 5% 55%)"></span>request</span><span>user / file transfer</span>
          <span class="legend-key"><span class="legend-dot" style="background:hsl(142 71% 38%)"></span>trigger</span><span>Kestra polls FTP every 10s</span>
          <span class="legend-key"><span class="legend-dot" style="background:hsl(217 91% 60%)"></span>subflow</span><span>parent calls <code>acme/summarize-pdf</code> for AI summary</span>
        </div>
      </div>
    </div>
  </div>

  <script>
    const drop = document.getElementById('drop');
    const fileInput = document.getElementById('file');
    const submit = document.getElementById('submit');
    const fileRow = document.getElementById('fileRow');
    const fileName = document.getElementById('fileName');
    const fileSize = document.getElementById('fileSize');
    const form = document.getElementById('form');
    const msg = document.getElementById('msg');

    const archBtn = document.getElementById('archBtn');
    const archModal = document.getElementById('archModal');
    const archClose = document.getElementById('archClose');
    function openArch() { archModal.classList.add('open'); }
    function closeArch() { archModal.classList.remove('open'); }
    archBtn.addEventListener('click', openArch);
    archClose.addEventListener('click', closeArch);
    archModal.addEventListener('click', e => { if (e.target === archModal) closeArch(); });
    document.addEventListener('keydown', e => { if (e.key === 'Escape') closeArch(); });

    function fmtSize(n) {
      if (n < 1024) return n + ' B';
      if (n < 1024*1024) return (n/1024).toFixed(1) + ' KB';
      return (n/1024/1024).toFixed(2) + ' MB';
    }

    function setFile(f) {
      if (!f) { fileRow.style.display = 'none'; submit.disabled = true; return; }
      fileName.textContent = f.name;
      fileSize.textContent = fmtSize(f.size);
      fileRow.style.display = 'flex';
      submit.disabled = false;
    }

    fileInput.addEventListener('change', e => setFile(e.target.files[0]));

    ['dragenter','dragover'].forEach(ev => drop.addEventListener(ev, e => {
      e.preventDefault(); e.stopPropagation(); drop.classList.add('over');
    }));
    ['dragleave','drop'].forEach(ev => drop.addEventListener(ev, e => {
      e.preventDefault(); e.stopPropagation(); drop.classList.remove('over');
    }));
    drop.addEventListener('drop', e => {
      const f = e.dataTransfer.files[0];
      if (f) { const dt = new DataTransfer(); dt.items.add(f); fileInput.files = dt.files; setFile(f); }
    });

    form.addEventListener('submit', async e => {
      e.preventDefault();
      submit.disabled = true;
      submit.textContent = 'Uploading...';
      msg.className = 'msg';
      msg.textContent = '';
      try {
        const fd = new FormData(form);
        const res = await fetch('/upload', { method: 'POST', body: fd });
        const data = await res.json();
        if (data.ok) {
          msg.className = 'msg ok';
          msg.textContent = data.message;
          form.reset();
          setFile(null);
        } else {
          msg.className = 'msg err';
          msg.textContent = data.message;
        }
      } catch (err) {
        msg.className = 'msg err';
        msg.textContent = 'Upload failed: ' + err.message;
      } finally {
        submit.textContent = 'Upload to FTP';
        submit.disabled = fileInput.files.length === 0;
      }
    });
  </script>
</body>
</html>
"""


@app.get("/")
def index():
    return render_template_string(PAGE, kestra_url=KESTRA_URL)


@app.post("/upload")
def upload():
    f = request.files.get("file")
    if not f or not f.filename:
        return jsonify(ok=False, message="No file selected"), 400
    try:
        ftp = FTP()
        ftp.connect(FTP_HOST, FTP_PORT, timeout=15)
        ftp.login(FTP_USER, FTP_PASS)
        ftp.set_pasv(True)
        ftp.storbinary(f"STOR {f.filename}", f.stream)
        ftp.quit()
        return jsonify(ok=True, message=f"Uploaded {f.filename}. Kestra will pick it up within ~10 seconds.")
    except error_perm as e:
        return jsonify(ok=False, message=f"FTP error: {e}"), 500
    except Exception as e:
        return jsonify(ok=False, message=f"Upload failed: {e}"), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8088)
