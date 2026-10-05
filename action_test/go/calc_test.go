package calc

import (
	"bufio"
	"os"
	"strconv"
	"strings"
	"testing"
)

func loadEnvFile(path string) {
	file, err := os.Open(path)
	if err != nil {
		return
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := strings.TrimSpace(scanner.Text())
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		parts := strings.SplitN(line, "=", 2)
		if len(parts) == 2 {
			k := strings.TrimSpace(parts[0])
			v := strings.TrimSpace(parts[1])
			if os.Getenv(k) == "" {
				os.Setenv(k, v)
			}
		}
	}
}

func getEnvInt(key string, fallback int) int {
	val := os.Getenv(key)
	if val == "" {
		return fallback
	}
	i, err := strconv.Atoi(val)
	if err != nil {
		return fallback
	}
	return i
}

func TestCalc(t *testing.T) {
	loadEnvFile(".env")
	loadEnvFile(".env.example")

	bagia := getEnvInt("BAGIA", 20)
	bagib := getEnvInt("BAGIB", 4)
	bagic := getEnvInt("BAGIC", 5)

	tambaha := getEnvInt("TAMBAHA", 4)
	tambahb := getEnvInt("TAMBAHB", 6)
	tambahc := getEnvInt("TAMBAHC", 10)

	moda := getEnvInt("MODA", 22)
	modb := getEnvInt("MODB", 7)
	modc := getEnvInt("MODC", 1)

	t.Run("Test Add", func(t *testing.T) {
		got := Tambah(tambaha, tambahb)
		if got != tambahc {
			t.Fatalf("Tambah(%d, %d) = %d; want %d", tambaha, tambahb, got, tambahc)
		}
	})

	t.Run("Test Bagi", func(t *testing.T) {
		got := Bagi(bagia, bagib)
		if got != bagic {
			t.Fatalf("Bagi(%d, %d) = %d; want %d", bagia, bagib, got, bagic)
		}
	})

	t.Run("Test Mod", func(t *testing.T) {
		got := Mod(moda, modb)
		if got != modc {
			t.Fatalf("Mod(%d, %d) = %d; want %d", moda, modb, got, modc)
		}
	})
}
