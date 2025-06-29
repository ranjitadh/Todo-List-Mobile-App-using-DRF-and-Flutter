from rest_framework.routers import DefaultRouter
from django.urls import path, include
from .views import ItemsViewSet

router = DefaultRouter()
router.register(r'items', ItemsViewSet)

urlpatterns = [
    path('api/', include(router.urls)),
]