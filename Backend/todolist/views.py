from django.shortcuts import render

from rest_framework import viewsets
from .models import Items
from .serializer import ItemsSerializer

class ItemsViewSet(viewsets.ModelViewSet):
    queryset = Items.objects.all()
    serializer_class = ItemsSerializer
    
