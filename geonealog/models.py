from django.contrib.gis.db import models
from django.contrib.gis.geos import Point

from ndh.models import Links, NamedModel
from wikidata.client import Client


class WDPlace(Links, NamedModel):
    wd = models.PositiveIntegerField(blank=True, null=True)

    point = models.PointField(geography=True, blank=True, null=True)

    @property
    def wd_url(self):
        return f'https://www.wikidata.org/wiki/Q{self.wd}'

    def update_from_wd(self):
        claims = Client().get(f'Q{self.wd}', load=True).data['claims']

        self.name = claims['P373'][0]['mainsnak']['datavalue']['value']
        coordinate = claims['P625'][0]['mainsnak']['datavalue']['value']
        self.point = Point(coordinate['longitude'], coordinate['latitude'])

        self.save()
