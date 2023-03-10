from django.db import models

# Create your models here.

class Moive(models.Model):
    rank = models.IntegerField()
    name = models.CharField(max_length=255)
    poster = models.CharField(max_length=3000)
    duration = models.CharField(max_length=255)
    grading = models.CharField(max_length=255, null=True)