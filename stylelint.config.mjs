export default {
  extends: ["stylelint-config-standard-scss", "@stylistic/stylelint-config", "stylelint-config-clean-order"],

  plugins: ["stylelint-no-indistinguishable-colors"],

  ignoreFiles: ["app/assets/builds/**"],

  rules: {
    "@stylistic/max-line-length": [
      200,
      {
        ignorePattern: /font-family:|^[^{}]+,[^{}]+\s*\{/,
      },
    ],

    "@stylistic/selector-list-comma-newline-after": "never-multi-line",
    "@stylistic/selector-list-comma-newline-before": "never-multi-line",
    "@stylistic/selector-list-comma-space-after": "always",
    "@stylistic/selector-list-comma-space-before": "never",

    "@stylistic/value-list-comma-newline-after": "never-multi-line",
    "@stylistic/value-list-comma-newline-before": "never-multi-line",
    "@stylistic/value-list-comma-space-after": "always",
    "@stylistic/value-list-comma-space-before": "never",

    "@stylistic/declaration-colon-space-after": "always",

    "plugin/stylelint-no-indistinguishable-colors": [
      true,
      {
        allowEquivalentNotation: true,
        // Preserve the intentionally close deep and panel background tokens.
        whitelist: [["#070708", "#0c0b0c"]],
      },
    ],
  },
};
