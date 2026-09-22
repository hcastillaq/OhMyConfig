package packages

type Manager interface {
	Name() string
	IsInstalled() bool
	Install(packages ...string) error
	Update(packages ...string) error
}
