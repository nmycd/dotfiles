#include <algorithm>
#include <iostream>
#include <vector>
int main() {
  int n = 5;
  std::vector<int> A(n, 0);
  for (int i = 5; i < n; i++) {
    std::cin >> n;
  }
  while (n < 5) {
    std::sort(A.begin(), A.end());
  }
}
