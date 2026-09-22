package mise

import (
	"omc/internal/packages"
	"os/exec"
)

type Mise struct {
	packageManager packages.Manager
}

func New(packageManager packages.Manager) *Mise {
	return &Mise{
		packageManager: packageManager,
	}
}

func (m *Mise) ID() string {
	return "mise"
}

func (m *Mise) Name() string {
	return "Mise"
}

func (m *Mise) IsInstalled() bool {
	_, err := exec.LookPath("mise")
	return err == nil
}

func (m *Mise) Install() error {

	if m.IsInstalled() {
		return nil
	}
	return m.packageManager.Install(m.ID())

}

func (m *Mise) Updated() error {
	return nil
}

func (m *Mise) Doctor() error {
	return nil
}
