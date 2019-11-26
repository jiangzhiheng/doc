package load_balance

type Balancer interface {
	DoBalance([]*Instance, ...string) (*Instance, error)
}
