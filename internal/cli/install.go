package cli

import (
	"omc/internal/logger"
	"omc/internal/modules"
)

func InstallCommand(registry *modules.Registry, logger *logger.Logger) {

	modules := registry.All()

	for _, module := range modules {
		logger.Step("Instalando %s", module.ID())

		if err := module.Install(); err != nil {
			logger.Error("Error instalando %s: %w", module.Name(), err)
			continue
		}

		logger.Success("%s instalado correctamente", module.Name())
	}

}
