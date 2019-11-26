package main

func qsort(a []int, left, right int) {
	if left >= right-1 {
		return
	}
	val := a[left]
	//确定val所在的位置
	k := left

	for i := left + 1; i <= right; i++ {
		if a[i] < val {
			a[k] = a[i]
			a[i] = a[k+1]
			k++
		}
	}
	a[k] = val
	qsort(a, left, k-1)
	qsort(a, k+1, right)
}

func main() {
	b := [...]int{8, 7, 5, 56, 2, 7}
	qsort(b[:], 0, len(b))
}
