package module

type Module interface {
	ID() string
	Name() string

	IsInstalled() bool
	Install() error
	Updated() error
	Doctor() error
}
