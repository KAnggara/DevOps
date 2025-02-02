export class Calc {
  static add(a: number, b: number) {
    return a + b;
  }
  static div(a: number, b: number) {
    return a - b;
  }
  static sum(...numbers: number[]) {
    let sum = 0;
    for (const element of numbers) {
      sum += element;
    }
    return sum;
  }
}
