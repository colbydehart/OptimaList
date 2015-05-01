# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('ol', '0002_auto_20150402_2214'),
    ]

    operations = [
        migrations.AlterField(
            model_name='recipeitem',
            name='quantity',
            field=models.FloatField(),
        ),
    ]
