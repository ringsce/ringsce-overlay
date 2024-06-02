/* 
errno error code
*/

#include <errno.h>
#include <iostream.h>
#include <cstdio.h>

int main(int argc, char **argv)
{

cerr << "EACCES: EACCES" << endl;
perror("FILE");
return 0;


}