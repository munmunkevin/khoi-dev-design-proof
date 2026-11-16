# DEMO — how narration-chain.sh runs

## What the demo shows

1. **Synthesised test signal** — a 220 Hz sine wave, 12 seconds, −20 dB, with a light tremolo (generated with ffmpeg, see `tests/run-tests.sh`). This is a test signal, not real speech.
2. **Run the script** — `./narration-chain.sh test-tone.wav test-out.wav` (default target: I=−16 LUFS).
3. **Check the output** — `ffprobe` (48 kHz / stereo / PCM 16-bit) and `ffmpeg ebur128` (loudness + true peak).
4. **The `--deess` variant** — one extra run with the deesser on, checking it does not crash and still produces a valid WAV.

## Steps, by hand

```bash
cd script-bug

# 1. Create the test signal (12 seconds)
ffmpeg -hide_banner -y -f lavfi -i "sine=frequency=220:duration=12" \
  -af "volume=-20dB,tremolo=f=2:d=0.3" test-tone.wav

# 2. Run the script (the copy in this folder)
./narration-chain.sh test-tone.wav test-out.wav

# 3. Check the output format
ffprobe -hide_banner -select_streams a:0 \
  -show_entries stream=sample_rate,channels,codec_name \
  -of csv=p=0 test-out.wav
# Expected: 48000, 2, pcm_s16le

# 4. Measure loudness + true peak
ffmpeg -hide_banner -i test-out.wav -af ebur128=framelog=verbose:peak=true -f null -
# Expected: Integrated loudness I ≈ -16 LUFS, True Peak <= -1 dB
```

Or run all four steps with the automated test:

```bash
./tests/run-tests.sh
```

## Expected results

- The script exits with code 0 and prints `Done: ... (target I=-16 LUFS, TP=-1 dBTP, ...)`.
- The output WAV is 48 kHz, 2 channels, PCM 16-bit.
- ebur128 loudness is within ±1.5 LU of −16 LUFS; true peak ≤ −1 dB (0.2 dB measurement tolerance).
- The `--deess` variant finishes without error.

The real run (commands run, real figures, run date) is in `TEST_RESULTS.md`. If a test fails, it is recorded as a failure — no fake passes.
