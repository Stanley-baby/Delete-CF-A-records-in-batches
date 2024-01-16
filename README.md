# 删除 Cloudflare A 记录脚本

这个 Bash 脚本用于删除指定 Cloudflare 域名的所有 A 记录。

## 使用方法

1. 下载或克隆这个仓库到你的本地环境。

2. 打开 `delete_dns_record.sh` 文件，替换以下变量为你的 Cloudflare API 信息和需要删除 A 记录的域名：

    ```shellscript
    EMAIL="填写 CF 账户邮箱"
    API_KEY="填写 CF 全局 key"
    ZONE_NAME="填写需要删除 A 记录的域名"
    ```

3. 保存文件并关闭。

4. 在终端中，导航到脚本所在的目录，然后运行以下命令来执行脚本：

    ```shellscript
    bash delete_dns_record.sh
    ```

## 脚本说明

这个脚本首先通过 Cloudflare API 获取指定域名的所有 DNS 记录，然后筛选出所有的 A 记录。对于每个 A 记录，脚本会发送一个 DELETE 请求到 Cloudflare API 来删除该记录，然后打印出被删除的子域名、IP 地址和删除状态。

## 注意事项

* 这个脚本需要 `curl` 和 `jq` 这两个命令。在运行脚本之前，请确保这两个命令在你的环境中可用。

* 这个脚本是用 Bash shell 编写的，它在 Unix-like 系统（如 Linux 和 macOS）上运行。在 Windows 系统上，你需要一个兼容的 shell 环境来运行它，如 Windows Subsystem for Linux、Git Bash 或 Cygwin。

* 这个脚本会删除所有的 A 记录。在运行脚本之前，请确保你已经备份了所有重要的 A 记录。

## 贡献

如果你有任何问题或建议，欢迎提交 issue 或 pull request。