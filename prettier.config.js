import * as voidHtmlPlugin from "@awmottaz/prettier-plugin-void-html";

export default {
  // Keep CLI and editor formatting consistent for every Prettier-supported file.
  printWidth: 200,
  // Use modern HTML void-element syntax (`<meta>`, `<br>`, etc.) instead of
  // Prettier's XHTML-style self-closing syntax (`<meta />`, `<br />`, etc.).
  // Import the module instead of relying on runtime package-name discovery so
  // the Prettier CLI and the VS Code extension receive the same plugin object.
  plugins: [voidHtmlPlugin],
  overrides: [
    {
      files: "**/*.html",
      options: {
        // Stylelint owns CSS in <style> blocks so Prettier cannot undo its fixes.
        embeddedLanguageFormatting: "off",
      },
    },
  ],
};
