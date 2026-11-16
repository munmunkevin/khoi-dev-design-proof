# TEST_RESULTS — narration-chain.sh (the copy in this folder)

Last run: **2026-11-16 15:49 Vietnam time** (08:49 UTC).
Environment: ffmpeg 8.1.2, Python 3.12.3, bash, on this machine. No network, no secrets.

## Command run

```bash
cd ~/workspace/khoi-dev-design-proof/script-bug
./tests/run-tests.sh
```

## Final run result (verbatim, exit 0)

```text
PASS: test file created: /tmp/tmp.n6dkbTWFjS/test-tone.wav
PASS: script finished, exit 0
PASS: output WAV file exists
PASS: sample rate 48000 Hz (measured: 48000)
PASS: stereo, 2 channels (measured: 2)
PASS: PCM 16-bit (measured: pcm_s16le)
Measured: I=-16.0 LUFS, True Peak=-13.1 dBFS via ebur128 (target: I=-16 LUFS, TP<=-1 dB)
PASS: loudness -16.0 LUFS within +-1.5 LU of -16
PASS: true peak -13.1 dBFS <= -0.8 (limit -1 dB, 0.2 measurement tolerance)
PASS: --deess variant runs
----------------------------------------
Result: 9 PASS, 0 FAIL
```

## Real measured figures

| Item | Target | Measured | How measured |
|---|---|---|---|
| Output format | 48 kHz, stereo, PCM 16-bit | 48000 Hz, 2 channels, `pcm_s16le` | ffprobe |
| Integrated loudness | I = −16 LUFS (±1.5 LU) | **−16.0 LUFS** | ffmpeg `ebur128` |
| True peak | ≤ −1 dB | **−13.1 dBFS** (ebur128 reports true peak in dBFS) | ffmpeg `ebur128` (`framelog=verbose:peak=true`) |
| `--deess` variant | Runs, produces a valid file | Finished, exit 0, file exists | run directly |

Extra observation (earlier manual verification run, same test signal): the script printed `measured_I=-44.32, linear=false` in its loudnorm pass — the test signal came in very quiet (−44.32 LUFS) and was normalised up to the −16 LUFS target exactly.

## Original file untouched — check

The copy in this folder and the original file have the same SHA-256:

```text
1ce256cab9972adfd512b8dd914072b48cfa94847bb33d84788cf63969e7902b  ~/workspace/tools/voice-chain/narration-chain.sh (original)
1ce256cab9972adfd512b8dd914072b48cfa94847bb33d84788cf63969e7902b  narration-chain.sh (copy)
```

`diff` between the two files returns no differences.

## Run history — recorded honestly, including the failed run

- **First run (same day): 4 PASS, 4 FAIL.** All 4 failures were bugs in **the test harness I wrote**, not in the script:
  1. ffprobe `-of csv` returns columns in the order `codec, sample_rate, channels`, not the order requested — the test read the wrong columns and reported wrong sample rate / channel count / codec.
  2. The ebur128 measurement was missing `peak=true`, so the summary had no "True peak" section — the test could not read the figure.
  3. A unit label in the test said "dBTP" while ebur128 reports true peak in dBFS — the label was fixed.
- After fixing the test harness (parse ffprobe as `key=value`, measure ebur128 with `framelog=verbose:peak=true`, fix the unit label) and re-running: **9 PASS, 0 FAIL** (result above). The script was not changed to "make the test pass".

## Limits

- The test signal is a synthesised 220 Hz sine wave (12 seconds), not real speech — the test proves the chain runs correctly and measures correctly, not voice quality.
- Figures were measured on this machine, ffmpeg 8.1.2; another machine may differ slightly.
- The script processes one file at a time; no batch mode, no preview mode.
