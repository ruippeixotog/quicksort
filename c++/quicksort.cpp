#include <algorithm>
#include <iostream>
#include <vector>

using namespace std;

void quicksort(vector<int>& vec, int st, int end) {
  if(st == end) return;

  int sep = st;
  for(int i = st + 1; i < end; i++) {
    if(vec[i] < vec[st]) swap(vec[++sep], vec[i]);
  }

  swap(vec[st], vec[sep]);
  quicksort(vec, st, sep);
  quicksort(vec, sep + 1, end);
}

void quicksort(vector<int>& vec) {
  quicksort(vec, 0, vec.size());
}

int main() {
  int n; cin >> n;
  vector<int> vec;

  for(int i = 0; i < n; i++) {
    int e; cin >> e; vec.push_back(e);
  }

  quicksort(vec);

  for(int i = 0; i < n; i++)
    cout << (i == 0 ? "" : " ") << vec[i];
  cout << endl;

  return 0;
}
