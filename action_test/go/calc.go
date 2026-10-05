package calc

func Tambah(a, b int) int {
	return a + b
}

func Bagi(a, b int) int {
	if b == 0 {
		return 0
	}
	return a / b
}

func Mod(a, b int) int {
	if b == 0 {
		return 0
	}
	return a % b
}
