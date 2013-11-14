import twitter4j.conf.*;
import twitter4j.internal.async.*;
import twitter4j.internal.org.json.*;
import twitter4j.internal.logging.*;
import twitter4j.json.*;
import twitter4j.internal.util.*;
import twitter4j.management.*;
import twitter4j.auth.*;
import twitter4j.api.*;
import twitter4j.util.*;
import twitter4j.internal.http.*;
import twitter4j.*;
import twitter4j.internal.json.*;
import java.util.*;


import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

//Markov stuff
import rita.*;
RiMarkov markov;
String line;

//Twitter stuff
Twitter twitter;
String searchString = "syria missamerica MileyCyrus";
List<Status> tweets;

int currentTweet;
//String[] latestStatus = new String(

//write text file
BufferedWriter bw = null;
String fileName = "/Users/taranagupta/Documents/Processing/Syria_Twitter/data.txt";
boolean appendData = true; 

void setup()
{
  size(1280, 720);

  //twitter stuff
  ConfigurationBuilder cb = new ConfigurationBuilder();
  cb.setOAuthConsumerKey("vlb5XPjI4sa82LSzOgMcrA");
  cb.setOAuthConsumerSecret("WhyHl1Bvzab8CSrnz1YOjQt0xIoshDXQGZsRGNIQ");
  cb.setOAuthAccessToken("1865031588-dg6NKHuTjLeSMqg29bi1BiQwrMLtizboBO914Do");
  cb.setOAuthAccessTokenSecret("159VB7Ywyw8XBbxcQY7hjLoHq3BSXxDzAFZ6qXSvU");

  TwitterFactory tf = new TwitterFactory(cb.build());  
  twitter = tf.getInstance();

  // Twitter twitter = TwitterFactory.getSingleton();
  //Status status = twitter.updateStatus(latestStatus);

  CreateWriter();
  getNewTweets();

  currentTweet = 0;

  //new markov object
  markov = new RiMarkov(this, 2);
}

void draw() {
  background(0);
  currentTweet = currentTweet + 1;

  if (currentTweet >= tweets.size()) {
    currentTweet = 0;
  }

  Status status = tweets.get(currentTweet);

  // text(status.getText(), 50, 250, 600, 300);
  //println(status.getText());

  getNewTweets();
  
  CloseWriter();

  //markov file load
  markov.loadFile(sketchPath + "/data.txt", 1);
  line = markov.generateSentences(5)[1]; 
  fill(200);
  textSize(24);
  text(line, 50, 250, 600, 300);
  
  try {
    Status status1 = twitter.updateStatus(line+ "#Syria #socialhacking");
    System.out.println("Successfully updated the status to [" + status1.getText() + "].");
  }
  catch (TwitterException te) {
    println("Couldn't connect: " + te);
  };
  
  println(line+"\n");
  delay(4000);
  
}


void getNewTweets() {
  try {
    // try to get tweets here
    Query query = new Query(searchString);
    QueryResult result = twitter.search(query);
    tweets = result.getTweets();
    print(tweets.size());
    WriteTweets(tweets);
  } 
  catch (TwitterException te) {
    // deal with the case where we can't get them here
    System.out.println("Failed to search tweets: " + te.getMessage());
    System.exit(-1);
  }
}


void WriteTweets(List<Status> tweets) {
  for (int i=0; i<tweets.size();i=i+1) {
    WriteToFile(tweets.get(i).getText());
    //println(tweets.get(i));
  }
}


void CreateWriter() {
  //creating a writer
  try {  
    println("creating writer");
    //bw = null;
    FileWriter fw = new FileWriter(fileName, appendData);
    bw = new BufferedWriter(fw);
    //bw = new FileWriter(fileName, appendData);
  } 
  catch (IOException e) {
    println(e.toString());
    //System.err.println(e);
  }
}

void CloseWriter() {
  try { 
    if (bw != null) {
      bw.close();
    }
  } 
  catch (IOException e) {
    println(e.toString());
    // System.err.println(e);
  }
}

void WriteToFile(String newData) {
  try {
    bw.write(newData);
    bw.write("\n");
    bw.flush();
  }
  catch(IOException e) {
    // println(str(e));
    println(e.toString());
    // System.err.println(e);
  }
}












