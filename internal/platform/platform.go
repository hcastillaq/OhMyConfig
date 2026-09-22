package platform

type Platform string

const (
	Darwin Platform = "darwing"
	Linux  Platform = "linux"
)

func (p Platform) String() string {
	return string(p)
}
