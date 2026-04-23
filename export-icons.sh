#!/bin/bash
# Poshmark Icon SVG Exporter
# Usage: FIGMA_TOKEN=figd_xxx ./export-icons.sh
#
# Get your personal access token:
# Figma → Settings → Security → Personal access tokens

set -e

FIGMA_TOKEN="${FIGMA_TOKEN:-}"
FILE_KEY="1kNsNrzvoLUzuBi18amuy3"
OUT_DIR="${OUT_DIR:-./svg}"

if [ -z "$FIGMA_TOKEN" ]; then
  echo "Error: FIGMA_TOKEN is required"
  echo "Usage: FIGMA_TOKEN=figd_xxxx ./export-icons.sh"
  exit 1
fi

mkdir -p "$OUT_DIR"
echo "Exporting icons to $OUT_DIR/ ..."

# Batch node IDs (20 at a time to stay within URL limits)
declare -A ICONS=(
  ["icon-down-10"]="474-1013"
  ["icon-up-10"]="735-18365"
  ["icon-dismiss-10"]="735-12446"
  ["icon-down-12"]="474-1049"
  ["icon-up-12"]="735-18369"
  ["icon-dismiss-12"]="735-12442"
  ["icon-information-16"]="192-33997"
  ["icon-up-16"]="192-34095"
  ["icon-down-16"]="192-34107"
  ["icon-right-16"]="752-12298"
  ["icon-sort-16"]="540-12881"
  ["icon-search-16"]="599-9345"
  ["icon-dismiss-16"]="616-9226"
  ["icon-truck-solid-16"]="838-25206"
  ["icon-fire-solid-16"]="838-25208"
  ["icon-clock-16"]="838-25217"
  ["icon-down-20"]="192-34061"
  ["icon-up-20"]="192-34111"
  ["icon-right-20"]="135-1764"
  ["icon-dismiss-20"]="270-544"
  ["icon-arrow-up-20"]="543-11040"
  ["icon-arrow-down-20"]="543-11045"
  ["icon-apple-24"]="358-577"
  ["icon-google-24"]="358-579"
  ["icon-facebook-24"]="358-585"
  ["icon-wallet-24"]="931-18882"
  ["icon-sheet-edit-24"]="931-18889"
  ["icon-scale-24"]="931-18895"
  ["icon-posh-shows-24"]="931-18897"
  ["icon-person-group-24"]="931-18902"
  ["icon-person-check-24"]="931-18904"
  ["icon-party-24"]="931-18906"
  ["icon-paper-24"]="931-18911"
  ["icon-money-24"]="931-18913"
  ["icon-message-percentage-24"]="931-18917"
  ["icon-rotate-right-24"]="932-19810"
  ["icon-megaphone-24"]="931-18921"
  ["icon-location-24"]="931-18924"
  ["icon-flag-24"]="931-18926"
  ["icon-eye-on-24"]="931-18928"
  ["icon-consignment-24"]="931-18930"
  ["icon-card-add-24"]="931-18932"
  ["icon-card-24"]="931-18934"
  ["icon-bundle-24"]="931-18936"
  ["icon-box-24"]="931-18938"
  ["icon-back-24"]="192-34050"
  ["icon-search-24"]="192-34055"
  ["icon-book-24"]="932-18154"
  ["icon-message-info-24"]="932-18156"
  ["icon-conversation-24"]="932-18158"
  ["icon-heart-24"]="932-18167"
  ["icon-widget-24"]="932-18169"
  ["icon-send-24"]="932-19791"
  ["icon-dismiss-word-24"]="192-34059"
  ["icon-liked-grid-24"]="311-5619"
  ["icon-bundle-add-grid-24"]="311-5623"
  ["icon-bundle-check-grid-24"]="311-5622"
  ["icon-bundle-bag-grid-24"]="311-5621"
  ["icon-dismiss-grid-24"]="311-5617"
  ["icon-share-grid-24"]="311-5620"
  ["icon-view-grid-24"]="331-5922"
  ["icon-inactive-grid-24"]="455-7433"
  ["icon-save-grid-24"]="311-5618"
  ["icon-save-grid-selected24"]="1113-40956"
  ["icon-back-nav-24"]="996-18251"
  ["icon-close-nav-24"]="1001-20224"
  ["icon-menu-nav-24"]="932-18148"
  ["icon-neart-nav-24"]="932-18174"
  ["icon-notification-nav-24"]="932-18175"
  ["icon-search-mweb-24"]="1009-25100"
  ["icon-close-28"]="192-34048"
  ["icon-check-30"]="192-34118"
)

# Collect all node IDs for batch request
NODE_IDS=$(IFS=,; echo "${ICONS[*]}" | tr ' ' ',')

# Build comma-separated list
IDS_PARAM=""
for name in "${!ICONS[@]}"; do
  [[ -n "$IDS_PARAM" ]] && IDS_PARAM+=","
  IDS_PARAM+="${ICONS[$name]}"
done

echo "Requesting SVG export URLs from Figma API..."
RESPONSE=$(curl -sf \
  -H "X-Figma-Token: $FIGMA_TOKEN" \
  "https://api.figma.com/v1/images/$FILE_KEY?ids=$IDS_PARAM&format=svg&scale=1")

if echo "$RESPONSE" | grep -q '"err"'; then
  echo "API Error: $(echo $RESPONSE | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("err","unknown"))')"
  exit 1
fi

# Download each SVG
DOWNLOADED=0
FAILED=0

for name in "${!ICONS[@]}"; do
  NODE_ID="${ICONS[$name]}"
  SVG_URL=$(echo "$RESPONSE" | python3 -c "
import sys,json
d=json.load(sys.stdin)
images = d.get('images',{})
node_id = '$NODE_ID'.replace('-',':')
url = images.get(node_id) or images.get('$NODE_ID')
print(url or '')
")

  if [ -z "$SVG_URL" ] || [ "$SVG_URL" = "None" ]; then
    echo "  SKIP: $name (no URL)"
    ((FAILED++))
    continue
  fi

  OUT_FILE="$OUT_DIR/$name.svg"
  if curl -sf "$SVG_URL" -o "$OUT_FILE"; then
    echo "  OK: $name.svg"
    ((DOWNLOADED++))
  else
    echo "  FAIL: $name"
    ((FAILED++))
  fi
done

echo ""
echo "Done: $DOWNLOADED downloaded, $FAILED failed"
echo "SVGs saved to: $OUT_DIR/"
