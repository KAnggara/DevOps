import { Calc } from "../src/calc";
import { describe, expect, it } from "bun:test";

const bagia = parseInt(process.env.BAGIA, 0);
const bagib = parseInt(process.env.BAGIB, 0);
const bagic = parseInt(process.env.BAGIC, 0);

const tambaha = parseInt(process.env.TAMBAHA, 0);
const tambahb = parseInt(process.env.TAMBAHB, 0);
const tambahc = parseInt(process.env.TAMBAHC, 0);

const moda = parseInt(process.env.MODA, 0);
const modb = parseInt(process.env.MODB, 0);
const modc = parseInt(process.env.MODC, 0);

describe("Test add", () => {
  it("Test Add", () => {
    expect(Calc.tambah(tambaha, tambahb)).toBe(tambahc);
  });

  it("Test Bagi", () => {
    expect(Calc.bagi(bagia, bagib)).toBe(bagic);
  });

  it("Test Add", () => {
    expect(Calc.mod(moda, modb)).toBe(modc);
  });
});
