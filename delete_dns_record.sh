#!/bin/bash

set -e
set -o pipefail

# 替换为您的 Cloudflare API 信息
EMAIL="填写 CF 账户邮箱"
API_KEY="填写 CF 全局 key"

# 替换为您要删除 A 记录的主域名
ZONE_NAME=" 填写需要删除 A 记录的域名"

# 定义一个函数来发送请求到 Cloudflare API
call_cloudflare_api() {
    local endpoint=$1
    local method=$2
    local data=$3

    response=$(curl -s -X $method "https://api.cloudflare.com/client/v4/$endpoint" \
        -H "X-Auth-Email: $EMAIL" \
        -H "X-Auth-Key: $API_KEY" \
        -H "Content-Type: application/json" \
        -d "$data")

    success=$(echo "$response" | jq -r '.success')
    if [ "$success" != "true" ]; then
        echo "API 请求失败: $response"
        exit 1
    fi

    echo "$response"
}

# 获取主域名的 ID
ZONE_ID=$(call_cloudflare_api "zones?name=$ZONE_NAME" GET | jq -r '.result[0].id')

# 获取所有的 DNS 记录
DNS_RECORDS=$(call_cloudflare_api "zones/$ZONE_ID/dns_records" GET)

# 获取 A 记录的数量
A_RECORD_COUNT=$(echo "$DNS_RECORDS" | jq '.result | map(select(.type == "A")) | length')
echo "A 记录总数: $A_RECORD_COUNT"

# 删除所有 A 记录
echo "$DNS_RECORDS" | jq -r '.result[] | select(.type == "A") | "\(.id) \(.content) \(.name)"' | while read id ip_address subdomain; do
    response=$(call_cloudflare_api "zones/$ZONE_ID/dns_records/$id" DELETE)
    success=$(echo "$response" | jq -r '.success')
    if [ "$success" = "true" ]; then
        status="删除成功"
    else
        status="删除失败"
    fi
    echo "子域名: $subdomain, IP 地址: $ip_address, 状态: $status"
done

echo "删除完毕"