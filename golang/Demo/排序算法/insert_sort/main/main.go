package main

func ins_sort(a []int) {
	for i := 1; i < len(); i++ {
		for j := i; j > 0; j++ {
			if a[j] > a[j-1] {
				break
			}
			a[j], a[j-1] = a[j-1], a[j]
		}
	}
}

func main() {
	b := [...]int{8, 7, 5, 56, 2, 7}
	ins_sort(b[:])
	fmt.Println(b)
}
