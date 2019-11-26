package main

import "fmt"

//选择排序

func select_sort() {
	a := []int{34, 1, 43, 54, 2, 47, 33, 78, 44}
	for i := 0; i < len(a); i++ {
		for j := i + 1; j < len(a); j++ {
			if a[i] > a[j] {
				a[i], a[j] = a[j], a[i]
			}
		}
	}
	fmt.Println(a)
}

//冒泡排序
func bsort(a []int) {
	for i := 0; i < len(a); i++ {
		for j := 1; j < len(a)-i; j++ {
			if a[j] > a[j-1] {
				a[j], a[j-1] = a[j-1], a[j]
			}
		}
	}
}

func main() {
	select_sort()
	b := [...]int{8, 7, 5, 56, 2, 7}
	bsort(b[:])
	fmt.Println(b)

}
