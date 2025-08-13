#!/bin/bash
set -euo pipefail

# 写死的路径
PYTHON="/home/liuyunhui/miniconda3/envs/aspera-cli-env/bin/python3"
SCRIPT="/mnt/f/OneDrive/科研/4_代码/9-My-Toolskit/1-下载数据/script/1-NCBI/python/0-csv→SRR.py"
# 输入输出文件路径
INPUT="/mnt/d/aDNA_下载/NCBI_9_10/10/10_SRA010102_runinfo.csv"
OUTPUT="/mnt/d/aDNA_下载/NCBI_9_10/10/10_SRA010102.txt"

# 运行 Python 脚本
"$PYTHON" "$SCRIPT" "$INPUT" "$OUTPUT"

echo "输出文件：$OUTPUT"
