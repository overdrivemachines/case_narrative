#!/usr/bin/env node

import { readdir, readFile, stat, writeFile } from "node:fs/promises";
import path from "node:path";
import process from "node:process";
import scss from "postcss-scss";
import prettier from "prettier";

const PRINT_WIDTH = 200;
const DEFAULT_PATH = "app/assets/stylesheets";

async function collectScssFiles(inputPaths) {
  const files = [];

  async function visit(inputPath) {
    const inputStat = await stat(inputPath);

    if (inputStat.isDirectory()) {
      const entries = await readdir(inputPath, { withFileTypes: true });
      await Promise.all(entries.map((entry) => visit(path.join(inputPath, entry.name))));
    } else if (inputStat.isFile() && inputPath.endsWith(".scss")) {
      files.push(inputPath);
    }
  }

  await Promise.all(inputPaths.map(visit));
  return files.sort();
}

function joinShortSelectorLists(source, filePath) {
  const root = scss.parse(source, { from: filePath });

  root.walkRules((rule) => {
    if (!rule.selector.includes(",") || !/\r?\n/.test(rule.selector) || rule.selector.includes("/*")) return;

    const joinedSelector = rule.selector
      .replace(/\s*,\s*/g, ", ")
      .replace(/\s+/g, " ")
      .trim();
    const indentation = rule.raws.before?.split(/\r?\n/).at(-1) ?? "";

    if (indentation.length + joinedSelector.length + 2 <= PRINT_WIDTH) {
      rule.selector = joinedSelector;
    }
  });

  return root.toResult({ syntax: scss }).css;
}

async function formatScss(source, filePath) {
  const prettierOutput = await prettier.format(source, { filepath: filePath });
  return joinShortSelectorLists(prettierOutput, filePath);
}

async function main() {
  const argumentsList = process.argv.slice(2);
  const checkIndex = argumentsList.indexOf("--check");
  const check = checkIndex !== -1;
  if (check) argumentsList.splice(checkIndex, 1);

  const files = await collectScssFiles(argumentsList.length > 0 ? argumentsList : [DEFAULT_PATH]);
  const unformatted = [];

  for (const file of files) {
    const source = await readFile(file, "utf8");
    const formatted = await formatScss(source, file);

    if (formatted === source) continue;

    if (check) {
      unformatted.push(file);
    } else {
      await writeFile(file, formatted);
      console.log(file);
    }
  }

  if (check && unformatted.length > 0) {
    console.error("SCSS formatting differs in:");
    for (const file of unformatted) console.error(`  ${file}`);
    process.exitCode = 1;
  }
}

await main();
