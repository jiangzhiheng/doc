package main

import (
	"fmt"
	"go_dev/day7/LoadBalance/load_balance"
	"math/rand"
	"os"
	"time"
)

func main() {
	//insts := make([]*load_balance.Instance)
	var insts []*load_balance.Instance
	for i := 0; i < 16; i++ {
		host := fmt.Sprintf("192.168.%d.%d", rand.Intn(255), rand.Intn(255))
		one := load_balance.NewInstace(host, 8080)
		insts = append(insts, one)
	}
	var balanceName = "random"
	if len(os.Args) > 1 {
		balanceName = os.Args[1]
	}

	//选择一个LB算法
	for {
		inst, err := load_balance.DoBalance(balanceName, insts)
		if err != nil {
			fmt.Println("do balance err", err)
			continue
		}
		fmt.Println(inst) //打印实例，测试用
		time.Sleep(time.Second)
	}
}
