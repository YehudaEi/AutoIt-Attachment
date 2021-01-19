#include <iostream>
#include <ctime>

using namespace std;

int GetRand(int min, int max);
int main(void)
{
  int i, r, num, dummy;
    r = GetRand(1, 100);
  num = r;
  do{
      cout<<"Guess a number:";
      cin>> dummy;
      cin.ignore();
      if ( num > dummy ) {
          cout<<"Your number was too low\n";
      }
      else if ( num == dummy) {
          cout<<"You Win! You guessed the right number!\n";
      }
      else {
          cout<<"Your number was too high\n";
      }
  } while ( dummy != num);
  cin.get();
}

int GetRand(int min, int max)
{
  static int Init = 0;
  int rc;

  if (Init == 0)
  {
    /*
     *  As Init is static, it will remember it's value between
     *  function calls.  We only want srand() run once, so this
     *  is a simple way to ensure that happens.
     */
    srand(time(NULL));
    Init = 1;
  }

  /*
   * Formula:
   *    rand() % N   <- To get a number between 0 - N-1
   *    Then add the result to min, giving you
   *    a random number between min - max.
   */
  rc = (rand() % (max - min + 1) + min);

  return (rc);
}
