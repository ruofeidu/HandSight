//
//  HSAudio.m
//  HandSight
//
//  Created by Ruofei Du on 7/16/14.
//  Copyright (c) 2014 Ruofei Du. All rights reserved.
//

#import "HSAudio.h"

static AudioComponentInstance toneUnit;
static double m_audioTheta, m_audioFrequency, m_audioSampleRate;

OSStatus RenderTone(
                    void *inRefCon,
                    AudioUnitRenderActionFlags 	*ioActionFlags,
                    const AudioTimeStamp 		*inTimeStamp,
                    UInt32 						inBusNumber,
                    UInt32 						inNumberFrames,
                    AudioBufferList 			*ioData)
{
	// amplitude corresponds to the frequency
    // 200-300
    // 500-600
    //m_audioFrequency = 400 - y / fabs(y) * 100 * powf(2.f, fabs(y) / 127);
    
	// Get the tone parameters out of the view controller
	//HSAudio *me = (__bridge HSAudio*)inRefCon;
    
    
    //double frequency = viewController->m_audioFrequency;
    
    double amplitude = 0.25;
    
    /*
     if (frequency > 400 && frequency < 700) {
     amplitude = 0.05 + 0.35 * (frequency - 500) / 100;
     } else
     if (frequency < 400 && frequency > 100) {
     amplitude = 0.8 - 0.1 * (frequency - 200) / 100;
     }
     amplitude = ceil(amplitude * 10) / 10;
     NSLog(@"amplitude: %.2f, frequency: %.2f", amplitude, frequency);
     */
    
	double theta = m_audioTheta;
	double theta_increment = 2.0 * M_PI * m_audioFrequency / m_audioSampleRate;
    
	// This is a mono tone generator so we only need the first buffer
	const int channel = 0;
	Float32 *buffer = (Float32 *)ioData->mBuffers[channel].mData;
	
	// Generate the samples
	for (UInt32 frame = 0; frame < inNumberFrames; frame++)
	{
		buffer[frame] = sin(theta) * amplitude;
		
		theta += theta_increment;
		if (theta > 2.0 * M_PI)
		{
			theta -= 2.0 * M_PI;
		}
	}
	
	// Store the theta back in the view controller
	m_audioTheta = theta;
    
	return noErr;
}

@implementation HSAudio

- (id)init
{
    self = [super init];
    
    if (self) {
        toneUnit = nil;
        
        m_audioTheta = 0.0;
        m_audioFrequency = 440.0;
        m_audioSampleRate = 44100.00;
        
        [SoundManager sharedManager].allowsBackgroundMusic = YES;
        [[SoundManager sharedManager] prepareToPlay];
        
        State = [HSState sharedInstance];
        
        NSLog(@"[AU] Inited");
    }
    
    return self;
}

+ (HSAudio*) sharedInstance
{
    static  HSAudio* sharedInstance = nil ;
    static  dispatch_once_t onceToken;
    dispatch_once (& onceToken, ^ {
        sharedInstance = [[self  alloc] init];
    });
    return  sharedInstance;
}

- (AudioComponentInstance) getTone
{
    return toneUnit;
}

- (void) play
{
	if (!toneUnit)
	{
		[self createToneUnit];
		
		// Stop changing parameters on the unit
		OSErr err = AudioUnitInitialize(toneUnit);
		
		// Start playback
		err = AudioOutputUnitStart(toneUnit);
	}
}

- (void) stop
{
    //if ([m_diracAudioPlayer playing]) [m_diracAudioPlayer stop];
	if (toneUnit)
	{
		AudioOutputUnitStop(toneUnit);
		AudioUnitUninitialize(toneUnit);
		AudioComponentInstanceDispose(toneUnit);
		toneUnit = nil;
	}
}

- (double) audioFrequency {
    return m_audioFrequency; 
}

- (void) updateAudioFrequency: (CGFloat) y {
    if (y == 0) return;
    if ([State audioLinear]) {
        // TODO
        m_audioFrequency = [State audioMiddleValue] - y / fabs(y) * [State audioIncValue] * powf(2.f, fabs(y) / [State maxFeedbackValue]);
    } else {
        m_audioFrequency = [State audioMiddleValue] - y / fabs(y) * [State audioIncValue] * powf(2.f, fabs(y) / [State maxFeedbackValue]);
    }
}

- (void)createToneUnit
{
    //NSLog(@"[Audio] Created A Tone Unit with Freq %.2lf", m_audioFrequency);
	
    // Configure the search parameters to find the default playback output unit
	// (called the kAudioUnitSubType_RemoteIO on iOS but
	// kAudioUnitSubType_DefaultOutput on Mac OS X)
	AudioComponentDescription defaultOutputDescription;
	defaultOutputDescription.componentType = kAudioUnitType_Output;
	defaultOutputDescription.componentSubType = kAudioUnitSubType_RemoteIO;
	defaultOutputDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
	defaultOutputDescription.componentFlags = 0;
	defaultOutputDescription.componentFlagsMask = 0;
	
	// Get the default playback output unit
	AudioComponent defaultOutput = AudioComponentFindNext(NULL, &defaultOutputDescription);
	NSAssert(defaultOutput, @"Can't find default output");
	
	// Create a new unit based on this that we'll use for output
	OSErr err = AudioComponentInstanceNew(defaultOutput, &toneUnit);
	NSAssert1(toneUnit, @"Error creating unit: %hd", err);
	
	// Set our tone rendering function on the unit
	AURenderCallbackStruct input;
	input.inputProc = RenderTone;
	input.inputProcRefCon = (__bridge void *)(self);
	err = AudioUnitSetProperty(toneUnit,
                               kAudioUnitProperty_SetRenderCallback,
                               kAudioUnitScope_Input,
                               0,
                               &input,
                               sizeof(input));
	NSAssert1(err == noErr, @"Error setting callback: %hd", err);
	
	// Set the format to 32 bit, single channel, floating point, linear PCM
	const int four_bytes_per_float = 4;
	const int eight_bits_per_byte = 8;
	AudioStreamBasicDescription streamFormat;
	streamFormat.mSampleRate = m_audioSampleRate;
	streamFormat.mFormatID = kAudioFormatLinearPCM;
	streamFormat.mFormatFlags =
    kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved;
	streamFormat.mBytesPerPacket = four_bytes_per_float;
	streamFormat.mFramesPerPacket = 1;
	streamFormat.mBytesPerFrame = four_bytes_per_float;
	streamFormat.mChannelsPerFrame = 1;
	streamFormat.mBitsPerChannel = four_bytes_per_float * eight_bits_per_byte;
	err = AudioUnitSetProperty (toneUnit,
                                kAudioUnitProperty_StreamFormat,
                                kAudioUnitScope_Input,
                                0,
                                &streamFormat,
                                sizeof(AudioStreamBasicDescription));
	NSAssert1(err == noErr, @"Error setting stream format: %hd", err);
}

- (void) playAudio:(enum AUDIO) audio {
    switch (audio) {
        case AU_LINE_BEGIN:  [[SoundManager sharedManager] playSound:@"LB_DingDong.wav" looping:NO]; break;
        case AU_LINE_END:    [[SoundManager sharedManager] playSound:@"LE_DongDing.wav" looping:NO]; break;
        case AU_PARA_END:    [[SoundManager sharedManager] playSound:@"EOP_Dang.mp3" looping:NO]; break;
        case AU_SKIP_WORD:   [[SoundManager sharedManager] playSound:@"EOP_AirDong.wav" looping:NO]; break;
    }
}

@end


