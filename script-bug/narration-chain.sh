#!/usr/bin/env bash
# Chuỗi xử lý giọng narration/podcast — viết lại 2026-11-02 từ ghi chú TOOLS.md
# (bản gốc ~/workspace/tools/voice-chain/narration-chain.sh đã mất khi VM thay thế).
#
# Thứ tự chuẩn, KHÔNG reverb trong chuỗi:
#   highpass 80 Hz
#   -> EQ -1.5 dB @300 Hz / +1.5 dB @3.5 kHz (equalizer width_type=o width=1)
#   -> deesser (CHỈ khi bật --deess, vì tiếng 's, x' chói; mặc định tắt)
#   -> acompressor threshold 0.126 (~-18 dB), ratio 2.5, attack 20, release 250
#   -> alimiter limit 0.891 (~-1 dB)
#   -> loudnorm 2 lượt, I=-16 (hoặc -14 với --streaming), TP=-1, LRA=11
#
# Gotcha (ghi chú gốc): ffmpeg trên máy này KHÔNG in trường `linear` trong
# JSON của loudnorm — script suy linear từ `normalization_type`
# (dynamic -> false, còn lại -> true), đừng grep `linear` trực tiếp.
#
# Cách dùng:
#   narration-chain.sh <input> <output.wav> [--streaming] [--deess]
# Output: WAV 48 kHz STEREO PCM 16-bit (chuẩn stem narration của pilot).
set -eu

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <input> <output.wav> [--streaming] [--deess]" >&2
  exit 1
fi

IN="$1"
OUT="$2"
shift 2

TARGET_I="-16"
DEESS=0
for arg in "$@"; do
  case "$arg" in
    --streaming) TARGET_I="-14" ;;
    --deess) DEESS=1 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

CHAIN="highpass=f=80,equalizer=f=300:width_type=o:width=1:g=-1.5,equalizer=f=3500:width_type=o:width=1:g=1.5"
if [ "$DEESS" -eq 1 ]; then
  CHAIN="$CHAIN,deesser=i=0.25:m=0.5:f=0.5"
fi
CHAIN="$CHAIN,acompressor=threshold=0.126:ratio=2.5:attack=20:release=250,alimiter=limit=0.891:level=false"

TMPDIR_WORK="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_WORK"' EXIT
MEASURE_LOG="$TMPDIR_WORK/measure.log"

# Lượt 1: đo loudness của tín hiệu đã qua chuỗi (chưa chuẩn hoá).
ffmpeg -hide_banner -y -i "$IN" -af "$CHAIN,loudnorm=I=$TARGET_I:TP=-1:LRA=11:print_format=json" \
  -f null - 2> "$MEASURE_LOG" || true

# Trích các giá trị đo được từ JSON của loudnorm bằng python3.
# (Không grep trường `linear`: ffmpeg ở đây không in nó.)
read -r MEASURED_I MEASURED_TP MEASURED_LRA MEASURED_THRESH OFFSET LINEAR < <(
  MEASURE_LOG="$MEASURE_LOG" python3 - <<'PYEOF'
import json, os, re, sys
log = open(os.environ["MEASURE_LOG"], errors="ignore").read()
m = re.search(r"\{[^{}]*\"input_i\".*?\}", log, re.S)
if not m:
    sys.exit("loudnorm: khong tim thay JSON do trong log ffmpeg")
d = json.loads(m.group(0))
linear = d.get("linear")
if linear is None:
    linear = "false" if d.get("normalization_type") == "dynamic" else "true"
elif isinstance(linear, bool):
    linear = "true" if linear else "false"
print(d["input_i"], d["input_tp"], d["input_lra"], d["input_thresh"],
      d["target_offset"], linear)
PYEOF
)

# Lượt 2: chuẩn hoá với các giá trị đã đo, xuất WAV 48 kHz stereo PCM 16-bit.
ffmpeg -hide_banner -y -i "$IN" \
  -af "$CHAIN,loudnorm=I=$TARGET_I:TP=-1:LRA=11:measured_I=$MEASURED_I:measured_TP=$MEASURED_TP:measured_LRA=$MEASURED_LRA:measured_thresh=$MEASURED_THRESH:offset=$OFFSET:linear=$LINEAR:print_format=json" \
  -ar 48000 -ac 2 -c:a pcm_s16le "$OUT"

echo "Done: $OUT (target I=$TARGET_I LUFS, TP=-1 dBTP, measured_I=$MEASURED_I, linear=$LINEAR)"
