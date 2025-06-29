from rest_framework import serializers
from .models import Items

class ItemsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Items
        fields = '__all__'
        # fields = ['id', 'name', 'description', 'status']  # Specify fields explicitly if needed
        # read_only_fields = ['id']  # If you want to make the id field read-only