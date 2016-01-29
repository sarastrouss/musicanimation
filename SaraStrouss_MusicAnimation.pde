import ddf.minim.*;
import ddf.minim.analysis.*;

Minim m;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
AudioMetaData data;

float kickSize, snareSize, hatSize;
float rKickSize, rSnareSize, rHatSize;


//Class taken from minim library 
class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;
  
  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void setup() {
  size(512,200);
  m = new Minim(this);
  beat = new BeatDetect();
  song = m.loadFile("Never_Work_For_Free.mp3");
  song.play();
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  beat.setSensitivity(100);
  bl = new BeatListener(beat, song); 
  data = song.getMetaData();
  smooth();
  kickSize = 100;
  snareSize = 100;
  hatSize = 100;
  rKickSize = 100;
  rSnareSize = 100;
  rHatSize = 100;
}

void draw() {
  background(0);
  int timeSeconds = (int)(song.position()/1000) % 60;
  if (timeSeconds < 10) {
    drawSquares();
  }
  if(timeSeconds > 9 && timeSeconds < 21) {
    drawRandom();
  }
  if(timeSeconds > 20 && timeSeconds < 34) {
    drawRandomAndSquares();
  }
  if(timeSeconds ==  34) {
    stop();
  }
 }
  
  void drawSquares() {
    if(beat.isKick()) kickSize=200;
    if(beat.isSnare()) snareSize=200;
    if(beat.isHat()) hatSize=200;
    fill(22, 160, 133);
    rect(width/4 - kickSize/2, height/2 - kickSize/2, kickSize, kickSize);
    fill(241, 196, 15);
    rect(width/2 - snareSize/2, height/2 - snareSize/2, snareSize, snareSize);
    fill(142, 68, 173);
    rect(3*width/4 - hatSize/2, height/2 - hatSize/2, hatSize, hatSize);
    kickSize = constrain(kickSize * 0.95, 100, 200);
    snareSize = constrain(snareSize * 0.95, 100, 200);
    hatSize = constrain(hatSize * 0.95, 100, 200);
    noStroke();
  }
  
  void drawRandom() {
    if(beat.isKick()) rKickSize=255;
    if(beat.isSnare()) rSnareSize=255;
    if(beat.isHat()) rHatSize=255;
    for(int i = 0; i < 55; i++) {
      fill(22, 160, 133, rKickSize);
      rect(random(width), random(height), i, i);
    }
    for(int i = 0; i < 55; i++) {
      fill(241, 196, 15, rSnareSize);
      rect(random(width), random(height), i, i);
    }
    for(int i = 0; i < 55; i++) {
      fill(142, 68, 173, rHatSize);
      rect(random(width), random(height), i, i);
    }
    rKickSize = constrain(rKickSize * 0.95, 100, 255);
    rSnareSize = constrain(rSnareSize * 0.95, 100, 255);
    rHatSize = constrain(rHatSize * 0.95, 100, 255);
    noStroke();
  }

  void drawRandomAndSquares() {
    drawRandom();
    drawSquares();
    int timeSeconds = (int)(song.position()/1000) % 60;
    if(timeSeconds > 20 && timeSeconds < 25) {
      filter(INVERT);
    } else if(timeSeconds > 24 && timeSeconds < 30) {
       filter(GRAY);
    } else if(timeSeconds > 30 && timeSeconds < 36) {
      filter(DILATE);
    }
  }

  
  void stop() {
     song.close();
     m.stop();
     super.stop();
  }
  




