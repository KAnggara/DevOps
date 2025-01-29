import { Calc } from "../calc";
import { describe, expect, it } from "bun:test";

describe("Test add", () => {
  it("Test Sum", () => {
    expect(Calc.sum(1, 2, 3, 4)).toBe(10);
  });
  it("Test Add", () => {
    expect(Calc.add(4, 6)).toBe(10);
  });
});
