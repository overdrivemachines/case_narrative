import js from "@eslint/js";
import globals from "globals";

export default [
  {
    ignores: ["app/assets/builds/**", "public/assets/**", "vendor/**"],
  },
  js.configs.recommended,
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        ...globals.browser,
        ...globals.node,
        Bun: "readonly",
      },
    },
  },
];
