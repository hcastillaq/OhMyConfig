package shell

import (
	"os"
	"os/exec"
)

type Runner struct{}

func New() Runner {
	return Runner{}
}

func (r Runner) Run(command string, args ...string) error {
	cmd := exec.Command(command, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin

	return cmd.Run()
}
