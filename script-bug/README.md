# Automation script — narration-chain.sh

> No fiction applies here: this script is a **real asset used in real work**, presented honestly. It is NOT a script written for a client, and it does not pretend to be one.

## What this script is

`narration-chain.sh` is a narration/podcast voice-processing chain built on ffmpeg, rewritten on 2026-11-02 from Khoi's notes, used for a series of Buddhist teaching clips (narrated voice "Thiền Tâm Đức"). Its original purpose: turn a raw voice recording into a release-ready WAV for the clips — correct processing order, correct loudness.

Processing order (no reverb anywhere in the chain):

1. `highpass=f=80` — cuts low rumble below 80 Hz
2. EQ −1.5 dB @300 Hz / +1.5 dB @3.5 kHz (equalizer `width_type=o width=1`)
3. Deesser `i=0.25:m=0.5:f=0.5` — ONLY with `--deess` (harsh "s/x" sounds; off by default)
4. `acompressor=threshold=0.126:ratio=2.5:attack=20:release=250` (0.126 ≈ −18 dB)
5. `alimiter=limit=0.891:level=false` (0.891 ≈ −1 dB)
6. Two-pass `loudnorm`: I=−16 LUFS (or −14 with `--streaming`), TP=−1 dBTP, LRA=11

Output: WAV, 48 kHz, stereo, PCM 16-bit.

## Origin

- Original file: `~/workspace/tools/voice-chain/narration-chain.sh` (rewritten 2026-11-02, after the first version was lost when the VM was replaced).
- The file in this folder is a **byte-for-byte copy** of the original — nothing changed. Proof: the `sha256sum` of both files matches (see `TEST_RESULTS.md`).
- Original notes on the chain and how it was tested: the voice-chain notes in `~/TOOLS.md` (2026-10-31) and `~/AGENTS.md`.
- **Language note:** the copied script keeps its original Vietnamese comments verbatim, because the locked brief requires the copy to stay identical to the original (same SHA-256). Everything written for this proof set around it — this README, the tests, `DEMO.md`, `TEST_RESULTS.md`, `BUG-CASE.md` — is in English.

## How to run it in 3 minutes

### System requirements

- `bash`, `ffmpeg` (plus `ffprobe` to check the output), `python3`.
- No root access, no network, no secrets or credentials.

### Quick run

```bash
cd script-bug
./tests/run-tests.sh
```

The test generates a test audio file with ffmpeg, runs the script, and checks the output. See `DEMO.md` for the steps and `TEST_RESULTS.md` for the real measured results.

### Run by hand (one file)

```bash
./narration-chain.sh <input> <output.wav> [--streaming] [--deess]
```

Examples:

```bash
./narration-chain.sh raw-voice.wav processed-voice.wav
./narration-chain.sh raw-voice.wav streaming-voice.wav --streaming
./narration-chain.sh raw-voice.wav deessed-voice.wav --deess
```

## Gotchas already handled in the script (written down so the next reader does not trip on them)

- ffmpeg on this machine does NOT print the `linear` field in loudnorm's JSON. The script infers `linear` from `normalization_type` (dynamic → false, otherwise → true) instead of grepping the `linear` field directly — grepping it directly would silently kill the script when `set -o pipefail` is on.
- The temp directory is cleaned up with a `trap`, so no junk is left behind even if the script fails halfway.

## Limits (stated plainly)

- The script processes **one file at a time**; for a batch, wrap it in your own loop.
- No dry-run / preview mode; you hear the result only after it has run.
- The bundled test uses a synthesised sine signal, not real speech — it proves the chain runs correctly and measures correctly, not voice quality.
- The loudness figures in `TEST_RESULTS.md` were measured on this machine on the date stated in that file; another machine with a different ffmpeg version may differ slightly.
