from operator import mod
from unittest.util import _MAX_LENGTH
from django.db import models

# Create your models here.
class Memo(models.Model) :
    memotitle = models.CharField(max_length=40)
    memodate = models.DateTimeField()
class Recommendation(models.Model) :
    recommend = models.CharField(max_length=500)