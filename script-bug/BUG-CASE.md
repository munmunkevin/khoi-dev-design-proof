# Sample bug case — Remotion re-downloads Chrome headless shell even though the cache folder already exists

> Source: history notes dated 2026-11-07 in `~/AGENTS.md` (section on the real Remotion Chrome headless shell cache, Channel 02 case) and `~/TOOLS.md`.
> Stated clearly: the "History (07/11/2026)" section is old notes, NOT something re-run today. The "Re-checked today (16/11/2026)" section is what was actually verified again on the day this case was written. Old notes are never presented as if they were run again today.

## Repro — symptoms

- **Symptoms:** when rendering with Remotion, the in-app download of Chrome headless shell failed with `server sent no data for 20 seconds`, and Remotion re-downloaded Chrome even though the cache folder seemed to be already there.
- **Commands / actions run (07/11):** ran the Remotion render inside the app (the Channel 02 project's render command at the time); in parallel, downloaded the same URL with `curl` to compare.
- **Result at the time:** curl downloaded the full file in ~2.5 seconds — the network was fine. Conclusion: the fault was not a blocked network, but how Remotion checks its cache.

## Root cause

- Remotion was assumed to cache at `remotion/.remotion/`, but the **real cache** is at `remotion/node_modules/.remotion/chrome-headless-shell/`, with the layout:
  `linux-x64/chrome-headless-shell-linux-x64/chrome-headless-shell`
- Inside that cache folder, Remotion **requires** a `VERSION` file containing the exact version string (for example `149.0.7790.0`) at `chrome-headless-shell/VERSION`.
- **Without the `VERSION` file, Remotion re-downloads**, even if the folder and the binary are already there. In other words: Remotion's "already downloaded" check is not "binary exists", it is "binary + correct `VERSION` file exist".

## Fix — before / after

| | Before (broken) | After (fixed) |
|---|---|---|
| Cache location checked | `remotion/.remotion/` (wrong) | `remotion/node_modules/.remotion/chrome-headless-shell/` (correct) |
| `VERSION` file | Missing | Present, containing the exact version string, e.g. `149.0.7790.0` |
| Remotion behavior | Re-downloads Chrome every time, sometimes failing after 20 seconds | Reuses the downloaded Chrome |

**Fix applied at the time (07/11):**

1. Placed the `VERSION` file with the correct version string into the real cache path by hand (way out #1).
2. After the owner (Miki) approved the `remotion.media` card, the in-app download worked and fetched the full 91.9 MB (way out #2).
3. The two ways out do not exclude each other: placing it by hand first + approving the card are both valid ways through.

**What was NOT done:** the network was not declared "blocked" based only on the in-app download error, because curl fetched the same URL in ~2.5 seconds.

## Verification

### Re-checked today (16/11/2026) — actually run

- Checked the old cache folder `~/workspace/tools/phat-phap-remotion/node_modules/.remotion/chrome-headless-shell/`: today it contains **only a `download.lock` file** — no binary, no `VERSION` file. This matches the fact that the project has since moved to the Chrome at `~/workspace/tools/chrome-headless-shell/` (see `~/workspace/tools/hyperframes-env.sh`, updated 2026-11-02).
- Checked the Chrome in use today: `~/workspace/tools/chrome-headless-shell/chrome-headless-shell-linux64/chrome-headless-shell --version` returns **Chromium 157.0.8080.0**. This Chrome was verified working (used to screenshot the landing page in this proof set).
- Stated plainly: the 07/11 Remotion download failure was **not re-run** today, and the missing-`VERSION` situation was **not recreated** today. The "Verification" of the original case (07/11) is: after placing the `VERSION` file by hand + approving the card, the in-app download worked and fetched the full 91.9 MB — that is the result recorded on 07/11, quoted as-is, not a figure measured today.

### Lessons (general use)

1. When a tool reports "not present / downloading again", check **the condition it uses to decide "present"** (here, the `VERSION` file), not only whether the main file exists.
2. When an in-app download fails, cross-check with an independent download path (curl) before concluding the network is at fault.
3. Write down the real cache path and the mandatory companion file — next time the same error appears, check the right place first instead of searching again.
