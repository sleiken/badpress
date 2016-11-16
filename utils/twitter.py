import tweepy
import csv
import numpy as np
from textblob import TextBlob

consumer_key= 'F279JL3R75Vg1XPYhXmAXQeAI'
consumer_secret= '6kW4DSGMiHgPlXBwMbZkEKY6bMWd2MwKxexNxlXW2jqN9qu3tu'
access_token='41011520-WpjhVtQT4cEckS94UrLeRzupcjDqpEYlIvGuzSlnx'
access_token_secret='YDwKEMwKGM7E9QsCtd4lghL3iTSbtL6UhnybjvV19GXxG'
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)

def analyze_tweets(search_term):
    public_tweets = api.search('microsoft')
    pos_tweets = []
    for tweet in public_tweets:
        analysis = TextBlob(tweet.text)
        print(analysis.polarity)
        if analysis.polarity > 0:
            pos_tweets.append({tweet: analysis})
    return pos_tweets
