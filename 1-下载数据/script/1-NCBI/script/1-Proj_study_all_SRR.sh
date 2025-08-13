#!/bin/bash
set -euo pipefail

# ========== 配置部分 ==========
# 存放要查询的 ID 列表，每行一个 ID，各种类型都可以，如DRA004001，SRA010102，PRJNA123456，SRP098765
ID_FILE="/mnt/f/OneDrive/科研/4_代码/9-My-Toolskit/1-下载数据/script/1-NCBI/conf/project_ids.txt"

# 输出目录
OUTPUT_DIR="/mnt/f/OneDrive/科研/4_代码/9-My-Toolskit/1-下载数据/script/1-NCBI/conf/SRR_ID"
mkdir -p "$OUTPUT_DIR"

# 确保安装了 EDirect 工具 (esearch, elink, efetch)
command -v esearch >/dev/null 2>&1 || { echo "错误: 未安装 EDirect 工具"; exit 1; }

# 检查 ID 文件是否存在
if [[ ! -f "$ID_FILE" ]]; then
    echo "错误: ID 文件不存在: $ID_FILE"
    exit 1
fi

# ========== 主循环 ==========
while IFS= read -r ID; do
    # 跳过空行和注释
    [[ -z "$ID" || "$ID" =~ ^# ]] && continue

    OUT_CSV="${OUTPUT_DIR}/${ID}_runinfo.csv"

    echo "正在处理: $ID"

    # 判断 ID 类型
    if [[ "$ID" =~ ^(PRJ|DRA|ERP|SRP) ]]; then
        esearch -db sra -query "$ID" \
            | efetch -format runinfo > "$OUT_CSV"
    elif [[ "$ID" =~ ^(SRA) ]]; then
        esearch -db sra -query "$ID" \
            | efetch -format runinfo > "$OUT_CSV"
    else
        echo "警告: $ID 格式无法识别，跳过"
        continue
    fi

    # 提取 Run ID
    echo "Run IDs for $ID:"
    awk -F',' 'NR>1 {print $1}' "$OUT_CSV" | grep -E 'SRR|ERR|DRR' || echo "无 Run ID"
    echo "结果已保存到: $OUT_CSV"
done < "$ID_FILE"
