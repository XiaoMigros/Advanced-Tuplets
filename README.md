# [Advanced Tuplets](https://musescore.org/project/advanced-tuplets)
A MuseScore plugin for more precise &amp; customisable tuplet input.

### [Download](https://github.com/XiaoMigros/advanced-tuplets/archive/main.zip)

## Features:
- See the actual length of the tuplets you input, not just the ratio
- The plugin detects invalid tuplets before they are created
- Copy notes into the tuplet, instead of the tuplet simply replacing them
- Completely customisable length, no need for the split measures hack
- Create nested tuplets otherwise impossible to make
- MuseScore 3 and 4 compatible
### Changelog
#### v1.2
- Full fledged support for nested tuplets
- Improved corruption detection, error detection for nested tuplets
- Fixed visual glitch in the bracket type UI
#### v1.1
- Input smaller notes (128th-1024th)
- Basic corruption detection system
- Bug fix: tuplets can now be created in the last measure of a score
#### v1.0.1
- Fixed bug where some dotted tuplets were incorrectly declared invalid
- Fixed bug where the plugin didn't correctly apply saved settings

## Screenshots
![Plugin Window Screenshot](https://github.com/XiaoMigros/Advanced-Tuplets/blob/main/example.png)

## Installation
Download [all the files](https://github.com/XiaoMigros/advanced-tuplets/archive/main.zip), unzip them and move them to MuseScore's plugins folder.

For more help installing this plugin, see the handbook: [MuseScore 3](https://musescore.org/en/handbook/3/plugins#installation) | [MuseScore 4](https://musescore.org/en/handbook/4/plugins#Installing_a_new_plugin).

## Usage
Running the plugin via plugins tab or via a shortcut opens the tuplet input window. If the plugin thinks the currently entered tuplet is invalid, it won't allow it to be created.<br/>
If the tuplet is valid, pressing OK will add it to the currently selected note/rest. If no note/rest is selected, the plugin will retroactively create the tuplet on the next selected note/rest.

The plugin also features a primitive corruption detection mechanism. It's possible to create these tuplets regardless, but do so at your own risk.
