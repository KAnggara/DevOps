const test = require("node:test");
const assert = require("node:assert");
const fs = require("node:fs");
const path = require("node:path");
const { Calc } = require("./calc.js");

function loadEnvFile(filePath) {
  if (!fs.existsSync(filePath)) return;
  const content = fs.readFileSync(filePath, "utf-8");
  for (const line of content.split("\n")) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) continue;
    const [k, ...rest] = trimmed.split("=");
    const v = rest.join("=").trim();
    if (k && !process.env[k.trim()]) {
      process.env[k.trim()] = v;
    }
  }
}

test("Test Add", () => {
  loadEnvFile(path.join(__dirname, ".env"));
  loadEnvFile(path.join(__dirname, ".env.example"));

  const tambaha = parseInt(process.env.TAMBAHA || "4", 10);
  const tambahb = parseInt(process.env.TAMBAHB || "6", 10);
  const tambahc = parseInt(process.env.TAMBAHC || "10", 10);

  assert.strictEqual(Calc.tambah(tambaha, tambahb), tambahc);
});

test("Test Bagi", () => {
  loadEnvFile(path.join(__dirname, ".env"));
  loadEnvFile(path.join(__dirname, ".env.example"));

  const bagia = parseInt(process.env.BAGIA || "20", 10);
  const bagib = parseInt(process.env.BAGIB || "4", 10);
  const bagic = parseInt(process.env.BAGIC || "5", 10);

  assert.strictEqual(Calc.bagi(bagia, bagib), bagic);
});

test("Test Mod", () => {
  loadEnvFile(path.join(__dirname, ".env"));
  loadEnvFile(path.join(__dirname, ".env.example"));

  const moda = parseInt(process.env.MODA || "22", 10);
  const modb = parseInt(process.env.MODB || "7", 10);
  const modc = parseInt(process.env.MODC || "1", 10);

  assert.strictEqual(Calc.mod(moda, modb), modc);
});
