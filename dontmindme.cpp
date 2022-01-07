#include <iostream>
using namespace std;

int main() {
    cout << "Dont mind me. Just creepin.." << endl;
    cout << "How does this make you feel?\n1. Creeped out\n2. It's cool" << endl;
    int x;
    cin >> x;
    do{
    if (x == 1){
        cout << "My Bad" << endl;
    }
    else {
        cout << "Cool" << endl;
    }
    }
    while (x != 1 && x !=2);
    return 0;
}
