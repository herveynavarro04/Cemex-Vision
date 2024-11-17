from flask import Flask, request, jsonify
import os
from subprocess import check_output
from FloorplanToBlenderLib import IO, config, const, execution, floorplan
import subprocess

app = Flask(__name__)


@app.route("/upload", methods=["POST"])
def upload_image():
    # Create uploads directory if it doesn't exist
    uploads_dir = os.path.join(os.path.dirname(__file__), "uploads")
    if not os.path.exists(uploads_dir):
        os.makedirs(uploads_dir)

    if "image" not in request.files:
        return jsonify({"error": "No image part in the request"}), 400

    file = request.files["image"]
    if file.filename == "":
        return jsonify({"error": "No selected file"}), 400

    # Save the uploaded image
    image_path = os.path.join(uploads_dir, file.filename)
    file.save(image_path)

    # Prepare to create the Blender project
    target_folder = const.TARGET_PATH
    if not os.path.exists("." + target_folder):
        os.makedirs("." + target_folder)

    target_base = target_folder + const.TARGET_NAME
    target_path = target_base + const.BASE_FORMAT
    target_path = (
        IO.get_next_target_base_name(target_base, target_path) + const.BASE_FORMAT
    )

    # Create the Blender project
    data_paths = [image_path]  # Assuming you only upload one image
    blender_install_path = "/Applications/Blender.app/Contents/MacOS/Blender"
    program_path = os.path.dirname(os.path.realpath(__file__))
    blender_script_path = const.BLENDER_SCRIPT_PATH

    try:
        subprocess.check_output(
            [
                blender_install_path,
                "-noaudio",
                "--background",
                "--python",
                blender_script_path,
                program_path,
                target_path,
            ]
            + data_paths
        )

        return (
            jsonify(
                {"message": "3D model created successfully", "model_path": target_path}
            ),
            200,
        )

    except subprocess.CalledProcessError as e:
        print(f"Error occurred: {e.output}")
        return jsonify({"error": str(e.output)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
