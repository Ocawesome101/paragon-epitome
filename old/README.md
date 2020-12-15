# Epitome

Epitome is an init system designed for the Paragon kernel. It focuses primarily on stability and modularity over speed.

## Building

To build Epitome, you will need `lua` (version 5.3 or newer - older versions MAY work but are unsupported and untested), a VT100-compatible terminal (alternatively, you may pass the `-d` command-line flag to `build.lua` to skip configuration menus and include everything) and a Unix-like shell + utilities. Simply run `lua build.lua` from the repository root and you will get `init.lua` as well as some utilities in `build`.

### Build Configuration

Epitome may be configured at build time in a manner similar to Paragon. There are some modules that are optional and some that are required.
