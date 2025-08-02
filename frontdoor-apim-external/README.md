# Azure Front Door + APIM External + Azure Function (Private Endpoint)

このTerraformテンプレートは、以下の構成を作成します：

```
Internet → Azure Front Door → API Management (External) → Azure Function (Private Endpoint)
```

## 🏗️ アーキテクチャ

- **Azure Front Door**: グローバルロードバランサー、CDN、WAF機能
- **API Management**: 外部VNet配置、Public IP経由でアクセス可能、APIゲートウェイ機能
- **Azure Functions**: Private Endpoint経由でのみアクセス可能
- **Virtual Network**: すべてのリソースが分離されたネットワーク環境

## 📁 ファイル構成

```
terraform-frontdoor-apim-function/
├── main.tf                    # メイン設定（Terraform/Provider）
├── variables.tf               # 変数定義
├── networking.tf              # VNet、サブネット、NSG
├── function.tf                # Function App、Private Endpoint
├── apim.tf                   # API Management設定
├── frontdoor.tf              # Azure Front Door設定
├── outputs.tf                # 出力値
├── terraform.tfvars.example  # 設定例
└── README.md                 # このファイル
```

## 🚀 デプロイ手順

### 1. 前提条件

- Azure CLI がインストール済み
- Terraform >= 1.0 がインストール済み
- Azureサブスクリプションへのアクセス権限

### 2. 認証

```bash
# Azure CLIでログイン
az login

# サブスクリプション設定（必要に応じて）
az account set --subscription "your-subscription-id"
```

### 3. 設定ファイル作成

```bash
# 設定ファイルをコピー
cp terraform.tfvars.example terraform.tfvars

# 設定値を編集
vim terraform.tfvars
```

### 4. Terraformデプロイ

```bash
# 初期化
terraform init

# プランの確認
terraform plan

# デプロイ実行
terraform apply
```

## ⚙️ 主要設定

### ネットワーク構成

- **VNet**: `10.0.0.0/16`
- **APIM サブネット**: `10.0.1.0/24`
- **Function サブネット**: `10.0.2.0/24` (委任設定あり)
- **Private Endpoint サブネット**: `10.0.3.0/24`

### セキュリティ設定

- Function App: Private Endpoint経由のみアクセス
- APIM: 内部VNet配置、NSGで保護
- Front Door: WAF (Web Application Firewall) 有効
- Storage Account: VNet統合、プライベートアクセスのみ

### SKU構成

- **APIM**: Developer_1 (本番環境では Standard_1 または Premium_1 推奨)
- **Function App**: P1V3 (Premium V3 plan - より高いパフォーマンスとスケーラビリティ)
- **Front Door**: Standard_AzureFrontDoor

#### Function App Premium V3 の特徴
- **高性能**: より高いCPU・メモリ性能
- **スケーラビリティ**: 最大100インスタンスまでスケール
- **VNet統合**: プライベートネットワーク接続
- **SLA**: 99.95% の可用性保証

## 🧪 テスト方法

デプロイ完了後、以下のURLでテスト可能：

```bash
# Front Door経由（推奨）
curl "https://[front-door-endpoint]/func/httpget?name=Test"

# APIM直接（VNet内からのみ）
curl "[apim-gateway-url]/func/httpget?name=Test"
```

## 📋 重要な注意事項

### Function Key管理

```bash
# Function Keyを取得してAPIMに設定
FUNCTION_KEY=$(az functionapp keys list --name [function-app-name] --resource-group [rg-name] --query "functionKeys.default" -o tsv)

# APIMのNamed Valueを更新
az apim nv update --service-name [apim-name] --resource-group [rg-name] --named-value-id function-key --value $FUNCTION_KEY
```

### 3. DNS解決

- Private DNS Zoneが自動作成されます
- VNet内のリソースは自動的にプライベートエンドポイントを解決

### Premium V3 SKU オプション

```hcl
# 開発環境
function_app_sku = "P0V3"  # 1 vCPU, 4GB RAM

# 小規模本番環境
function_app_sku = "P1V3"  # 2 vCPU, 8GB RAM

# 中規模本番環境
function_app_sku = "P2V3"  # 4 vCPU, 16GB RAM

# 大規模本番環境
function_app_sku = "P3V3"  # 8 vCPU, 32GB RAM
```

### 追加セキュリティ設定

```hcl
# カスタムドメイン、SSL証明書設定
# IP制限、認証設定
# より詳細なWAFルール
```

## 💰 コスト最適化

- 開発環境では `apim_sku_name = "Developer_1"` を使用
- 本番環境では適切なSKUを選択
- 不要時はリソースを停止/削除

## 🐛 トラブルシューティング

### よくある問題

1. **APIM作成エラー**: サブネット設定やNSGルールを確認
2. **Function接続エラー**: Private Endpoint、DNS設定を確認
3. **Front Door接続エラー**: Origin設定、WAFルールを確認

### ログ確認

```bash
# Function Appログ
az functionapp logs tail --name [function-app-name] --resource-group [rg-name]

# APIMログ
az monitor activity-log list --resource-group [rg-name]
```

## 🧹 クリーンアップ

```bash
# すべてのリソースを削除
terraform destroy
```

## 📚 参考資料

- [Azure Front Door Documentation](https://docs.microsoft.com/azure/frontdoor/)
- [API Management Documentation](https://docs.microsoft.com/azure/api-management/)
- [Azure Functions Documentation](https://docs.microsoft.com/azure/azure-functions/)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest)
