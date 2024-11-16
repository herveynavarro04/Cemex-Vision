from flask import flask, request, jsonify
import boto3
import os
from io import BytesIO
from dotenv import load_dotenv