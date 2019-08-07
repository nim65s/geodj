from django.contrib.gis import admin

from .models import WDPlace

admin.site.register(WDPlace, admin.OSMGeoAdmin)
