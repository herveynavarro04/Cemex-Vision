from flask import flask, request, jsonify
import boto3
import os
from io import BytesIO
from dotenv import load_dotenv

load_dotenv()
app = flask("__api__")

s3 = boto3.client(
    's3',
    aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
    region_name=os.getenv('AWS_REGION')
)

IMG_BUCKET = os.getenv('IMG_BUCKET')
MODEL_BUCKET = os.getenv('MODEL_BUCKET')

@app.route('/uploadIMG', methods=['POST'])
def upload_image():
    if 'image' not in request.files:
        return jsonify({"error": "No image found"}), 400
    file = request.files['image']

    if not file or file.filename:
        return jsonify({"error": "Invalid file"}), 400 
    
    try:
        s3.upload_fileObj(
            file,
            IMG_BUCKET,
            f'uploads/{file.filename}',  
            ExtraArgs={'ContentType': file.content_type}  
        )
        return jsonify({"message:" "File uploaded to AWS"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

