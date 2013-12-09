#ifndef SHOTODOL_PLUGIN_INCLUDE_H
#define SHOTODOL_PLUGIN_INCLUDE_H

#include <sys/socket.h>
#include <netinet/in.h>
#include <poll.h>
enum {
	NET_STREAM_FLAG_UDP = 1,
	NET_STREAM_FLAG_TCP = 1<<1,
	NET_STREAM_FLAG_BIND = 1<<2,
	NET_STREAM_FLAG_CONNECT = 1<<3,
};
struct net_stream {
	int sock;
	struct sockaddr_in sin;
	SYNC_UWORD8_T flags;
};

enum {
	MAXIMUM_POLL_LIMIT = 64,
};

struct net_stream_poll {
	int fdcount;
	int evtcount;
	int evtindex;
	struct pollfd fd_set[MAXIMUM_POLL_LIMIT];
	struct net_stream*strms[MAXIMUM_POLL_LIMIT];
};

// stream
#define net_stream_empty(x) ({(x)->sock = -1;})
int net_stream_new(struct net_stream*strm, struct aroop_txt*path, SYNC_UWORD8_T flags);
int net_stream_recv(struct net_stream*strm, struct aroop_txt*buf);
int net_stream_send(struct net_stream*strm, struct aroop_txt*buf);
#define net_stream_close(x) ({if((x)->sock > 0){close((x)->sock);};})
#define net_stream_accepting(x) ({((x)->flags & NET_STREAM_FLAG_BIND);})
int net_stream_accept_new(struct net_stream*newone, struct net_stream*from);

// poll
int net_stream_poll_add_stream(struct net_stream_poll*spoll, struct net_stream*strm);
int net_stream_poll_check_for(struct net_stream_poll*spoll, struct net_stream*strm, int writing, int reading);
int net_stream_poll_delete_stream(struct net_stream_poll*spoll, struct net_stream*strm);
int net_stream_poll_check_events(struct net_stream_poll*spoll);
struct net_stream*net_stream_poll_next(struct net_stream_poll*spoll);
#define net_stream_poll_create(x) ({(x)->fdcount = 0;})

#endif //SHOTODOL_PLUGIN_INCLUDE_H
