from django.urls import path
from django.views.generic import ListView

from . import models

app_name = 'geonealog'
urlpatterns = [
    path('', ListView.as_view(model=models.WDPlace), name='wdplaces'),
]
