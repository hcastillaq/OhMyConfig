package packages

import (
	"omc/internal/shell"
	"os/exec"
)

type BrewManager struct {
	name  string
	shell shell.Runner
}

func NewBrewManager(shell shell.Runner) *BrewManager {
	return &BrewManager{
		name:  "brew",
		shell: shell,
	}
}

func (b *BrewManager) Name() string {
	return b.name
}

func (b *BrewManager) IsInstalled() bool {
	_, err := exec.LookPath("brew")
	return err == nil
}

func (b *BrewManager) Install(packages ...string) error {
	args := append([]string{"install"}, packages...)
	return b.shell.Run("brew", args...)
}

func (b *BrewManager) Update(packages ...string) error {
	return nil
}
