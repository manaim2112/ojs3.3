# Klausula theme

A classic, formal **law-journal** theme for OJS 3.3. It is a child theme of the
bundled `defaultthemeplugin`, so it keeps every template and behaviour of the
default theme and only adds a serif/engraved visual identity on top.

- Serif typography: Playfair Display (headings) + EB Garamond (body) +
  Roboto Condensed (metadata), loaded from Google Fonts.
- Red palette on a clean white page, near-square corners, double rules and a
  subtle page texture.
- Two switchable colour schemes (see below).
- Optional per-author country flags and per-article view/download counts.

## Requirements

- OJS 3.3
- The bundled `defaultthemeplugin` must be present (it ships with OJS).
- Outbound access to Google Fonts and to the `flag-icons` CDN for the fonts and
  the flags. Both can be removed from `KlausulaThemePlugin::init()` if the
  journal must run fully offline.

## Enabling the theme

1. Copy the `klausula` folder into `plugins/themes/`.
2. In the journal, open **Settings → Website → Plugins → Installed plugins** and
   enable **Klausula theme**.
3. Open **Settings → Website → Appearance → Theme** and select **Klausula**.
4. Fill in the theme options and save.

## Theme options

| Option | Type | Default | What it does |
| --- | --- | --- | --- |
| Colour scheme | radio | Classic | Selects the palette (see *Colour schemes*). |
| Article statistics | radio | Yes | Shows abstract-view and file-download totals on article lists and on the article page. |
| Author country flags | radio | Yes | Shows the author's country flag next to the name (needs the country to be set on the author record). |
| Site emblem | radio | Seal | Adds a red "scales of justice" seal beside the site title. |
| Cover frame | radio | Ruled | Framing applied to issue and article cover images. |
| Publisher name / URL / phone | text | — | Shown in the footer. |
| Header background image | text (URL) | — | Image blended under the red header wash. |
| Footer background image | text (URL) | — | Image blended under the red footer wash. |

The background-image fields accept an absolute URL (`https://…`), a
protocol-relative URL (`//…`) or a site-relative path (`/public/…`). Anything
else (including `javascript:` payloads) is rejected. The image is layered
*under* the red gradient, so it always reads as part of the colour band rather
than as a photo.

## Colour schemes

The palette is emitted as CSS custom properties, and the scheme is applied as a
`body` class. Switching schemes is therefore instant — it repaints the page
without recompiling the stylesheet.

| Token | Classic (default) | Strong |
| --- | --- | --- |
| `--klausula-maroon-dark` (bands) | `#6E0B10` | `#8B0000` |
| `--klausula-maroon` (primary) | `#A4161A` | `#9E0000` |
| `--klausula-maroon-lift` (hover) | `#C1121F` | `#B30000` |
| `--klausula-accent` (rules, ticks) | `#D62828` | `#D40000` |
| `--klausula-accent-ink` (accent text) | `#A4161A` | `#B30000` |
| `--klausula-ivory` (page) | `#FFFFFF` | `#FFFFFF` |
| `--klausula-parchment` (blocks) | `#F8F8F8` | `#F7F7F7` |
| `--klausula-ink` (text) | `#1A1A1A` | `#333333` |

Both schemes are red on a clean white page — there is no brown and no gold. The
`accent` tokens carry a brighter red for rules, ticks and hover states, which
keeps the decorative layer distinct from the darker primary red. **Classic** is
the deeper, more formal red; **Strong** is the more saturated one.

Both schemes are declared once, in `styles/base.less`, from a single
`.klausula-palette()` mixin, so they can never drift apart. To add a third
scheme, add a `@scheme-<name>-*` block in `styles/variables.less`, call the
mixin for it in `base.less`, and add an `<option>` to the `colourScheme` option
in `KlausulaThemePlugin.inc.php`.

> **Editing the stylesheet?** OJS compiles a theme's LESS only when its cached
> file is missing. After changing anything under `styles/`, delete
> `cache/<contextId>-klausulaStyles-*.css` (e.g.
> `cache/14-klausulaStyles-1831254863.css`) or the browser will keep the old CSS.

## Helper class: sidebar link list

Custom sidebar blocks are usually a hand-written list of links. The
`klausula_link_list` class turns that plain markup into a themed contents list:
one row per link, a red chevron in the margin, a hairline rule between rows and a
light wash on hover. It is defined in `styles/components.less`.

### Markup

Wrap the links in a single element carrying the class:

```html
<div class="klausula_link_list">
	<a href="/index.php/ajis/issue/archive">Arsip terbitan</a>
	<a href="/index.php/ajis/about/editorialTeam">Dewan redaksi</a>
	<a href="/index.php/ajis/about/submissions">Panduan penulis</a>
</div>
```

Use it inside a **Custom Block** (Settings → Website → Plugins → Custom block
manager, *Content → HTML*) or anywhere in a sidebar block. The links may be
direct children of the wrapper, or wrapped one level deep in their own `div` —
both work:

```html
<div class="klausula_link_list">
	<div><a href="…">Satu</a></div>
	<div><a href="…">Dua</a></div>
</div>
```

### Optional count / badge

Append a `<span class="count">` to show a trailing figure (number of articles,
issues, and so on):

```html
<div class="klausula_link_list">
	<a href="/index.php/ajis/issue/archive">
		Terbitan
		<span class="count">24</span>
	</a>
	<a href="/index.php/ajis/issue/current">
		Terbitan terkini
		<span class="count">8</span>
	</a>
</div>
```

### Notes

- Link colours are inherited, so the helper matches the surrounding sidebar
  links inside a `.pkp_block` and the global link colour anywhere else.
- The helper is presentation only. It does not add any behaviour and does not
  depend on a particular block plugin.

## Other helper classes

| Class | Applied to | Effect |
| --- | --- | --- |
| `klausula_link_list` | a `div` of links | Themed sidebar link list (see above). |
| `klausula_author` | author byline `<span>` | Keeps the country flag and the name aligned. |
| `klausula_stats` / `klausula_stat` | metrics `<ul>` / `<li>` | Inline view/download counters on article lists. |

## File layout

```
klausula/
├── KlausulaThemePlugin.inc.php   Theme plugin: options, styles, helpers
├── readme.md                     This file
├── settings.xml                  Default settings for new journals
├── version.xml                   Plugin version metadata
├── locale/                       en_US and id_ID strings
├── styles/
│   ├── index.less                Entry point (@imports the files below)
│   ├── variables.less            Palettes, design tokens, motifs
│   ├── base.less                 Colour schemes + base typography
│   ├── header.less               Header band, logo, navigation, search
│   ├── footer.less               Footer band and contact details
│   ├── components.less           Buttons, forms, lists, sidebar, stats, flags
│   └── pages.less                Article, issue and submission page details
└── templates/frontend/           Overrides of the default theme templates
    ├── components/
    │   ├── header.tpl
    │   └── footer.tpl
    └── objects/
        ├── article_summary.tpl
        └── article_details.tpl
```
