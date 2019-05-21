#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <dlfcn.h>
#include <errno.h>

int getsockopt(int sockfd, int level, int optname, void *optval, socklen_t *optlen)
{
	if (level == SOL_SOCKET && optname == SO_RCVTIMEO)
	{
//		printf("overwriting getsockopt(..., SOL_SOCKET, SO_RCVTIMEO, ..., ...) with ENOPROTOOPT\n");
		errno = ENOPROTOOPT;
		return -1;
	}

	int(*original)(int, int, int, void*, socklen_t*);
	original = dlsym(RTLD_NEXT, "getsockopt");
//	printf("calling original getsockopt(..., %d, %d, ..., ...)\n", level, optname);
	return (*original)(sockfd, level, optname, optval, optlen);
}
