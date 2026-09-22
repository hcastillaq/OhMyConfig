package packages

import (
	"fmt"
	"omc/internal/platform"
	"omc/internal/shell"
)

func Resolve(plt platform.Platform, shell shell.Runner) (Manager, error) {

	switch plt {
	case platform.Darwin:
		manager := NewBrewManager(shell)

		if !manager.IsInstalled() {
			return nil, fmt.Errorf("El manejador de paquetes %s no está instalado", manager.Name())
		}

		return manager, nil
	default:
		return nil, fmt.Errorf("%s no es una plataforma soportada", plt.String())
	}

}
