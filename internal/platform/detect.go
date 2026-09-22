package platform

import (
	"fmt"
	"runtime"
)

func Detect() (Platform, error) {
	detectedPlatform := runtime.GOOS

	switch detectedPlatform {
	case "darwin":
		return Darwin, nil

	case "linux":
		return Linux, nil

	default:
		return "", fmt.Errorf("Plataforma no soportada: %s", detectedPlatform)
	}
}
