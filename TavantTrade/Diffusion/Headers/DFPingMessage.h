/*
 * PingMessage.h
 *
 *  Created by dhudson on 30/06/2009.
 *  Copyright 2009 Push Technology Ltd. All rights reserved.
 *
 *  This object will be sent to the DFClientDelegate on recipt of a Ping request 
 */

/**
 Representation of the ping response message, as sent from the Diffusion server.
 */
@interface DFPingMessage : NSObject 
{
	@private
	NSDate *timestamp;
	int queueSize;
}
@property(nonatomic,readonly) NSDate *timestamp;	/**<  Datestamp of the original ping request */
@property(nonatomic,readonly) int queueSize;		/**<  Current size of the mesage queue for this client */

/**
 Initialise a DFPingMessage object
 @param timestamp	String object holding a decimal number of milliseconds since the epoch
 @param size	Queue size for this client
 @return An initialiased DFPingMessage object
 */


@end
