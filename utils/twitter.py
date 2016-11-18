import os
import tweepy
from textblob import TextBlob

consumer_key = os.environ['TWITTER_CONSUMER_KEY']
consumer_secret = os.environ['TWITTER_CONSUMER_SECRET']
access_token = os.environ['TWITTER_ACCESS_TOKEN']
access_token_secret = os.environ['TWITTER_ACCESS_TOKEN_SECRET']
auth = tweepy.OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_token_secret)
api = tweepy.API(auth)

def analyze_tweets(term):
    public_tweets = api.search(term)
    pos_count = 0
    neg_count = 0
    subjectivity = 0
    num_tweets = len(public_tweets)
    for tweet in public_tweets:
        analysis = TextBlob(tweet.text)
        if analysis.polarity > 0:
            pos_count += 1
        else:
            neg_count += 1
        subjectivity += analysis.subjectivity
    scores = [pos_count / num_tweets, neg_count / num_tweets, subjectivity / num_tweets]
    return ['%.0f' % (x * 100) for x in scores]
