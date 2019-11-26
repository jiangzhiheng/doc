package load_balance

import "fmt"

type BalanceMgr struct {
	allBalance map[string]Balancer
}

var (
	mgr = BalanceMgr{ //声明struct
		allBalance: make(map[string]Balancer), //初始化map
	}
)

func (p *BalanceMgr) registerBalancer(name string, b Balancer) {
	p.allBalance[name] = b
}
func RegisterBalancer(name string, b Balancer) {
	mgr.registerBalancer(name, b)
}

func DoBalance(name string, insts []*Instance) (inst *Instance, err error) {
	balancer, ok := mgr.allBalance[name]
	if !ok {
		err = fmt.Errorf("Not found %s balance", name)
		return
	}
	fmt.Printf("use %s balance\n", name)
	inst, err = balancer.DoBalance(insts)
	return
}
