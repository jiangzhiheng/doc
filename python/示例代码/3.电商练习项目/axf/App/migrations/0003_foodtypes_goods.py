# -*- coding: utf-8 -*-
# Generated by Django 1.11.4 on 2019-07-31 13:04
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('App', '0002_mainshow'),
    ]

    operations = [
        migrations.CreateModel(
            name='FoodTypes',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('typeid', models.CharField(max_length=10)),
                ('typename', models.CharField(max_length=10)),
                ('childtypenames', models.CharField(max_length=100)),
                ('typesort', models.CharField(max_length=10)),
            ],
            options={
                'db_table': 'axf_foodtypes',
            },
        ),
        migrations.CreateModel(
            name='Goods',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('productid', models.CharField(max_length=10)),
                ('productimg', models.CharField(max_length=100)),
                ('productname', models.CharField(max_length=30)),
                ('productlongname', models.CharField(max_length=100)),
                ('isxf', models.CharField(max_length=10)),
                ('pmdesc', models.CharField(max_length=10)),
                ('specifics', models.CharField(max_length=10)),
                ('price', models.CharField(max_length=10)),
                ('marketprice', models.CharField(max_length=10)),
                ('categoryid', models.CharField(max_length=10)),
                ('childcid', models.CharField(max_length=10)),
                ('childcidname', models.CharField(max_length=30)),
                ('dealerid', models.CharField(max_length=10)),
                ('storenums', models.CharField(max_length=10)),
                ('productnum', models.CharField(max_length=10)),
            ],
            options={
                'db_table': 'axf_goods',
            },
        ),
    ]
