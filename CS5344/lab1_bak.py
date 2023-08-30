import sys
import json

import pyspark
from pyspark import SparkContext, SparkConf

conf = SparkConf()
sc = SparkContext(conf=conf)

dataPath, metaPath = sys.argv[1], sys.argv[2]

# read in data and transform to dictionary
review = sc.textFile(dataPath).map(lambda x: json.loads(x))
meta = sc.textFile(metaPath).map(lambda x: json.loads(x))

# group by productID and reiewTime, to get sum rating and number of reviews for each product-date pair
review_info = review.map(lambda x: ((x['asin'], x['reviewTime']), (x['overall'], 1))).reduceByKey(lambda a, b: (a[0] + b[0], a[1] + b[1])) #((ProductID, ReviewTime), (sum_rating, #review))

# for each productID, find date with greatest number of review
top15 = review_info.map(lambda x: (x[0][0], (x[1][1], x[0][1]))).reduceByKey(lambda a, b: a if a[0] > b[0] else b) # (ProductID, (#review, reviewTime))

# take top 15 productID as ranked by number of review of the date that has greatest number of review
top15 = sc.parallelize(top15.takeOrdered(15, key=lambda x: -x[1][0]))

# change key back to productID and reviewTime for later join
top15 = top15.map(lambda x: ((x[0], x[1][1]), x[1][0])) # ((productID, reviewTime), review_cnt)

# join review_info to get rating info
top15 = top15.join(review_info)

# change key to productID for later join, calcuate avg rating
top15 = top15.map(lambda x: (x[0][0], (x[0][1], x[1][1][0] / x[1][0], x[1][0]))) #(ProductID, (reviewTime, avg_rating, #review))

# join meta data to get brand name
top15 = top15.join(meta.map(lambda x: (x['asin'], x['brand']))) # (ProductId, ((reviewTime, avg_rating, #review), brand))

# format output to required format
top15 = top15.map(lambda x: (x[0], x[1][0][2], x[1][0][0], x[1][0][1], x[1][1]))

# repartition and save
top15.repartition(1).saveAsTextFile('lab1_bak')

sc.stop()