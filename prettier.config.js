import * as voidHtmlPlugin from "@awmottaz/prettier-plugin-void-html";

export default {
  // Keep CLI and editor formatting consistent for every Prettier-supported file.
  printWidth: 200,
  tabWidth: 2,
  useTabs: false,
  singleAttributePerLine: false,
  semi: true,
  singleQuote: false,
  bracketSpacing: true,
  trailingComma: "all",
  arrowParens: "always",
  // Use modern HTML void-element syntax (`<meta>`, `<br>`, etc.) instead of
  // Prettier's XHTML-style self-closing syntax (`<meta />`, `<br />`, etc.).
  // Import the module instead of relying on runtime package-name discovery so
  // the Prettier CLI and the VS Code extension receive the same plugin object.
  plugins: [voidHtmlPlugin],
  overrides: [
    {
      files: ["**/*.html"],
      options: {
        // Stylelint owns CSS in <style> blocks so Prettier cannot undo its fixes.
        embeddedLanguageFormatting: "off",
        htmlWhitespaceSensitivity: "ignore",
      },
    },
    {
      files: ["vendor/themes/adminator/**/*.html"],
      options: {
        // Adminator contains embedded JavaScript that should be formatted.
        embeddedLanguageFormatting: "auto",
        htmlWhitespaceSensitivity: "ignore",
      },
    },
  ],
};
