#!/bin/sh

coverage run --source commandlines -m py.test
coverage report -m
coverage html