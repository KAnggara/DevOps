class Calc {
  static tambah(a, b) {
    return a + b;
  }

  static bagi(a, b) {
    if (b === 0) return 0;
    return Math.floor(a / b);
  }

  static mod(a, b) {
    if (b === 0) return 0;
    return a % b;
  }
}

module.exports = { Calc };
