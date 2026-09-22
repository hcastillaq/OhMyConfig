package main

import (
	"os"

	"omc/internal/cli"
	"omc/internal/logger"
	"omc/internal/modules"
	"omc/internal/packages"
	"omc/internal/platform"
	"omc/internal/shell"
)

func main() {

	logger := logger.New()
	shell := shell.New()

	logger.Step("Detectando plataforma")

	detectedPlatform, err := platform.Detect()
	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}

	logger.Step("Detectando manejador de paquetes")
	packageManager, err := packages.Resolve(detectedPlatform, shell)

	if err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}

	logger.Success("Plataforma detectada: %s", detectedPlatform.String())
	logger.Success("Manejador de paquetes detectado: %s", packageManager.Name())

	registry := modules.NewRegistry(detectedPlatform, packageManager)

	if err := cli.Run(registry, logger); err != nil {
		logger.Error(err.Error())
		os.Exit(1)
	}

}
