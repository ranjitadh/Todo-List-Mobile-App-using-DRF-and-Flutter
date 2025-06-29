from django.db import models


class Items(models.Model):
    name =models.CharField(max_length=100)
    description =models.TextField()
    status =models.TextField()
