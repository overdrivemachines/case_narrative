// This project uses Bun and node_modules, not Yarn Plug'n'Play.
//
// vscode-stylelint searches every parent directory for `.pnp.cjs`. Without this
// local boundary it finds `~/.pnp.cjs`, preloads that unrelated dependency map,
// and then cannot load this project's Stylelint installation.
//
// Keep this file intentionally empty. It shadows the unrelated parent PnP hook
// while allowing Node's normal node_modules resolution to continue.
