# Brisa UI

A high-fidelity Naive UI inspired component library for Qt Quick.

`brisa-qml` is a Qt/QML component library focused on recreating the visual language and interaction feel of Naive UI on desktop with custom QML components.

## Status

This project is under active development.

It already includes a growing set of foundational and data-entry components, plus a showcase app used to compare behavior, spacing, motion, and dark mode support.

## Highlights

- High-fidelity Naive UI inspired component design for Qt Quick
- Custom QML components instead of default Qt Quick Controls styling
- Light and dark theme switching
- Built-in showcase app for visual verification
- Focus on interaction details such as hover, focus, popup positioning, loading states, and scroll behavior

## Implemented Components

Current work includes components such as:

- Button
- Input
- Input Number
- Select
- Checkbox
- Radio
- Switch
- Tag
- Card
- Divider
- Empty
- Progress
- Alert
- List
- Menu
- Tabs
- Breadcrumb
- Pagination
- Data Table
- Popup / Popover / Popconfirm / Tooltip / Dropdown / Drawer / Modal / Dialog
- Form / Form Item / Form Group
- Icon / Spin

## Project Structure

```text
brisa-qml/
  CMakeLists.txt
  README.md
  LICENSE
  PROGRESS.md
  qml/
    Brisa/
  examples/
    main.cpp
    Main.qml
    showcase/
  docs/
```

## Run The Showcase

Requirements:

- Qt 6
- CMake
- A C++ toolchain supported by your Qt installation

Build and run:

```bash
cmake -S . -B build
cmake --build build -j
./build/appbrisa_qml.app/Contents/MacOS/appbrisa_qml
```

If you are using Qt Creator, you can also open the project directly and run the showcase from there.

## Design Goal

The goal of this project is not to provide a thin wrapper around Qt Quick Controls. Instead, it aims to build a cohesive Qt Quick component library with:

- Naive UI inspired proportions and motion
- Desktop-friendly interaction details
- Custom visuals that stay consistent across components
- A practical development workflow for pixel-level refinement

## Roadmap

Short-term priorities:

- Continue improving high-fidelity alignment with Naive UI
- Keep refining popup, table, form, and layout behavior
- Improve dark theme consistency across all components
- Polish public API and documentation for open source use

## Contributing

Issues and pull requests are welcome.

Before contributing larger changes, please open an issue first so we can align on direction and avoid duplicate work.

## License

MIT. See `LICENSE`.
