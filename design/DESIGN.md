# DESIGN.md — Clearline (fictional brand)

> Fictional demo — Clearline is a made-up brand created for this capability proof set. All personal names, team names, and example content in this file are fictional — not a real product or a real client.

## 1. Overview

- **What Clearline is:** a to-do app for small teams. One shared board for the whole team: what needs doing, who is doing it, and when it is due.
- **Brand personality:** calm, clear, gentle. Not loud, not pushy, not showing off features.
- **Positioning in one line:** "Your whole team's work, clear at a glance."
- **Who uses it:** teams of 3–10 people working hands-on together — a classroom, a small shop, a volunteer group, a family planning a big event.
- **Design principle:** less but solid — each screen does exactly one thing; large type, generous white space; color marks status, never decoration.
- **Scope of this file:** logo, color, type, layout, elevation, shapes, components, and what must never be done. This file is the single source of truth for the proof set; if the demo page and this file disagree, follow this file.

## 2. Colors

Clearline's palette (chosen by us, taken from no other brand). Tokens list HEX and RGB.

### Main colors

| Token | Role | HEX | RGB |
|---|---|---|---|
| `color-ink-navy` | Main ink: headings, primary buttons, logo | `#1F2A44` | 31, 42, 68 |
| `color-sage` | Sage green: done state, secondary links, soft accents | `#7A9B76` | 122, 155, 118 |
| `color-amber` | Amber: highlights, gentle warnings, the check in the logo | `#E8A33D` | 232, 163, 61 |
| `color-notebook` | Notebook paper: page background | `#FAF7F0` | 250, 247, 240 |
| `color-white` | White: card and header backgrounds | `#FFFFFF` | 255, 255, 255 |
| `color-gray` | Gray for secondary text: descriptions, captions, footer | `#5B6472` | 91, 100, 114 |

### Why these colors

- Notebook `#FAF7F0` is the color of the notebook paper of the Little Sprouts classroom team — the fictional team whose week the landing page follows. The page background is their paper, not a generic cream.
- Sage `#7A9B76` is the "done" color: it marks finished tasks and done states, and nothing else.
- Amber `#E8A33D` is the color of a highlighter pen: it marks the one word, the one check, the one badge that matters on a page. It is never a background.
- The token for this color is `--notebook`, named for the notebook paper it stands for. The HEX value `#FAF7F0` is unchanged.

### Shade scales (tint = mixed with white, shade = mixed with black, even mixes)

**Navy `#1F2A44`**

| Level | HEX | Use for |
|---|---|---|
| tint-10 | `#353F57` | Primary button on hover |
| tint-20 | `#4C5569` | Secondary text on a navy background |
| tint-40 | `#797F8F` | Rules on a dark background |
| tint-80 | `#D2D4DA` | Muted text on a navy background |
| shade-20 | `#192236` | A darker background, one step down |
| shade-40 | `#131929` | Dark footer background (if needed) |

**Sage `#7A9B76`**

| Level | HEX | Use for |
|---|---|---|
| tint-20 | `#95AF91` | Border of a "done" box |
| tint-40 | `#AFC3AD` | Pale background of a status card |
| tint-80 | `#E4EBE4` | Palest background for a "done" tag |
| shade-20 | `#627C5E` | "Done" text on a pale background |
| shade-40 | `#495D47` | Dark text on a pale sage background |

**Amber `#E8A33D`**

| Level | HEX | Use for |
|---|---|---|
| tint-20 | `#EDB564` | CTA button on hover |
| tint-40 | `#F1C88B` | Pale warning background |
| tint-80 | `#FAEDD8` | Palest background for an "urgent" tag |
| shade-20 | `#BA8231` | Warning border |
| shade-40 | `#8B6225` | "Urgent" text on a pale background |

### Color rules

- The page background is always notebook `#FAF7F0`; cards are always white `#FFFFFF`. Never use navy as a full-page background.
- Navy is only for headings, primary buttons, and important text. Do not use navy for long body copy (use gray `#5B6472`).
- Amber is only for small highlights: the check in the logo, badges, CTA buttons. Never use amber as a whole-section background.
- Sage is only for the "done" state and soft accents. Never use sage as the main text color.
- Text contrast: navy text on notebook/white; white text on navy; `#8B6225` text on `#FAEDD8` (4.69:1). Never put pale gray text on a pale notebook background.
- Note: `#627C5E` text on `#E4EBE4` measures 3.79:1 — below the WCAG AA 4.5:1 bar for normal text. Use that pair only for large text (18px bold or larger) or for non-text marks, never for normal body text.

## 3. Typography

- **One font only:** the system stack — `system-ui, -apple-system, "Segoe UI", Roboto, sans-serif`. No downloaded fonts, no decorative fonts.
- **Headings:** same stack, weight 700.
- **Body:** same stack, weight 400.

| Role | Size | Weight | Line height | Used for |
|---|---|---|---|---|
| H1 — page title | 38px mobile / 46px tablet / 51px desktop | 700 | 1.05 | Hero heading, one per page |
| H2 — section title | 26px | 700 | 1.25 | Each section heading |
| H3 — card title | 18px | 700 | 1.25 | Card and plan titles |
| Body | 17px | 400 | 1.6 | Paragraphs, descriptions |
| Secondary text | 14–15px | 400 | 1.6 | Captions, footer, small print |
| Buttons | 16px | 700 | 1.0 | Button labels |
| Eyebrow labels | 15.2px (0.95rem) | 700 | 1.4 | Sentence case, 0.04em tracking |

- **Rules:** one page has exactly one H1. Do not set a whole long sentence in all caps. Do not use text smaller than 13px for readable content. Figures (prices, task counts) use the body font at weight 700 — no separate font for numbers.

## 4. Layout

- **Container:** 16px padding on mobile; `max-width: 1200px`, centered, on desktop.
- **Grid:** 1 column on mobile; 2 columns from 768px; 3 columns from 1024px (pricing). The features grid at 1024px is 2 columns — a wide card on the left, two narrow cards stacked on the right — so no grid cell is left empty.
- **Section spacing:** 56px top and bottom (same on mobile and desktop). Exception: the hero section uses tighter padding — 32px top / 40px bottom on mobile, 48px / 56px at 768px, 72px / 80px at desktop — because it is the page opener, not a regular section.
- **Gap between grid cards:** 16px.
- **Padding inside cards:** 20–24px.
- **Header:** sticky at the top, white background, thin bottom border, minimum height 64px. Logo left, navigation centre, action button right. On mobile only the logo and the CTA button show.
- **Hero:** 1 column on mobile; 2 columns from 1024px (copy left, illustration card right), 48px gap between columns.
- **Rules:** never put text flush against the screen edge (always 16px padding); no horizontal overflow at 390px; buttons at least 44px tall so they can be tapped with a finger.

## 5. Elevation & Depth

Clearline is almost flat. Only two elevation levels, used sparingly.

| Level | Shadow | Used for |
|---|---|---|
| 0 — flat | No shadow | Page background, regular cards, sections |
| 1 — slightly raised | `0 4px 16px rgba(31, 42, 68, 0.08)` | Hero illustration card, the featured pricing card (navy background) |

- **Rules:** no heavy shadows, no colored shadows, no stacked shadows. A regular card needs no shadow — a thin `#E3DDD0` border is enough to separate it from the notebook background. No lift-on-hover effects.

## 6. Shapes

- **Corner radius:** cards and buttons `10–14px`; logo square `14px`; tags/chips `6px`; check circles `50%`.
- **Logo:** a rounded square, never a circle as the main logo. The check inside the logo is two straight strokes (short + long) with rounded ends.
- **Borders:** cards use a 1px `#E3DDD0` border. The featured pricing card has no visible border — it is a solid navy block instead (see §7). No dashed borders on content cards.
- **Dividers:** 1px, `#E3DDD0`, between FAQ items and under the header.
- **Rules:** no sharp corners on primary buttons; no triangles or diamonds as decoration; no double-shadow frames.
- **Allowed breaks (deliberate — not mistakes):** the landing page breaks the rules above in exactly three places, each for a stated reason. Checked against `landing/styles.css` on 2026-11-16; if the landing changes, update this list.
  - At desktop widths the features grid is two columns: the first feature card fills the left column and spans both rows, while the other two cards stack in the right column — deliberate asymmetry, so the features do not read as three identical boxes and no grid cell is left empty.
  - The hero task-board card has a 4px amber top border on top of its 1px border — the amber edge is the highlighter mark of the page, kept on this one card only.
  - At the 768px breakpoint the featured pricing card spans both grid columns — the highlighted plan is deliberately wider than its neighbours on tablet widths.

## 7. Components

### Buttons
- **Primary:** navy `#1F2A44` background, white text, 10px radius, 12px 22px padding. On hover: `#353F57`.
- **Ghost:** white background, 2px navy border, navy text. On hover: notebook background.
- **CTA on a dark background:** amber `#E8A33D` background, navy text. On hover: `#EDB564`.
- **Small button (header):** 8px 16px padding, 15px type.
- **Rules:** one primary button per section — each section has at most one primary button; a page may have several, one per section. A disabled button is faded, never recolored.

### Cards
- White background, 1px `#E3DDD0` border, 14px radius, 20–24px padding. Title 18px weight 700, body gray `#5B6472`.
- **Featured card** (highlighted plan): solid navy background, white heading and price, `#D2D4DA` secondary text, amber ticks in its list, amber button with navy text; level-1 shadow; a plain note naming the team that uses the plan, no badge.

### Tags / chips
- 13px type, weight 700, 6px radius, 2px 8px padding.
- Assignee tag: sage-dark `#627C5E` text, white background, 1.5px sage border — clearly an outlined pill.
- "Urgent" tag: navy text on a solid amber background, uppercase, 0.05em tracking — clearly different from assignee tags.

### Check circle (task)
- 20px circle, 2px sage border. When done: sage fill with a white tick inside, task text struck through in gray.

### Logo
- See section 2 (colors) and `logo-clearline.svg`. Variants: full color, single color (all navy or all white), on a dark background. See `brand-kit.html`.
- **Wordmark:** the "Clearline" wordmark in `logo-clearline.svg` is drawn paths, not live text. It was converted from DejaVu Sans Bold (29px) with fontTools on 2026-11-16, so the logo renders the same on any machine and never depends on the viewer's fonts. Do not retype it as live text.
- **Files:** source `logo-clearline.svg` (220 × 64). PNG export `logo-clearline.png` (1100 × 320, RGB): rendered from the SVG at 5× in headless Chromium (chrome-headless-shell 157) — a plain HTML wrapper page sized the image to exactly 1100 × 320 on a white background, and the page was screenshotted over the DevTools Protocol with a small Node script. No cropping was needed; the wrapper set the exact output size.

## 8. Do's and Don'ts

### Do
- Use exactly the 6 colors in the palette; when a lighter/darker step is needed, use the shade scales in section 2.
- Keep one H1 per page; large type, generous white space.
- Check at 390px (mobile) before calling it done: no horizontal overflow, buttons tappable.
- Mark every demo page as a fictional demo.

### Don't
- **Don't stretch the logo** — keep its original proportions, never squeeze it horizontally or vertically.
- **Don't recolor it outside the palette** — no other colors, no gradients on the logo.
- **Don't rotate the logo** — it is always upright, never tilted or flipped.
- **Don't add effects** — no shadows, no glow, no drop shadow on the logo.
- **Don't retype the wordmark in another font** — the "Clearline" wordmark is drawn paths in the logo file; never type it in the system font or any other font and call that the logo.
- **Don't use AI images** for any illustration.
- **Don't use another brand's colors** (IBM blue, Google red, shadcn black-and-white) and call them Clearline colors.
- **Don't put pale gray text on a pale notebook background** — text must stay readable.
- **Don't add new sections** beyond what the locked brief lists without approval.
