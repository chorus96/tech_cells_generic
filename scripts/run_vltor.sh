#!/bin/bash
# Copyright (c) 2014-2018 ETH Zurich, University of Bologna
#
# Copyright and related rights are licensed under the Solderpad Hardware
# License, Version 0.51 (the "License"); you may not use this file except in
# compliance with the License.  You may obtain a copy of the License at
# http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
# or agreed to in writing, software, hardware and materials distributed under
# this License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#
# Fabian Schuiki <fschuiki@iis.ee.ethz.ch>
# Andreas Kurth  <akurth@iis.ee.ethz.ch>

set -e
ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

[ -z "$VERILATOR" ] && VERILATOR=verilator

FLIST="${ROOT}/compile_vltor.flist"
if [ ! -f "$FLIST" ]; then
    echo "Error: $FLIST not found. Run compile_vltor.sh first." >&2
    exit 1
fi

call_vltor() {
    local PORTS=$1 LATENCY=$2 WORDS=$3 DWIDTH=$4 BYTEWIDTH=$5
    local BUILD_DIR="${ROOT}/work-vltor/P${PORTS}_L${LATENCY}_W${WORDS}_D${DWIDTH}_B${BYTEWIDTH}"
    mkdir -p "${BUILD_DIR}"

    $VERILATOR --sv --binary --timing --assert \
        --timescale 1ns/1ps \
        -Wno-WIDTHTRUNC -Wno-WIDTHEXPAND -Wno-UNSIGNED -Wno-INITIALDLY -Wno-ASCRANGE \
        -GNumPorts="${PORTS}" -GLatency="${LATENCY}" -GNumWords="${WORDS}" \
        -GDataWidth="${DWIDTH}" -GByteWidth="${BYTEWIDTH}" \
        --top-module tb_tc_sram \
        --Mdir "${BUILD_DIR}" \
        -f "${FLIST}" 2>&1 | tee "${BUILD_DIR}/compile.log"

    # $stop() in Verilator calls abort(); use || true and verify output instead
    "${BUILD_DIR}/Vtb_tc_sram" 2>&1 | tee "${BUILD_DIR}/sim.log" || true
    grep "errors: 0" "${BUILD_DIR}/sim.log"
}

for PORTS in 1 2; do
  for LATENCY in 0 1 2; do
    for WORDS in 1 420 1024; do
      for DWIDTH in 1 42 64; do
        for BYTEWIDTH in 1 8 9; do
          call_vltor $PORTS $LATENCY $WORDS $DWIDTH $BYTEWIDTH
        done
      done
    done
  done
done
