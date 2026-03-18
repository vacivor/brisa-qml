# Brisa QML Progress

Last update: 2026-03-18

## Overview

`brisa-qml` is under active development and already includes a substantial set of reusable Qt Quick components.

The current focus is high-fidelity alignment with Naive UI, especially around spacing, motion, popup behavior, dark theme support, and interaction details.

## Current Status

| Component | Status | Notes |
| --- | --- | --- |
| Button | In Progress | Core states, group, icon, loading, ghost, dashed, text, block, circle, round implemented; still refining hover fidelity |
| Input | In Progress | Text, textarea, password, clearable, count, loading, pair, autosize, status, prefix/suffix implemented |
| Input Number | In Progress | Stepper, placements, update timing, hover/pressed states implemented |
| Select | In Progress | Single, multiple, filterable, tag, clearable, grouped options, popselect integration implemented |
| Checkbox | In Progress | Sizes, disabled, indeterminate, group behavior implemented |
| Radio | In Progress | Sizes, disabled, group behavior implemented |
| Switch | In Progress | Content mode, round/rail variations, dark theme aligned |
| Tag | In Progress | Closable, bordered, multiple themes, dark theme support implemented |
| Card | In Progress | Header, footer, action, segmented sections, scrollable content implemented |
| Divider | In Progress | Horizontal, vertical, title placements, dashed styles implemented |
| Breadcrumb | In Progress | Clickable items, separators, icon support implemented |
| Icon | In Progress | Wrapper and showcase implemented; still refining some icon fidelity |
| Spin | In Progress | Standalone spin and loading integration implemented |
| Tabs | In Progress | Line, card, segment styles, closable tabs, dark theme improvements implemented |
| Pagination | In Progress | Normal and simple modes, quick jumper, size picker implemented |
| Progress | In Progress | Core progress styles implemented |
| Alert | In Progress | Type variants and motion implemented |
| Empty | In Progress | Naive-inspired SVG empty icon and size variants implemented |
| List | In Progress | List and list item variants implemented |
| Menu | In Progress | Nested menu, groups, collapse mode, motion and indent tuning implemented |
| Popover / Popup | In Progress | Popup placement, arrow, tooltip, popconfirm, dropdown, popselect implemented; positioning still being refined |
| Modal | In Progress | Mask, close behavior, layout, theme support implemented |
| Dialog | In Progress | Title, content, action area, close semantics implemented; still tuning final fidelity |
| Drawer | In Progress | Placement, header/body/footer layout, close behavior, theme support implemented |
| Form | In Progress | Form, form item, inline and top-label layouts implemented |
| Data Table | In Progress | Basic table, selection, fixed columns, empty state, pagination integration implemented |
| Layout Showcase | In Progress | Showcase coverage expanded for layout patterns |
| Theme System | In Progress | Runtime light/dark switching implemented |

## Showcase Coverage

The showcase app currently includes pages for:

- Layout
- Buttons
- Inputs
- Input Number
- Select
- Tabs
- Pagination
- Progress
- Form
- Switch
- Checkbox
- Radio
- Alert
- Breadcrumb
- Icon
- List
- Spin
- Empty
- Data Table
- Divider
- Tag
- Card
- Menu
- Popups

## Recently Completed

Recent work includes:

- Runtime light/dark theme switching
- Popup follow behavior and arrow/layout fixes
- Modal / dialog / drawer layout refinement
- Empty SVG icon replacement
- Dark theme fixes for table, tabs, pagination, switch, tag, and showcase text
- Card content hosting cleanup for showcase interaction behavior
- Initial open-source repository setup with `README.md` and `LICENSE`

## Next Priorities

Short-term priorities:

- Continue polishing high-fidelity behavior for popup-related components
- Finish cursor/hover consistency across all showcase pages
- Refine button hover/press fidelity
- Continue dialog, drawer, and modal alignment work
- Improve data table, pagination, and dark theme edge cases
- Add contributor-facing documentation and API cleanup for open source use

## Notes

Status labels are intentionally conservative.

Most components listed as `In Progress` are already usable in the showcase, but still need visual or behavioral refinement before they should be considered stable.
