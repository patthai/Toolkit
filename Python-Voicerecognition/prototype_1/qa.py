import pandas
import sys, re
import numpy as np
import nltk
import random
import gensim.models.keyedvectors as word2vec
from nltk.tokenize import word_tokenize
from nltk.tag import pos_tag
from nltk.corpus import stopwords
from pyemd import emd

stop_words = set()
for word in set(stopwords.words('english')):
  stop_words.add(word)
  stop_words.add(word.capitalize())

df = pandas.read_csv('albert-einstein.csv', names = ["person", "page", "id", "quote"])
model = word2vec.KeyedVectors.load_word2vec_format("GoogleNews-vectors-negative300.bin", binary=True)

user_text = "hey einstein what should I do to celebrate my birthday"

if user_text.find('hey einstein') != -1:
    user_text = user_text.replace('hey einstein','')
    user_text = user_text.lower().split()
    user_text = [w for w in user_text if w not in stop_words]
    print (user_text)
    df2 = pandas.DataFrame(columns=['quote','quote_similarity'])
    quotes = df.quote.astype(str)
    for quote in quotes:
        quote_split = quote.lower().split()
        quote_split = [w for w in quote_split if w not in stop_words]
        distance = model.wmdistance(user_text, quote_split)
        #print (distance)
        df2 = df2.append({'quote': quote, 'quote_similarity': distance}, ignore_index=True)
    df2['Rank'] = df2['quote_similarity'].rank(ascending=1)

#df2.sort_values(by=['quote_similarity'])
answers = df2.sort_values(by=['quote_similarity']).reset_index().quote.astype(str)
answer_choice = random.randint(1, 3)
print (answers[answer_choice])