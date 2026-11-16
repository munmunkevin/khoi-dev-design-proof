#!/usr/bin/env bash
# Automated test for narration-chain.sh (the copy in the script-bug folder).
# Generates 1 test audio file with ffmpeg, runs the script, and checks the output:
#   - output WAV file exists
#   - correct format: 48 kHz, stereo, PCM 16-bit (ffprobe)
#   - loudness measured with ebur128 against the target I=-16 LUFS (tolerance +-1.5 LU),
#     true peak <= -1 dB (0.2 dB measurement tolerance)
# No network, no secrets. Run from the script-bug folder or anywhere.
set -u
cd "$(dirname "$0")/.."
PASS=0; FAIL=0

ok()   { PASS=$((PASS+1)); echo "PASS: $1"; }
bad()  { FAIL=$((FAIL+1)); echo "FAIL: $1"; }

command -v ffmpeg >/dev/null 2>&1 || { echo "FAIL: ffmpeg not found"; exit 1; }
command -v ffprobe >/dev/null 2>&1 || { echo "FAIL: ffprobe not found"; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo "FAIL: python3 not found"; exit 1; }

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
IN="$TMP/test-tone.wav"
OUT="$TMP/test-out.wav"

# Test signal: 220 Hz sine, 12 seconds, -20 dB, light tremolo so the signal
# is not a perfectly flat wave (loudnorm then measures something meaningful).
ffmpeg -hide_banner -loglevel error -y -f lavfi -i "sine=frequency=220:duration=12" \
  -af "volume=-20dB,tremolo=f=2:d=0.3" "$IN"

[ -s "$IN" ] && ok "test file created: $IN" || { bad "could not create test file"; exit 1; }

# Run the script (the copy in this folder; the original is never touched).
./narration-chain.sh "$IN" "$OUT" > "$TMP/run.log" 2>&1
RC=$?
[ "$RC" -eq 0 ] && ok "script finished, exit 0" || { bad "script failed, exit $RC"; cat "$TMP/run.log"; }

[ -s "$OUT" ] && ok "output WAV file exists" || bad "no output WAV file"

# Check the format with ffprobe (parse key=value, because the column order of
# csv output does not follow the requested order — lesson from the first test run).
FFP=$(ffprobe -hide_banner -loglevel error \
  -select_streams a:0 -show_entries stream=sample_rate,channels,codec_name \
  -of default=noprint_wrappers=1 "$OUT" 2>/dev/null)
SR=$(echo "$FFP" | grep '^sample_rate=' | cut -d= -f2)
CH=$(echo "$FFP" | grep '^channels=' | cut -d= -f2)
CODEC=$(echo "$FFP" | grep '^codec_name=' | cut -d= -f2)
[ "$SR" = "48000" ] && ok "sample rate 48000 Hz (measured: $SR)" || bad "wrong sample rate: $SR"
[ "$CH" = "2" ] && ok "stereo, 2 channels (measured: $CH)" || bad "wrong channel count: $CH"
[ "$CODEC" = "pcm_s16le" ] && ok "PCM 16-bit (measured: $CODEC)" || bad "wrong codec: $CODEC"

# Measure loudness + true peak with ebur128. Note: this ffmpeg build only prints
# the "True peak" section when both framelog=verbose and peak=true are set;
# without peak=true the summary has no such section (lesson from the first test run).
read -r I TP < <(ffmpeg -hide_banner -i "$OUT" -af ebur128=framelog=verbose:peak=true -f null - 2>&1 | python3 -c "
import sys, re
t = sys.stdin.read()
m = re.search(r'Summary:.*?Integrated loudness:\s*\n\s*I:\s*(-?[\d.]+) LUFS', t, re.S)
p = re.search(r'True peak:\s*\n\s*Peak:\s*(-?[\d.]+) dB', t, re.S)
print((m.group(1) if m else 'NA'), (p.group(1) if p else 'NA'))
")
echo "Measured: I=$I LUFS, True Peak=$TP dBFS via ebur128 (target: I=-16 LUFS, TP<=-1 dB)"
python3 - "$I" "$TP" > "$TMP/loud-check.txt" <<'PYEOF'
import sys
try:
    i = float(sys.argv[1]); tp = float(sys.argv[2])
except ValueError:
    print("FAIL: could not read loudness figures"); sys.exit(0)
if abs(i - (-16.0)) <= 1.5:
    print(f"PASS: loudness {i} LUFS within +-1.5 LU of -16")
else:
    print(f"FAIL: loudness {i} LUFS more than 1.5 LU away from -16")
if tp <= -0.8:
    print(f"PASS: true peak {tp} dBFS <= -0.8 (limit -1 dB, 0.2 measurement tolerance)")
else:
    print(f"FAIL: true peak {tp} dBFS above the -1 dB limit")
PYEOF
cat "$TMP/loud-check.txt"
PASS=$((PASS + $(grep -c '^PASS' "$TMP/loud-check.txt")))
FAIL=$((FAIL + $(grep -c '^FAIL' "$TMP/loud-check.txt")))

# The --deess variant must also run without crashing.
OUT2="$TMP/test-out-deess.wav"
./narration-chain.sh "$IN" "$OUT2" --deess > "$TMP/run2.log" 2>&1
[ "$?" -eq 0 ] && [ -s "$OUT2" ] && ok "--deess variant runs" || bad "--deess variant failed"

echo "----------------------------------------"
echo "Result: $PASS PASS, $FAIL FAIL"
[ "$FAIL" -eq 0 ] && exit 0 || exit 1
