# Clearline — Capability Proof Set (DEV & DESIGN lane)

Proof of capability for the NEAR / Frantic **DEV & DESIGN** lane, submitted for Leader review. One coherent fictional brand — **Clearline**, a calm to-do app for small teams — shown across three deliverables. Clearline is made up; all people, teams, prices and stories in this repo are fictional demo content, not a real product or client.

Live demo: https://munmunkevin.github.io/khoi-dev-design-proof/

## 1. Landing page demo

- Live: https://munmunkevin.github.io/khoi-dev-design-proof/ (`index.html` + `styles.css` at the repo root)
- Screenshots: `screenshots/desktop-1440.png`, `screenshots/tablet-768.png`, `screenshots/mobile-390.png`
- Tool: plain static HTML + CSS, no framework, no external resources, no images. Mobile-first, breakpoints 768 / 1024. FAQ accordion in vanilla JS (readable with JS off). Checked in Chromium 157 via CDP at 1440 / 768 / 390: no horizontal overflow, 0 console errors.

## 2. Design sample — brand kit

- `design/DESIGN.md` — 8-section brand specification: palette with HEX + RGB and tint/shade scales, typography, layout, elevation, shapes, components, do's and don'ts.
- `design/brand-kit.html` — live brand-kit page: logo variants, clearspace, palette, typography, buttons and cards, don'ts.
- `design/logo-clearline.svg` / `logo-clearline.png` — self-drawn SVG logo (navy rounded square + amber two-stroke check + "Clearline" wordmark drawn as a path, not typed in a system font).
- Palette: ink navy `#1F2A44`, sage `#7A9B76`, amber `#E8A33D`, notebook paper `#FAF7F0`, white, gray `#5B6472`. Each color has a stated reason (notebook paper of a classroom, sage = done, amber = highlighter pen).

## 3. Automation script + bug-fix case

- `script-bug/narration-chain.sh` — a tested audio-processing chain (highpass → EQ → de-esser → compressor → limiter → loudnorm to −16 LUFS). Copy of a real script from the author's workspace; SHA-256 identical to the original.
- `script-bug/README.md`, `script-bug/DEMO.md`, `script-bug/TEST_RESULTS.md`, `script-bug/tests/run-tests.sh` — README runnable in 3 minutes, automated tests, real measured results (9 PASS, 0 FAIL; output −16.0 LUFS, true peak −13.1 dBFS).
- `script-bug/BUG-CASE.md` — a real bug-fix write-up (Remotion Chrome headless shell cache): reproduction with measurements → root cause → fix → verification, honestly separating what was re-verified from the historical notes.

## Quality

Independent QC (a separate checker, not the builder) passed all three items on 2026-11-16, both parts: technical (measured with tools: no overflow, links live, tests re-run 9/9, SHA-256 match) and aesthetic (judged by eye, including an "AI-vibe" check against real award-winning work). Earlier rounds failed on AI-vibe grounds and were rebuilt after a dedicated learning round studying real human-designed work — the history is in the commit log, not hidden.

## Structure

- `index.html`, `styles.css` — the landing demo (also the GitHub Pages site)
- `design/` — brand kit
- `script-bug/` — automation script + bug-fix case
- `screenshots/` — landing screenshots at 1440 / 768 / 390
