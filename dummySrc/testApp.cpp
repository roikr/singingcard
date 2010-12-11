/*
 *  testApp.cpp
 *  SingingCard
 *
 *  Created by Roee Kremer on 12/9/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

#include "testApp.h"
#include "ofSoundStream.h"
#include "Constants.h"

testApp::testApp() {
	bInitialized = false;
	songState = SONG_IDLE;
	//bChangeSet = false;
}

int testApp::getSongVersion() {
	return songVersion;
}

void testApp::soundStreamStart() {
	ofSoundStreamStart();
}

void testApp::soundStreamStop() {
	ofSoundStreamStop();
}

void testApp::setSongState(int songState) {
	
	
	
	// song is valid and can Overwritten only when FINISHING RECORD
//	if (this->songState==SONG_RECORD && songState!=SONG_RECORD) {
//		songVersion++;
//	}
//	
//	if (this->songState==SONG_RENDER_VIDEO && songState!=SONG_RENDER_VIDEO) {
//		currentFrame =(ofGetElapsedTimeMillis()-startTime)  / 40;
//	}
	
	this->songState = songState;
	
//	if (songState == SONG_RENDER_AUDIO || songState == SONG_RENDER_VIDEO) {
//		duration = 0;
//		
//		for (int i=0;i<3;i++) {
//			float temp = player[i].getDuration();
//			if (temp > duration) {
//				duration = temp;
//			}
//		}
//	}		
//	
//	if (songState == SONG_RENDER_VIDEO) { 
//		currentBlock = 0;
//	}
//	
//	for (int i=0;i<3;i++) {
//		player[i].setSongState(songState);
//	}
	
	bNeedDisplay = true;
	
}

int  testApp::getSongState() { 
	
	return songState;
}

void testApp::seekFrame(int frame) {
	
	
	
//	int reqBlock = (float)frame/25.0f*(float)sampleRate/(float)blockLength;
//	
//	for (;currentBlock<reqBlock;currentBlock++) { // TODO: or song finished...
//		for (int i=0;i<3;i++) {
//			player[i].processForVideo();
//		}
//	}
//	
//	for (int i=0;i<3;i++) {
//		player[i].nextFrame();
//		
//	}
//	
//	lastRenderedFrame = frame;
	
	
}


void testApp::render(){
	
//	if (!bInitialized) {
//		return;
//		//	printf("draw()\n");
//	}
//	
//	
//	ofPushMatrix();
//	
//	
//	background.draw(0,0);
//	
//	int i;
//	for(i=0;i<3;i++)
//		player[i].draw();
//	
//	
//	ofPopMatrix();
}

float testApp::getRenderProgress(){
	
	
//	switch (songState) {
//		case SONG_RENDER_AUDIO: {
//			float playhead = (float)currentBlock * (float)blockLength / (float)sampleRate;
//			return playhead/duration;
//		}	break;
//		case SONG_RENDER_VIDEO:
//			return (float)currentBlock/(float)totalBlocks;
//		default:
//			return 0.0f;
//	}
	
	
	return songState == SONG_RENDER_VIDEO && totalBlocks!=0 ? (float)currentBlock/(float)totalBlocks : 0.0f;
	
}



void testApp::renderAudio() {
	
	setSongState(SONG_RENDER_AUDIO);
	
//	cout << "renderAudio started" << endl;
	
//	song.open(ofToDocumentsPath("temp.wav"));
	
	
	currentBlock = 0;
	
//	while (getSongState()==SONG_RENDER_AUDIO || getSongState()==SONG_CANCEL_RENDER_AUDIO) {
//		
//		
//		memset(lBlock, 0, blockLength*sizeof(float));
//		memset(rBlock, 0, blockLength*sizeof(float));
//		
//		for (int i=0;i<3;i++) {
//			player[i].processWithBlocks(lBlock, rBlock);
//		}
//		
//		song.saveWithBlocks(lBlock, rBlock);
//		currentBlock++;
//	}
	
//	song.close();	
	
//	cout << "renderAudio finished" << endl;
	
	setSongState(SONG_RENDER_AUDIO_FINISHED);
	
	totalBlocks = currentBlock;
	
}