# Generated by Django 5.1.2 on 2024-11-20 17:52

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("make_pdf", "0004_rename_grade_submission_paper_alter_submission_id"),
    ]

    operations = [
        migrations.AlterField(
            model_name="submission",
            name="paper",
            field=models.ImageField(upload_to="test_paper"),
        ),
    ]