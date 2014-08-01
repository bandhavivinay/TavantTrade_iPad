/** 
 * TopicMessage.h
 *
 *  Created by mcowie on 15/10/2010.
 *  Copyright (c) 2009 Push Technology Ltd. All rights reserved.
 *
 */

/** Logging macro */
#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#	define DLog(...) /* do nothing */
#endif

#define DF_PRIVATE(x) x
#define DF_PRIVATE_CLASS /* nothing */

#define K 1024

#define DIFFUSION_MESSAGE_TYPE_INITIAL_TOPIC_LOAD	20
#define DIFFUSION_MESSAGE_TYPE_DELTA				21
#define DIFFUSION_MESSAGE_TYPE_SUBSCRIBE			22
#define DIFFUSION_MESSAGE_TYPE_UNSUBSCRIBE			23
#define DIFFUSION_MESSAGE_TYPE_SERVER_PING			24
#define DIFFUSION_MESSAGE_TYPE_CLIENT_PING			25
#define DIFUFSION_MESSAGE_TYPE_SEND_CREDS			26
#define DIFFUSION_MESSAGE_TYPE_REJECTED_CREDS		27
#define DIFFUSION_MESSAGE_TYPE_CLIENT_ABORT			28
#define DIFFUSION_MESSAGE_TYPE_LOST_CONNECTION		29
#define DIFFUSION_MESSAGE_TYPE_ITL_REQ_ACK			30
#define DIFFUSION_MESSAGE_TYPE_DELTA_REQ_ACK		31
#define DIFFUSION_MESSAGE_TYPE_ACK_RESPONSE			32
#define DIFFUSION_MESSAGE_TYPE_FETCH				33
#define DIFFUSION_MESSAGE_TYPE_FETCH_RESPONSE		34
#define DIFFUSION_MESSAGE_TYPE_TOPIC_STATUS_NOTIFICATION	35

// Service/command messages - v4 feature
#define DIFFUSION_MESSAGE_TYPE_COMMAND					36
#define DIFFUSION_MESSAGE_TYPE_COMMAND_TOPIC_LOAD		40
#define DIFFUSION_MESSAGE_TYPE_COMMAND_NOTIFICATION		41

// Fragemented messages - v4 feature
#define FLAG_FRAGMENTED 0x40
#define DIFFUSION_MESSAGE_TYPE_INITIAL_TOPIC_LOAD_FRAGMENT ( DIFFUSION_MESSAGE_TYPE_INITIAL_TOPIC_LOAD | FLAG_FRAGMENTED )
#define DIFFUSION_MESSAGE_TYPE_DELTA_FRAGMENT			( DIFFUSION_MESSAGE_TYPE_DELTA | FLAG_FRAGMENTED )
#define DIFFUSION_MESSAGE_TYPE_FETCH_RESPONSE_FRAGMENT	( DIFFUSION_MESSAGE_TYPE_FETCH_RESPONSE | FLAG_FRAGMENTED )
#define DIFFUSION_MESSAGE_TYPE_FRAGMENT_SET_CANCEL		0x30

#define DIFFUSION_MESSAGE_ENCODING_NONE_ENCODING		0
#define DIFFUSION_MESSAGE_ENCODING_ENCRYPTED_ENCODING	17
#define DIFFUSION_MESSAGE_ENCODING_COMPRESSED_ENCODING	18
#define DIFFUSION_MESSAGE_ENCODING_BASE64_ENCODING		19

#define DIFFUSION_MESSAGE_ENCODING_ENCRYPTED_REQUESTED	1
#define DIFFUSION_MESSAGE_ENCODING_COMPRESSED_REQUESTED	2
#define DIFFUSION_MESSAGE_ENCODING_BASE64_REQUESTED		3

#define MD "\x00"
#define RD "\x01"
#define FD "\x02"

NSArray *shuffleArray( NSArray *array );
NSString *formatInteger( int number, int radix );

/**
 * The protocols currently supported
 */
#define DPT @"dpt"
#define DPTS @"dpts"

@interface NSMutableData (DFCommon)

@end

@interface NSArray (DFCommon) 

@end
