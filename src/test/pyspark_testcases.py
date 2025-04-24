import unittest

from pyspark.sql import SparkSession

class PySparkTestCase(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.spark = SparkSession.builder.appName("Testing PySpark Example").getOrCreate()

    @classmethod
    def tearDownClass(cls):
        cls.spark.stop()