package cli

import (
	"fmt"
	"omc/internal/logger"
	"omc/internal/modules"
	"os"
)

func Run(registry *modules.Registry, logger *logger.Logger) error {
	if len(os.Args) < 2 {
		return fmt.Errorf("Se requiere un comando")
	}

	command := os.Args[1]

	switch command {
	case "install":
		InstallCommand(registry, logger)
		return nil

	default:
		return fmt.Errorf("Comando %s no reconocido", command)
	}
}
