package modules

import (
	"omc/internal/module"
	"omc/internal/modules/mise"
	"omc/internal/packages"
	"omc/internal/platform"
)

type Registry struct {
	modules []module.Module
}

func NewRegistry(plt platform.Platform, packageManager packages.Manager) *Registry {

	registeredModules := []module.Module{
		mise.New(packageManager),
	}

	// agregar swhits para seprar modulos por plataformas

	return &Registry{
		modules: registeredModules,
	}
}

func (r *Registry) All() []module.Module {
	return r.modules
}
