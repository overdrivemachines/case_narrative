export default {
  extends: ["stylelint-config-standard-scss"],
  plugins: ["@stylistic/stylelint-plugin"],
  ignoreFiles: ["app/assets/builds/**"],
  overrides: [
    {
      // Parse CSS inside <style> blocks in the static public error pages.
      files: ["public/**/*.html"],
      customSyntax: "postcss-html",
    },
  ],
  rules: {
    // Enforce the shared project width. Comma-separated selectors and font
    // families remain exempt because this project intentionally keeps them inline.
    "@stylistic/max-line-length": [200, { ignorePattern: /font-family:|^[^{}]+,[^{}]+\s*\{/ }],

    // Keep comma-separated selectors together, e.g. `i, em { ... }`.
    "@stylistic/selector-list-comma-newline-after": "never-multi-line",
    "@stylistic/selector-list-comma-newline-before": "never-multi-line",
    "@stylistic/selector-list-comma-space-after": "always",
    "@stylistic/selector-list-comma-space-before": "never",

    // Keep comma-separated property values together, including font families.
    "@stylistic/value-list-comma-newline-after": "never-multi-line",
    "@stylistic/value-list-comma-newline-before": "never-multi-line",
    "@stylistic/value-list-comma-space-after": "always",
    "@stylistic/value-list-comma-space-before": "never",

    // Keep wrapped property values on the same line as the property name.
    "@stylistic/declaration-colon-space-after": "always",
  },
};
