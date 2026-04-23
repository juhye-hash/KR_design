# Poshmark Icon Library

Icons from the Posh 2.0 Web Components design system.

**Figma source:** [Posh2.0_Web-Components → Components / Icons](https://www.figma.com/design/1kNsNrzvoLUzuBi18amuy3/Posh2.0_Web-Components?node-id=78-1064)

---

## Icon list (72 icons)

| Size | Icons |
|------|-------|
| 10px | icon-down, icon-up, icon-dismiss |
| 12px | icon-down, icon-up, icon-dismiss |
| 16px | icon-information, icon-up, icon-down, icon-right, icon-sort, icon-search, icon-dismiss, icon-truck-solid, icon-fire-solid, icon-clock |
| 20px | icon-down, icon-up, icon-right, icon-dismiss, icon-arrow-up, icon-arrow-down |
| 24px | icon-apple, icon-google, icon-facebook, icon-wallet, icon-sheet-edit, icon-scale, icon-posh-shows, icon-person-group, icon-person-check, icon-party, icon-paper, icon-money, icon-message-percentage, icon-rotate-right, icon-megaphone, icon-location, icon-flag, icon-eye-on, icon-consignment, icon-card-add, icon-card, icon-bundle, icon-box, icon-back, icon-search, icon-book, icon-message-info, icon-conversation, icon-heart, icon-widget, icon-send, icon-dismiss-word |
| 24px (grid) | icon-liked-grid, icon-bundle-add-grid, icon-bundle-check-grid, icon-bundle-bag-grid, icon-dismiss-grid, icon-share-grid, icon-view-grid, icon-inactive-grid, icon-save-grid, icon-save-grid-selected |
| 24px (nav) | icon-back-nav, icon-close-nav, icon-menu-nav, icon-neart-nav, icon-notification-nav, icon-search-mweb |
| 28px | icon-close |
| 30px | icon-check |

---

## Export SVG files

### 1. Get a Figma Personal Access Token

Figma → Settings → Security → **Personal access tokens** → Generate new token

### 2. Run the export script

```bash
FIGMA_TOKEN=figd_xxxx ./export-icons.sh
```

SVG files will be saved to `./svg/`.

### 3. Custom output directory

```bash
FIGMA_TOKEN=figd_xxxx OUT_DIR=./icons/svg ./export-icons.sh
```

---

## Naming convention

```
icon-{name}-{size}
```

Examples:
- `icon-down-16.svg`
- `icon-search-24.svg`
- `icon-bundle-add-grid-24.svg`
