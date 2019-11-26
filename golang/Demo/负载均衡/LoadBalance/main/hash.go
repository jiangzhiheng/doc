package main

import (
	"fmt"
	"go_dev/day7/LoadBalance/load_balance"
	"hash/crc32"
	"math/rand"
)

//一致性hash算法

type HaskBalance struct {
	//	key string
}

func init() {
	load_balance.RegisterBalancer("hash", &HaskBalance{})
}

func (p *HaskBalance) DoBalance(insts []*load_balance.Instance, key ...string) (inst *load_balance.Instance, err error) {
	var defKey string = fmt.Sprintf("%d", rand.Int())
	if len(key) > 0 {
		//err = fmt.Errorf("hash balance must pass balance key")
		defKey = key[0]
	}
	lens := len(insts)
	if lens == 0 {
		err = fmt.Errorf("No backend instance")
	}
	crcTable := crc32.MakeTable(crc32.IEEE)
	haskVal := crc32.Checksum([]byte(defKey), crcTable)
	index := int(haskVal) % lens
	inst = insts[index]
	return
}
